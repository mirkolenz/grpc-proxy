{
  lib,
  writeShellApplication,
  opts,
  envoy,
  app,
  ...
}:
writeShellApplication {
  name = "grpc-proxy-full";
  text = ''
    ${lib.getBin app}/bin/grpc-proxy \
      ${builtins.toString (lib.mapAttrsToList (key: val: "--${key}=${val}") opts)} \
      "$@" \
      --envoy "${lib.getBin envoy}/bin/envoy"
  '';
}
