# { stdenv, fetchurl, python2, keybinder3, intltool, file, gtk3, gobject-introspection
{ lib, pkgs, ... }:
with lib;
with pkgs;

python2.pkgs.buildPythonApplication rec {
  name = "xterminator-${version}";
  version = "1.91";

  src = /home/ajit/xterminator;

  nativeBuildInputs = [ file intltool wrapGAppsHook gobject-introspection ];
  buildInputs = [ gtk3 vte libnotify keybinder3
    gobject-introspection # Temporary fix, see https://github.com/NixOS/nixpkgs/issues/56943
  ];
  propagatedBuildInputs = with python2.pkgs; [ pygobject3 psutil pycairo ];

  postPatch = ''
    patchShebangs .
  '';

  checkPhase = ''
    ./run_tests
  '';

  meta = with lib; {
    description = "Terminal emulator with support for tiling and tabs";
    longDescription = ''
      The goal of this project is to produce a useful tool for arranging
      terminals. It is inspired by programs such as gnome-multi-term,
      quadkonsole, etc. in that the main focus is arranging terminals in grids
      (tabs is the most common default method, which Terminator also supports).
    '';
    homepage = https://gnometerminator.blogspot.no/p/introduction.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
