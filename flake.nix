{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    flocken = {
      url = "github:mirkolenz/flocken/v2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  nixConfig = {
    extra-substituters = [
      "https://mirkolenz.cachix.org"
    ];
    extra-trusted-public-keys = [
      "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho="
    ];
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      systems,
      flocken,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      perSystem =
        {
          pkgs,
          system,
          config,
          lib,
          ...
        }:
        {
          _module.args = {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ inputs.gomod2nix.overlays.default ];
            };
          };
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              gofmt.enable = true;
              nixfmt.enable = true;
            };
          };
          checks =
            {
              inherit (config.packages) grpc-proxy;
            }
            // lib.optionalAttrs (lib.elem system lib.platforms.linux) {
              inherit (config.packages) grpc-proxy-full;
              docker = config.packages.docker.passthru.stream;
            };
          packages =
            {
              default = config.packages.grpc-proxy;
              grpc-proxy = pkgs.callPackage ./default.nix { };
              release-env = pkgs.buildEnv {
                name = "release-env";
                paths = with pkgs; [
                  go
                  goreleaser
                  gomod2nix
                ];
              };
              gomod2nix = pkgs.gomod2nix;
            }
            // lib.optionalAttrs (lib.elem system lib.platforms.linux) {
              full = config.packages.grpc-proxy-full;
              grpc-proxy-full = pkgs.callPackage ./full.nix { inherit (config.packages) grpc-proxy; };
              docker = pkgs.callPackage ./docker.nix { inherit (config.packages) grpc-proxy-full; };
            };
          legacyPackages.docker-manifest = flocken.legacyPackages.${system}.mkDockerManifest {
            github = {
              enable = true;
              token = "$GH_TOKEN";
            };
            version = builtins.getEnv "VERSION";
            images = with self.packages; [
              x86_64-linux.docker
              aarch64-linux.docker
            ];
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              go
              goreleaser
              gomod2nix
              config.treefmt.build.wrapper
            ];
          };
        };
    };
}
