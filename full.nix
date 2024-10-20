{
  lib,
  envoy,
  grpc-proxy,
  makeWrapper,
}:
grpc-proxy.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/grpc-proxy \
      --add-flags "--envoy ${lib.getExe envoy}"
  '';
  meta = old.meta // {
    platforms = lib.platforms.linux;
  };
})
