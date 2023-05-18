Install dzgui on nix-based systems

# Installation

## Using flake profiles (not recommended)

```sh
# install
nix profile install github:lelgenio/dzgui-nix

# update
nix profile upgrade '.*dzgui.*'
```

### You will also *need* to set `vm.max_map_count`:

This is done automatically if you install via NixOs modules as shown 

#### on NixOs systems:

```nix
# configuration.nix
{
    boot.kernel.sysctl."vm.max_map_count" = 1048576;
}
```

#### on non-NixOs systems:

```sh
sudo sysctl -w vm.max_map_count | sudo tee /etc/sysctl.d/dayz.conf
```

## As a NixOs module (recommended)

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

2 - Add the `dzgui-nix` module to your system configuration, and enable it:

```nix
# flake.nix
{
    outputs = inputs@{pkgs, ...}: {
        nixosConfigurations.your-hostname-here = lib.nixosSystem {
            modules = [ 
                # Add the module
                inputs.dzgui-nix.nixosModules.default 
                # Enable it, this can also go in configuration.nix
                { programs.dzgui.enable = true; }
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

## On non flake systems

Good luck.
