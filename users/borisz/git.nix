{pkgs, ... }:
{
    programs.git = {
	enable = true;
	userName = "Boris Zupancic";
	userEmail = "105008019+BorisZupancic@users.noreply.github.com"; # Use the noreply one!
	extraConfig = {
	  core.askPass = ""; # Disables the annoying KDE popup error
	};
      };
}
