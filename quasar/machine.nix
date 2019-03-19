
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machine;
in {
  imports = [
    # ../hardware-configuration.nix
    # ./base.nix
    ./machines/dellxpsL502x.nix
    ./users.nix
  ];
  
  options.quasar.machine = {
    enable = mkEnableOption "quasar machine configuration";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    
    quasar.users.enable = true;
    quasar.machines.dellxpsL502x.enable = true;
  };
}