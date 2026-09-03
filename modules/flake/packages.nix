_: {
  perSystem = {pkgs, ...}: {
    packages = {
      matlab = pkgs.callPackage ../../pkgs/matlab-fhs.nix {};
      sam-ba = pkgs.callPackage ../../pkgs/sam-ba.nix {};
    };
  };
}
