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
    ../../modules/grub.nix
    ../../modules/spicetify.nix
    ../../modules/network.nix
  ];

  systemd.services.NetworkManager-wait-online.enable = false;

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
  xdg.portal.enable = true;
  xdg.portal.config.common.default = "gnome";
  xdg.portal.config.common."org.freedesktop.impl.portal.FileChooser" = "gtk";

  networking.hostName = "atlas";
  networking.hostId = "742b7683";

  time.timeZone = "America/Chicago";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "pyro" = import ./home.nix;
    };
  };

  programs.hyprland.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    poppins
    nerd-fonts.caskaydia-cove
  ];

  environment.systemPackages = with pkgs; [
    manix
    neovim
    prismlauncher
    python314
    ffmpeg-full
    filezilla
    man-pages
    man-pages-posix
    onlyoffice-bin
    xrandr
    glfw-wayland-minecraft
    xfce.thunar
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
    fastfetch
    rofi-calc
    rofi-file-browser
    rofi-power-menu
    tealdeer
    kdePackages.kdeconnect-kde
    wikiman
    slurp
    p7zip
    fastfetch
    pavucontrol
    btop
    vesktop
    gptfdisk
    pipx
    parsec-bin
    vlc
    bat
    sdl3
    custom.neovim-pyro
    unzip
    nixfmt-rfc-style
    unrar
    cifs-utils
    javaPackages.compiler.temurin-bin.jdk-21
    firefox
    kitty
    copyq
    git
    dunst
    vesktop
    lsd
    obsidian
    zfs
    inputs.zen-browser.packages."${system}".default
  ];
  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
