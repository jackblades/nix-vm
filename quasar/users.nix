
{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.users;
    constants = config.constants;
    xterminator = import ./overrides/xterminator.nix { inherit lib pkgs; };
    wpsoffice6567 = import ./overrides/wpsoffice6567.nix { pkgs = pkgs; };
    vscodeCustom = import ./overrides/vscode.nix { pkgs = pkgs; };
    yEd319 = import ./overrides/yEd.nix pkgs;
    qsteam = pkgs.steam.override {
      withPrimus = true;
    };
in {
  imports = [
    ./shell/fish.nix
    ./wm/xmonad.nix
    ./wm/gnome3.nix
    ./home/manager.nix
  ];

  options.quasar.users = {
    enable = mkEnableOption "quasar users configuration";
  };

  config = mkIf cfg.enable {
    quasar.fish.enable = true;
    quasar.xmonad.enable = true;
    quasar.gnome3.enable = false;
    quasar.home.manager.enable = true;

    users.extraUsers."${constants.qsr-user}" = {
      name = constants.qsr-user;
      description = constants.qsr-user-name;    
      isNormalUser = true;

      uid = 1000;
      group = constants.qsr-user-group;
      home = constants.qsr-user-home;

      shell = constants.qsr-user-shell;
      createHome = constants.qsr-user-createHome;
      # cat /etc/group
      extraGroups = [ "audio" "video" "disk" "networkmanager" "wheel" "mlocate" "mpd" "docker" "libvirtd" ];

      # openssh.authorizedKeys.keys = constants.qsr-authorized-keys;
    };

    # installed applications
    environment.systemPackages = with pkgs; [

      home-manager
      vscodeCustom
      firefox
      
      # vlc
      mpv
      wpsoffice6567
      # yEd319

      speedtest-cli

      ntfs3g
      gparted

      youtube-dl

      # dev stuff [ also see flathub ]
      # datagrip  
      # gitkraken
      # slade
      # smartsynchronize
    ];

    # services.samba.enable = true;
    # services.samba.enableWinbindd = true;
  };
}
