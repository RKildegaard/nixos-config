{
  description = "NixOS multi-host (laptop/desktop) + Home Manager + Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    forSystem = system: let
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      pkgs = pkgs;
      lib = nixpkgs.lib;
    };
  in
  {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
          ./modules/common.nix
          ./modules/locale.nix
          ./modules/users.nix
          ./modules/packages.nix
          ./modules/devtools.nix
          ./modules/wayland-hyprland.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.raskil = import ./home/raskil/common.nix;
          }
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          ./modules/common.nix
          ./modules/locale.nix
          ./modules/users.nix
          ./modules/packages.nix
          ./modules/devtools.nix
          ./modules/wayland-hyprland.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.raskil = import ./home/raskil/common.nix;
          }
        ];
      };
    };
  };
}

