{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.xmonad;
    constants = config.constants;
    compton-kawase-blur = import ../../overrides/compton-kawase-blur.nix pkgs;
in {
  imports = [];

  config = {
    systemd.services.quasar-topbar.enable = false;
    systemd.user.services.quasar-topbar = {
      description = "xmonad topbar";
      serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.yabar-unstable}/bin/yabar -c ${../../home/dotfiles/yabar.config}";
      };
    };
    systemd.services.quasar-terminal.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-terminal = {
      description = "terminal service at F1";
      serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.terminator}/bin/terminator --hidden";
      };
    };
    systemd.services.quasar-terminal-kitty.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-terminal-kitty = {
      description = "terminal service at F1";
      serviceConfig = {
        Restart = "always";
        # shell opens and toggles terminal (hide), and reports to xmonad on exit
        ExecStart = "${pkgs.kitty}/bin/kitty --class 'quasar-terminal-kitty' /etc/quasar-terminal-kitty";
      };
    };

    systemd.timers."quasar-twominute".enable = true;  # trigger from xmonad
    systemd.user.timers."quasar-twominute" = {
      description = "two minute timer";
      timerConfig = {
        Unit = "quasar-wallpaper.service";
        OnCalendar = "*:0/2";  # 2 minutes
        # OnCalendar = "*:*:0,15,30,45";
      };
    };
    systemd.services.quasar-wallpaper.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-wallpaper = {
      description = "wallpaper service";
      serviceConfig = {
        Environment="DISPLAY=:0";
        ExecStart = "/etc/set-wall-random";
      };
    };

    services.redshift = {
      enable = true;
    };
  
    services.compton = {
      enable = false;
      backend = "glx";

      shadow = true;
      fade = true;
      fadeDelta = 2;

      shadowExclude = [ "class_g = '.terminator-wrapped'" "name ~= 'Notification'" "name ~= 'yabar$'" "name ~= 'compton'" ];
      fadeExclude = [ "class_g = '.terminator-wrapped'" "_NET_WM_NAME@:s = 'rofi'" "name ~= 'yabar$'" ];
      inactiveOpacity = "0.8";
      opacityRules = [ "60:window_type = 'dock'" "0:window_type = 'desktop'" ];
      settings = {
        no-dnd-shadow = true;
        no-dock-shadow = true;
        clear-shadow = true;
    
        focus-exclude = [ "name *?= 'i3lock'" "name ~= 'yabar$'" ];

        mark-wmwin-focused = true;
        mark-overdir-focused = true;
        use-ewmh-active-win = true;
    
        vsync = "opengl";
        dbe = false;
        paint-on-overlay = true;

        unredir-if-possible = true;

        detect-transient = true;
        detect-client-leader = true;

        # glx backend
        glx-no-stencil = true;
        glx-copy-from-front = false;
        glx-no-rebind-pixmap = true;

        wintypes = {
          tooltip = {
            fade = true;
            shadow = false;
            focus = true;
          };
        };    
      };
    };


    ## user services
    systemd.services.quasar-compton.enable = true;  # trigger from xmonad
    systemd.user.services.quasar-compton = {
      description = "compton with kawase blur";
      serviceConfig = {
        Environment="DISPLAY=:0";
        ExecStart = ''${compton-kawase-blur}/bin/compton --config ${../../home/dotfiles/compton.conf}'';
      };
    };

    systemd.services.quasar-nixlist-pkgs.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-nixlist-pkgs = {
      description = "nix-env -qaP '*' > /tmp/nix-list-pkgs";
      serviceConfig = {
        ExecStart = ''/bin/sh -c "${pkgs.nix}/bin/nix-env -qaP '*' > /tmp/nix-list-pkgs"'';
      };
    };

    systemd.services.quasar-torrentdl.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-torrentdl = {
      description = "torrent downloader service";
      serviceConfig = {
        WorkingDirectory = "${constants.qsr-user-storage-quasar}/torrentdl";
        ExecStart = "/etc/torrentdl";
      };
    };
    systemd.services.quasar-youtubedl.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-youtubedl = {
      description = "youtube downloader service";
      serviceConfig = {
        WorkingDirectory = "${constants.qsr-user-storage-quasar}/youtubedl";
        ExecStart = "/etc/youtubedl";
      };
    };

  };
}
