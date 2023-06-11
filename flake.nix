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
        dockerImageName = "grpc-proxy";
        dockerImageTags = {
          "x86_64-linux" = "amd64";
          "aarch64-linux" = "arm64";
        };
        dockerImageTag = dockerImageTags.${system};
      in {
        apps = {
          copyDockerImage = {
            type = "app";
            program = lib.getExe (pkgs.writeShellApplication {
              name = "copy-docker-image";
              text = ''
                ${lib.getExe pkgs.docker} load -i ${self'.packages.dockerImage}
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
            name = dockerImageName;
            tag = dockerImageTag;
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
