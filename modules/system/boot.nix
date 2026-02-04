{ pkgs, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false; # The "Speed Boost"
   
    extraConfig = ''
      insmod nvme
    '';

  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8192; # 8GB of swap
  } ];

}
