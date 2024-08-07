{
  description = "DayZ TUI/GUI server browser";
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs, ... }:
    let
      # DayZ only runs on x86_64 systems
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };
    in
    with pkgs; {
      packages.${system} = rec {
        default = dzgui;
        inherit (pkgs) dzgui;
      };

      overlays = {
        default = (final: _: {
          dzgui = (final.callPackage ./package { });
        });
      };

      nixosModules = rec {
        default = dzgui;
        dzgui = import ./module.nix { inherit self; };
      };

      devShells.${system}.default =
        mkShell { buildInputs = self.packages.${system}.default.runtimeDeps; };
    };
}
