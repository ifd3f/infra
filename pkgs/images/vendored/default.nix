# VM images from external sources
{ pkgs }: {
  vendored-centos-8-cloud = pkgs.fetchurl {
    url = "https://dl.rockylinux.org/pub/rocky/8.5/images/Rocky-8-GenericCloud-8.5-20211114.2.x86_64.qcow2";
    sha256 = "c23f58f26f73fb9ae92bfb4cf881993c23fdce1bbcfd2881a5831f90373ce0c8";
  };

  vendored-talos-os = pkgs.fetchurl {
    url = "https://github.com/siderolabs/talos/releases/download/v1.0.0/talos-amd64.iso";
    sha256 = "sha256-UiyVJzhceKDtpebSoLVdr9tbh6OAxuG8QsBIDjJE8qg=";
  };
}

