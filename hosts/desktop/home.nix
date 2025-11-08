{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  mod = "SUPER";
  terminal = "kitty";
  browser = "zen";
in
{
  imports = [
    ../../modules/homeManager/zsh.nix
  ];

  custom = {
    shell.zsh = {
      enable = true;
      aliases = {
        ls = "lsd";
        ll = "ls -l";
        vim = "nvim";
        vi = "nvim";
        cd = "z";
      };
    };
  };
  programs.zsh.historySubstringSearch = {
    searchDownKey = "$terminfo[kcud1]";
    searchUpKey = "$terminfo[kcuu1]";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita-dark";
    };
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
    platformTheme.name = "qtct";
  };

  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;
    hyprcursor.size = 24;
    x11.enable = true;
    x11.defaultCursor = "left_ptr";
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  home.packages = with pkgs; [
    pinta
    inputs.niri-scratchpad-flake.packages."x86_64-linux".niri-scratchpad
  ];
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ranger = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.mimeApps =
    let
      value =
        let
          zen-browser = inputs.zen-browser.packages."x86_64-linux".default;
        in
        zen-browser.meta.desktopFileName;

      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name value;
          })
          [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]
      );
    in
    {
      associations.added = associations;
      defaultApplications = associations;
    };
  home.username = "pyro";
  home.homeDirectory = "/home/pyro";

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  programs.kitty.enable = true;
  programs.kitty.settings = {
    confirm_os_window_close = 0;
    paste_actions = "filter";
    window_padding_width = 10;
    window_padding_height = 5;
    enable_audio_bell = false;
    #background_opacity = 0.8;
  };

  programs.kitty.font = {
    size = 16;
    name = "Caskaydia Cove NerdFont Mono";
  };
  #wayland.windowManager.hyprland.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = 1;
    MANPAGER = "nvim +Man!";
    QT_QPA_PLATFORM = "wayland";
  };

  #wayland.windowManager.hyprland.settings = {
  #  xwayland.force_zero_scaling = true;
  #  exec-once = [
  #    "xrandr --output DP-1 --primary"
  #    "dunst"
  #    "copyq --start-server"
  #  ];
  #  #decoration = {
  #  #  rounding = 8;
  #  #};
  #  monitor = [
  #    "DP-1,3840x2160@240,0x0,1.5"
  #    "DP-2,2560x1440@144,2560x0,1.25"
  #  ];
  #  workspace = [
  #    "1,monitor:DP-1,default:true"
  #    "2,monitor:DP-1"
  #    "3,monitor:DP-1"
  #    "4,monitor:DP-2,default:true"
  #    "5,monitor:DP-2"
  #    "6,monitor:DP-2"
  #    "special:terminal,on-created-empty:[float;size 75% 75%] kitty, persistent:false"
  #    "special:spotify,on-created-empty:[float;size 75% 75%] spotify, persistent:false"
  #  ];
  #  misc."enable_anr_dialog" = false;
  #  input.accel_profile = "flat";

  #  general = {
  #    layout = "dwindle";
  #    allow_tearing = false;
  #    resize_on_border = false;
  #    gaps_in = 10;
  #    gaps_out = 15;
  #    border_size = 4;
  #  };

  #  windowrulev2 = [
  #    "suppressevent maximize, class:."
  #  ];
  #  bind = [
  #    "${mod}, F, exec, ${browser}"
  #    "${mod}, Z, togglespecialworkspace, terminal"
  #    "${mod}, P, togglespecialworkspace, spotify"
  #    "${mod}, Q, exec, ${terminal}"
  #    "${mod}, R, exec, rofi -show drun"
  #    "${mod} SHIFT, R, exec, rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | wl-copy\""
  #    "${mod} ALT, R, exec, rofi -show p -modi p:'rofi-power-menu'"
  #    "${mod}, X, fullscreen"
  #    "${mod}, C, killactive"
  #    "${mod}, M, exit"
  #    "${mod}, V, togglefloating"
  #    "${mod}, H, movefocus, l"
  #    "${mod}, J, movefocus, d"
  #    "${mod}, K, movefocus, u"
  #    "${mod}, L, movefocus, r"
  #    "${mod}, 1, workspace, 1"
  #    "${mod}, 2, workspace, 2"
  #    "${mod}, 3, workspace, 3"
  #    "${mod}, 4, workspace, 4"
  #    "${mod} SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
  #    "${mod}, 5, workspace, 5"
  #    "${mod}, 6, workspace, 6"
  #    "${mod} SHIFT, 1, movetoworkspace, 1"
  #    "${mod} SHIFT, 2, movetoworkspace, 2"
  #    "${mod} SHIFT, 3, movetoworkspace, 3"
  #    "${mod} SHIFT, 4, movetoworkspace, 4"
  #    "${mod} SHIFT, 5, movetoworkspace, 5"
  #    "${mod} SHIFT, 6, movetoworkspace, 6"
  #  ];
  #  bindm = [
  #    "${mod}, mouse:272, movewindow"
  #    "${mod}, mouse:273, resizewindow"
  #  ];
  #};
}
