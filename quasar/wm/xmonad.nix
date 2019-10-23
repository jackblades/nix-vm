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

    usermode = m: c: c // { user = "ajit"; group = "users"; mode = m; };
    rx = "555";  # rx is permissions
    rxfile = usermode rx;

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
      settings-calendar = rxfile {
        text = ''
          #!/bin/sh
          ${pkgs.procps}/bin/pgrep gnome-calendar || ${pkgs.gnome3.gnome-calendar}/bin/gnome-calendar &
        '';
      };
      settings-network = rxfile {
        text = ''
          #!/bin/sh
          env PATH=${rofi-dmenu}/bin/:${pkgs.pinentry}/bin/:$PATH ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu &
        '';
      };
      settings-power = rxfile {
        text = ''
          #!${pkgs.fish}/bin/fish
          set power_options reboot suspend poweroff "" hibernate hybrid-sleep 
          set choice (for op in $power_options; ${pkgs.coreutils}/bin/echo "    $op"; end | ${rofi-dmenu}/bin/dmenu) 
          string length $choice
            and ${pkgs.systemd}/bin/systemctl $choice
        '';
      };
      settings-sound = rxfile {
        text = ''
          #!/bin/sh
          ${pkgs.procps}/bin/pkill -f blueman-manager || ${pkgs.blueman}/bin/blueman-manager &
          ${pkgs.procps}/bin/pkill pavucontrol || (${pkgs.pavucontrol}/bin/pavucontrol && /etc/settings-volume >> /tmp/volume)&
        '';
      };
      settings-volume = rxfile {
        text = ''
          #!/bin/sh

          # Get the index of the selected sink:
          getsink() {
              ${pkgs.pulseaudio}/bin/pacmd list-sinks |
                  ${pkgs.gawk}/bin/gawk '/index:/{i++} /* index:/{print i; exit}'
          }

          # Get the selected sink volume
          getvolume() {
              ${pkgs.pulseaudio}/bin/pacmd list-sinks |
                  ${pkgs.gawk}/bin/gawk '/^\svolume:/{i++} i=='$(getsink)'{print $5; exit}'
          }

          ${pkgs.coreutils}/bin/echo  $(getvolume)
        '';
      };
      settings-volume-mute = rxfile {
        text = ''
          #!/bin/sh
          ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
          /etc/settings-volume >> /tmp/volume
        '';
      };
      settings-volume-set = rxfile {
        text = ''
          #!/bin/sh
          ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ "$@"
          /etc/settings-volume >> /tmp/volume
        '';
      };
      settings-brightness = rxfile {
        text = ''
          #!/bin/sh
          ${pkgs.brightnessctl}/bin/brightnessctl s "$@"
        '';
      };
      settings-toggle-redshift = rxfile {
        text = ''
          #!${pkgs.fish}/bin/fish
          ${pkgs.systemd}/bin/systemctl --user status redshift
          and ${pkgs.systemd}/bin/systemctl --user stop redshift
          or ${pkgs.systemd}/bin/systemctl --user start redshift
        '';
      };
      
      # rofi config
      "rofi/config" = rxfile {
        source = ../home/dotfiles/rofi/config;
      };
      "rofi/nord.rasi" = rxfile {
        source = ../home/dotfiles/rofi/nord.rasi;
      };
    };

    # services.dbus.packages = with pkgs; [ gnome3.dconf ];

    environment.systemPackages = with pkgs; [
      bashmount  # WARN
      blueman
      lxapp
      feh
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

      linuxPackages.bbswitch
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
      shadowExclude = [ "class_g = '.terminator-wrapped'" "name ~= 'yabar$'" ];
      fade = true;
      fadeExclude = [ "class_g = '.terminator-wrapped'" "_NET_WM_NAME@:s = 'rofi'" ];
      inactiveOpacity = "0.8";
      settings = {
        focus-exclude = [ "name *?= 'i3lock'" ];
      };
    };

    services.redshift = {
      enable = true;
    };
    location.latitude = 12.9716;
    location.longitude = 77.5946;

    hardware.bumblebee.enable = true;
    hardware.bumblebee.connectDisplay = true;
    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.extraModprobeConfig = "options nouveau modeset=0";
    services.xserver = {
      enable = true;
      autorun = true;
      videoDrivers = [ "intel" "nvidia" ];
      
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
