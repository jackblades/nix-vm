{ lib, config, pkgs, ...}:
# -- see https://medium.com/@ejpcmac/about-using-nix-in-my-development-workflow-12422a1f2f4c
# -- especially direnv
with lib;
let cfg = config.quasar.fish-nix-shell;
in {
  options.quasar.fish-nix-shell = {
    enable = mkEnableOption "fish shell in nix-shell";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))
    ];

    programs.fish.enable = true;
    programs.fish.promptInit = ''
      fish-nix-shell --info-right | source
    '';
  };
}

