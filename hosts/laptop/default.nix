{
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  ...
}:

let
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/grub.nix
    ../../modules/nixos/apps/spicetify.nix
    ../../modules/nixos/network.nix
    inputs.noctalia.nixosModules.default
  ];

  services.noctalia-shell.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config = {
        niri = {
          default = "gnome;gtk";
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";

          "org.freedesktop.impl.portal.FileChooser" = "gtk";
        };
      };
      configPackages = [ pkgs.niri ]; # This gets overridden by the config above
    };
  };

  networking.hostName = "laptop";
  networking.hostId = "f24c3b0c";

  time.timeZone = "America/Chicago";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.dbus.implementation = "broker";
  services.printing.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  xdg.icons.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Nvidia GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;

  # Gaming time
  boot.kernel.sysctl = {
    "fs.file-max" = 2097152;
    "vm.max_map_count" = 2147483642;
  };

  security.rtkit.enable = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  users.users.pyro = {
    isNormalUser = true;
    description = "Pyro";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  hardware.i2c.enable = true;
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pyro" = import ./home.nix;
    };
  };

  programs.niri.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    poppins
    nerd-fonts.caskaydia-cove
    iosevka
    rubik
    overpass
  ];

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    manix
    inputs.matugen.packages."x86_64-linux".default
    adw-gtk3
    nwg-look
    neovim
    kdePackages.qt6ct
    python314
    ffmpeg-full
    filezilla
    onlyoffice-desktopeditors
    xrandr
    wlr-randr
    man-pages
    moonlight-qt
    man-pages-posix
    xfce.thunar
    ddcutil
    wl-clipboard
    grim
    qalculate-gtk
    (rofi.override {
      plugins = with pkgs; [
        rofi-calc
        rofi-file-browser
      ];
    })
    libqalculate
    rusty-path-of-building
    zathura
    appimage-run
    fastfetch
    rofi-calc
    rofi-file-browser
    rofi-power-menu
    tealdeer
    freetype
    wikiman
    slurp
    foliate
    p7zip
    xwayland-satellite
    fastfetch
    pavucontrol
    btop
    vesktop
    gptfdisk
    pipx
    vlc
    protonup-qt
    bat
    sdl3
    custom.neovim-pyro
    unzip
    nixfmt-rfc-style
    unrar
    cifs-utils
    javaPackages.compiler.temurin-bin.jdk-21
    kitty
    copyq
    git
    lsd
    labwc
    obsidian
    inputs.zen-browser.packages."${system}".default
  ];
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
