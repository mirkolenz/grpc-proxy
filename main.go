package main

import (
	"bytes"
	_ "embed"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"runtime/debug"
	"strings"
	"text/template"

	"github.com/alecthomas/kong"
)

var cli struct {
	Version    kong.VersionFlag `help:"Print version information."`
	AccessLogs []string         `help:"Access log files." name:"access-log" type:"path" default:"/dev/stdout"`
	Envoy      string           `default:"envoy" help:"Path to the envoy executable. If set to an empty string, the config will only be printed."`
	Backend    struct {
		Host    string `default:"127.0.0.1" help:"Host address of the backend."`
		Ports   []int  `required:"" name:"port" help:"Port of the backend. Multiple can be provided to enable load balancing via round robin."`
		Timeout int    `default:"120" help:"Timeout in seconds for requests sent to the backend."`
	} `embed:"" prefix:"backend-" group:"Backend Options"`
	Proxy struct {
		Host string `default:"127.0.0.1" help:"Host address of the envoy proxy."`
		Port int    `required:"" help:"Port of the envoy proxy."`
	} `embed:"" prefix:"proxy-" group:"Proxy Options"`
	Admin struct {
		Host string `default:"127.0.0.1" help:"Host address of the admin interface."`
		Port int    `optional:"" help:"Port of the admin interface."`
	} `embed:"" prefix:"admin-" group:"Admin Options"`
	Rest struct {
		Type                         string   `hidden:"" json:"@type" default:"type.googleapis.com/envoy.extensions.filters.http.grpc_json_transcoder.v3.GrpcJsonTranscoder"`
		ProtoDescriptor              string   `json:"proto_descriptor" xor:"proto_descriptor" type:"existingfile" help:"Supplies the filename of the proto descriptor set for the gRPC services."`
		ProtoDescriptorBin           string   `json:"proto_descriptor_bin" xor:"proto_descriptor" help:"Supplies the binary content of the proto descriptor set for the gRPC services."`
		Services                     []string `json:"services" name:"service" help:" A list of strings that supplies the fully qualified service names (i.e. “package_name.service_name”) that the transcoder will translate. If the service name doesn't exist in proto_descriptor, Envoy will fail at startup. The proto_descriptor may contain more services than the service names specified here, but they won’t be translated. By default, the filter will pass through requests that do not map to any specified services. If the list of services is empty, filter is considered disabled. However, this behavior changes if reject_unknown_method is enabled."`
		AutoMapping                  bool     `json:"auto_mapping" default:"true" negatable:"" help:"Whether to route methods without the google.api.http option."`
		ConvertGrpcStatus            bool     `json:"convert_grpc_status" help:"Whether to convert gRPC status headers to JSON. When trailer indicates a gRPC error and there was no HTTP body, take google.rpc.Status from the grpc-status-details-bin header and use it as JSON body. If there was no such header, make google.rpc.Status out of the grpc-status and grpc-message headers. The error details types must be present in the proto_descriptor."`
		UrlUnescapeSpec              string   `json:"url_unescape_spec" default:"ALL_CHARACTERS_EXCEPT_RESERVED" help:"URL unescaping policy. This spec is only applied when extracting variable with multiple segments in the URL path. For example, in case of /foo/{x=*}/bar/{y=prefix/*}/{z=**} x variable is single segment and y and z are multiple segments. For a path with /foo/first/bar/prefix/second/third/fourth, x=first, y=prefix/second, z=third/fourth. If this setting is not specified, the value defaults to ALL_CHARACTERS_EXCEPT_RESERVED."`
		QueryParamUnescapePlus       bool     `json:"query_param_unescape_plus" help:"If true, unescape + to space when extracting variables in query parameters. This is to support HTML 2.0"`
		MatchUnregisteredCustomVerb  bool     `json:"match_unregistered_custom_verb" help:"If true, try to match the custom verb even if it is unregistered. By default, only match when it is registered. According to the http template syntax, the custom verb is “:” LITERAL at the end of http template."`
		CaseInsensitiveEnumParsin    bool     `json:"case_insensitive_enum_parsing" help:"Proto enum values are supposed to be in upper cases when used in JSON. Set this to true if your JSON request uses non uppercase enum values."`
		MaxRequestBodySize           uint32   `json:"max_request_body_size" default:"10000000" help:" The maximum size of a request body to be transcoded, in bytes. A body exceeding this size will provoke a HTTP 413 Request Entity Too Large response. Large values may cause envoy to use a lot of memory if there are many concurrent requests."`
		MaxResponseBodySize          uint32   `json:"max_response_body_size" default:"10000000" help:"The maximum size of a response body to be transcoded, in bytes. A body exceeding this size will provoke a HTTP 500 Internal Server Error response. Large values may cause envoy to use a lot of memory if there are many concurrent requests."`
		IgnoreUnknownQueryParameters bool     `json:"ignore_unknown_query_parameters" help:"Whether to ignore query parameters that cannot be mapped to a corresponding protobuf field. Use this if you cannot control the query parameters and do not know them beforehand. Otherwise use ignored_query_parameters. Defaults to false."`
		IgnoredQueryParameters       []string `json:"ignored_query_parameters" name:"ignored-query-parameter" help:"A list of query parameters to be ignored for transcoding method mapping. By default, the transcoder filter will not transcode a request if there are any unknown/invalid query parameters."`
		Print                        struct {
			AddWhitespace              bool `json:"add_whitespace" default:"true" negatable:"" help:"Whether to add spaces, line breaks and indentation to make the JSON output easy to read. Defaults to true."`
			AlwaysPrintPrimitiveFields bool `json:"always_print_primitive_fields" help:"Whether to always print primitive fields. By default primitive fields with default values will be omitted in JSON output. For example, an int32 field set to 0 will be omitted. Setting this flag to true will override the default behavior and print primitive fields regardless of their values. Defaults to false."`
			AlwaysPrintEnumsAsInts     bool `json:"always_print_enums_as_ints" help:"Whether to always print enums as ints. By default they are rendered as strings. Defaults to false."`
			PreserveProtoFieldNames    bool `json:"preserve_proto_field_names" help:"Whether to preserve proto field names. By default protobuf will generate JSON field names using the json_name option, or lower camel case, in that order. Setting this flag will preserve the original field names. Defaults to false."`
			StreamNewlineDelimited     bool `json:"stream_newline_delimited" help:"If true, return all streams as newline-delimited JSON messages instead of as a comma-separated array."`
		} `embed:"" json:"print_options"`
		RequestValidation struct {
			RejectUnknownMethod              bool `json:"reject_unknown_method" help:"By default, a request that cannot be mapped to any specified gRPC services will pass-through this filter. When set to true, the request will be rejected with a HTTP 404 Not Found."`
			RejectUnknownQueryParameters     bool `json:"reject_unknown_query_parameters" help:"By default, a request with query parameters that cannot be mapped to the gRPC request message will pass-through this filter. When set to true, the request will be rejected with a HTTP 400 Bad Request."`
			RejectBindingBodyFieldCollisions bool `json:"reject_binding_body_field_collisions" help:"If this field is set to true, the request will be rejected if the binding value is different from the body value."`
		} `embed:"" json:"request_validation_options"`
	} `embed:"" prefix:"rest-" group:"REST Gateway Options"`
}

//go:embed envoy.yaml
var rawConfig string
var version string

func main() {
	var finalConfigBuffer bytes.Buffer

	if info, ok := debug.ReadBuildInfo(); ok && version == "" {
		version = info.Main.Version
	}

	ctx := kong.Parse(&cli, kong.Vars{
		"version": version,
	})

	tmpl := template.New("envoy.yaml").Delims("#<", ">#").Funcs(template.FuncMap{
		"toJson": func(v interface{}, indent int) string {
			b, _ := json.MarshalIndent(v, strings.Repeat(" ", indent), "  ")
			return string(b)
		},
	})

	template.Must(tmpl.Parse(rawConfig))

	err := tmpl.Execute(&finalConfigBuffer, cli)
	ctx.FatalIfErrorf(err)

	finalConfig := finalConfigBuffer.String()
	fmt.Println("Generated the following config:")
	fmt.Println(finalConfig)

	if cli.Envoy != "" {
		f, err := os.CreateTemp("", "envoy.*.yaml")
		ctx.FatalIfErrorf(err)
		f.WriteString(finalConfig)

		fmt.Println("Starting envoy...")

		cmd := exec.Command(cli.Envoy, "-c", f.Name())
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr

		err = cmd.Run()
		ctx.FatalIfErrorf(err)

		os.Remove(f.Name())
	}
}
