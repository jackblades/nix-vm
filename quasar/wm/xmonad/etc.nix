{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.xmonad;
    constants = config.constants;

    rofi-dmenu = import ../../overrides/rofi-dmenu.nix pkgs;
    
    usermode = m: c: c // { user = constants.qsr-user; group = constants.qsr-user-group; mode = m; };
    rx = "555";  # rx is permissions
    rxfile = usermode rx;
    rxtextfile = ftext: usermode rx { text = ftext ; };

in {
  imports = [];

  config.environment.etc = {
    quasar-terminal-kitty = rxtextfile ''
      #!/bin/sh
      
      # function on_exit --on-process %self
      #   echo fish is now exiting
      # end
      
      exec ${pkgs.fish}/bin/fish -C "${constants.qsr-user-home}/.xmonad/xmonad-x86_64-linux client terminalToggle"
    '';

    settings-calendar = rxtextfile ''
      #!/bin/sh
      ${pkgs.procps}/bin/pgrep gnome-calendar || ${pkgs.gnome3.gnome-calendar}/bin/gnome-calendar &
    '';
    settings-network = rxtextfile ''
      #!/bin/sh
      env PATH=${rofi-dmenu}/bin/:${pkgs.pinentry}/bin/:$PATH ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu &
    '';
    settings-power = rxtextfile ''
      #!${pkgs.fish}/bin/fish
      set power_options suspend reboot poweroff "" hibernate hybrid-sleep 
      set choice (for op in $power_options; ${pkgs.coreutils}/bin/echo "    $op"; end | ${rofi-dmenu}/bin/dmenu | string trim) 
      string length $choice
      and ${pkgs.systemd}/bin/systemctl $choice
    '';
    settings-sound = rxtextfile ''
      #!/bin/sh
      ${pkgs.procps}/bin/pkill -f blueman-manager || ${pkgs.blueman}/bin/blueman-manager &
      ${pkgs.procps}/bin/pkill pavucontrol || (${pkgs.pavucontrol}/bin/pavucontrol && /etc/settings-volume >> /tmp/volume)&
    '';
    settings-volume = rxtextfile ''
      #!/bin/sh

      # Get the index of the selected sink:
      getsink() {
        ${pkgs.pulseaudio}/bin/pacmd list-sinks |
          ${pkgs.gawk}/bin/gawk '/index:/{i++} /* index:/{print i; exit}'
      }

      # Get the selected sink volume
      getvolume() {
        ${pkgs.pulseaudio}/bin/pacmd list-sinks |
            ${pkgs.gawk}/bin/gawk '/^\svolume:/{i++} i=='$(getsink)'{print $5; exit}'
      }

      ${pkgs.coreutils}/bin/echo  $(getvolume)
    '';
    settings-volume-mute = rxtextfile ''
      #!/bin/sh
      ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
      /etc/settings-volume >> /tmp/volume
    '';
    settings-volume-set = rxtextfile ''
      #!/bin/sh
      ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ "$@"
      /etc/settings-volume >> /tmp/volume
    '';
    settings-brightness = rxtextfile ''
      #!/bin/sh
      ${pkgs.brightnessctl}/bin/brightnessctl s "$@"
    '';
    settings-toggle-redshift = rxtextfile ''
      #!${pkgs.fish}/bin/fish
      ${pkgs.systemd}/bin/systemctl --user status redshift
      and ${pkgs.systemd}/bin/systemctl --user stop redshift
      or ${pkgs.systemd}/bin/systemctl --user start redshift
    '';

    # utility
    set-wall-random = rxtextfile ''
      #!${pkgs.fish}/bin/fish
      # randomize bg from /etc/nixos/quasar/assets/wall

      # (${pkgs.curl}/bin/curl -L "https://source.unsplash.com/random/1366x768" > ${constants.qsr-wall-path}2 && ${pkgs.coreutils}/bin/mv ${constants.qsr-wall-path}2 ${constants.qsr-wall-path} && ${pkgs.feh}/bin/feh --bg-scale ${constants.qsr-wall-path})&
      # ${pkgs.feh}/bin/feh --randomize --bg-scale ${constants.qsr-user-storage-wallpaper}/* &
      
      ${pkgs.coreutils}/bin/rm ${constants.qsr-wall-path}
      set wallpaper (${pkgs.findutils}/bin/find ${constants.qsr-user-storage-wallpaper}/ | ${pkgs.coreutils}/bin/shuf -n1)
      ${pkgs.coreutils}/bin/ln -s $wallpaper ${constants.qsr-wall-path}
      ${pkgs.feh}/bin/feh --bg-scale ${constants.qsr-wall-path}
    '';


    youtubedl = rxtextfile ''
      #!${pkgs.fish}/bin/fish
      ${pkgs.coreutils}/bin/test -f /tmp/youtube-queue
        or ${pkgs.coreutils}/bin/touch /tmp/youtube-queue
      ${pkgs.coreutils}/bin/tail -f /tmp/youtube-queue | while read -l url
        ${pkgs.youtube-dl}/bin/youtube-dl "$url"
      end
    '';
    torrentdl = rxtextfile ''
      #!${pkgs.fish}/bin/fish
      ${pkgs.coreutils}/bin/test -f /tmp/torrent-queue
        or ${pkgs.coreutils}/bin/touch /tmp/torrent-queue
      ${pkgs.coreutils}/bin/tail -f /tmp/torrent-queue | while read -l url
        ${pkgs.aria2}/bin/aria2c --connect-timeout=60 --max-connection-per-server=16 --split=16 --min-split-size=1M --human-readable=true --download-result=full --seed-time=none "$url"
      end
    '';
          
    
    # rofi config
    "rofi/runconfig" = rxfile {
      source = ../../home/dotfiles/rofi/runconfig;
    };
    "rofi/drun.rasi" = rxfile {
      source = ../../home/dotfiles/rofi/drun.rasi;
    };
    "rofi/nord.rasi" = rxfile {
      source = ../../home/dotfiles/rofi/nord.rasi;
    };
  };
}
