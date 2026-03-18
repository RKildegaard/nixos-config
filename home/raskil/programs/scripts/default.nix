{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "template-menu";
      runtimeInputs = [
        pkgs.bashInteractive
        pkgs.coreutils
        pkgs.gum
        pkgs.jq
        pkgs.nix
      ];
      text = builtins.readFile ./template-menu;
    })
  ];
}
