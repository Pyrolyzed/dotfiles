{ inputs, config, ... }:
let
  settings = config.flake.settings;
in
{
  flake.modules.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = with config.flake.modules.nixos; [
        network
      ];

      security.rtkit.enable = true;

      boot = {
        supportedFilesystems = [ "zfs" ];
        initrd.supportedFilesystems = [ "zfs" ];
      };

      networking.hostId = settings.hostId;

      services = {
        zfs.autoScrub.enable = true;
        zfs.trim.enable = true;

        sanoid = {
          enable = true;
          templates.default = {
            autosnap = true;
            autoprune = true;
            daily = 7;
            weekly = 4;

          };
        };
      };
      users = {
        users.root.initialPassword = "password";
        users.pyro = {
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
            "input"
            "plugdev"
            "dialout"
            "seat"
          ];
          # TODO: Hashed password
          initialPassword = "password";
        };
        groups.sanoid = { };
        users.sanoid = {
          isSystemUser = true;
          group = "sanoid";
        };
        defaultUserShell = pkgs.zsh;
      };

      nix = {
        settings = {
          trusted-users = [
            "root"
            "@wheel"
          ];
          experimental-features = [
            "nix-command"
            "pipe-operators"
            "flakes"
          ];
          download-buffer-size = 268435456;
          substituters = [
            "https://cache.nixos.org/"
          ];
        };
        package = pkgs.nixVersions.latest;
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };

      environment = {
        shells = [ pkgs.zsh ];

        systemPackages = with pkgs; [
          sops
          dbus
          hdparm

          btop
          nh
          alejandra
          git
          unzip
          unrar
          p7zip
          openssl
          usbutils
        ];

        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };
      };
    };
}
