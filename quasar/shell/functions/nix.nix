{ lib, pkgs, config, ... }:
with lib;
{
  shellAliases = {
    nix-pkgs = "less /tmp/packages.nix";
    nix-home-conf = "man home-configuration.nix | grep -v '^        ' | grep -v '^[ \\r\\n\\t]*$' | less";

    nix-install = "nix-env -i";
    nix-uninstall = "nix-env -e";
    nix-list-installed = "nix-env -q";

    nix-gc = "nix-collect-garbage --delete-older-than 3d";
    nix-gc1 = "nix-collect-garbage --delete-older-than 1d";
    nix-gcd = "nix-collect-garbage --delete-older-than";
    nix-gc-force = "nix-collect-garbage -d";
    nix-optimize-store = "nix-store --optimise -v";

    nix-list-generations = "nix-env --list-generations";
    nix-rebuild-os = "sudo cp -r ~/nixos /etc; and sudo nixos-rebuild switch";
    nix-rollback-os = "sudo nixos-rebuild switch --rollback";
  };
  shellInit =
    ''
      test -f /tmp/packages.nix; 
        or nix-env -qaP '*' > /tmp/packages.nix &

      function nix-shell-fish
        fish-nix-shell-wrapper $argv
        set -gx FISH_NIX_SHELL_EXIT_STATUS $status
      end
    '';
}