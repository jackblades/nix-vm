{ lib, pkgs, config, ...}:
with lib;
let cfg = config.quasar.gpu-passthrough;
in {
  imports = [
    
  ];

  options.quasar.gpu-passthrough = {
    enable = mkEnableOption "quasar.gpu-passthrough service";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [ "intel_iommu=on" ];
    boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
    boot.kernelModules = [ "kvm-amd" "kvm-intel" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    # generated from ./list_iommu.sh
    boot.extraModprobeConfig = "options vfio-pci ids=10de:1f07,10de:10f9,10de:1ada,10de:1adb";
  
    virtualisation = {
      libvirtd = {
        enable = true;
        qemuOvmf = true;
        qemuVerbatimConfig = ''
          # default
          namespaces = []

          # audio
          user = "ajit"
        '';
      };
    };

    # services.xserver.extraConfig = ''
    #   Section "Device"
    #     Driver  "noveau"
    #     Option  "RegistryDwords"   "PowerMizerEnable=0x1; PerfLevelSrc=0x3333; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
    #     [other options might exist here - do not touch those]
    #   EndSection
    # '';

    environment.systemPackages = with pkgs; [ virtmanager ];
    services.dbus.packages = with pkgs; [ gnome3.dconf ];
  };
}
