{ pkgs, ... }:

{
  home.packages = with pkgs; [
    sage
    (python3.withPackages (ps: with ps; [
      numpy
      matplotlib
      ipywidgets
      ipykernel
    ]))
  ];

  # This is much cleaner as a user-level session variable
  home.sessionVariables = {
    JUPYTER_PATH = "${pkgs.sage}/share/jupyter";
  };
}
