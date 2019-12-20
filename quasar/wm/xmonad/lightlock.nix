
{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.lightlock;
in {
  options.quasar.lightlock = {
    enable = mkEnableOption "quasar lightlock service";
  };

  config = mkIf cfg.enable {
    environment.etc.lightlockbg = {
      user = "lightdm";
      group = "lightdm";
      source = /etc/nixos/quasar/assets/lightlockbg.jpg;
    };

    services.xserver = {
      displayManager = {
        lightdm.greeters.gtk.enable = true;
        lightdm.background = "/etc/lightlockbg";
        lightdm.greeters.gtk.extraConfig = ''
          position = 10%,start 65%,center
          default-user-image = /assets/usericon
          xft-antialias = true
          xft-dpi = 96
          xft-hintstyle = slight
          xft-rgba = rgb
          indicators = ~clock;~language;~spacer;~session;~power;
        '';
        sessionCommands = with pkgs; lib.mkAfter ''
          ${pkgs.feh}/bin/feh --bg-scale /etc/xmonadbg
          # ${pkgs.xautolock}/bin/xautolock -locknow
          ${pkgs.lightlocker}/bin/light-locker --no-late-locking --lock-on-suspend &  # TODO locker-crash?
        '';
      };
    };
    
    environment.systemPackages = with pkgs; [ lightlocker ];
    systemd.user.services.lightlocker = {
      description = "lightdm locker service";
      serviceConfig = {
        # Environment = [ "DISPLAY=:0" ];
        User = config.constants.qsr-user;
        ExecStart = "${pkgs.lightlocker}/bin/light-locker --no-late-locking --lock-on-suspend";
        Restart = "always";
      };
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
    systemd.services.lightlocker.enable = false; # failing
  };
}
