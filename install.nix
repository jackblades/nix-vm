




# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let args = { config = config; pkgs = pkgs; };
    baseConfig = import ./configuration/base.nix args;
    installConfig = {
      imports =
        [ # Include the results of the hardware scan.
        ./configuration/hardware-configuration.nix
        ];  
    } // baseConfig;

in installConfig














