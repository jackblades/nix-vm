

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./quasar/base.nix
    # -- post install configuration
    ./quasar/machine.nix
  ];

  # config.quasar.machine.enable = false;  # during install
  config.quasar.machine.enable = true;
}














