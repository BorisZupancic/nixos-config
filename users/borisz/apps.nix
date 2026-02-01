{ pkgs, ... }:
{
    home.packages = with pkgs; [
    htop

    git

    discord

    zathura
    xdotool #Helps VimTeX interact with window focus

    texlive.combined.scheme-full # Includes everything; use 'scheme-small' for less bloat

    zotero
    poppler_utils # This provides pdftotext and pdfinfo
    ];
}
