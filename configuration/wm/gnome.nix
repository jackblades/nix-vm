{ pkgs, ...}:

let gnome = {
      services.xserver = {
        enable = true;
        
        desktopManager = {
          gnome3.enable = true;
        };
      };
    };

# in lib.recursiveUpdate xmonad yabar
in gnome
