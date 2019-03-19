{ pkgs, ...}:

let lib = import <nixpkgs/lib>;
    gnome = {
      services.xserver = {
        enable = true;
        
        desktopManager = {
          gnome3.enable = true;
        };
        
        # Enable XMonad Desktop Environment. (Optional)
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

# in lib.recursiveUpdate xmonad yabar
in gnome
