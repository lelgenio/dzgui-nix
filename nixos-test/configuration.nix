{
  imports = [ ../module.nix ];
  programs.dzgui.enable = true;

  boot.isContainer = true;
  system.stateVersion = "24.05";
}
