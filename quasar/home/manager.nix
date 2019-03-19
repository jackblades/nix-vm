

{ pkgs, home-manager, ... }:

{
  # force write on existing file
  # home.activation.copyMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
  #   install -D ${./path/to/my/file} $HOME/where/i/want/it
  # '';

  home-manager.users.ajit = {
    
    # programs.git = {
    #   enable = true;
    #   userName  = "my_git_username";
    #   userEmail = "my_git_username@gmail.com";
    # };

    home.file.".xmonad/xmonad.hs".source = ./dotfiles/xmonad.hs;
    home.file.".xmonad/yabar.config".source = ./dotfiles/yabar.config;
    home.file.".gtkrc-2.0".source = ./dotfiles/gtkrc-2.0;
    home.file.".config/gtk-3.0/settings.ini".source = ./dotfiles/gtk3-settings.ini;
    home.file.".config/terminator/config".source = ./dotfiles/terminator.config;
    home.file.".config/vlc/vlcrc".source = ./dotfiles/vlcrc;
    home.file.".config/nvim/init.vim".source = ./dotfiles/nvim-init.vim;
    
  };
}




























