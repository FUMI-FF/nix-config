{
  description = "NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # 安定が良ければ nixos-25.11 みたいに固定してOK
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

        # Home Manager を NixOS module として統合
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
  # let
  #   system = "x86_64-linux";
  #   host = "fumi-no-nixos";
  # in {
  #   nixosConfigurations."fumi-no-nixos" = nixpkgs.lib.nixosSystem {
  #     inherit system;

  #     modules = [
  #       ./hosts/${host}/hardware-configuration.nix
  #       ./hosts/${host}/default.nix

  #       # Home Manager を NixOS module として統合
  #       home-manager.nixosModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.backupFileExtension = "bak";
  #         home-manager.users.fumi = import ./home/fumi.nix;
  #       }
  #     ];
  #   };
  # };
}
