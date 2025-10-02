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

    # Applications 
   	signal-desktop
    	firefox
	google-chrome
	onedrive

	python314
	brightnessctl
	playerctl 
	pulseaudio
  ];
}

