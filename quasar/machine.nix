
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machine;
in {
  imports = [
    ./machines/dellxpsL502x.nix
    ./users.nix
  ];
  
  options.quasar.machine = {
    enable = mkEnableOption "quasar machine configuration";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    
    quasar.users.enable = true;
    quasar.machines.dellxpsL502x.enable = true;

    environment.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = [ "1" ];
      # TODO is this necessary?
      GTK_DATA_PREFIX = [
        "${config.system.path}"
      ];
    };

    # user services
    programs.gnupg.agent.enable = true;
    programs.gnupg.dirmngr.enable = true;

    hardware.brightnessctl.enable = true;  # add users to 'video' group
    services.autorandr.enable = true;    

    services.flatpak.enable = true;
    services.flatpak.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    
    # system wide services

    services.locate = {
      enable = true;
      locate = pkgs.mlocate;
      interval = "hourly";
      # localuser = "ajit";  -- insecure [ uses su ]
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
        font-droid
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