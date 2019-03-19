
{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.lightlock;
in {
  options.quasar.lightlock = {
    enable = mkEnableOption "quasar lightlock service";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ lightlocker ];

    services.xserver = {
      displayManager = {
        lightdm.greeters.gtk.enable = true;
        lightdm.background = "/assets/lockscreen";  # TODO WARN global state
        lightdm.greeters.gtk.extraConfig = ''
        position = 10%,start 65%,center
        default-user-image = /assets/usericon
        xft-antialias = true
        xft-dpi = 96
        xft-hintstyle = slight
        xft-rgba = rgb
        indicators = ~clock;~language;~spacer;~session;~power;
        '';
      };
    };
  };
}
