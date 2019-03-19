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

    environment.systemPackages = with pkgs; [
      bashmount  # WARN
      brightnessctl
      lxapp
      feh
      gotty  # WARN
      i3lock-fancy
      rofi  # WARN
      xtitle
      xorg.xprop
      yabar-unstable
    ];

    # TODO handle better (no tty switching but no cli password)
    
    # physlock handles true terminals 
    services.physlock.enable = true;
    services.physlock.lockOn.hibernate = false;
    services.physlock.lockOn.suspend = false;

    # xss-lock handles system-wide sleep (suspend/hibernate)
    programs.xss-lock.enable = true;
    programs.xss-lock.lockerCommand = "xautolock -locknow";

    # xautolock handles inactivity [ xmonad.hs:services.xmonad.xautolock ]
    services.xserver = {
      # use the session lock to login
      displayManager.auto.enable = true;
      displayManager.auto.user = "ajit";
      displayManager.sessionCommands = with pkgs; lib.mkAfter ''
        ${pkgs.xautolock}/bin/xautolock -locknow
      '';
      
      # TODO notifications, power management
      xautolock.enable = true;
      xautolock.time = 1;
      xautolock.locker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";  # TODO run physlock
      xautolock.nowlocker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
      xautolock.killer = "${pkgs.systemd}/bin/systemctl suspend";
      xautolock.killtime = 20;
      xautolock.extraOptions = [ "-detectsleep" ];
    };
  };
}
