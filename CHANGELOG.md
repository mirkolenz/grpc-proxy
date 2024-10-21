# Changelog

## [3.0.4](https://github.com/mirkolenz/grpc-proxy/compare/v3.0.3...v3.0.4) (2024-10-21)


### Bug Fixes

* **rest:** remove empty proto descriptor flags, otherwise envoy fails ([2cd4593](https://github.com/mirkolenz/grpc-proxy/commit/2cd45935122f2c7e355660ef0579172a4f3f371d))

## [3.0.3](https://github.com/mirkolenz/grpc-proxy/compare/v3.0.2...v3.0.3) (2024-10-20)


### Bug Fixes

* **rest:** update cli flag names of array params ([5b98dca](https://github.com/mirkolenz/grpc-proxy/commit/5b98dcaee10d0bbb0f4ecca3c100dc460b02c2a3))

## [3.0.2](https://github.com/mirkolenz/grpc-proxy/compare/v3.0.1...v3.0.2) (2024-10-19)


### Bug Fixes

* **envoy:** check for proto descriptor file and bin ([f51da6b](https://github.com/mirkolenz/grpc-proxy/commit/f51da6b5ee879bb4571632d6430747593cfef0e5))

## [3.0.1](https://github.com/mirkolenz/grpc-proxy/compare/v3.0.0...v3.0.1) (2023-10-11)


### Bug Fixes

* bump kong to v0.8.1 ([795d8a6](https://github.com/mirkolenz/grpc-proxy/commit/795d8a6b468f77d310e652c92258b518600313c9))

## [3.0.0](https://github.com/mirkolenz/grpc-proxy/compare/v2.0.0...v3.0.0) (2023-09-30)


### ⚠ BREAKING CHANGES

* The entire application is now written in Go. This makes it possible to run the proxy with an existing envoy installation and decouples it from Nix. The tools also gained a full POSIC-compatible CLI interface with proper help for all available options. You can now easily download pre-built binaries of the proxy or use Go to install it on your machine.

### Features

* allow configuration of cluster options ([586ea6a](https://github.com/mirkolenz/grpc-proxy/commit/586ea6a798d4afe0a948a8220abb35f72a4066e6))
* allow floating point values for timeout ([a01e30e](https://github.com/mirkolenz/grpc-proxy/commit/a01e30e22dafa235de8b19a33c580c41317c7545))
* rewrite entire application in go ([d3a1f61](https://github.com/mirkolenz/grpc-proxy/commit/d3a1f6162de402decf5ea5f8dc2567ee4381dece))


### Bug Fixes

* add enum for url unescape spec ([d4a7f89](https://github.com/mirkolenz/grpc-proxy/commit/d4a7f891fe72c6ff7ba2810a9f0760de3a61b9bc))
* trigger ci build ([b4adea4](https://github.com/mirkolenz/grpc-proxy/commit/b4adea4f1627d5754b16d49ac56f725073c3d3e9))

## [3.0.0-beta.4](https://github.com/mirkolenz/grpc-proxy/compare/v3.0.0-beta.3...v3.0.0-beta.4) (2023-09-05)


### Bug Fixes

* add enum for url unescape spec ([d4a7f89](https://github.com/mirkolenz/grpc-proxy/commit/d4a7f891fe72c6ff7ba2810a9f0760de3a61b9bc))

## [3.0.0-beta.3](https://github.com/mirkolenz/grpc-proxy/compare/v3.0.0-beta.2...v3.0.0-beta.3) (2023-09-05)


### Features

* allow configuration of cluster options ([586ea6a](https://github.com/mirkolenz/grpc-proxy/commit/586ea6a798d4afe0a948a8220abb35f72a4066e6))
* allow floating point values for timeout ([a01e30e](https://github.com/mirkolenz/grpc-proxy/commit/a01e30e22dafa235de8b19a33c580c41317c7545))

## [3.0.0-beta.2](https://github.com/mirkolenz/grpc-proxy/compare/v3.0.0-beta.1...v3.0.0-beta.2) (2023-08-10)


### Bug Fixes

* trigger ci build ([b4adea4](https://github.com/mirkolenz/grpc-proxy/commit/b4adea4f1627d5754b16d49ac56f725073c3d3e9))

## [3.0.0-beta.1](https://github.com/mirkolenz/grpc-proxy/compare/v2.0.0...v3.0.0-beta.1) (2023-08-10)


### ⚠ BREAKING CHANGES

* The entire application is now written in Go. This makes it possible to run the proxy with an existing envoy installation and decouples it from Nix. The tools also gained a full POSIC-compatible CLI interface with proper help for all available options. You can now easily download pre-built binaries of the proxy or use Go to install it on your machine.

### Features

* rewrite entire application in go ([d3a1f61](https://github.com/mirkolenz/grpc-proxy/commit/d3a1f6162de402decf5ea5f8dc2567ee4381dece))

## [2.0.0](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.16...v2.0.0) (2023-08-08)


### ⚠ BREAKING CHANGES

* The parameters/options passed to the app should now be lowercased. That change should make it easier and faster to write the variable names.
* The project now includes a REST gateway in addition to the existing gRPC-Web proxy. To use it, create a descriptor set of your gRPC service and specify the services that shall be exposed. The readme has been updated with more details.

### Features

* add rest gateway ([ca0d7e3](https://github.com/mirkolenz/grpc-proxy/commit/ca0d7e35b0cabf3bdef85de6624bf4f8ef6f1290))
* allow multiple access log locations ([5a3c516](https://github.com/mirkolenz/grpc-proxy/commit/5a3c5169ab46c508f01d3406b41c35a6d73b728d))
* use lowercase parameters ([2828f38](https://github.com/mirkolenz/grpc-proxy/commit/2828f38ed0057e0605f01ca94afb4a46a6e07346))


### Bug Fixes

* improve startup logging ([b4de5dd](https://github.com/mirkolenz/grpc-proxy/commit/b4de5ddc2ca324538ac43c5f2b5b6e7e51e85949))
* print generated envoy config on startup ([e9b50ea](https://github.com/mirkolenz/grpc-proxy/commit/e9b50ea409650c0565a337d8ff49a3cdeea8aaf1))
* properly implement load balancing ([750721c](https://github.com/mirkolenz/grpc-proxy/commit/750721c41af0c5a9d1902b0c42dca98be7f35ed0))
* remove unneeded spacing in generated config ([392a6a6](https://github.com/mirkolenz/grpc-proxy/commit/392a6a603526af46fda4e6e4b678a16b0ef06987))
* silence nix lib.getExe warnings ([06edc20](https://github.com/mirkolenz/grpc-proxy/commit/06edc208d3d76f64eed93b1360396a4b50fdeb43))

## [1.0.16](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.15...v1.0.16) (2023-06-20)


### Bug Fixes

* allow/expose more headers ([#3](https://github.com/mirkolenz/grpc-proxy/issues/3)) ([d3d88f9](https://github.com/mirkolenz/grpc-proxy/commit/d3d88f9ca8a350b8cf4f84ba7766e9b668f07859))

## [1.0.15](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.14...v1.0.15) (2023-06-12)


### Bug Fixes

* add extra platforms to nix ([e5fccfd](https://github.com/mirkolenz/grpc-proxy/commit/e5fccfd5777d74f10e62ea0651b4d860705a2670))

## [1.0.14](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.13...v1.0.14) (2023-06-12)


### Bug Fixes

* move qemu action to top in ci ([751e1e7](https://github.com/mirkolenz/grpc-proxy/commit/751e1e7c9f2b922befd4535b5c3bde7ae00df78c))

## [1.0.13](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.12...v1.0.13) (2023-06-12)


### Bug Fixes

* add qemu action in ci ([761f3ff](https://github.com/mirkolenz/grpc-proxy/commit/761f3ffa05baaca42629b6e14fa4a93ff01fd960))

## [1.0.12](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.11...v1.0.12) (2023-06-12)


### Bug Fixes

* check for parameters was not working ([c867ce2](https://github.com/mirkolenz/grpc-proxy/commit/c867ce2b648119cacfa9e0caee9b84a4ce401ac7))

## [1.0.11](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.10...v1.0.11) (2023-06-12)


### Bug Fixes

* use qemu instead of pkgsCross ([8d4e2dd](https://github.com/mirkolenz/grpc-proxy/commit/8d4e2ddf76e484b0fa6f84014fae0c222cef2b9c))

## [1.0.10](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.9...v1.0.10) (2023-06-12)


### Bug Fixes

* refactor using callPackage and pkgsCross ([5810059](https://github.com/mirkolenz/grpc-proxy/commit/5810059543726ed1ec3bde7cdcb8288a83140764))

## [1.0.9](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.8...v1.0.9) (2023-06-11)


### Bug Fixes

* do not remove manifest after upload ([3f3accf](https://github.com/mirkolenz/grpc-proxy/commit/3f3accf42ce971714ae09a93c71e8a4907889b1f))

## [1.0.8](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.7...v1.0.8) (2023-06-11)


### Bug Fixes

* enable echo for docker manifest ([4fc0adc](https://github.com/mirkolenz/grpc-proxy/commit/4fc0adcd777d88bc6c976d95c25005fa4800dd6f))

## [1.0.7](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.6...v1.0.7) (2023-06-11)


### Bug Fixes

* move from buildx to buildah for multi-arch ([af2057c](https://github.com/mirkolenz/grpc-proxy/commit/af2057ce51688ae91730a7f28725d262901f01a3))

## [1.0.6](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.5...v1.0.6) (2023-06-11)


### Bug Fixes

* remove initial arg from dockerfile ([3591a10](https://github.com/mirkolenz/grpc-proxy/commit/3591a10313fcb10152014f23159517687b0a8380))

## [1.0.5](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.4...v1.0.5) (2023-06-11)


### Bug Fixes

* actually build docker image in ci ([0ee549e](https://github.com/mirkolenz/grpc-proxy/commit/0ee549e15e0d61dbf950e0d06fb6fed3d8e39eaf))

## [1.0.4](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.3...v1.0.4) (2023-06-11)


### Bug Fixes

* use docker buildx for multi-arch images ([3109152](https://github.com/mirkolenz/grpc-proxy/commit/31091529ef7d2efa37bad2391bcc1467fc5cdbc5))

## [1.0.3](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.2...v1.0.3) (2023-06-11)


### Bug Fixes

* log into docker registry for publishing ([13d2884](https://github.com/mirkolenz/grpc-proxy/commit/13d28842e8a1571384727ab6ecde4a674e97efab))

## [1.0.2](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.1...v1.0.2) (2023-06-11)


### Bug Fixes

* create proper multi-arch docker manifest ([3682551](https://github.com/mirkolenz/grpc-proxy/commit/3682551e509783e472f9be6c0c77b4b2ad8a9cfc))

## [1.0.1](https://github.com/mirkolenz/grpc-proxy/compare/v1.0.0...v1.0.1) (2023-06-11)


### Bug Fixes

* add qemu-based aarch64 docker build ([4eba6d9](https://github.com/mirkolenz/grpc-proxy/commit/4eba6d9ede9df4bd8b9b1b9c75210e3ee285094e))

## 1.0.0 (2023-06-10)


### Features

* expose more config, automatic host detection ([a7ab8b9](https://github.com/mirkolenz/grpc-proxy/commit/a7ab8b9f89e6dd5b9db12e60a8351b615d1145af))
* initial version ([118b54f](https://github.com/mirkolenz/grpc-proxy/commit/118b54fa91b1a208af92837149900e6f6eb23f80))
* switch from envsubst to gomplate ([0d3ff82](https://github.com/mirkolenz/grpc-proxy/commit/0d3ff8274739a9d432d83c788008b4dce22e7372))


### Bug Fixes

* allow passing env vars as command args ([2b92786](https://github.com/mirkolenz/grpc-proxy/commit/2b92786e2e70f75e0b1d1bbeaa289fd4e05051b3))
* better handling of missing params ([008efe8](https://github.com/mirkolenz/grpc-proxy/commit/008efe86848de42c69980a373e361a4116993039))
