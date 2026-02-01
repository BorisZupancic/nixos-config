{ pkgs, ... }:

{
  # This enables the GPG agent globally
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true; # Allows you to use GPG keys as SSH keys!
    pinentryPackage = pkgs.pinentry-qt; # Uses a nice KDE popup for passwords
  };
}
