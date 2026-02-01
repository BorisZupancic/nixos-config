{ config, pkgs, ... }:

{
  imports = [
	./hardware-configuration.nix
	
	./modules/desktop/plasma.nix
	
	./modules/services/syncthing.nix
	./modules/services/ssh.nix
	./modules/services/gpg.nix

	./modules/system/boot.nix
	./modules/system/scientific.nix
	./modules/system/fonts.nix

	./users/borisz
    ];
  
  
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  
  # Define your hostname.
  networking.hostName = "banana"; 

  # Enable networking
  networking.networkmanager.enable = true;

  # Localization
  time.timeZone = "America/Toronto"; #time zone
  i18n.defaultLocale = "en_CA.UTF-8"; #language

  # Global System Packages
  environment.systemPackages = with pkgs; [
    vim wget wl-clipboard
  ];
   
  # Global Program Enables
  programs.zsh.enable = true; 
  
  #Allow unfree packages and enable Zsh binary
  nixpkgs.config.allowUnfree = true;

  #Home Manager (for user settings/config)
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  system.stateVersion = "24.11";

}
