{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      font-awesome
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
