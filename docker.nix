{
  lib,
  dockerTools,
  callPackage,
  package ? ./full.nix,
  flags ? {},
}: let
  entrypoint = callPackage package {
    flags =
      {
        proxy-host = "0.0.0.0";
        admin-host = "0.0.0.0";
        backend-host = "host.docker.internal";
      }
      // flags;
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
