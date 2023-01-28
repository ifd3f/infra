{
  # https://bbs.archlinux.org/viewtopic.php?pid=1727712#p1727712
  # Disabling 802.11n. This device only has one antenna, anyways, so
  # it's not like it would improve anything.
  boot.extraModprobeConfig = ''
    options iwlwifi 11n_disable=1
  '';
}
