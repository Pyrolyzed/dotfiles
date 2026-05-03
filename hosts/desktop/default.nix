{
  pkgs,
  pkgs-unstable,
  pkgs-mesa,
  inputs,
  lib,
  config,
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
    # Eden emulator
    #inputs.eden-emu.nixosModules.default
    inputs.noctalia.nixosModules.default
  ];

  # Eden emulator
  #programs.eden.enable = true;

  custom = {
    apps.gaming = {
      enable = true;
      minecraft.enable = true;
      lutris.enable = true;
    };
  };
  security.polkit = {
    enable = true;
  };
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "udev-hidapi";
      text = ''
        KERNEL=="hidraw*", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/69-hid.rules";
    })
  ];
  # https://github.com/openzfs/zfs/issues/10891
  systemd.services.systemd-udev-settle.enable = false;
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
  #services.avahi = {
  #  enable = true;
  #  nssmdns4 = true;
  #  openFirewall = true;
  #};
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      mfcl3770cdwlpr
      cups-filters
      cups-browsed
    ];
  };

  services.displayManager.sddm.enable = true;
  #  services.displayManager.sddm.wayland.enable = true;
  services.xserver.enable = true;

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
  boot.kernelModules = [
    "amdgpu"
    "ntsync"
  ];

  # AMD GPU
  # Nvidia GPU
  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.nvidia.open = false;

  # Enable ZFS
  boot.supportedFilesystems = [
    "zfs"
  ];
  # Auto mount
  #boot.zfs.extraPools = [ "storage" ];
  boot.zfs.package = pkgs.zfs_2_4;

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
  # Sunshine game streaming
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    autoStart = true;
  };

  fileSystems."/home/pyro/NAS" = {
    device = "//192.168.1.143/Storage";
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
  fileSystems."/home/pyro/Shared" = {
    device = "//192.168.1.143/Shared";
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

  services.flatpak.enable = true;
  hardware.new-lg4ff.enable = true;

  programs.niri.enable = true;
  services.desktopManager.cosmic.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    poppins
    nerd-fonts.caskaydia-cove
    nerd-fonts.comic-shanns-mono
    iosevka
    rubik
    overpass
  ];

  programs.java = {
    enable = true;
    package = pkgs.temurin-bin-21;
  };
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main.rightalt = "layer(meta)";
        };
      };
    };
  };
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    manix
    polkit_gnome
    via
    inputs.matugen.packages."x86_64-linux".default
    steamtinkerlaunch
    adwaita-icon-theme
    adw-gtk3
    nwg-look
    neovim
    kdePackages.qt6ct
    python314
    ffmpeg-full
    clonehero
    filezilla
    onlyoffice-desktopeditors
    xrandr
    glfw3-minecraft
    wlr-randr
    man-pages
    moonlight-qt
    man-pages-posix
    vscode
    fuzzel
    custom.yarc
    pegasus-frontend
    skyscraper
    peacock
    xfce.thunar
    gpu-screen-recorder
    nautilus
    ddcutil
    nodejs
    samira
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
    qemu
    libqalculate
    looking-glass-client
    reaper
    synthesia
    bottles
    python313Packages.pywal
    python313Packages.watchdog
    rusty-path-of-building
    zathura
    obs-studio
    appimage-run
    ntfs3g
    mangohud
    pywalfox-native
    fastfetch
    rofi-calc
    vulkan-tools
    rofi-file-browser
    rofi-power-menu
    tealdeer
    freetype
    umu-launcher
    kdePackages.kdeconnect-kde
    wikiman
    slurp
    foliate
    caligula
    p7zip
    xwayland-satellite
    fastfetch
    pavucontrol
    wine
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
    qbittorrent
    nixfmt-rfc-style
    unrar
    cifs-utils
    temurin-bin-21
    kitty
    copyq
    git
    vesktop
    lsd
    gamescope
    labwc
    obsidian
    zfs
    # morrowind
    openmw
    oversteer
    hidapi
    udev
    gimp
    libuv
    yt-dlp
    libunarr
    wine64
    er-patcher
    chromium
    inputs.zen-browser.packages."${system}".default
  ];
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
