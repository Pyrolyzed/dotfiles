{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      pyro = import ./home.nix;
    };
  };
  environment.pathsToLink = [ "/share/zsh" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  environment.localBinInPath = true; 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;  
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  programs.ssh.enableAskPassword = false;
  programs.ssh.askPassword = "";
# Set your time zone.
  time.timeZone = "America/Chicago";
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr ];
  xdg.portal.enable = true;
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  programs.zsh.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.hyprland.enable = true;
  services.displayManager.sddm.enable = true;
  
  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  fileSystems."/home/pyro/LVM" = {
   device = "/dev/vg1/lvol0";
   fsType = "ext4";
  };
  # Define a user account.
  users.users.pyro = {
    isNormalUser = true;
    extraGroups = [ "wheel" "power" "video" "audio" ]; 
    packages = with pkgs; [
      firefox
      kitty
      wofi
      steam
      vesktop
      copyq
      wl-clipboard
      spotify
      dunst
      hyprpaper
      zoxide
      fzf
      fastfetch
      zsh
      lvm2
      bat
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      prismlauncher
      lutris
      heroic
      dolphin
      unrar
      unzip
      ark
    ];
  };

  users.defaultUserShell = pkgs.zsh; 

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  environment.sessionVariables = rec {
    EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [
    neovim
    hyprland
    sddm
    pkgs.home-manager
    git
    bash
  ];
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

