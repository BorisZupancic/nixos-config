{ pkgs, ... }:

{
  # 1. System-level: Open the ports
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  # 2. System-level: Install the tray app globally 
  environment.systemPackages = [ pkgs.syncthingtray ];

  # 3. User-level: Configure the actual sync service
  home-manager.users.borisz = {
    services.syncthing = {
      enable = true;
      tray.enable = true;
    };
  };
}
