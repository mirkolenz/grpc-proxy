{
  lib,
  writeShellApplication,
  env,
  coreutils,
  gomplate,
  envoy,
  ...
}:
writeShellApplication {
  name = "entrypoint";
  text = ''
    if [ $# -eq 0 ]; then
      ${coreutils}/bin/echo "The following parameters are required: PROXY_PORT, BACKEND_PORT." >&2
      ${coreutils}/bin/echo "Open the manual for details: https://github.com/mirkolenz/grpc-proxy" >&2
      exit 1
    fi

    PROXY_OUTDIR=$(${coreutils}/bin/mktemp --directory)
    PROXY_ENVOY_CONFIG="$PROXY_OUTDIR/envoy.yaml"

    ${coreutils}/bin/env --ignore-environment \
      ${builtins.toString (lib.mapAttrsToList (key: val: "${key}=${val}") env)} \
      "$@" \
      ${lib.getExe gomplate} \
      --config ${./gomplate.yaml} \
      --file ${./envoy.yaml} \
      --out "$PROXY_ENVOY_CONFIG"

    ${lib.getExe envoy} -c "$PROXY_ENVOY_CONFIG"
  '';
}
