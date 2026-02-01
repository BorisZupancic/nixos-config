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
    
    # Manual entry for Arch Linux
    extraEntries = ''
      menuentry "Arch Linux" {
        insmod gzio
        insmod part_gpt
        insmod ext2
        insmod nvme
        search --no-floppy --fs-uuid --set=root da6ba101-6524-450e-b95e-abfe1a19dfd4
        linux /boot/vmlinuz-linux root=UUID=da6ba101-6524-450e-b95e-abfe1a19dfd4 rw
        initrd /boot/initramfs-linux.img
      }
    '';
  };


  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8192; # 8GB of swap
  } ];

}
