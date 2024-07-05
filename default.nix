{
  pkgs ? import <nixpkgs> { },
}:
{
  dzgui = pkgs.callPackage ./package { };
}
