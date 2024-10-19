{
  lib,
  writeShellApplication,
  envoy,
  grpc-proxy,
  flags ? { },
}:
let
  mkCliOptions = lib.cli.toGNUCommandLineShell { };
in
writeShellApplication {
  name = "grpc-proxy-full";
  text = ''
    ${lib.getExe grpc-proxy} \
      ${mkCliOptions flags} \
      "$@" \
      --envoy "${lib.getBin envoy}/bin/envoy"
  '';
}
