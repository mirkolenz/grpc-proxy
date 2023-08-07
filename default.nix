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
      ${coreutils}/bin/echo "The following parameters are required: proxy_port, backend_port." >&2
      ${coreutils}/bin/echo "Open the manual for details: https://github.com/mirkolenz/grpc-proxy" >&2
      exit 1
    fi

    proxy_outdir=$(${coreutils}/bin/mktemp --directory)
    proxy_config="$proxy_outdir/envoy.yaml"

    ${coreutils}/bin/env --ignore-environment \
      ${builtins.toString (lib.mapAttrsToList (key: val: "${key}=${val}") env)} \
      "$@" \
      ${lib.getBin gomplate}/bin/gomplate \
      --config ${./gomplate.yaml} \
      --file ${./envoy.yaml} \
      --out "$proxy_config"

    ${coreutils}/bin/echo "Generated the following configuration:"
    ${coreutils}/bin/cat "$proxy_config"

    ${coreutils}/bin/echo "Starting envoy..."
    ${lib.getBin envoy}/bin/envoy -c "$proxy_config"
  '';
}
