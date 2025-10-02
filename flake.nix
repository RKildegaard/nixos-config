{
  description = "NixOS multi-host (laptop/desktop) + Home Manager + Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix (note: no leading 'inputs.' here)
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  # include sops-nix in the arg list so you can use sops-nix.nixosModules.sops
  outputs = { self, nixpkgs, home-manager, sops-nix, ... }:
  let
    lib = nixpkgs.lib;

    mkHost = hostPath: lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        hostPath

        # sops-nix module (enables `sops.*` options you used)
        sops-nix.nixosModules.sops

        # System modules
        ./modules/system/common.nix
        ./modules/system/locale.nix
        ./modules/system/users.nix
        ./modules/system/packages.nix
        ./modules/system/devtools.nix
        ./modules/system/greetd.nix
        ./modules/system/wayland-hyprland.nix

        # Optional overlays
        { nixpkgs.overlays = [ (import ./modules/overlays) ]; }

        # Home Manager
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

