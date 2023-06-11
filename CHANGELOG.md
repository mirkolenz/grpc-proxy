# Changelog

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