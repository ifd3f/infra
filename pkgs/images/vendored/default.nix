# VM images from external sources
{ pkgs }: {
  vendored-centos-8-cloud = pkgs.fetchurl {
    url = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20220125.1.x86_64.qcow2";
    sha256 = "sha256-olVgqznhBZTuekodrcunvzA7fDxBVZtKf8PFIlQKZnI=";
  };

  vendored-talos-os = pkgs.fetchurl {
    url = "https://github.com/siderolabs/talos/releases/download/v1.0.0/talos-amd64.iso";
    sha256 = "sha256-UiyVJzhceKDtpebSoLVdr9tbh6OAxuG8QsBIDjJE8qg=";
  };
}

