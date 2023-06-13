{
  lib,
  dockerTools,
  callPackage,
  ...
}: let
  entrypoint =
    callPackage ./.
    {
      env = rec {
        PROXY_HOST = "0.0.0.0";
        ADMIN_HOST = PROXY_HOST;
        BACKEND_HOST = "host.docker.internal";
      };
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
