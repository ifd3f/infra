imagetar=$1
if [ ! -f "$imagetar" ]; then
    echo "ERROR: Please specify a valid image tar file"
    echo "Usage: $0 [docker image tar] [additional tags ...]"
    exit 1
fi
shift 1

echo "=== Loading image $imagetar ==="
image=$(docker load -i $imagetar | tr -d '\n' | sed -r 's/Loaded image: (.*)$/\1/')
repository="${image%:*}"

echo "Image:      $image"
echo "Repository: $repository"

for tag in "$@"; do
    newTag="$repository:$tag"
    echo "=== Tagging $image -> $newTag ==="
    docker image tag $image $newTag
done

echo "=== Pushing tags ==="
docker push -a $repository

