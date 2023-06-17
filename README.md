# gRPC-Web/Connect Proxy

Proxy server built on [envoy](https://github.com/envoyproxy/envoy) which translates [gRPC-Web](https://github.com/grpc/grpc-web) and/or [Connect](https://connect.build) requests requests into regular [gRPC](https://github.com/grpc/grpc) requests.

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

| Parameter         | Description                                                           | Default                                            |
| ----------------- | --------------------------------------------------------------------- | -------------------------------------------------- |
| `PROXY_PORT`      | The port at which the proxy server will listen for incoming requests. | _required_                                         |
| `BACKEND_PORT`    | The port of the gRPC backend server.                                  | _required_                                         |
| `ADMIN_PORT`      | The port of the envoy admin page.                                     | _optional_                                         |
| `PROXY_HOST`      | The host at which the proxy server will listen for incoming requests. | `127.0.0.1` (nix), `0.0.0.0` (docker)              |
| `BACKEND_HOST`    | The host of the gRPC backend server.                                  | `127.0.0.1` (nix), `host.docker.internal` (docker) |
| `BACKEND_HOST`    | The host of the envoy admin page.                                     | `127.0.0.1` (nix), `0.0.0.0` (docker)              |
| `BACKEND_TIMEOUT` | Time to wait for a response from the backend server.                  | `120s`                                             |
| `ACCESS_LOG`      | The path to envoy's access log file                                   | `/dev/stdout`                                      |

## Related Projects

- [bufbuild/connect-envoy-demo](https://github.com/bufbuild/connect-envoy-demo)
- [kilroybot/grpc-web-proxy](https://github.com/kilroybot/grpc-web-proxy)

## Development

The project uses Nix to manage dependencies and build the project (including the docker containers).
Releases are automatically handled by GitHub Actions through semantic-release.
Any kind of contribution is welcome!
