{ lib, pkgs, config, ...}:
with lib;

let cfg = config.quasar.xautolock;
    
    lxapp = pkgs.lxappearance.overrideAttrs (old: rec {
      name = "lxappearance-0.6.2";
      src = pkgs.fetchurl {
        url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
        sha256 = "07r0xbi6504zjnbpan7zrn7gi4j0kbsqqfpj8v2x94gr05p16qj4";
      };
    });

in {
  options.quasar.xautolock = {
    enable = mkEnableOption "quasar autolock service";
  };

  config = mkIf cfg.enable {
    environment.etc.xmonadbg = {
      user = "ajit";
      group = "users";
      source = ../assets/xmonadbg.jpg;
    };

    environment.etc.xautolock-locker = {
      user = "ajit";
      group = "users";
      mode = "555";
      text = ''
        #!${pkgs.bash}/bin/bash

        # TODO handle better (no tty switching but no cli password)
        pgrep i3lock-fancy || (${pkgs.i3lock-fancy}/bin/i3lock-fancy --nofork)
      '';
    };

    environment.systemPackages = with pkgs; [ i3lock-fancy ];
    
    # physlock handles true terminals 
    services.physlock.enable = true;
    services.physlock.lockOn.hibernate = false;
    services.physlock.lockOn.suspend = false;

    # xss-lock handles system-wide sleep (suspend/hibernate)
    programs.xss-lock.enable = true;
    programs.xss-lock.lockerCommand = "/etc/xautolock-locker";

    # xautolock handles inactivity [ xmonad.hs:services.xmonad.xautolock ]
    services.xserver = {
      # use the session lock to login
      displayManager.auto.enable = true;
      displayManager.auto.user = "ajit";
      displayManager.sessionCommands = with pkgs; lib.mkAfter ''
        ${pkgs.feh}/bin/feh --bg-scale /etc/xmonadbg
        /etc/xautolock-locker
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
  };
}
