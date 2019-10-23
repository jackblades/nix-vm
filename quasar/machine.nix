
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machine;
in {
  imports = [
    # ./machines/dellxpsL502x.nix
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

    services.aria2.enable = false;
    services.aria2.downloadDir = "/home/ajit/aria2";
    services.aria2.extraArguments = "--max-connection-per-server=16";
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
    services.mpd = {
      enable = false;
      user = "ajit";
      group = "users";
      musicDirectory = "/run/media/common/_archive/Music";
      dataDir = "/run/media/common/quasar/mpd";
      extraConfig = ''
        audio_output {
          type    "pulse"
          name    "Local MPD"
          # server  "127.0.0.1"
          server  "localhost"
        }
      '';
    };
    services.ympd.enable = false;

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
