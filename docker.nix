{
  lib,
  dockerTools,
  callPackage,
  env,
  ...
}: let
  entrypoint = callPackage ./. {
    inherit env;
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
