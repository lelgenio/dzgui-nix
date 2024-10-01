{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.dzgui;
in
{
  options.programs.dzgui = {
    enable = lib.mkEnableOption (
      lib.mdDoc ''
        Weather to install dzgui and setup workarounds for DayZ to work on linux
      ''
    );
    package = lib.mkOption {
      type = with lib.types; nullOr package;
      default = pkgs.callPackage ./package { };
      defaultText = lib.literalExpression "pkgs.dzgui";
      description = lib.mdDoc "Dzgui package to use.";
    };
  };
  config = lib.mkIf cfg.enable {
    # Needed by DayZ
    boot.kernel.sysctl."vm.max_map_count" = 1048576;
    environment.systemPackages = [ cfg.package ];
  };
}
