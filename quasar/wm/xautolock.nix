{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.xautolock;
    
in {
  options.quasar.xautolock = {
    enable = mkEnableOption "quasar autolock service";
  };

  config = mkIf cfg.enable {
    environment.etc.quasar = {
      user = "ajit";
      group = "users";
      source = ../assets;
    };

    environment.etc.xautolock-locker = {
      user = "ajit";
      group = "users";
      mode = "555";
      text = ''
        #!/bin/sh
        # TODO handle tty switching

        # randomize bg from /etc/quasar/wall
        ${pkgs.coreutils}/bin/cp `${pkgs.coreutils}/bin/shuf -n1 -e /etc/quasar/wall/*` /tmp/bg 
        ${pkgs.coreutils}/bin/chmod 600 /tmp/bg

        pgrep i3lock-color || ( \
          ${pkgs.i3lock-color}/bin/i3lock-color --nofork \
          --ignore-empty-password \
          --image=/tmp/bg \
          --clock \
          --noinputtext="_|____" \
          --verifcolor=0892D0aa \
          --veriftext="********" \
          --wrongcolor=b92e34cc \
          --wrongtext=xxxxxxxx\
          --bar-indicator \
          --bar-color=222222cc \
          --bar-position="h*0.7" \
          --keyhlcolor=666666aa\
          --bshlcolor=44000000 \
          --ringvercolor=252566aa \
          --bar-direction=1

          # --redraw-thread \
          # --bar-base-width=100 \
          # --bar-max-height=0 \
          # --bar-step=60 \
          # --bar-periodic-step=60 \
          # --bar-width=1366
        )

        # ${pkgs.feh}/bin/feh --randomize --bg-scale /etc/quasar/wall/*
        
        # change wallpaper on lock, and locks once at startup
        # (${pkgs.curl}/bin/curl -L "https://source.unsplash.com/random/1366x768" > /tmp/bg2 && ${pkgs.coreutils}/bin/mv /tmp/bg2 /tmp/bg && ${pkgs.feh}/bin/feh --bg-scale /tmp/bg)&

        # lower left ring indicator
        # pkill -u $USER -USR1 dunst
        # i3lock-color --indicator -n -i /tmp/bg \
        #   --insidecolor=373445ff --ringcolor=ffffffff --line-uses-inside \
        #   --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --separatorcolor=00000000 \
        #   --insidevercolor=fecf4dff --insidewrongcolor=d23c3dff \
        #   --ringvercolor=ffffffff --ringwrongcolor=ffffffff --indpos="w*0.05:h*0.95" \
        #   --radius=15 --veriftext="" --wrongtext="" --noinputtext="*"
        # pkill -u $USER -USR2 dunst
      '';
    };

    environment.systemPackages = with pkgs; [ i3lock-color ];
    
    # physlock handles true terminals 
    services.physlock.enable = false;
    services.physlock.lockOn.hibernate = false;
    services.physlock.lockOn.suspend = false;

    # xss-lock handles system-wide sleep (suspend/hibernate)
    programs.xss-lock.enable = false;
    programs.xss-lock.lockerCommand = "/etc/xautolock-locker";

    # xautolock handles inactivity [ xmonad.hs:services.xmonad.xautolock ]
    services.xserver = {
      # use the session lock to login
      displayManager.auto.enable = true;
      displayManager.auto.user = "ajit";
      displayManager.sessionCommands = with pkgs; lib.mkAfter ''
        ${pkgs.feh}/bin/feh --randomize --bg-scale /etc/quasar/wall/* &
        ${pkgs.coreutils}/bin/cp `${pkgs.coreutils}/bin/shuf -n1 -e /etc/quasar/wall/*` /tmp/bg &
        (/etc/xautolock-locker && ${pkgs.terminator}/bin/terminator --hidden)&
      '';
      
      # TODO notifications, power management
      xautolock.enable = true;
      xautolock.time = 5;
      xautolock.locker = "/etc/xautolock-locker";
      xautolock.nowlocker = "/etc/xautolock-locker";
      xautolock.killer = "${pkgs.systemd}/bin/systemctl suspend";
      xautolock.killtime = 20;
      xautolock.extraOptions = [ "-detectsleep" ];
    };

    systemd.user.services.xlocksuspend = {
      description = "i3lock on suspend";
      serviceConfig = {
        User = "ajit";
        Type = "oneshot";
        ExecStart = "/etc/xautolock-locker";
      };
      wantedBy = [ "sleep.target" "suspend.target" ];
    };
    systemd.services.xlocksuspend.enable = true;
  };
}
