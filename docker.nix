{
  lib,
  dockerTools,
  cacert,
  tzdata,
  grpc-proxy-full,
}:
let
  mkCliOptions = lib.cli.toGNUCommandLine { };
  defaultOptions = mkCliOptions {
    proxy-host = "0.0.0.0";
    admin-host = "0.0.0.0";
    backend-host = "host.docker.internal";
  };
in
dockerTools.buildLayeredImage {
  name = "grpc-proxy";
  tag = "latest";
  created = "now";
  contents = [
    cacert
    tzdata
  ];
  extraCommands = ''
    mkdir -m 1777 tmp
  '';
  config.Entrypoint = [ (lib.getExe grpc-proxy-full) ] ++ defaultOptions;
}
