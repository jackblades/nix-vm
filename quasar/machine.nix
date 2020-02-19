
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machine;
    constants = config.constants;
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

    services.urxvtd.enable = false;

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
    programs.ssh.askPassword = "";
    programs.gnupg.agent.enable = true;
    programs.gnupg.dirmngr.enable = true;
    programs.gnupg.agent.enableSSHSupport = true;

    hardware.brightnessctl.enable = true;  # add users to 'video' group
    services.autorandr.enable = true;    

    services.aria2.enable = false;
    services.aria2.downloadDir = constants.qsr-user-storage-torrent;
    services.aria2.extraArguments = "--connect-timeout=60 --max-connection-per-server=16 --split=16 --min-split-size=1M --human-readable=true --download-result=full --seed-time=none";
    services.aria2.openPorts = true;
    services.aria2.rpcListenPort = 8081;
    # see https://aria2.github.io/manual/en/html/aria2c.html#rpc-auth
    services.aria2.rpcSecret = "aria2rpc"; 
    
    # xdg.portal.enable = true;
    # services.flatpak.enable = true;
    # services.flatpak.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    
    # system wide services

    services.locate = {
      enable = true;
      locate = pkgs.mlocate;
      interval = constants.locate-interval;
      # localuser = constants.qsr-user;  -- insecure [ uses su ]
      pruneNames = constants.locate-pruneNames;
    };

    #
    services.taskserver = {
      enable = false;
      user = constants.qsr-user;  # "taskd"
      allowedClientIDs = [];  # "any", "none"
      dataDir = constants.qsr-user-storage-quasar + "/tasks";
      listenPort = 53589;  # 53589
    };

    # mpd service
    # boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];
    services.mpd = {
      enable = true;
      # TODO authentication if "any"
      network.listenAddress = "any";  # "127.0.0.1"
      network.port = constants.mpd-port;  # 6600
      startWhenNeeded = true;
      user = constants.qsr-user;
      group = constants.qsr-user-group;
      musicDirectory = constants.qsr-user-storage-music;
      dataDir = constants.qsr-user-storage-quasar + "/mpd";
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
    services.ympd.webPort = 8080;  # TODO

    services.plex = {
      enable = false;
      user = constants.qsr-user;
      group = constants.qsr-user-group;
      dataDir = constants.qsr-user-storage-quasar + "/plex";
    };
    # Dashboard > Advanced > SecureConntionMode=Disabled, AutoPortMapping=Disabled
    services.jellyfin = {
      enable = false;
      user = constants.qsr-user;
      group = constants.qsr-user-group;
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

      fontconfig.defaultFonts.monospace = constants.fontconfig-default-monospace;
      # fontconfig.defaultFonts.sansSerif = "";
      # fontconfig.defaultFonts.serif = "";
    };
  };
}
