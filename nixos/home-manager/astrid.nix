{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Astrid Yu";
    userEmail = "astrid@astrid.tech";
  };

  home.packages = [
    pkgs.htop
  ];

  home.sessionVariables = {
    EDITOR = "vi";
  };
}
