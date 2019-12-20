
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.constants; in
{
  imports = [
  ];
  
  options.constants = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  # style guide: all paths must begin with / and end without 
  config.constants = {
    state-version = "19.09";      

    qsr-user = "ajit";
    qsr-user-name = "Ajit Singh";
    qsr-user-group = "users";
    qsr-user-home = "/home/ajit";
    qsr-user-createHome = true;
    qsr-user-shell = "${pkgs.fish}/bin/fish";
    # qsr-authorized-keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoEMEdWQpZe2ZK48JFFGUb4sSU/cLrUZjr6RuX3XMlU9BIeJ9FCNzTZVmfK3Rwy9x/mfmS/MngTE/DP0JmP25sZdETx8QFWlwkC6lyuydFIKk93chz8ZmXHlKR7NCjgGru8PvxMX1RWnD6+hcKqqpAijoeCO0PchJjVUKOjcz9UGJLaqDzGBV8KmGH2wVA1KRHPUw7OxHasckY1frpwO8ENfHjSu1TiEFDKGwlkOc7LOBxj0LSbzka5S9Wdij67xCTQUmp2S/lWrS6yogX4TPTyZIElUReAe4tkmujwMOmlq5cwT1kx62whMf1WnfGq0yiH7Ch95C/XIe0PgjZXbL3 ajit@ajit-Latitude-E7240" ];

    qsr-user-media = "/media";  
    qsr-user-storage = cfg.qsr-user-media + "/external";
    qsr-user-storage-quasar = cfg.qsr-user-storage + "/quasar";
    qsr-user-storage-wallpaper = cfg.qsr-user-storage + "/Wallpapers";
    qsr-user-storage-music = cfg.qsr-user-storage + "/Music";
    qsr-user-storage-torrent = cfg.qsr-user-storage-quasar + "/torrentdl";
    qsr-user-storage-youtube = cfg.qsr-user-storage-quasar + "/youtubedl";

    qsr-wall-path = "/tmp/bg";
    mpd-port = 6600;  # 6600

    boot-device = "/dev/sdb";
    gpu-iommu-ids = "10de:1f07,10de:10f9,10de:1ada,10de:1adb";
    console-font = "Droid Sans, FontAwesome Bold 9";
    fontconfig-default-monospace = [ "Inconsolata\-dz for Powerline" ];
    hostname = "quasar";
    timezone = "Asia/Calcutta";
    locate-interval = "hourly";
    locate-pruneNames = [ ".git" ".bzr" ".hg" ".svn" ".stack-work" ".cache" ];

  };

  config.location = {
  	latitude = 12.9716;
  	longitude = 77.5946;
  };
}
