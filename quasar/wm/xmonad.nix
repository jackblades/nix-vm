{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.xmonad;
    
    lxapp = pkgs.lxappearance.overrideAttrs (old: rec {
      name = "lxappearance-0.6.2";
      src = pkgs.fetchurl {
        url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
        sha256 = "07r0xbi6504zjnbpan7zrn7gi4j0kbsqqfpj8v2x94gr05p16qj4";
      };
    });

in {
  imports = [
    ./xautolock.nix
    ./lightlock.nix
  ];

  options.quasar.xmonad = {
    enable = mkEnableOption "quasar xmonad service";
  };

  config = mkIf cfg.enable {
    quasar.xautolock.enable = true;
    # quasar.lightlock.enable = true;

    environment.systemPackages = with pkgs; [
      bashmount  # WARN
      lxapp
      feh
      gotty  # WARN
      rofi  # WARN
      xcalib
      xtitle
      xorg.xprop
      yabar-unstable
    ];

    services.compton = {
      enable = true;
      # backend = "glx";
      shadow = true;
      shadowExclude = [ "class_g = '.terminator-wrapped'" ];
      fade = true;
      fadeExclude = [ "class_g = '.terminator-wrapped'" ];
      inactiveOpacity = "0.8";
      # opacityRules = [
      #   "95:class_g = 'yabar'"
      # ];
    };

    services.xserver = {
      enable = true;
      autorun = true;
      
      # trackpag config
      libinput.enable = true;

      # key repeat configs
      autoRepeatDelay = 200;
      autoRepeatInterval = 25;

      # session
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
}
