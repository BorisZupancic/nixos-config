{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    # In the future, you can add 'profiles' here to 
    # configure extensions, bookmarks, and settings!
  };
}
