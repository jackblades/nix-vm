
{ lib, pkgs, config, ... }:
with lib;
let cfg = config.quasar.fish;
    fishconf = import ./functions.nix;
    masenkoPrompt = import ./masenko-prompt.nix { pkgs = pkgs; };

    rangerScrollPreview = import ../overrides/ranger.nix pkgs;
    fsearch = import ../overrides/fsearch.nix pkgs;

    ## fish functions
    args = { inherit lib pkgs config; };
    base = import ./functions/base.nix args;
    nix = import ./functions/nix.nix args;
    system = import ./functions/system.nix args;
    apps = import ./functions/apps.nix args;
    desktop = import ./functions/desktop.nix args;
    kitty = import ./functions/kitty.nix args;
    
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
        apps.shellAliases 
        desktop.shellAliases 
        kitty.shellAliases 
      ];
      shellInit = builtins.concatStringsSep "\n\n" [ 
        base.shellInit 
        nix.shellInit 
        system.shellInit 
        apps.shellInit 
        desktop.shellInit 
        kitty.shellInit 
      ];
    };

    quasar.fish-nix-shell.enable = true;

    environment.systemPackages = with pkgs; [
      grc
      python36Packages.pygments

      ripgrep
      exa
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
      # terminator  
      pkgs.kitty

      # IDE stuff
      highlight  # for ranger highlighting
      rangerScrollPreview
      
      mpc_cli
      ncmpcpp
      # fsearch

      # afuse
      # funion
      # gitfs
      # httpfs
      # securefs
      # sshfs
    ];
  };
}