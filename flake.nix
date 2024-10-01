{
  description = "DayZ TUI/GUI server browser";
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };
  outputs =
    { self, nixpkgs, ... }:
    let
      # DayZ only runs on x86_64 systems
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system} = rec {
        default = dzgui;
        dzgui = pkgs.callPackage ./package { };
      };

      overlays = {
        default = (final: _: { dzgui = (final.callPackage ./package { }); });
      };

      nixosModules = rec {
        default = dzgui;
        dzgui = import ./module.nix;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = self.packages.${system}.default.runtimeDeps;
      };

      checks.${system}.nixosCheck =
        (nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            self.nixosModules.default
            {
              programs.dzgui.enable = true;

              boot.isContainer = true;
              system.stateVersion = "24.05";
            }
          ];
        }).config.system.build.toplevel;
    };
}
