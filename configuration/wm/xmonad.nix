{ pkgs, ...}:

let lib = import <nixpkgs/lib>;
    yabar = import ./yabar.nix { pkgs = pkgs; };
    xmonad = {
      services.compton = {
        enable = true;
        shadow = true;
        shadowExclude = [ "class_g = '.terminator-wrapped'" ];
        inactiveOpacity = "0.8";
        # opacityRules = [
        #   "95:class_g = 'yabar'"
        # ];
      };

      services.xserver = {
        enable = true;
        autorun = true;
        
        # trackpag config
        # DEPRECATED synaptics.enable = true;
        libinput.enable = true;

        # key repeat configs
        autoRepeatDelay = 200;
        autoRepeatInterval = 25;
        
        # displayManager.lightdm.greeters.gtk.enable = true;
        displayManager.lightdm.background = "/assets/lockscreen";  # TODO WARN global state
        displayManager.lightdm.greeters.gtk.extraConfig = ''
          position = 10%,start 65%,center
          default-user-image = /assets/usericon
          xft-antialias = true
          xft-dpi = 96
          xft-hintstyle = slight
          xft-rgba = rgb
          indicators = ~clock;~language;~spacer;~session;~power;
	'';

        # displayManager.lightdm.greeters.gtk.theme.name = "Arc Dark";
        # displayManager.lightdm.greeters.gtk.iconTheme.name = "Paper";

        displayManager.auto.enable = false;
        displayManager.auto.user = "ajit";
        
	      displayManager.sddm.enable = true;
        displayManager.sddm.theme = "/assets/deepin";  # TODO global state
        # displayManager.sddm.theme = "/assets/elegant-sddm/Elegant/";
        displayManager.sddm.extraConfig = ''
          [Theme]
          FacesDir=/assets/sddm-faces
        '';
        
	      displayManager.sessionCommands = with pkgs; lib.mkAfter ''
          test -d /tmp/mounts; or mkdir /tmp/mounts
          feh --bg-scale /home/ajit/Downloads/159353.jpg &
        '';
        
        desktopManager.xterm.enable = false;

        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
            haskellPackages.xmonad
          ];
        };
        
        windowManager.default = "xmonad";
      };
    };

in lib.recursiveUpdate xmonad yabar
