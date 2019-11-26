{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.xmonad;
    rofi-dmenu = import ../overrides/rofi-dmenu.nix pkgs;
    
    lxapp = pkgs.lxappearance.overrideAttrs (old: rec {
      name = "lxappearance-0.6.2";
      src = pkgs.fetchurl {
        url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
        sha256 = "07r0xbi6504zjnbpan7zrn7gi4j0kbsqqfpj8v2x94gr05p16qj4";
      };
    });

    

in {
  imports = [
    ./xmonad/xautolock.nix
    ./xmonad/lightlock.nix

    ./xmonad/etc.nix
    ./xmonad/services.nix
  ];

  options.quasar.xmonad = {
    enable = mkEnableOption "quasar xmonad service";
  };

  config = mkIf cfg.enable {
    quasar.xautolock.enable = true;
    # quasar.lightlock.enable = true;
    
    # services.dbus.packages = with pkgs; [ gnome3.dconf ];

    location.latitude = 12.9716;
    location.longitude = 77.5946;

    environment.systemPackages = with pkgs; [
      bashmount  # WARN
      blueman
      lxapp
      feh
      scrot
      gotty  # WARN
      xfce.thunar
      xcalib
      xtitle
      xorg.xprop
      yabar-unstable
      
      rofi
      rofi-dmenu
      rofi-pass
      rofi-systemd
    ];

    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.extraModprobeConfig = "options nouveau modeset=0";
    services.xserver = {
      enable = true;
      autorun = true;
      videoDrivers = [ "nvidia" ];
      
      # trackpag config
      libinput.enable = true;

      # key repeat configs
      autoRepeatDelay = 200;
      autoRepeatInterval = 25;

      # session
      desktopManager.xterm.enable = false;

      displayManager.sessionCommands = with pkgs; lib.mkAfter ''
        ${pkgs.xorg.xrandr}/bin/xrandr \
          --output DVI-D-0 --off \
          --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal \
          --output DP-0 --off \
          --output DP-1 --off \
          --output DP-2 --off \
          --output DP-3 --off \
          --output USB-C-0 --off
        ${pkgs.xorg.xrandr}/bin/xrandr --dpi 100

        /etc/xautolock-locker
        /etc/settings-volume > /tmp/volume
        systemctl --user start quasar-twominute.timer
        systemctl --user start quasar-wallpaper.service
        systemctl --user start quasar-terminal.service
        systemctl --user start quasar-nixlistall.service
        # systemctl --user start quasar-torrentdl.service
        # systemctl --user start quasar-youtubedl.service
      '';
      
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
