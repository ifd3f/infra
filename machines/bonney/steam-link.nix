{
  # packaged via flatpak
  services.flatpak.enable = true;

  # Fails to run without this
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
}
