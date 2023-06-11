# The container is built in `flake.nix`.
# This file is used for mutli-arch builds with buildx.
FROM grpc-proxy:$TARGETARCH
