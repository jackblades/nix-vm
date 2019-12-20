{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.xautolock;
    constants = config.constants;
in {
  options.quasar.xautolock = {
    enable = mkEnableOption "quasar autolock service";
  };

  config = mkIf cfg.enable {
    environment.etc.quasar = {
      user = constants.qsr-user;
      group = constants.qsr-user-group;
      source = /etc/nixos/quasar/assets;
    };

    environment.etc.xautolock-locker = {
      user = constants.qsr-user;
      group = constants.qsr-user-group;
      mode = "555";
      text = ''
        #!${pkgs.fish}/bin/fish
        # TODO handle tty switching

        # if focused application is vlc or youtube
        ${pkgs.xtitle}/bin/xtitle | ${pkgs.gnugrep}/bin/grep -qP "( - YouTube - | - VLC media player|aria2c |Prime Video: )"
        
        # and audio is playing
        and ${pkgs.pulseaudio}/bin/pacmd list-sink-inputs | ${pkgs.gnugrep}/bin/grep -q 'state: RUNNING'
        
        # do not lock, otherwise
        or begin

          # run if not already running
          pgrep i3lock-color
          or ${pkgs.i3lock-color}/bin/i3lock-color --nofork \
            --ignore-empty-password \
            --image=${constants.qsr-wall-path} \
            --clock \
            --noinputtext="////////" \
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

          # lower left ring indicator
          # pkill -u $USER -USR1 dunst
          # i3lock-color --indicator -n -i ${constants.qsr-wall-path} \
          #   --insidecolor=373445ff --ringcolor=ffffffff --line-uses-inside \
          #   --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --separatorcolor=00000000 \
          #   --insidevercolor=fecf4dff --insidewrongcolor=d23c3dff \
          #   --ringvercolor=ffffffff --ringwrongcolor=ffffffff --indpos="w*0.05:h*0.95" \
          #   --radius=15 --veriftext="" --wrongtext="" --noinputtext="*"
          # pkill -u $USER -USR2 dunst
        end
        '';
    };
    environment.etc.xautolock-suspend = {
      user = constants.qsr-user;
      group = constants.qsr-user-group;
      mode = "555";
      text = ''
        #!/bin/sh

        (${pkgs.pulseaudio}/bin/pacmd list-sink-inputs | ${pkgs.gnugrep}/bin/grep 'state: RUNNING') || ${pkgs.systemd}/bin/systemctl suspend
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
      displayManager.auto.user = constants.qsr-user;
      
      # TODO notifications, power management
      xautolock.enable = true;
      xautolock.time = 5;
      xautolock.locker = "/etc/xautolock-locker";
      xautolock.nowlocker = "/etc/xautolock-locker";
      xautolock.killer = "/etc/xautolock-suspend";
      xautolock.killtime = 20;
      xautolock.extraOptions = [ "-detectsleep" ];
    };

    systemd.user.services.xlocksuspend = {
      description = "i3lock on suspend";
      serviceConfig = {
        User = constants.qsr-user;
        Type = "oneshot";
        ExecStart = "/etc/xautolock-locker";
      };
      wantedBy = [ "sleep.target" "suspend.target" ];
    };
    systemd.services.xlocksuspend.enable = true;
  };
}
