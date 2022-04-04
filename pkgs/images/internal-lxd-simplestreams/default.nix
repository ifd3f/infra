{ dockerTools, caddy, bashInteractive, internal-lxd-simplestreams-tree }:
dockerTools.buildImage {
  name = "ghcr.io/astralbijection/internal-lxd-simplestreams";
  contents = [ caddy bashInteractive internal-lxd-simplestreams-tree ];
  config.Entrypoint = [ "caddy" "file-server" "-root=${internal-lxd-simplestreams-tree}" ];
}
