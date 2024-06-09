{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pyro";
  home.homeDirectory = "/home/pyro";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.zsh-powerlevel10k
  ];

  
  programs.zsh = {
     enable = true;
     dotDir = ".config/zsh";
     enableCompletion = true;
     autosuggestion.enable = true;
     syntaxHighlighting.enable = true;
     defaultKeymap = "viins";
	

     shellAliases = {
       ls = "ls --color";
       ll = "ls -l --color";
       cd = "z";
       vim = "nvim";
       c = "clear";
       neofetch = "fastfetch";
       cat = "bat";
     };

     history = {
       size = 10000;
       path = "${config.xdg.dataHome}/.zsh_history";
       ignoreSpace = true;
       ignoreDups = true;
       ignoreAllDups = true;
     };
     
     zplug = {
       enable = true;
       plugins = [
         { name = "zsh-users/zsh-autosuggestions"; }
	 { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
       ];
     };

     initExtra = ''
       if [[ -r "~/.cache/p10k-instant-prompt-pyro.zsh" ]]; then
	  source "~/.cache/p10k-instant-prompt-pyro.zsh"
       fi
       [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
       eval "$(zoxide init zsh)"
       eval "$(fzf --zsh)"
     '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  home.pointerCursor = {
    gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

	gtk = {
	  enable = true;
	  theme = {
	    package = pkgs.flat-remix-gtk;
	    name = "Flat-Remix-GTK-Grey-Darkest";
	  };

	  iconTheme = {
	    package = pkgs.gnome.adwaita-icon-theme;
	    name = "Adwaita";
	  };

	  font = {
	    name = "Sans";
	    size = 11;
	  };
	};
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pyro/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
