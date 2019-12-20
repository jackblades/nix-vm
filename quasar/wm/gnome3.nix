{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.gnome3;
    constants = config.constants;
in {
  imports = [
    
  ];

  options.quasar.gnome3 = {
    enable = mkEnableOption "quasar.gnome3 service";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      autorun = true;
      startDbusSession = true;
      layout = "us";

      displayManager = {
        # sessionCommands = '' 
        #   ${pkgs.xorg.xhost}/bin/xhost +SI:localuser:$USER 
        # '';

        gdm = {
          enable = true;
          wayland = true;
        };

      }; # displayManager 

      desktopManager = {
        xterm.enable = false;
        gnome3.enable = true;
      }; # desktopManager

      videoDrivers = [ "intel" "nouveau" ];

      libinput = {
        enable = true;
        naturalScrolling = false;
        middleEmulation = true;
      }; # libinput

    }; # xserver
    
    services.dbus.packages = with pkgs; [ gnome3.dconf gnome2.GConf ];
  };
}
