{
  description = "NixOS multi-host (laptop/desktop) + Home Manager + Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
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
        hostPath


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
      laptop  = mkHost ./hosts/laptop/configuration.nix;
      desktop = mkHost ./hosts/desktop/configuration.nix;
    };

    # Packages produced by this flake (Rust GUI app)
    packages = forAllSystems (pkgs: {
      raskil-settings = pkgs.rustPlatform.buildRustPackage {
        pname = "raskil-settings";
        version = "0.1.0";
        src = ./apps/settings;                     # <- your Rust project root
        cargoLock = { lockFile = ./apps/settings/Cargo.lock; };

        nativeBuildInputs = [
          pkgs.pkg-config
          pkgs.wrapGAppsHook4
        ];
        buildInputs = [
          pkgs.gtk4
          pkgs.libadwaita
        ];

        # Optional: speed up builds a bit
        RUSTFLAGS = "-C debuginfo=0";
      };
    });

    # (Optional) default package for `nix build .`
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.raskil-settings;
  };
}

