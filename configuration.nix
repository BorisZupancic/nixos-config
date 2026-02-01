# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8192; # 8GB of swap
  } ];
  
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
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

  networking.hostName = "banana"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.borisz = {
    isNormalUser = true;
    description = "Boris Zupancic";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  ##########################################################################
  # PERSONAL ADDITIONS
  
  # Syncthing ports: 22000 (TCP/UDP) for sync, 21027 (UDP) for discovery
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    wl-clipboard
    syncthingtray
    
    sage
    (python3.withPackages (ps: with ps; [
      numpy
      matplotlib
      ipywidgets
      ipykernel
    ]))

    #(sage.override {
    #  extraPythonPackages = ps: with ps; [
    #    jupyterlab
    #    ipywidgets
    #   ];
    # })

    # Essential for Sage plotting/UI
    texlive.combined.scheme-small
  ];
  # This tells Jupyter where to find the Sage kernel specifically
  environment.sessionVariables.JUPYTER_PATH = "/run/current-system/sw/share/jupyter"; 
 
 # Fonts 
  fonts.packages = with pkgs; [
    nerd-fonts.tinos
    nerd-fonts.jetbrains-mono
  ];
  
  # Firefox
  programs.firefox.enable = true;
  
  #Allow unfree packages and enable Zsh binary
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true; 
  users.users.borisz.shell = pkgs.zsh;

  #Home Manager (for user settings/config)
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.borisz = { pkgs, ... }: {
    # Essential: Match this to your NixOS version (e.g., "25.11")
    home.stateVersion = "25.11"; 
    
    # Syncthing
    services.syncthing = {
      enable = true;
      tray.enable = true;
      # dataDir = "/home/borisz/Sync";    # Default folder for new syncs
      # configDir = "/home/borisz/.config/syncthing";   # Where config is stored
      # openDefaultPorts = true;
      # Optional: GUI credentials (can be set in the browser instead)
      # settings.gui = {
      #  user = "";
      #  password = "";
      # };
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
    
    # Zsh and Oh My Zsh Configuration
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "agnoster"; # Your chosen theme here
      };
    };
    
    # Neovim 
    programs.neovim = {
      enable = true;
    
      viAlias = true;
      vimAlias = true; 
     
      # Reprocudible binaries for your LSPs/Linters (Replaces Mason's job)
      extraPackages = with pkgs; [
        pyright # Python
	python311Packages.python-lsp-server # Python/Sage
        clang-tools # C/C++
        lua-language-server
        nil # Nix LSP
        ripgrep # Required for telescope/nvim-tree
      ];

      plugins = with pkgs.vimPlugins; [
        # 1. Colorscheme
        {
          plugin = gruvbox-nvim;
          config = "colorscheme gruvbox";
        }

        # 2. Syntax & Interface
        {
          plugin = nvim-treesitter.withPlugins (p: [ 
  	    p.tree-sitter-nix 
       	    p.tree-sitter-python 
   	    p.tree-sitter-c 
	    p.tree-sitter-cpp 
            p.tree-sitter-lua
            p.tree-sitter-vim
            p.tree-sitter-bash
          ]);
          type = "lua";
          config = "require('nvim-treesitter.configs').setup { highlight = { enable = true } }";
        }

        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = "require('nvim-tree').setup{}";
        }
        {
          plugin = which-key-nvim;
          type = "lua";
          config = "require('which-key').setup{}";
        }

        # 3. LSP & Completion
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        
	# VimTeX
	vimtex
      ];

      # All your custom Lua config goes here
      extraLuaConfig = ''
        -- Set leaders first
        vim.g.mapleader = " "
        vim.g.maplocalleader = ","
        
	-- Vimtex configuration
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_compiler_method = 'latexmk'
	-- This tells VimTeX to use DBus to communicate with Zathura
	-- It is much more stable on Linux/NixOS
	vim.g.vimtex_view_zathura_options = '-x "nvim --remote-silent +%l %f"'

        vim.opt.number = true       -- Shows the current line number
        vim.opt.relativenumber = true -- Shows distance to other lines

        -- 1. Set filetype detection for Sage
        vim.filetype.add({
          extension = {
            sage = "python",
          },
        })

	-- 2. New Neovim 0.11+ LSP API for Pyright (Sage)
        vim.lsp.config('pyright', {
          settings = {
            python = {
              pythonPath = "${pkgs.sage}/bin/python",
              analysis = {
                extraPaths = { "${pkgs.sage}/lib/python3.13/site-packages" },
                typeCheckingMode = "basic",
              }
            }
          }
        })
        vim.lsp.enable('pyright')

        -- 3. Other Servers (using your preferred 0.11+ syntax)
        vim.lsp.config('clangd', {})
        vim.lsp.enable('clangd')

        vim.lsp.config('nil_ls', {})
        vim.lsp.enable('nil_ls')

        vim.lsp.config('lua_ls', {})
        vim.lsp.enable('lua_ls')
      '';
      };
  

    # Add other user-level packages here
    home.packages = with pkgs; [
      htop
      
      git
      
      discord
      
      zathura
      xdotool #Helps VimTeX interact with window focus
      
      texlive.combined.scheme-full # Includes everything; use 'scheme-small' for less bloat

      zotero
      poppler-utils # This provides pdftotext and pdfinfo
    ];
  };

}
