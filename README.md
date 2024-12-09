Install dzgui on nix-based systems

# Installation

## Using flake profiles

```sh
# install
nix profile install github:lelgenio/dzgui-nix

# update
nix profile upgrade '.*dzgui.*'
```

## On non flake NixOs systems

```nix
# configuration.nix
{ pkgs, ... }:
let
  dzgui-nix = pkgs.fetchFromGitHub {
    owner = "lelgenio";
    repo = "dzgui-nix";
    rev = "995dd52adc6fe5cbbd4530a9f2add88e1e04d0da";
    hash = "sha256-giMAU0PqMOqTe3zQax4rTbhu5efyFcaQu3EP5CqPIaU=";
  };
  dzgui = (pkgs.callPackage "${dzgui-nix}/package");
in
{
  environment.systemPackages = [
    dzgui
  ];
}
```

## As part of a NixOs system flake

Flake users are assumed to have a `flake.nix` file and a `configuration.nix`.

1 - Add `dzgui-nix` as a flake input:

```nix
# flake.nix
{
    inputs.dzgui-nix = {
        # url of this repository, may change in the future
        url = "github:lelgenio/dzgui-nix";
        # save storage by not having duplicates of packages
        inputs.nixpkgs.follows = "nixpkgs";
    };
    # other inputs...
}
```

2 - Add the `dzgui` package to your environment packages:

```nix
# flake.nix
{
    outputs = inputs@{pkgs, ...}: {
        nixosConfigurations.your-hostname-here = lib.nixosSystem {
            modules = [
                {
                  environment.systemPackages = [
                    inputs.dzgui-nix.packages.default
                  ];
                }
                # other modules...
            ];
        };
    };
}
```

3 - Rebuild your system

```sh
nixos-rebuild --switch --flake .#your-hostname-here
```

Now dzgui will update together with your flake:

```sh
nix flake update
```
