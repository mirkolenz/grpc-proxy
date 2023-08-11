# gRPC Proxy for REST, gRPC-Web, and Connect

Proxy server built on [envoy](https://github.com/envoyproxy/envoy) providing a REST gateway and the ability to translate [gRPC-Web](https://github.com/grpc/grpc-web) and/or [Connect](https://connect.build) requests requests into regular [gRPC](https://github.com/grpc/grpc) requests.
The Go binaries are available via GitHub Releases and we also provide a Docker image and a Nix package.

## Using the Full Distribution (with Envoy)

For most users, we recommend using our full distribution, which includes envoy.

### Docker (recommended)

```shell
docker run --rm -it -p 50052:50052 ghcr.io/mirkolenz/grpc-proxy:latest --proxy-port 50052 --backend-port 50051
```

### Nix (Linux only)

```shell
nix run github:mirkolenz/grpc-proxy#full -- --proxy-port 50052 --backend-port 50051
```

## Using the Binaries (without Envoy)

For this type of installation, we assume that you have envoy installed on your system.
Please refer to the [official documentation](https://www.envoyproxy.io/docs/envoy/latest/start/install) for instructions on how to install envoy.
If the envoy binary is not available in your `$PATH`, you can provide the path to the binary via the `--envoy` parameter.

### Go

First, install the binary:

```shell
go install github.com/mirkolenz/grpc-proxy@latest
```

Then, run the proxy as follows:

```shell
grpc-proxy --envoy /usr/bin/envoy --proxy-port 50052 --backend-port 50051
```

### Binary Downloads

Go to the [latest GitHub Release](https://github.com/mirkolenz/grpc-proxy/releases/latest) and download the binary for your platform for the list of assets.
Then, run the proxy as follows:

```shell
./grpc-proxy --envoy /usr/bin/envoy --proxy-port 50052 --backend-port 50051
```

### Nix (Linux and macOS)

```shell
nix run github:mirkolenz/grpc-proxy -- --proxy-port 50052 --backend-port 50051
```

## Special Considerations for the REST Gateway

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
grpc-proxy proxy_port=50052 backend_port=50051 --rest-proto-descriptor "./descriptor.binpb" --rest-services "package1.ServiceA,package2.ServiceB"
```

## Options and Help

<!-- echo -e "\n```txt\n$(COLUMNS=80 go run . --help)\n```" >> README.md -->

```txt
Usage: grpc-proxy --backend-port=BACKEND-PORT,... --proxy-port=INT

Flags:
  -h, --help             Show context-sensitive help.
      --version          Print version information.
      --access-log=/dev/stdout,...
                         Access log files.
      --envoy="envoy"    Path to the envoy executable. If set to an empty
                         string, the config will only be printed.

Backend Options
  --backend-host="127.0.0.1"    Host address of the backend.
  --backend-port=BACKEND-PORT,...
                                Port of the backend. Multiple can be provided to
                                enable load balancing via round robin.
  --backend-timeout=120         Timeout in seconds for requests sent to the
                                backend.

Proxy Options
  --proxy-host="127.0.0.1"    Host address of the envoy proxy.
  --proxy-port=INT            Port of the envoy proxy.

Admin Options
  --admin-host="127.0.0.1"    Host address of the admin interface.
  --admin-port=INT            Port of the admin interface.

REST Gateway Options
  --rest-proto-descriptor=STRING
                                  Supplies the filename of the proto descriptor
                                  set for the gRPC services.
  --rest-proto-descriptor-bin=STRING
                                  Supplies the binary content of the proto
                                  descriptor set for the gRPC services.
  --rest-service=REST-SERVICE,...
                                  A list of strings that supplies the
                                  fully qualified service names (i.e.
                                  “package_name.service_name”) that the
                                  transcoder will translate. If the service
                                  name doesn’t exist in proto_descriptor, Envoy
                                  will fail at startup. The proto_descriptor may
                                  contain more services than the service names
                                  specified here, but they won’t be translated.
                                  By default, the filter will pass through
                                  requests that do not map to any specified
                                  services. If the list of services is empty,
                                  filter is considered disabled. However,
                                  this behavior changes if reject_unknown_method
                                  is enabled.
  --[no-]rest-auto-mapping        Whether to route methods without the
                                  google.api.http option.
  --rest-convert-grpc-status      Whether to convert gRPC status headers to
                                  JSON. When trailer indicates a gRPC error and
                                  there was no HTTP body, take google.rpc.Status
                                  from the grpc-status-details-bin header
                                  and use it as JSON body. If there was no
                                  such header, make google.rpc.Status out of
                                  the grpc-status and grpc-message headers.
                                  The error details types must be present in the
                                  proto_descriptor.
  --rest-url-unescape-spec="ALL_CHARACTERS_EXCEPT_RESERVED"
                                  URL unescaping policy. This spec is only
                                  applied when extracting variable with multiple
                                  segments in the URL path. For example,
                                  in case of /foo/{x=*}/bar/{y=prefix/*}/{z=**}
                                  x variable is single segment and y and
                                  z are multiple segments. For a path with
                                  /foo/first/bar/prefix/second/third/fourth,
                                  x=first, y=prefix/second, z=third/fourth.
                                  If this setting is not specified, the value
                                  defaults to ALL_CHARACTERS_EXCEPT_RESERVED.
  --rest-query-param-unescape-plus
                                  If true, unescape + to space when extracting
                                  variables in query parameters. This is to
                                  support HTML 2.0
  --rest-match-unregistered-custom-verb
                                  If true, try to match the custom verb even
                                  if it is unregistered. By default, only match
                                  when it is registered. According to the http
                                  template syntax, the custom verb is “:”
                                  LITERAL at the end of http template.
  --rest-case-insensitive-enum-parsin
                                  Proto enum values are supposed to be in upper
                                  cases when used in JSON. Set this to true if
                                  your JSON request uses non uppercase enum
                                  values.
  --rest-max-request-body-size=10000000
                                  The maximum size of a request body to be
                                  transcoded, in bytes. A body exceeding this
                                  size will provoke a HTTP 413 Request Entity
                                  Too Large response. Large values may cause
                                  envoy to use a lot of memory if there are many
                                  concurrent requests.
  --rest-max-response-body-size=10000000
                                  The maximum size of a response body to be
                                  transcoded, in bytes. A body exceeding this
                                  size will provoke a HTTP 500 Internal Server
                                  Error response. Large values may cause envoy
                                  to use a lot of memory if there are many
                                  concurrent requests.
  --rest-ignore-unknown-query-parameters
                                  Whether to ignore query parameters that cannot
                                  be mapped to a corresponding protobuf field.
                                  Use this if you cannot control the query
                                  parameters and do not know them beforehand.
                                  Otherwise use ignored_query_parameters.
                                  Defaults to false.
  --rest-ignored-query-parameter=REST-IGNORED-QUERY-PARAMETER,...
                                  A list of query parameters to be ignored
                                  for transcoding method mapping. By default,
                                  the transcoder filter will not transcode a
                                  request if there are any unknown/invalid query
                                  parameters.
  --[no-]rest-add-whitespace      Whether to add spaces, line breaks and
                                  indentation to make the JSON output easy to
                                  read. Defaults to true.
  --rest-always-print-primitive-fields
                                  Whether to always print primitive fields. By
                                  default primitive fields with default values
                                  will be omitted in JSON output. For example,
                                  an int32 field set to 0 will be omitted.
                                  Setting this flag to true will override the
                                  default behavior and print primitive fields
                                  regardless of their values. Defaults to false.
  --rest-always-print-enums-as-ints
                                  Whether to always print enums as ints.
                                  By default they are rendered as strings.
                                  Defaults to false.
  --rest-preserve-proto-field-names
                                  Whether to preserve proto field names.
                                  By default protobuf will generate JSON field
                                  names using the json_name option, or lower
                                  camel case, in that order. Setting this flag
                                  will preserve the original field names.
                                  Defaults to false.
  --rest-stream-newline-delimited
                                  If true, return all streams as
                                  newline-delimited JSON messages instead of as
                                  a comma-separated array.
  --rest-reject-unknown-method    By default, a request that cannot be mapped to
                                  any specified gRPC services will pass-through
                                  this filter. When set to true, the request
                                  will be rejected with a HTTP 404 Not Found.
  --rest-reject-unknown-query-parameters
                                  By default, a request with query parameters
                                  that cannot be mapped to the gRPC request
                                  message will pass-through this filter.
                                  When set to true, the request will be rejected
                                  with a HTTP 400 Bad Request.
  --rest-reject-binding-body-field-collisions
                                  If this field is set to true, the request will
                                  be rejected if the binding value is different
                                  from the body value.
```
