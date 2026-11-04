_: {
  perSystem = {pkgs, ...}: {
    packages = {
      artcraft-launcher = pkgs.callPackage ../../pkgs/artcraft-launcher.nix {};
      matlab = pkgs.callPackage ../../pkgs/matlab-fhs.nix {};
      sam-ba = pkgs.callPackage ../../pkgs/sam-ba.nix {};
    };
  };
}
