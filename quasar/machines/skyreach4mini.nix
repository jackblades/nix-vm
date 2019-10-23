
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machines.skyreach4mini;
in {
  options.quasar.machines.skyreach4mini = {
    enable = mkEnableOption "quasar machine configuration for the skyreach 4 mini system";
  };

  config = mkIf cfg.enable {
    # sdc3
    # fileSystems."/run/media/common" = {
      # device = "/dev/disk/by-uuid/450407545A0B2C50";
      # fsType = "ntfs";
    # };

    # sound support
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    
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
    hardware.opengl.extraPackages = with pkgs; [
      (vaapiIntel.override {
        enableHybridCodec = true; })
      vaapiVdpau
      libvdpau-va-gl
      # intel-media-driver # only available starting nixos-19.03 or the current nixos-unstable
    ];
  };
}
