# NixOS setup

This repository manages NixOS hosts with flakes and Home Manager.

## Structure

- `flake.nix`
  - host registry and shared user defaults
- `modules/nixos/`
  - reusable NixOS modules
- `hosts/<hostname>/`
  - machine-specific NixOS config
- `home/default.nix`
  - reusable Home Manager config
- `home/fumi.nix`
  - compatibility wrapper for the current user
- `dotfiles/`
  - application config files
- `assets/`
  - static assets such as wallpapers

## Rebuild on current machine

```bash
cd ~/nix-config
sudo nixos-rebuild switch --flake .#$(hostname)
```

Or explicitly:

```bash
sudo nixos-rebuild switch --flake .#fumi-main
```

## Add a new machine

Replace `<new-host>` with the new machine name.

```bash
git clone <repo-url> ~/nix-config
cd ~/nix-config
mkdir -p hosts/<new-host>
sudo nixos-generate-config --dir ./hosts/<new-host>
```

Replace the generated `hosts/<new-host>/default.nix` with a small host file:

```nix
{ hostName, ... }:

{
  networking.hostName = hostName;
}
```

Register the host in `flake.nix`:

```nix
hosts = {
  fumi-main = {
    modules = [
      ./modules/nixos/bluetooth-audio.nix
    ];
  };

  fumi-no-nixos = { };

  <new-host> = { };
};
```

If the new machine needs host-specific modules, add them under `modules`:

```nix
<new-host> = {
  modules = [
    ./modules/nixos/bluetooth-audio.nix
  ];
};
```

If the new machine should use another Linux architecture or user:

```nix
<new-host> = {
  system = "aarch64-linux";
  user = {
    username = "alice";
    fullName = "Alice";
    gitName = "Alice";
    gitEmail = "alice@example.com";
  };
};
```

Commit the new files. Flakes only see tracked files.

```bash
git add flake.nix hosts/<new-host>
git commit -m "Add host <new-host>"
```

Apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#<new-host>
```

## Notes

`hardware-configuration.nix` is machine-specific. Generate it on each PC and do not copy it from another machine.

Shared NixOS settings live in `modules/nixos/common.nix`. Optional shared features, such as Bluetooth audio, live in separate modules so each host can opt in.

Home Manager receives `username`, `homeDirectory`, `gitName`, and `gitEmail` from `flake.nix`. Dotfiles should avoid hard-coded `/home/<user>` paths; generate those files from Home Manager when a path depends on the user.

If Home Manager reports that a file would be clobbered, this repo uses:

```nix
home-manager.backupFileExtension = "bak";
```
