{ buildGoApplication, lib }:
buildGoApplication rec {
  name = "grpc-proxy";
  src = ./.;
  pwd = src;
  meta = with lib; {
    description =
      "Proxy server built on envoy providing a REST gateway and the ability to translate gRPC-Web and/or Connect requests requests into regular gRPC requests.";
    license = licenses.mit;
    maintainers = with maintainers; [ mirkolenz ];
    platforms = with platforms; linux ++ darwin;
    homepage = "https://github.com/mirkolenz/grpc-proxy";
    mainProgram = "grpc-proxy";
  };
}
