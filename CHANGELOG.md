# Changelog

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
