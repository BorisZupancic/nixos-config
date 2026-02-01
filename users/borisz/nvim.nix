{ pkgs, ... }:
{
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

	    -- LSP Config
	    local lspconfig = require('lspconfig')

	    -- Python / Sage
	    lspconfig.pyright.setup({
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

	    -- Others
	    lspconfig.clangd.setup({})
	    lspconfig.nil_ls.setup({})
	    lspconfig.lua_ls.setup({})
	'';
    };
}
