{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.borisz = {
    isNormalUser = true;
    description = "Boris Zupancic";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  home-manager.users.borisz = { pkgs, ... }: {
  	imports = [ 
	    ./git.nix
	    ./nvim.nix
	    ./terminal.nix
	    ./apps.nix
	    ./firefox.nix
	    ./scientific.nix
	];

	# Essential: Match this to your NixOS version (e.g., "25.11")
	home.stateVersion = "24.11"; 
    };
}
