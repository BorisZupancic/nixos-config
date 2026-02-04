{ pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "borisz";
    group = "users";
    configDir = "/home/borisz/.config/syncthing";
    dataDir = "/home/borisz/Sync";
    openDefaultPorts = true;
  };

  systemd.services.syncthing = {
    # 1. Ensure it starts on boot
    wantedBy = [ "multi-user.target" ]; 
    
    # 2. Wait for the network to be ready
    after = [ "network.target" "network-online.target" ];
    wants = [ "network-online.target" ];

    # 3. The environment
    environment.HOME = "/home/borisz";

    # 4. Restart if it fails during the boot scramble
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  environment.systemPackages = [ pkgs.syncthing pkgs.syncthingtray ];

  home-manager.users.borisz = {
    services.syncthing.tray = {
      enable = true;
      command = "syncthingtray --wait"; #waits for syncthing to start
    };
  };
}
