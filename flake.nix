{
  description = "NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      defaultSystem = "x86_64-linux";

      defaultUser = {
        username = "fumi";
        fullName = "fumi";
        gitName = "fumi";
        gitEmail = "expugnatiomundi@gmail.com";
      };

      hosts = {
        fumi-main = {
          modules = [
            ./modules/nixos/bluetooth-audio.nix
          ];
        };

        fumi-no-nixos = { };
      };

      mkNixosConfiguration =
        hostName: hostConfig:
        let
          system = hostConfig.system or defaultSystem;
          user = defaultUser // (hostConfig.user or { });
        in
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit hostName;
            username = user.username;
            fullName = user.fullName;
          };

          modules = [
            ./hosts/${hostName}/hardware-configuration.nix
            ./modules/nixos/common.nix
            ./hosts/${hostName}

            (
              { lib, ... }:
              {
                nixpkgs.config.allowUnfreePredicate =
                  pkg:
                  builtins.elem (lib.getName pkg) [
                    "vivaldi"
                  ];
              }
            )

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.extraSpecialArgs = {
                inherit (user) username gitName gitEmail;
                homeDirectory = "/home/${user.username}";
              };
              home-manager.users.${user.username} = import ./home;
            }
          ]
          ++ (hostConfig.modules or [ ]);
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkNixosConfiguration hosts;
    };
}
