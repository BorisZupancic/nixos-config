{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      # Standard high-quality fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      
      # The Nerd Fonts (with the override for efficiency)
      (nerdfonts.override { 
        fonts = [ "Tinos" "JetBrainsMono" ]; 
      })
    ];

    # Optional: Enable some default font settings
    fontconfig = {
      defaultFonts = {
        serif = [ "Tinos" "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}
