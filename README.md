Install dzgui on nix-based systems

# Installation

## Using flake profiles (manual updates)

```
# install
nix profile install github:lelgenio/dzgui-nix

# update
nix profile upgrade '.*dzgui.*'
```

## As a flake input (auto updates)

Flake users are expected to have a `flake.nix` file and a `configuration.nix`.

Note that this is just a suggestion on how to to it, you may have different configuration structure.

1 - Add `dzgui` as a flake input:

```nix
# flake.nix
{
    inputs.dzgui = {
        # url of this repository, may change in the future
        url = "github:lelgenio/dzgui-nix";
        # save storage by not having duplicates of packages
        inputs.nixpkgs.follows = "nixpkgs";
    };
    # outputs...
}
```

2 - Pass `inputs` to your to you system config

```nix
# flake.nix
{
    outputs = inputs@{pkgs, ...}: {
        nixosConfigurations.your-hostname-here = lib.nixosSystem {
            specialArgs = { inherit inputs; };
            # modules...
        };
    };
}
```

3 - Add dzgui as a package in your system:

```nix
# configuration.nix
# this is the file generate by `nixos-generate-config`
{ inputs, pkgs, ... }: {
    environment.systemPackages = [
        inputs.dzgui.packages.${pkgs.system}.dzgui
    ];
}
```

4 - Rebuild your system

```sh
nixos-rebuild --switch --flake .#your-hostname-here
```

Now dzgui will auto update together with your system.

## On non flake systems

Good luck.
