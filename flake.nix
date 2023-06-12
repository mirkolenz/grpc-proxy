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
        apps = {
          copyDockerManifest = {
            type = "app";
            program = lib.getExe (pkgs.callPackage ./docker-manifest.nix {
              branch = builtins.getEnv "GITHUB_REF_NAME";
              images = [self'.packages.dockerImage self'.packages.dockerImageCross];
              repo = builtins.getEnv "GITHUB_REPOSITORY";
              version = builtins.getEnv "VERSION";
            });
          };
          default = {
            type = "app";
            program = lib.getExe self'.packages.default;
          };
        };
        packages = {
          default = pkgs.callPackage ./. {
            env = rec {
              PROXY_HOST = "127.0.0.1";
              ADMIN_HOST = PROXY_HOST;
              BACKEND_HOST = PROXY_HOST;
            };
          };
          grpc-proxy = self'.packages.default;
          dockerImage = pkgs.callPackage ./docker-image.nix {};
          dockerImageCross = pkgs.pkgsCross.aarch64-multiplatform.callPackage ./docker-image.nix {};
        };
      };
    };
}
