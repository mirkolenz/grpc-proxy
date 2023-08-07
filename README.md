# gRPC Proxy for REST, gRPC-Web, and Connect

Proxy server built on [envoy](https://github.com/envoyproxy/envoy) providing a REST gateway and the ability to translate [gRPC-Web](https://github.com/grpc/grpc-web) and/or [Connect](https://connect.build) requests requests into regular [gRPC](https://github.com/grpc/grpc) requests.

## Usage

### Docker (recommended)

```shell
docker run --rm -it -p 50052:50052 ghcr.io/mirkolenz/grpc-proxy:latest PROXY_PORT=50052 BACKEND_PORT=50051
```

### Nix (advanced)

_Note:_ Currently only works on Linux systems.

```shell
nix run github:mirkolenz/grpc-proxy -- PROXY_PORT=50052 BACKEND_PORT=50051
```

## Parameters

| Parameter               | Description                                                                                    | Default                                            |
| ----------------------- | ---------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| `PROXY_PORT`            | The port at which the proxy server will listen for incoming requests.                          | _required_                                         |
| `BACKEND_PORT`          | The port of the gRPC backend server.                                                           | _required_                                         |
| `ADMIN_PORT`            | The port of the envoy admin page.                                                              | _optional_                                         |
| `PROXY_HOST`            | The host at which the proxy server will listen for incoming requests.                          | `127.0.0.1` (nix), `0.0.0.0` (docker)              |
| `BACKEND_HOST`          | The host of the gRPC backend server.                                                           | `127.0.0.1` (nix), `host.docker.internal` (docker) |
| `ADMIN_HOST`            | The host of the envoy admin page.                                                              | `127.0.0.1` (nix), `0.0.0.0` (docker)              |
| `BACKEND_TIMEOUT`       | Time to wait for a response from the backend server.                                           | `120s`                                             |
| `ACCESS_LOG`            | The path to envoy's access log file.                                                           | `/dev/stdout`                                      |
| `REST_PROTO_DESCRIPTOR` | Protobuf descriptor set of the gRPC services.                                                  | _optional_ (see notes below)                       |
| `REST_SERVICES`         | Fully qualified names (separated via comma) of the gRPC services to be exposed via a REST API. | _optional_ (see notes below)                       |

The gRPC-Web and Connect translation works without any additional configuration.
The REST gateway requires the protobuf descriptor set as well as an explicit list of services to be exposed.

If you are already using [buf](https://buf.build), make sure to add `buf.build/googleapis/googleapis` to your `deps`.
Then, you can generate the descriptor set as follows:

```shell
buf build -o descriptor.binpb
```

When using plain `protoc`, please refer to the [official documentation](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/grpc_json_transcoder_filter).
Bear in mind that in case of using Docker, you need to mount the descriptor set into the container (e.g., `-v $(pwd)/descriptor.binpb:/descriptor.binpb`).
Afterwards, run the proxy as follows:

```shell
grpc-proxy PROXY_PORT=50052 BACKEND_PORT=50051 REST_PROTO_DESCRIPTOR=./descriptor.binpb REST_SERVICES=package1.ServiceA,package2.ServiceB
```

The envoy REST gateway provides [several configuration options](https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/http/grpc_json_transcoder/v3/transcoder.proto).
We are using the default values for all of them except for `auto_mapping: true`.
To alter a parameter, uppercase its name and prefix it with `REST_` (e.g., `auto_mapping: true` becomes `REST_AUTO_MAPPING=true`).

## Related Projects

- [bufbuild/connect-envoy-demo](https://github.com/bufbuild/connect-envoy-demo)
- [kilroybot/grpc-web-proxy](https://github.com/kilroybot/grpc-web-proxy)

## Development

The project uses Nix to manage dependencies and build the project (including the docker containers).
Releases are automatically handled by GitHub Actions through semantic-release.
Any kind of contribution is welcome!
