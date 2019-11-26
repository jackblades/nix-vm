
{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
    name = "rofi-dmenu";
    buildInputs = [ pkgs.coreutils pkgs.rofi ];
    unpackPhase = "true"; # null src: skip the unpack phase
    installPhase = let dmenu-cmd = ''
        #!/bin/sh
        ${pkgs.rofi}/bin/rofi -dmenu $@
    ''; in ''
        ${pkgs.coreutils}/bin/mkdir -p $out/bin
        ${pkgs.coreutils}/bin/echo "${dmenu-cmd}" > $out/bin/dmenu
        ${pkgs.coreutils}/bin/chmod 555 $out/bin/dmenu
    '';
}