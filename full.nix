{ lib, envoy, grpc-proxy, makeBinaryWrapper, }:
grpc-proxy.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeBinaryWrapper ];
  postInstall = ''
    wrapProgram $out/bin/grpc-proxy \
      --prefix PATH : ${lib.makeBinPath [ envoy ]}
  '';
  meta = old.meta // {
    platforms = lib.intersectLists old.meta.platforms envoy.meta.platforms;
  };
})
