{
  lib,
  dockerTools,
  callPackage,
  opts,
  app,
  ...
}: let
  entrypoint = callPackage ./full.nix {
    inherit opts app;
  };
in
  dockerTools.buildLayeredImage {
    name = "grpc-proxy";
    tag = "latest";
    created = "now";
    extraCommands = ''
      mkdir -p tmp
    '';
    config = {
      entrypoint = [(lib.getExe entrypoint)];
      cmd = [];
    };
  }
