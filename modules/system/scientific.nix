{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sage
    (python3.withPackages (ps: with ps; [
      numpy
      matplotlib
      ipywidgets
      ipykernel
    ]))
    texlive.combined.scheme-small
  ];

  environment.sessionVariables.JUPYTER_PATH = "/run/current-system/sw/share/jupyter";
}
