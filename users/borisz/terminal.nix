{ pkgs, ... }:
{    
    # Zsh and Oh My Zsh Configuration
    programs.zsh = {
	enable = true;
	enableCompletion = true;
	autosuggestion.enable = true;
	syntaxHighlighting.enable = true;

	oh-my-zsh = {
	    enable = true;
	    plugins = [ "git" "sudo" ];
	    theme = "agnoster";
	};
    }; 

    # Alacritty Configuration
    programs.alacritty = {
	enable = true;
	settings = {
	    # Force alacritty to use zsh
	    terminal.shell = {
	      program = "${pkgs.zsh}/bin/zsh";
	      args = [ "--login" ];
	    };

	    general.import = [
	      (builtins.fetchurl {
		url = "https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/gruvbox_dark.toml";
		sha256 = "19vf24a1v9qjapmyblvq94gr0pi5kqmj6d6kl6h9pf1cffn5xnl5";
	      })
	    ];

	    font = {
	      size = 12.0; #
	       normal = {
		 family = "JetBrainsMono Nerd Font";
		 style = "Regular";
	       };
	       bold = {
		 family = "JetBrainsMono Nerd Font";
		 style = "Bold";
	       };
	       italic = {
		 family = "JetBrainsMono Nerd Font";
		 style = "Italic";
	       };
	    };

	    window.opacity = 0.95;
	};
    };
}
