

{ lib, config, pkgs, ... }:
with lib;
let home-manager = builtins.fetchGit {
      url = "https://github.com/rycee/home-manager.git";
      rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed"; # CHANGEME 
      ref = "release-18.09";
    };
    
    cfg = config.quasar.home.manager;

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
    
    home-manager.users.ajit = {
      
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
        font.name = "Meslo LG Ms for Powerline 10";
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
        useGtkTheme = false;
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




























