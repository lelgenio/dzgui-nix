{
  description = "DayZ TUI/GUI server browser";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    dzgui = {
      url = "github:aclist/dztui";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, dzgui, ... }:
    let
      # DayZ only runs on x86_64 systems
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in with pkgs; {
      packages.${system} = {
        default = self.packages.${system}.dzgui;
        dzgui = (pkgs.callPackage ./. { }).overrideAttrs (_: { src = dzgui; });
      };

      devShells.${system}.default =
        mkShell { buildInputs = self.packages.${system}.default.runtimeDeps; };
    };
}
