{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };
  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    systems,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      perSystem = {
        pkgs,
        system,
        lib,
        self',
        ...
      }: let
        mkEntrypoint = env:
          pkgs.writeShellApplication {
            name = "entrypoint";
            text = ''
              if [ -z "''${PROXY_PORT:-}" ] || [ -z "''${BACKEND_PORT:-}" ]; then
                ${pkgs.coreutils}/bin/echo "The following parameters are required: PROXY_PORT, BACKEND_PORT." >&2
                ${pkgs.coreutils}/bin/echo "Open the manual for details: https://github.com/mirkolenz/grpc-proxy" >&2
                exit 1
              fi

              PROXY_OUTDIR=$(${pkgs.coreutils}/bin/mktemp --directory)
              PROXY_ENVOY_CONFIG="$PROXY_OUTDIR/envoy.yaml"

              ${pkgs.coreutils}/bin/env --ignore-environment \
                ${builtins.toString (lib.mapAttrsToList (key: val: "${key}=${val}") env)} \
                "$@" \
                ${lib.getExe pkgs.gomplate} \
                --config ${./gomplate.yaml} \
                --file ${./envoy.yaml} \
                --out "$PROXY_ENVOY_CONFIG"

              ${lib.getExe pkgs.envoy} -c "$PROXY_ENVOY_CONFIG"
            '';
          };
        nixEntrypoint = mkEntrypoint rec {
          PROXY_HOST = "127.0.0.1";
          ADMIN_HOST = PROXY_HOST;
          BACKEND_HOST = PROXY_HOST;
        };
        dockerEntrypoint = mkEntrypoint rec {
          PROXY_HOST = "0.0.0.0";
          ADMIN_HOST = PROXY_HOST;
          BACKEND_HOST = "host.docker.internal";
        };

        dockerImageName = "ghcr.io/${builtins.getEnv "GITHUB_REPOSITORY"}";
        version = builtins.getEnv "VERSION";
        refname = builtins.getEnv "GITHUB_REF_NAME";
        versionParts = lib.splitString "." version;

        tags =
          [refname]
          ++ (lib.optional (builtins.elem refname ["main" "master"]) "latest")
          ++ (lib.optional (version != "") version)
          ++ (lib.optionals (version != "" && !lib.hasInfix "-" version) [
            (lib.concatStringsSep "." (lib.sublist 0 2 versionParts))
            (builtins.elemAt versionParts 0)
          ]);

        archs = ["x86_64" "aarch64"];
      in {
        apps = {
          copyDockerManifest = {
            type = "app";
            program = lib.getExe (pkgs.writeShellApplication {
              name = "copy-docker-manifest";
              text = ''
                set -x # echo on
                ${lib.getExe pkgs.buildah} manifest create grpc-proxy
                ${builtins.concatStringsSep "\n" (
                  builtins.map (
                    arch: "${lib.getExe pkgs.buildah} manifest add grpc-proxy docker-archive:./docker-${arch}.tar.gz"
                  )
                  archs
                )}
                ${builtins.concatStringsSep "\n" (
                  builtins.map (
                    tag: "${lib.getExe pkgs.buildah} manifest push --all --format v2s2 grpc-proxy docker://${dockerImageName}:${tag}"
                  )
                  tags
                )}
              '';
            });
          };
          default = {
            type = "app";
            program = lib.getExe self'.packages.default;
          };
        };
        packages = {
          grpc-proxy = nixEntrypoint;
          default = nixEntrypoint;
          dockerImage = pkgs.dockerTools.buildLayeredImage {
            name = "grpc-proxy";
            tag = "latest";
            created = "now";
            extraCommands = ''
              mkdir -p tmp
            '';
            config = {
              entrypoint = [(lib.getExe dockerEntrypoint)];
              cmd = [];
            };
          };
        };
      };
    };
}
