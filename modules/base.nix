{ inputs, config, ... }:
let
  inherit (config) flake;
  settings = flake.settings;
in
{
  flake.modules.nixos.base =
    {
      pkgs,
      ...
    }:
    {
      imports = with flake.modules.nixos; [
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
      programs.zsh.enable = true;
      boot.kernel.sysctl = {
        "fs.file-max" = 2097152;
        "vm.max_map_count" = 214748342;
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
          options = "--delete-older-than 14d";
        };
      };

      documentation.man.enable = true;
      # Slow, but needed for apropos
      documentation.man.generateCaches = true;

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
          fastfetch
          # TODO: Wrapped/custom package?
          neovim
        ];
        sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
          MANPAGER = "nvim +Man!";
        };
      };
    };
}
