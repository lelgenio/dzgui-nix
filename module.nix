{ self, ... }:
{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.programs.dzgui;
in
{
  options.programs.dzgui = {
    enable = mkEnableOption (mdDoc ''
      Weather to install dzgui and setup workarounds for DayZ to work on linux
    '');
    package = mkOption {
      type = with types; nullOr package;
      default = pkgs.dzgui;
      defaultText = literalExpression "pkgs.dzgui";
      description = mdDoc "Dzgui package to use.";
    };
  };
  config = mkIf cfg.enable {
    # Needed by DayZ
    boot.kernel.sysctl."vm.max_map_count" = 1048576;
    nixpkgs.overlays = [ self.overlays.default ];
    environment.systemPackages = [ cfg.package ];
  };
}
