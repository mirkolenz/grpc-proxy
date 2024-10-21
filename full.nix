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
      --prefix PATH : ${lib.makeBinPath [ envoy ]}
  '';
  meta = old.meta // {
    platforms = lib.platforms.linux;
  };
})
