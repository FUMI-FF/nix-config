{
  description = "NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    host = "fumi-main";
  in {
    nixosConfigurations."fumi-main" = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/${host}/hardware-configuration.nix
        ./hosts/${host}/default.nix

        ({ lib, ... }: {
          nixpkgs.config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "vivaldi"
            ];
        })

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.users.fumi = import ./home/fumi.nix;
        }
      ];
    };
  };
}
