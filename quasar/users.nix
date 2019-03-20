
{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.users;
    wpsoffice6567 = import ./overrides/wpsoffice6567.nix { pkgs = pkgs; };
in {
  imports = [
    ./shell/fish.nix
    ./wm/xmonad.nix
  ];

  options.quasar.users = {
    enable = mkEnableOption "quasar users configuration";
  };

  config = mkIf cfg.enable {
    quasar.fish.enable = true;
    quasar.xmonad.enable = true;

    users.extraUsers.ajit = {
      name = "ajit";
      description = "Ajit Singh";    
      isNormalUser = true;

      uid = 1000;
      group = "users";
      home = "/home/ajit";

      shell = "${pkgs.fish}/bin/fish";
      createHome = true;
      extraGroups = [ "wheel" "disk" "networkmanager" "sound" "pulse" "audio" "mlocate" ];

      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoEMEdWQpZe2ZK48JFFGUb4sSU/cLrUZjr6RuX3XMlU9BIeJ9FCNzTZVmfK3Rwy9x/mfmS/MngTE/DP0JmP25sZdETx8QFWlwkC6lyuydFIKk93chz8ZmXHlKR7NCjgGru8PvxMX1RWnD6+hcKqqpAijoeCO0PchJjVUKOjcz9UGJLaqDzGBV8KmGH2wVA1KRHPUw7OxHasckY1frpwO8ENfHjSu1TiEFDKGwlkOc7LOBxj0LSbzka5S9Wdij67xCTQUmp2S/lWrS6yogX4TPTyZIElUReAe4tkmujwMOmlq5cwT1kx62whMf1WnfGq0yiH7Ch95C/XIe0PgjZXbL3 ajit@ajit-Latitude-E7240" ];
    };

    # installed applications
    environment.systemPackages = with pkgs; [
      speedtest-cli

      vlc
      firefox
      vscode
      wpsoffice6567

      # dev stuff [ also see flathub ]
      # datagrip  
      # gitkraken
      # slade
      # smartsynchronize

      arc-theme
      paper-icon-theme
    ];

    # user services
    services.flatpak.enable = true;
    services.flatpak.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    
    services.locate = {
      enable = true;
      locate = pkgs.mlocate;
      interval = "hourly";
      # localuser = "ajit";  -- insecure [ uses su ]
    };
    
    # fonts
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
