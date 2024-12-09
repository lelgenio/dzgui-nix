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
        default = import ./overlay.nix;
      };

      nixosModules = rec {
        default = dzgui;
        dzgui = pkgs.lib.warn (
          "The dzgui NixOs module is deprecated and will be removed in the future, "
          + "check https://github.com/lelgenio/dzgui-nix/blob/main/README.md "
          + "for instructions on how to install dzgui as a regular package"
        ) (import ./module.nix);
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = self.packages.${system}.default.runtimeDeps;
      };

      checks.${system}.nixosCheck =
        (nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./nixos-test/configuration.nix ];
        }).config.system.build.toplevel;
    };
}
