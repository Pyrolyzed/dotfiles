{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/c0b0e0fddf73fd517c3471e546c0df87a42d53f4";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eden-emu = {
      url = "github:grantimatter/eden-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-scratchpad-flake = {
      url = "github:gvolpe/niri-scratchpad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #niri.url = "github:sodiboo/niri-flake";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen.url = "github:/InioX/Matugen";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms.url = "github:AvengeMedia/DankMaterialShell";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        config.allowUnfree = true;
        inherit system;
      };
      pkgs-stable = import inputs.nixpkgs-stable {
        config.allowUnfree = true;
        inherit system;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        config.allowUnfree = true;
        inherit system;
      };
    in
    {
      # nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      #   inherit
      #     pkgs
      #     system
      #     ;
      #   specialArgs = { inherit inputs; };
      #   modules = [
      #     ./hosts/desktop
      #     ./overlays
      #     inputs.home-manager.nixosModules.default
      #     #inputs.niri.nixosModules.niri
      #   ];
      # };
      nixosConfigurations = import ./hosts/nixos.nix {
        inherit
          pkgs
          pkgs-stable
          pkgs-unstable
          system
          inputs
          ;
        inherit (nixpkgs) lib;
      };
    };
}
