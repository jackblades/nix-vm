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
        
        displayManager = {
          # lightdm.greeters.gtk.enable = true;
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

          auto.enable = false;
          auto.user = "ajit";
          
          sddm.enable = true;
          sddm.theme = "/assets/deepin";  # TODO WARN global state
          # sddm.theme = "/assets/elegant-sddm/Elegant/";
          # ${FacesDir}/<username>.face.icon is the user avatar
          sddm.extraConfig = ''
            [Theme]
            FacesDir=/assets/sddm-faces
          '';
          
          sessionCommands = with pkgs; lib.mkAfter ''
            test -d /tmp/mounts; or mkdir /tmp/mounts
            feh --bg-scale /home/ajit/Downloads/159353.jpg &
          '';
        };
        
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
