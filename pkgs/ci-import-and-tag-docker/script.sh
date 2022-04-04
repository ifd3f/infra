imagetar=$1
if [ ! -f "$imagetar" ]; then
    echo "ERROR: Please specify a valid image tar file"
    echo "Usage: $0 [docker image tar] [additional tags ...]"
    exit 1
fi
shift 1

echo "=== Loading image $imagetar ==="
docker load -i $imagetar

for tag in "$@"; do
    echo "=== Tagging images with $tag ==="
    docker image ls --format "docker image tag {{.Repository}}:{{.Tag}} {{.Repository}}:$tag" | bash
done

echo "=== Pushing tags ==="
docker image ls --format "docker push {{.Repository}}:{{.Tag}}" | bash

