{
  pkgs,
  inputs,
  ...
}:

let
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/grub.nix
    ../../modules/nixos/apps/gaming.nix
    ../../modules/nixos/apps/spicetify.nix
    ../../modules/nixos/network.nix
  ];

  custom = {
    apps.gaming = {
      enable = true;
      minecraft.enable = true;
      lutris.enable = true;
    };
  };
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

  networking.hostName = "atlas";
  networking.hostId = "742b7683";

  time.timeZone = "America/Chicago";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.dbus.implementation = "broker";
  services.printing.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.initrd.kernelModules = [
    "amdgpu"
  ];

  # Enable ZFS
  boot.supportedFilesystems = [
    "zfs"
  ];
  # Auto mount
  boot.zfs.extraPools = [ "storage" ];

  fileSystems."/home/pyro/NAS" = {
    device = "//192.168.1.200/Storage";
    fsType = "cifs";
    # Plain text password because I'm lazy and also because it's not exposed to the internet and also I don't use it anywhere else.
    options = [
      "uid=1000"
      "username=pyro"
      "password=spoons"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
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
  ];

  environment.systemPackages = with pkgs; [
    manix
    neovim
    steamtinkerlaunch
    python314
    ffmpeg-full
    clonehero
    filezilla
    man-pages
    man-pages-posix
    onlyoffice-desktopeditors
    xrandr
    glfw3-minecraft
    wlr-randr
    vscode
    xfce.thunar
    ddcutil
    wl-clipboard
    grim
    arma3-unix-launcher
    qalculate-gtk
    (rofi.override {
      plugins = with pkgs; [
        rofi-calc
        rofi-file-browser
      ];
    })
    libqalculate
    mangohud
    fastfetch
    rofi-calc
    rofi-file-browser
    rofi-power-menu
    tealdeer
    kdePackages.kdeconnect-kde
    wikiman
    slurp
    p7zip
    xwayland-satellite
    fastfetch
    pavucontrol
    btop
    vesktop
    gptfdisk
    pipx
    parsec-bin
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
    dunst
    vesktop
    lsd
    gamescope
    labwc
    obsidian
    zfs
    inputs.zen-browser.packages."${system}".default
  ];
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
