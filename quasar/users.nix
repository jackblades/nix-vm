
{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.users;
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

    users.extraUsers.ajit = {
      name = "ajit";
      description = "Ajit Singh";    
      isNormalUser = true;

      uid = 1000;
      group = "users";
      home = "/home/ajit";

      shell = "${pkgs.fish}/bin/fish";
      createHome = true;
      extraGroups = [ "audio" "video" "disk" "wheel" "mlocate" "mpd" "aria2" "docker" "libvirtd" ];

      # openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoEMEdWQpZe2ZK48JFFGUb4sSU/cLrUZjr6RuX3XMlU9BIeJ9FCNzTZVmfK3Rwy9x/mfmS/MngTE/DP0JmP25sZdETx8QFWlwkC6lyuydFIKk93chz8ZmXHlKR7NCjgGru8PvxMX1RWnD6+hcKqqpAijoeCO0PchJjVUKOjcz9UGJLaqDzGBV8KmGH2wVA1KRHPUw7OxHasckY1frpwO8ENfHjSu1TiEFDKGwlkOc7LOBxj0LSbzka5S9Wdij67xCTQUmp2S/lWrS6yogX4TPTyZIElUReAe4tkmujwMOmlq5cwT1kx62whMf1WnfGq0yiH7Ch95C/XIe0PgjZXbL3 ajit@ajit-Latitude-E7240" ];
    };

    # installed applications
    environment.systemPackages = with pkgs; [
      hardinfo

      home-manager
      vscode
      firefox

      vlc
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
