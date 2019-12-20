

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./constants.nix
    ./quasar/base.nix
    ./quasar/machine.nix
  ];

  config.quasar.machine.enable = true;  # disable during install

  # config.boot.plymouth.enable = true;
  # boot.plymouth.logo = ./file.png;

}














