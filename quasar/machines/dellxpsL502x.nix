
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machines.dellxpsL502x;
in {
  options.quasar.machines.dellxpsL502x = {
    enable = mkEnableOption "quasar machine configuration for dell xps 15 [L502X]";
  };

  config = mkIf cfg.enable {
    # sound support
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    

    # bluetooth support
    hardware.bluetooth.enable = true;
    hardware.bluetooth.extraConfig = ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
      # hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];


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
    services.xserver.videoDrivers = [ "intel" "nvidia" ];
    # hardware.bumblebee.enable = true;  # seems ok without it    
  };
}