{
  description = "Boris's NixOS Flake Configuration";

  inputs = {
    # NixOS official package source (unstable or a specific version like 24.11)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # This 'banana' must match the name after the # in your rebuild command
    nixosConfigurations.banana = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        # This makes home-manager a module of the system
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
