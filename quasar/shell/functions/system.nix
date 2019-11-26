{ lib, pkgs, config, ... }:
with lib;
{
  shellAliases = {
    fonts-list = "fc-list";
    mount-list = "ls /tmp/mounts";

    settings-net = "nmtui";
    settings-bt = "bluetoothctl";
    settings-wall = "feh --bg-scale /etc/nixos/quasar/assets/wall/(ls /etc/nixos/quasar/assets/wall | fzf --reverse --prompt \"wallpaper > \")";

    bt-stone-connect = "echo connect FC:58:FA:D4:FC:68 | bluetoothctl";
    bt-stone-disconnect = "echo disconnect | bluetoothctl";
    bt-stone-reconnect = "bt-stone-disconnect; and sleep 5; and bt-stone-connect";
  };

  shellInit = ''
    function xmonad-reset
      rm /home/ajit/.xmonad/xmonad-x86_64-linux
      sudo systemctl restart display-manager
    end
  '';    
}