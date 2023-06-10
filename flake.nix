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
      }: {
        apps = let
          app = {
            type = "app";
            program = lib.getExe self'.packages.default;
          };
        in {
          copyDockerImage = {
            type = "app";
            program = builtins.toString (pkgs.writeShellScript "copyDockerImage" ''
              IFS=$'\n' # iterate over newlines
              set -x # echo on
              for DOCKER_TAG in $DOCKER_METADATA_OUTPUT_TAGS; do
                ${lib.getExe pkgs.skopeo} --insecure-policy copy "docker-archive:${self'.packages.dockerImage}" "docker://$DOCKER_TAG"
              done
            '');
          };
          default = app;
        };
        packages = let
          mkEntrypoint = env:
            pkgs.writeShellApplication {
              name = "entrypoint";
              text = ''
                PROXY_OUTDIR=$(${pkgs.toybox}/bin/mktemp -d)
                PROXY_ENVOY_CONFIG="$PROXY_OUTDIR/envoy.yaml"

                ${pkgs.toybox}/bin/env -i \
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
        in {
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
