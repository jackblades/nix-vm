{ lib, pkgs, config, ... }:
with lib;
{
  shellAliases = {
    kitty-remote = "kitty -o allow_remote_control=yes -o enabled_layouts=fat,tall,stack";
    kitty-restricted = "map ctrl+k launch --allow-remote-control";

  };
  shellInit =
    ''
      # https://sw.kovidgoyal.net/kitty/remote-control.html

      function fcd
        # kitty @ new-window --title Output --keep-focus ranger --choosedir=/tmp/rcd
        # kitty @focus-window --match title:Output
        # kitty @ send-text --match cmdline:cat Hello, World!
        # cat /tmp/rcd
      end

    '';
}