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
          entrypoint = pkgs.writeShellApplication {
            name = "entrypoint";
            text = ''
              PARSED_ENVOY_CONFIG=$(${pkgs.toybox}/bin/mktemp -d)/envoy.yaml
              ${lib.getExe pkgs.gomplate} \
                --config ${./gomplate.yaml} \
                --file ${./envoy.yaml} \
                --out "$PARSED_ENVOY_CONFIG"
              ${lib.getExe pkgs.envoy} -c "$PARSED_ENVOY_CONFIG"
            '';
          };
        in {
          grpc-proxy = entrypoint;
          default = entrypoint;
          dockerImage = pkgs.dockerTools.buildImage {
            name = "grpc-proxy";
            tag = "latest";
            created = "now";
            runAsRoot = ''
              #!${pkgs.runtimeShell}
              mkdir -p tmp
            '';
            config = {
              entrypoint = [(lib.getExe entrypoint)];
              cmd = [];
            };
          };
        };
      };
    };
}
