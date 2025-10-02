{ pkgs, ... }:
{
  # Pure package list for user scope.
  home.packages = with pkgs; [
    # CLIs
    	curl 
	wget 
	jq 
	ripgrep 
	fd 
	bat 
	eza 
	unzip 
	zip
    	btop 
	htop 
	tree

    # Wayland helpers
    	wl-clipboard
    	cliphist
    	grim 
	slurp
    	swappy
    	wtype

    	signal-desktop
    	firefox
	brightnessctl
	playerctl 
	pulseaudio
  ];
}

