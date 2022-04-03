{ writeScriptBin, docker, docker-tars }:
let
in writeScriptBin "ci-import-and-tag-docker" ''
  for imagetar in ${docker-tars}/*.tar*; do
    echo "=== Loading image $imagetar ==="
    docker load -i $imagetar
  done

  for tag in "$@"; do
    echo "=== Tagging images with $tag ==="
    docker image ls --format "docker image tag {{.Repository}}:{{.Tag}} {{.Repository}}:latest" | tee | bash
  done
''

