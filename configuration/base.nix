# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.cleanTmpDir = true;

  networking.hostName = "quasar"; # Define your hostname.
  # networking.networkmanager.enable = true;
  # interfaceMonitor.enable = true; # watch for plugged in cable
  networking.wireless.enable = false;
  networking.useDHCP = false;
  networking.wicd.enable = true;
  # networking.firewall.enable = false;
  # networking.enableIPv6 = false;

  i18n = {
    # consoleFont = "Lat2-Terminus16";
    consoleFont = "Droid Sans, FontAwesome Bold 9";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Asia/Calcutta";

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = with pkgs; [
    binutils
    gitAndTools.gitFull
    gcc
    htop
    manpages
    nix
    python2
    python3
    rsync
    sudo
    which
    wget
  ];
  
  # List services that you want to enable:
  services.openssh.enable = true;
  powerManagement.enable = true;
  services.upower.enable = true;
  # services.printing.enable = true;  # CUPS
  # services.redis.enable = true;

  services.xserver = {
    enable = false;
    layout = "us";
    xkbOptions = "eurosign:e";    
  };

  # user profile
  programs.fish.enable = true;
  users.extraUsers.ajit = {
    description = "Ajit Singh";    
    name = "ajit";
    isNormalUser = true;

    uid = 1000;
    group = "users";
    home = "/home/ajit";

    shell = "/run/current-system/sw/bin/fish";
    createHome = true;
    extraGroups = [ "wheel" "disk" "networkmanager" "sound" "pulse" "audio" "mlocate" ];

    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoEMEdWQpZe2ZK48JFFGUb4sSU/cLrUZjr6RuX3XMlU9BIeJ9FCNzTZVmfK3Rwy9x/mfmS/MngTE/DP0JmP25sZdETx8QFWlwkC6lyuydFIKk93chz8ZmXHlKR7NCjgGru8PvxMX1RWnD6+hcKqqpAijoeCO0PchJjVUKOjcz9UGJLaqDzGBV8KmGH2wVA1KRHPUw7OxHasckY1frpwO8ENfHjSu1TiEFDKGwlkOc7LOBxj0LSbzka5S9Wdij67xCTQUmp2S/lWrS6yogX4TPTyZIElUReAe4tkmujwMOmlq5cwT1kx62whMf1WnfGq0yiH7Ch95C/XIe0PgjZXbL3 ajit@ajit-Latitude-E7240" ];
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.09";

  ### custom begin here
  
  # enable virtualization
  # virtualisation.virtualbox.guest.enable = true;
  
  # disable fsck (always fails and blocks at startup)
  boot.initrd.checkJournalingFS = false;   
  
  # show the manual on console 8
  # services.nixosManual.showManual = true;

  # global env vars
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = [ "1" ];
    # GTK_DATA_PREFIX = [ "/run/current-system/sw" ];
    PATH = [ ]; # "/home/ajit/.nix-profile/bin" "/run/current-system/sw/bin" added by default
    # XCURSOR_PATH = [
    #   "${config.system.path}/share/icons"
    #   "$HOME/.icons"
    #   "$HOME/.nix-profile/share/icons/"
    # ];
    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];
  };
}
