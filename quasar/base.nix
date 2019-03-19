# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{ # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.09";  
  
  # virtualisation.virtualbox.guest.enable = true;
  
  # show the manual on console 8
  # services.nixosManual.showManual = true;
  
  ## ---

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.cleanTmpDir = true;
  # disable fsck (always fails and blocks at startup)
  boot.initrd.checkJournalingFS = false;   

  # timezone
  time.timeZone = "Asia/Calcutta";

  # tty console
  i18n.consoleFont = "Droid Sans, FontAwesome Bold 9";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  # networking
  networking.hostName = "quasar";
  # networking.networkmanager.enable = true;
  # interfaceMonitor.enable = true; # watch for plugged in cable
  networking.wireless.enable = false;
  networking.useDHCP = false;
  networking.wicd.enable = true;
  # networking.firewall.enable = false;
  # networking.enableIPv6 = false;

  # hardware
  powerManagement.enable = true;
  services.upower.enable = true;
  # services.printing.enable = true;  # CUPS

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  
  # default packages
  environment.systemPackages = with pkgs; [
    nix
    
    binutils
    gitAndTools.gitFull
    gcc
    htop
    manpages
    pciutils
    python2
    python3
    rsync
    sudo
    utillinux
    which
    wget
  ];
  
  # TODO [position] global env vars
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = [ "1" ];
    GTK_DATA_PREFIX = [
      "${config.system.path}"
    ];
  };
}
