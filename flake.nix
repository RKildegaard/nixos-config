{
  description = "NixOS multi-host (laptop/desktop) + Home Manager + Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
  let
    lib = nixpkgs.lib;

    # Build a host with the shared module stack
    mkHost = hostPath: lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit self nixos-hardware; };
      
      modules = [
        ./modules/nixos
        hostPath

        # Optional overlays
        { nixpkgs.overlays = [ (import ./modules/overlays) ]; }

        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Make 'self' available inside your HM modules (so you can use self.packages.*)
          home-manager.extraSpecialArgs = { inherit self; };

          home-manager.users.raskil = import ./home/raskil;
        }
      ];
    };

    # Build our Rust settings app for each system we care about
    forAllSystems = f: lib.genAttrs [ "x86_64-linux" ] (system:
      f (import nixpkgs { inherit system; })
    );

  in {
    # NixOS machines
    nixosConfigurations = {
      laptop  = mkHost ./hosts/laptop;
      desktop = mkHost ./hosts/desktop;
    };

    # Packages produced by this flake (Rust GUI app)
    packages = forAllSystems (pkgs:
      let
        raskilSettings = pkgs.rustPlatform.buildRustPackage {
          pname = "raskil-settings";
          version = "0.1.0";
          src = ./apps/settings;
          cargoLock = { lockFile = ./apps/settings/Cargo.lock; };

          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.wrapGAppsHook4
          ];
          buildInputs = [
            pkgs.gtk4
            pkgs.libadwaita
          ];

          RUSTFLAGS = "-C debuginfo=0";
        };
      in {
        raskil-settings = raskilSettings;
        default = raskilSettings;
      }
    );
  };
}
