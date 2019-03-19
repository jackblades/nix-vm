# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let lib = import <nixpkgs/lib>;
    args = { config = config; pkgs = pkgs; home-manager = home-manager; };
    baseConfig = import ./configuration/base.nix args;
    machineConfig = import ./configuration/machine.nix args;

    home-manager = builtins.fetchGit {
      url = "https://github.com/rycee/home-manager.git";
      rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed"; # CHANGEME 
      ref = "release-18.09";
    };

    installConfig = {
      imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        "${home-manager}/nixos"
        ];  
    } // baseConfig;

in lib.recursiveUpdate installConfig machineConfig














