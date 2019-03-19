{ pkgs, ...}:

let lib = import <nixpkgs/lib>;
    xfce = {
      services.xserver = {
        enable = true;
        
        # trackpag config
        synaptics.enable = true;

       
        desktopManager = {
          xfce.enable = true;
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
in xfce
