
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machine;
in {
  imports = [
    ./machines/skyreach4mini.nix
    ./machines/gpu-passthrough.nix
    ./users.nix
  ];
  
  options.quasar.machine = {
    enable = mkEnableOption "quasar machine configuration";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.oraclejdk.accept_license = true;
    # nixpkgs.config.steam.primus = true;
    # nixpkgs.config.steam.java = true;
    nixpkgs.config.permittedInsecurePackages = [
      "webkitgtk-2.4.11"
    ];
    
    quasar.users.enable = true;
    # quasar.gpu-passthrough.enable = true;
    quasar.machines.skyreach4mini.enable = true;

    services.urxvtd.enable = true;

    services.logind.lidSwitch = "ignore";
    services.logind.lidSwitchDocked = "ignore";

    environment.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";

      # path config for gtk apps
      GTK_DATA_PREFIX = [
        "${config.system.path}"
      ];

      # wm thing java apps
      _JAVA_AWT_WM_NONREPARENTING = "1";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
    };

    # user services
    programs.gnupg.agent.enable = true;
    programs.gnupg.dirmngr.enable = true;

    hardware.brightnessctl.enable = true;  # add users to 'video' group
    services.autorandr.enable = true;    

    services.aria2.enable = true;
    services.aria2.downloadDir = "/run/media/external/quasar/torrentdl";
    services.aria2.extraArguments = "--connect-timeout=60 --max-connection-per-server=16 --split=16 --min-split-size=1M --human-readable=true --download-result=full --seed-time=none";
    services.aria2.openPorts = true;
    services.aria2.rpcListenPort = 6800;
    # see https://aria2.github.io/manual/en/html/aria2c.html#rpc-auth
    services.aria2.rpcSecret = "aria2rpc"; 
    
    # xdg.portal.enable = true;
    # services.flatpak.enable = true;
    # services.flatpak.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    
    # system wide services

    services.locate = {
      enable = true;
      locate = pkgs.mlocate;
      interval = "hourly";
      # localuser = "ajit";  -- insecure [ uses su ]
    };

    #
    services.taskserver = {
      enable = false;
    };

    # mpd service
    # boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
    services.mpd = {
      enable = true;
      # TODO authentication if "any"
      network.listenAddress = "any";  # "127.0.0.1"
      network.port = 6600;  # 6600
      startWhenNeeded = true;
      user = "ajit";
      group = "users";
      musicDirectory = "/run/media/external/Music";
      dataDir = "/run/media/external/quasar/mpd";
      extraConfig = ''
        audio_output {
          type    "pulse"
          name    "Local MPD"
          server  "127.0.0.1"
          # server  "localhost"
        }
      '';
    };
    services.ympd.enable = true;
    services.ympd.webPort = 8080;

    services.plex = {
      enable = false;
      user = "ajit";
      group = "users";
      dataDir = "/run/media/external/quasar/plex";
    };
    # Dashboard > Advanced > SecureConntionMode=Disabled, AutoPortMapping=Disabled
    services.jellyfin = {
      enable = true;
      user = "ajit";
      group = "users";
    };

    # fonts [ TODO move to home-manager? ]
    fonts = {
      enableFontDir = true;
      enableGhostscriptFonts = true;
      enableDefaultFonts = true;
      fonts = with pkgs; [
        anonymousPro
        corefonts
        dejavu_fonts
        noto-fonts
        freefont_ttf
        google-fonts
        inconsolata
        liberation_ttf
        powerline-fonts
        source-code-pro
        terminus_font
        ttf_bitstream_vera
        ubuntu_font_family

        vistafonts
        proggyfonts
        font-awesome-ttf
        source-sans-pro
        source-serif-pro 
      ];

      fontconfig.defaultFonts.monospace = [ "Inconsolata\-dz for Powerline" ];
      # fontconfig.defaultFonts.sansSerif = "";
      # fontconfig.defaultFonts.serif = "";
    };
  };
}
