# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let constants = config.constants; in
{ # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = constants.state-version;  
  
  # virtualisation.virtualbox.guest.enable = true;
  
  # show the manual on console 8
  # services.nixosManual.showManual = true;
  
  imports = [
      # ./overrides/iwd-nm-service.nix
  ];

  ## ---

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  boot.loader.grub.device = constants.boot-device;
  boot.loader.grub.useOSProber = true;
  boot.cleanTmpDir = true;
  
  # disable fsck (always fails and blocks at startup)
  boot.initrd.checkJournalingFS = false;   
  boot.supportedFilesystems = [ "ntfs" ];   

  # bluetooth wifi interference issue
  # boot.extraModprobeConfig = ''
  #   options iwlwifi bt_coex_active=0
  # '';
    # bbswitch load_state=-1 unload_state=1

  # get newer kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [ "acpi_rev_override=1" ];
  # hardware.nvidiaOptimus.disable = true;
  
  # timezone
  time.timeZone = constants.timezone;

  # tty console
  i18n.consoleFont = constants.console-font;
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  # networking
  networking.hostName = constants.hostname;
  networking.networkmanager.enable = true;
  # TODO BUG ipv6 may still be enabled
    # use sudo sysctl -w net.ipv6.conf.wlo1.disable_ipv6=1
    # boot.kernel.sysctl."net.ipv6.conf.wlo1.disable_ipv6" = true
  networking.enableIPv6 = false;
  networking.firewall.enable = false;  
  # networking.iwd-nm.enable = true;
  # networking.iwd-nm.wifi.backend = "iwd";
  # systemd.services."network-manager".requires = [
  #   "network-pre.target"
  #   "dbus.service"
  #   "iwd.service"
  # ];

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
    gitAndTools.gitFull
    # linuxPackages.bbswitch
    
    hardinfo
    binutils
    htop
    powertop
    iotop
    pciutils
    utillinux
    
    gcc
    manpages
    
    python2
    python3
    rsync
    sudo
    which
    wget
  ];

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  # nix.gc.dates = "03:15";
}
