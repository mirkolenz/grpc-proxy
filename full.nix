{
  lib,
  callPackage,
  writeShellApplication,
  envoy,
  flags ? {},
}: let
  app = callPackage ./. {};
  _flags = lib.mapAttrsToList (key: val: ''--${key} "${val}"'') flags;
in
  writeShellApplication {
    name = "grpc-proxy-full";
    text = ''
      ${lib.getBin app}/bin/grpc-proxy \
        ${builtins.toString _flags} \
        "$@" \
        --envoy "${lib.getBin envoy}/bin/envoy"
    '';
  }
