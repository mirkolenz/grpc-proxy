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
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        inputs.git-hooks.flakeModule
      ];
      perSystem =
        {
          pkgs,
          system,
          config,
          ...
        }:
        {
          _module.args = {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ inputs.gomod2nix.overlays.default ];
            };
          };
          pre-commit.settings.hooks = {
            gofmt.enable = true;
            gotest.enable = true;
            # https://github.com/cachix/git-hooks.nix/issues/464
            # golangci-lint.enable = true;
            nixfmt-rfc-style.enable = true;
          };
          checks = {
            inherit (config.packages) grpc-proxy;
          };
          packages = {
            default = pkgs.callPackage ./. { };
            grpc-proxy = config.packages.default;
            full = pkgs.callPackage ./full.nix { };
            docker = pkgs.callPackage ./docker.nix { };
            release-env = pkgs.buildEnv {
              name = "release-env";
              paths = with pkgs; [
                go
                goreleaser
                gomod2nix
              ];
            };
            gomod2nix = pkgs.gomod2nix;
          };
          legacyPackages.dockerManifest = flocken.legacyPackages.${system}.mkDockerManifest {
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
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
            packages = with pkgs; [
              go
              goreleaser
            ];
          };
        };
    };
}
