{ lib, pkgs, config, ... }:
with lib;
{
  shellAliases = {
    fish-theme = "set -U | grep fish_color_";

    # TODO desktop functionality here
    # remove packages from other places
    qapps = "${pkgs.rofi}/bin/rofi -show drun -config /etc/rofi/runconfig";
    qscreenshot = "${pkgs.scrot}/bin/scrot window_%Y-%m-%d-%H-%M-%S.png -d 1-u -e 'mv $f /media/external/quasar/screenshot/'";

  };
  shellInit =
    ''
      
    '';
}