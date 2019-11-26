
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machines.skyreach4mini;
    fmount-uuid = uuid: fstype: { 
      device = "/dev/disk/by-uuid/${uuid}"; 
      fsType = fstype; 
    };

in {
  options.quasar.machines.skyreach4mini = {
    enable = mkEnableOption "quasar machine configuration for the skyreach 4 mini system";
  };

  config = mkIf cfg.enable {
    # sdc3
    fileSystems."/run/media/external" = fmount-uuid "A0DEA515DEA4E4AE" "ntfs";
    fileSystems."/run/media/common" = fmount-uuid "A4C2158AC215623A" "ntfs";
    # fileSystems."/run/media/win10ltsc" = fmount-uuid "79416EEF4F0AE288" "ntfs"
      

    # sound support
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    # hardware.pulseaudio.systemWide = true;
    hardware.pulseaudio.tcp.enable = true;
    hardware.pulseaudio.tcp.anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
    
    # bluetooth support
    hardware.bluetooth.enable = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    hardware.pulseaudio.support32Bit = true;
    hardware.pulseaudio.extraConfig = ''
      # switch to bluetooth on connect
      .ifexists module-switch-on-connect.so
      load-module module-switch-on-connect
      .endif
    '';
    hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
    # hardware.bluetooth.extraConfig = ''
    #   # may be unncesessary and does not work with bluez5
    #   [General]
    #   Enable=Source,Sink,Media,Socket
    # '';
    

    # opengl support
    hardware.opengl.enable = true;
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages = [ pkgs.intel-media-driver ];
  };
}
