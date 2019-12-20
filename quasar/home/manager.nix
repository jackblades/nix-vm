

{ lib, config, pkgs, ... }:
with lib;
let home-manager = builtins.fetchGit {
      url = "https://github.com/rycee/home-manager.git";
      # rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed"; # CHANGEME 
      ref = "release-19.09";
    };
    
    cfg = config.quasar.home.manager;
    constants = config.constants;

    compton-kawase-blur = import ../overrides/compton-kawase-blur.nix pkgs;
in {
  imports = [
    "${home-manager}/nixos"
  ];

  options.quasar.home.manager = {
    enable = mkEnableOption "quasar home management configuration";
  };

  # force write on existing file
  # home.activation.copyMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
  #   install -D ${./path/to/my/file} $HOME/where/i/want/it
  # '';

  config = mkIf cfg.enable {
    # gnome settings stuff
    services.dbus.packages = with pkgs; [ gnome3.dconf ];
    
    home-manager.users."${constants.qsr-user}" = {
      
      # programs.git = {
      #   enable = true;
      #   userName  = "my_git_username";
      #   userEmail = "my_git_username@gmail.com";
      # };

      services.udiskie.enable = true;
      services.dunst = {
        # notifications
        enable = true;
        iconTheme = {
          name = "Paper";
          package = pkgs.paper-icon-theme;
          size = "32x32";
        };
        settings = import ./dunstrc.nix;
      };

      xsession.pointerCursor = {
        name = "Numix";
        package = pkgs.numix-cursor-theme;
      };

      gtk = {
        enable = true;
        
        theme.name = "Adapta-Eta";
        theme.package = pkgs.adapta-gtk-theme;
        iconTheme.name = "Paper";
        iconTheme.package = pkgs.paper-icon-theme;
        font.name = "Source Sans Pro";
        # font.package = pkgs.whatever;

        gtk2.extraConfig = ''
          gtk-toolbar-style=GTK_TOOLBAR_ICONS
          gtk-button-images=1
          gtk-menu-images=1         
          gtk-enable-event-sounds=0
          gtk-enable-input-feedback-sounds=0
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="none"
        '';
      };

      qt = {
        enable = true;
        # platformTheme = false;
      };

      services.compton = {
        enable = false;
        package = compton-kawase-blur;
        backend = "glx";
        vSync = "opengl";

        blur = true;
        shadow = true;
        fade = true;
        fadeDelta = 2;

        # blurExclude = [];
        shadowExclude = [ "class_g = '.terminator-wrapped'" "name ~= 'Notification'" "name ~= 'yabar$'" "name ~= 'compton'" ];
        fadeExclude = [ "class_g = '.terminator-wrapped'" "_NET_WM_NAME@:s = 'rofi'" "name ~= 'yabar$'" ];
        
        activeOpacity = "0.8";
        menuOpacity = "0.8";
        inactiveOpacity = "0.8";
        noDNDShadow = true;
        noDockShadow = true;
        opacityRule = [ "60:window_type = 'dock'" "0:window_type = 'desktop'" ];
        extraOptions = ''
          frame-opacity = 0.7;
          inactive-opacity-override = false;

          blur-background = true;
          blur-background-frame = false;
          blur-kern = "3x3box";
          blur-method = "kawase";
          blur-strength = 15;
          blur-background-fixed = false;

          focus-exclude = [ "name *?= 'i3lock'", "name ~= 'yabar$'" ];

          mark-wmwin-focused = true;
          mark-overdir-focused = true;
          use-ewmh-active-win = true;
          detect-client-opacity = true;
      
          dbe = false;
          paint-on-overlay = true;
          sw-opti = false;

          unredir-if-possible = true;
          detect-transient = true;
          detect-client-leader = true;

          # glx backend
          glx-no-stencil = true;
          glx-copy-from-front = false;
          glx-no-rebind-pixmap = true;
        '';    
      };

      # home.file.".xmonad/xmonad.hs".source = ./dotfiles/xmonad.hs;
      # home.file.".xmonad/yabar.config".source = ./dotfiles/yabar.config;
      home.file.".config/terminator/config".source = ./dotfiles/terminator.config;
      home.file.".config/nvim/init.vim".source = ./dotfiles/nvim-init.vim;
      home.file.".config/vlc/vlcrc".source = ./dotfiles/vlcrc;
      # home.file.".config/deadbeef/config".source = ./dotfiles/deadbeef/config;
      # home.file.".config/deadbeef/dspconfig".source = ./dotfiles/deadbeef/dspconfig;
      # home.file.".config/rofi/config".source = ./dotfiles/rofi/config;
      
    };
  };
}




























