{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    flocken = {
      url = "github:mirkolenz/flocken/v1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    systems,
    flocken,
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
        _module.args = {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.gomod2nix.overlays.default
            ];
          };
        };
        apps = {
          dockerManifest = {
            type = "app";
            program = lib.getExe (flocken.legacyPackages.${system}.mkDockerManifest {
              branch = builtins.getEnv "GITHUB_REF_NAME";
              name = "ghcr.io/" + builtins.getEnv "GITHUB_REPOSITORY";
              version = builtins.getEnv "VERSION";
              images = with self.packages; [x86_64-linux.docker aarch64-linux.docker];
            });
          };
        };
        packages = {
          default = pkgs.callPackage ./. {};
          grpcProxy = self'.packages.default;
          full = pkgs.callPackage ./full.nix {
            app = self'.packages.default;
            opts = {};
          };
          docker = pkgs.callPackage ./docker.nix {
            app = self'.packages.default;
            opts = rec {
              proxy-host = "0.0.0.0";
              admin-host = proxy-host;
              backend-host = "host.docker.internal";
            };
          };
          releaseEnv = pkgs.buildEnv {
            name = "releaseEnv";
            paths = with pkgs; [go goreleaser];
          };
          gomod2nix = pkgs.gomod2nix;
        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [go goreleaser];
        };
      };
    };
}
