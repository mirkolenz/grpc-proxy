{
  lib,
  writeShellApplication,
  buildah,
  branch,
  images,
  repo,
  version ? "",
  ...
}: let
  versionParts = lib.splitString "." version;
  tags =
    [branch]
    ++ (lib.optional (builtins.elem branch ["main" "master"]) "latest")
    ++ (lib.optional (version != "") version)
    ++ (lib.optionals (version != "" && !lib.hasInfix "-" version) [
      (lib.concatStringsSep "." (lib.sublist 0 2 versionParts))
      (builtins.elemAt versionParts 0)
    ]);
in
  writeShellApplication {
    name = "docker-manifest";
    text = ''
      set -x # echo on
      ${lib.getExe buildah} manifest create grpc-proxy
      for IMAGE in ${builtins.toString images}; do
        ${lib.getExe buildah} manifest add grpc-proxy docker-archive:$IMAGE
      done
      for TAG in ${builtins.toString tags}; do
        ${lib.getExe buildah} manifest push --all --format v2s2 grpc-proxy docker://ghcr.io/${repo}:$TAG
      done
    '';
  }
