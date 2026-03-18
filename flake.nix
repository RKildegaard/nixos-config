{
  description = "NixOS multi-host (laptop/desktop) + Home Manager + Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
  let
    lib = nixpkgs.lib;

    mkHost = name: lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit nixos-hardware; };

      modules = [
        ./hosts/${name}

        { nixpkgs.overlays = [ (import ./modules/overlays) ]; }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.raskil = {
            imports = [
              ./home/raskil
              ./home/raskil/hosts/${name}.nix
            ];
          };
        }
      ];
    };

  in {
    nixosConfigurations = {
      laptop = mkHost "laptop";
      desktop = mkHost "desktop";
    };
  };
}
