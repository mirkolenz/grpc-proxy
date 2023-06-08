# gRPC-Web/Connect Proxy

This is a gRPC-Web/Connect proxy server which translates gRPC-Web or Connect requests into regular gRPC HTTP/2 requests via envoy.

## Usage

```shell
docker run --rm -it -p 50052:50052 ghcr.io/recap-utr/grpc-proxy:latest PROXY_LISTEN_PORT=50052 PROXY_BACKEND_PORT=50051
```

## Parameters

| Parameter               | Description                                                           | Default                |
| ----------------------- | --------------------------------------------------------------------- | ---------------------- |
| `PROXY_LISTEN_PORT`     | The port at which the proxy server will listen for incoming requests. | _required_             |
| `PROXY_BACKEND_PORT`    | The port of the gRPC backend server.                                  | _required_             |
| `PROXY_BACKEND_HOST`    | The host of the gRPC backend server.                                  | `host.docker.internal` |
| `PROXY_BACKEND_TIMEOUT` | Time to wait for a response from the backend server.                  | `120s`                 |
| `PROXY_ACCESS_LOG`      | The path to envoy's access log file                                   | `/dev/stdout`          |
