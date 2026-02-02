{ pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "borisz";
    group = "users";
    # We remove configDir and dataDir to let Nix use its safe defaults
    # By default, it will now use /home/borisz/.config/syncthing correctly
    openDefaultPorts = true;
  };

  # This ensures the service has a clear path and doesn't look at /var/lib
  systemd.services.syncthing.environment.HOME = "/home/borisz";

  environment.systemPackages = [ pkgs.syncthing pkgs.syncthingtray ];

  home-manager.users.borisz = {
    services.syncthing.tray.enable = true;
  };
}
