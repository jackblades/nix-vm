{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.xmonad;

in {
  imports = [];

  config = {
    systemd.services.quasar-topbar.enable = false;
    systemd.user.services.quasar-topbar = {
      description = "xmonad topbar";
      serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.yabar}/bin/yabar -c ${../../home/dotfiles/yabar.config}";
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

    systemd.timers."quasar-twominute".enable = false;  # trigger from xmonad
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
      enable = true;
      backend = "glx";

      shadow = true;
      fade = true;

      shadowExclude = [ "class_g = '.terminator-wrapped'" "name ~= 'Notification'" "name ~= 'yabar$'" "name ~= 'compton'" ];
      fadeExclude = [ "class_g = '.terminator-wrapped'" "_NET_WM_NAME@:s = 'rofi'" "name ~= 'yabar$'" ];
      inactiveOpacity = "0.8";
      opacityRules = [ "60:window_type = 'dock'" ];
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
    systemd.services.quasar-nixlistall.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-nixlistall = {
      description = "nix-env -qaP '*' > /tmp/nix-env-qaP";
      serviceConfig = {
        ExecStart = ''/bin/sh -c "${pkgs.nix}/bin/nix-env -qaP '*' > /tmp/nix-env-qaP"'';
      };
    };

    systemd.services.quasar-torrentdl.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-torrentdl = {
      description = "torrent downloader service";
      serviceConfig = {
        WorkingDirectory = "/run/media/external/quasar/torrentdl";
        ExecStart = "/etc/torrentdl";
      };
    };
    systemd.services.quasar-youtubedl.enable = false;  # trigger from xmonad
    systemd.user.services.quasar-youtubedl = {
      description = "youtube downloader service";
      serviceConfig = {
        WorkingDirectory = "/run/media/external/quasar/youtubedl";
        ExecStart = "/etc/youtubedl";
      };
    };

  };
}
