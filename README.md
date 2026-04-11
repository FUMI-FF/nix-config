# NixOS setup

This repository manages my NixOS system with flakes and Home Manager.

## Structure

- `flake.nix`
  - entry point
- `hosts/<hostname>/`
  - machine-specific NixOS config
- `home/fumi.nix`
  - user environment
- `dotfiles/`
  - application config files
- `assets/`
  - static assets such as wallpapers

## Concepts

- `hosts/**`
  - OS / machine-level configuration
  - boot, networking, users, display manager, input method, fonts
- `home/fumi.nix`
  - user-level configuration
  - zsh, git, packages, dotfiles placement
- `dotfiles/`
  - actual config contents for applications like Hyprland, Waybar, Wofi, Neovim

## Rebuild on current machine

```bash
cd ~/nix-config
sudo nixos-rebuild switch --flake .#$(hostname)
````

Or explicitly:

```bash
sudo nixos-rebuild switch --flake .#fumi-no-nixos
```

## Add a new machine

### 1. Clone this repository

```bash
git clone <repo-url>
cd nix-config
```

### 2. Create a host directory

Replace `<new-host>` with the new machine name.

```bash
mkdir -p hosts/<new-host>
sudo nixos-generate-config --dir ./hosts/<new-host>
```

This generates:

* `hosts/<new-host>/hardware-configuration.nix`
* `hosts/<new-host>/default.nix`

### 3. Replace generated `default.nix`

The generated `default.nix` is only a temporary scaffold.

Copy the existing host config and edit it for the new machine:

```bash
cp hosts/fumi-no-nixos/default.nix hosts/<new-host>/default.nix
```

Then update at least:

```nix
networking.hostName = "<new-host>";
```

### 4. Add the new host to `flake.nix`

Example:

```nix
nixosConfigurations.<new-host> = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/<new-host>/hardware-configuration.nix
    ./hosts/<new-host>/default.nix

    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";

      home-manager.users.fumi = import ./home/fumi.nix;
    }
  ];
};
```

### 5. Commit new files

Flakes only see tracked files, so make sure new files are added to git.

```bash
git add flake.nix hosts/<new-host>
git commit -m "Add host <new-host>"
```

### 6. Apply configuration on the new machine

```bash
sudo nixos-rebuild switch --flake .#<new-host>
```

## Notes

### Hardware config is machine-specific

`hardware-configuration.nix` is generated per machine and should not be shared across different PCs.

### Flakes only see tracked files

If a file exists locally but is not added to git, Nix may fail with `path does not exist`.

Example:

```bash
git add assets/pixel_town.jpg
```

### Home Manager file conflicts

If Home Manager reports that a file would be clobbered, existing files may need to be backed up or removed.

This repo uses:

```nix
home-manager.backupFileExtension = "bak";
```

### Hyprland / Hyprpaper

* Hyprland is enabled in `hosts/**`
* config files are placed from `dotfiles/hypr`
* wallpapers are stored under `assets/` and linked into `~/Pictures/wallpapers/`

## Current workflow

* frequently edited app configs stay in `dotfiles/`
* package installation and user environment are managed by Nix / Home Manager
* stable or shared settings can later be moved further into Nix modules

## Future improvements

* split common host config into `hosts/common`
* automate host creation
* reduce manual `flake.nix` edits when adding new machines
