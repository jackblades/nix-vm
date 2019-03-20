
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.quasar.machine;
in {
  imports = [
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

    environment.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = [ "1" ];
      # TODO is this necessary?
      GTK_DATA_PREFIX = [
        "${config.system.path}"
      ];
    };
  };
}