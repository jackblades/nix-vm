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

    rofi-dmenu = pkgs.stdenv.mkDerivation {
      name = "rofi-dmenu";
      buildInputs = [ pkgs.coreutils pkgs.rofi ];
      unpackPhase = "true"; # null src: skip the unpack phase
      installPhase = let dmenu-cmd = ''
          #!/bin/sh
          ${pkgs.rofi}/bin/rofi -dmenu $@
        ''; in ''
          ${pkgs.coreutils}/bin/mkdir -p $out/bin
          ${pkgs.coreutils}/bin/echo "${dmenu-cmd}" > $out/bin/dmenu
          ${pkgs.coreutils}/bin/chmod 555 $out/bin/dmenu
        '';
    };

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

    environment.etc = {
      settings-sound = {
        user = "ajit";
        group = "users";
        mode = "555";
        text = ''
          #!/bin/sh
          ${pkgs.procps}/bin/pkill -f blueman-manager || ${pkgs.blueman}/bin/blueman-manager &
          ${pkgs.procps}/bin/pkill pavucontrol || ${pkgs.pavucontrol}/bin/pavucontrol &
        '';
      };
      settings-calendar = {
        user = "ajit";
        group = "users";
        mode = "555";
        text = ''
          #!/bin/sh
          ${pkgs.procps}/bin/pgrep gnome-calendar || ${pkgs.gnome3.gnome-calendar}/bin/gnome-calendar &
        '';
      };
      settings-network = {
        user = "ajit";
        group = "users";
        mode = "555";
        text = ''
          #!/bin/sh
          env PATH=${rofi-dmenu}/bin/:${pkgs.pinentry}/bin/:$PATH ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu &
        '';
      };
      settings-power = {
        user = "ajit";
        group = "users";
        mode = "555";
        text = ''
          #!${pkgs.fish}/bin/fish
          set power_options reboot suspend poweroff "" hibernate hybrid-sleep 
          set choice (for op in $power_options; ${pkgs.coreutils}/bin/echo "    $op"; end | ${rofi-dmenu}/bin/dmenu) 
          string length $choice
            and ${pkgs.systemd}/bin/systemctl $choice
        '';
      };
    };

    environment.systemPackages = with pkgs; [
      bashmount  # WARN
      lxapp
      feh
      gotty  # WARN
      xcalib
      xtitle
      xorg.xprop
      yabar-unstable
      
      rofi
      rofi-dmenu
      rofi-pass
      rofi-systemd

      # gnome3.gnome-calendar
    ];

    systemd.user.services.quasar-topbar = {
      description = "xmonad topbar";
      serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.yabar-unstable}/bin/yabar -c ${./yabar.config}";
      };
    };
    systemd.services.quasar-topbar.enable = true;

    services.compton = {
      enable = true;
      shadow = true;
      shadowExclude = [ "class_g = '.terminator-wrapped'" ];
      fade = true;
      fadeExclude = [ "class_g = '.terminator-wrapped'" ];
      inactiveOpacity = "0.8";
      extraOptions = ''
        focus-exclude: [ "name *?= 'i3lock'" ];
      '';
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
