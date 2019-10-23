
{ lib, pkgs, config, ... }:
with lib;
let cfg = config.quasar.fish;
    fishconf = import ./functions.nix;
    masenkoPrompt = import ./masenko-prompt.nix { pkgs = pkgs; };

    rangerScrollPreview = import ../overrides/ranger.nix pkgs;

    ## fish functions
    args = { inherit lib pkgs config; };
    base = import ./functions/base.nix args;
    nix = import ./functions/nix.nix args;
    system = import ./functions/system.nix args;
    
in {
  imports = [
    ./fish-nix-shell.nix
  ];

  options.quasar.fish = {
    enable = mkEnableOption "quasar fish configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      promptInit = "for f in ${masenkoPrompt}/*; source $f; end";
      shellAliases = builtins.foldl' (a: b: a // b) {} [ 
        base.shellAliases 
        nix.shellAliases 
        system.shellAliases 
      ];
      shellInit = builtins.concatStringsSep "\n\n" [ 
        base.shellInit 
        nix.shellInit 
        system.shellInit 
      ];
    };

    quasar.fish-nix-shell.enable = true;

    environment.systemPackages = with pkgs; [
      grc
      python36Packages.pygments

      ag
      aria2
      dtrx
      icdiff  # see csdiff in fish-config/bin, and diff-so-fancy in the gitAndTools package
      moreutils
      multitail
      ncdu
      pstree
      rclone
      tree

      fzf
      micro
      neovim
      tmux
      terminator  

      # IDE stuff
      highlight  # for ranger highlighting
      rangerScrollPreview

      # afuse
      # funion
      # gitfs
      # httpfs
      # securefs
      # sshfs
    ];
  };
}