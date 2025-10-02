{
  description = "NixOS multi-host (laptop/desktop) + Home Manager + Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    lib = nixpkgs.lib;

    # Helper to build a host by name with shared modules
    mkHost = hostPath: lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        hostPath

        # System modules (new paths)
        ./modules/system/common.nix
        ./modules/system/locale.nix
        ./modules/system/users.nix
        ./modules/system/packages.nix
        ./modules/system/devtools.nix
        ./modules/system/greetd.nix
        ./modules/system/wayland-hyprland.nix

        { nixpkgs.overlays = [ (import ./modules/overlays) ]; }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.raskil = import ./home/raskil;
        }
      ];
    };
  in {
    nixosConfigurations = {
      laptop  = mkHost ./hosts/laptop/configuration.nix;
      desktop = mkHost ./hosts/desktop/configuration.nix;
    };
  };
}

