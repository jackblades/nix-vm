

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./quasar/base.nix

    ./quasar/machine.nix
  ];

  # config.quasar.machine.enable = false;  # install configuration
  config.quasar.machine.enable = true;
}














