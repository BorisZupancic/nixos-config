{ ... }:

{
  services.openssh = {
    enable = false; # The "Master Switch" is OFF
    settings = {
      # These settings are ready for when you flip the switch
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Optional: Keep the port closed in the firewall for now
  # networking.firewall.allowedTCPPorts = [ 22 ];
}
