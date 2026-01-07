{
  pkgs,
  pkgs-unstable,
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
    # Eden emulator
    inputs.eden-emu.nixosModules.default
    #  inputs.noctalia.nixosModules.default
  ];

  #  services.noctalia-shell.enable = true;
  # Eden emulator
  programs.eden.enable = true;

  custom = {
    apps.gaming = {
      enable = true;
      minecraft.enable = true;
      lutris.enable = true;
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;

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
  services.printing.enable = true;

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
    package = pkgs-unstable.mesa;
    #package32 = pkgs-unstable.mesa;
  };

  xdg.icons.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # AMD GPU
  boot.initrd.kernelModules = [
    "amdgpu"
  ];

  # Nvidia GPU
  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.nvidia.open = false;

  # Enable ZFS
  boot.supportedFilesystems = [
    "zfs"
  ];
  # Auto mount
  boot.zfs.extraPools = [ "storage" ];
  boot.zfs.package = pkgs.zfs_2_4;

  # Gaming time
  boot.kernel.sysctl = {
    "fs.file-max" = 2097152;
    "vm.max_map_count" = 2147483642;
  };
  security.rtkit.enable = true;

  documentation.man.generateCaches = true;

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

  hardware.new-lg4ff.enable = true;

  programs.niri.enable = true;
  services.desktopManager.cosmic.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    poppins
    nerd-fonts.caskaydia-cove
    iosevka
    rubik
    overpass
  ];

  programs.gpu-screen-recorder.enable = true;
  programs.gpu-screen-recorder.package = pkgs.gpu-screen-recorder;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    manix
    gpu-screen-recorder
    inputs.matugen.packages."x86_64-linux".default
    steamtinkerlaunch
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
    pegasus-frontend
    skyscraper
    xfce.thunar
    nautilus
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
    python313Packages.pywal
    python313Packages.watchdog
    rusty-path-of-building
    gpu-screen-recorder-gtk
    obs-studio
    appimage-run
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
    qbittorrent
    nixfmt-rfc-style
    unrar
    cifs-utils
    javaPackages.compiler.temurin-bin.jdk-21
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
    inputs.zen-browser.packages."${system}".default
  ];
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
