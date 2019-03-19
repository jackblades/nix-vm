{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.xmonad;
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
