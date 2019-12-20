{ lib, pkgs, config, ... }:
with lib;
{
  shellAliases = {
    qlsfont = "fc-list";
    qlsmount = "ls /tmp/mounts";

    qsnet = "nmtui";
    qsbt = "bluetoothctl";
    qswall = "feh --bg-scale /etc/nixos/quasar/assets/wall/(ls /etc/nixos/quasar/assets/wall | fzf --reverse --prompt \"wallpaper > \")";

    bt-stone-connect = "echo connect FC:58:FA:D4:FC:68 | bluetoothctl";
    bt-stone-disconnect = "echo disconnect | bluetoothctl";
    bt-stone-reconnect = "bt-stone-disconnect; and sleep 5; and bt-stone-connect";
  };

  shellInit = ''
    function qxmreset
      rm ${config.constants.qsr-user-home}/.xmonad/xmonad-x86_64-linux
      sudo systemctl restart display-manager
    end

    function qrmwall
      rm (realpath ${config.constants.qsr-wall-path})
    end
  '';    
}