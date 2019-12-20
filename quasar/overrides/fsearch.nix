{ mkDerivation, lib, ... }:

let
  version = "1.0";
in stdenv.mkDerivation {
  name = "fsearch-${version}";
  src = fetchGit "https://github.com/cboxdoerfer/fsearch";

  # nativeBuildInputs = [
  #   cmake
  #   extra-cmake-modules
  # ];

  buildInputs = [
    automake 
    autoconf 
    libtool 
    pkg-config 
    intltool 
    autoconf-archive 
    libpcre3-dev 
    libglib2.0-dev 
    libgtk-3-dev 
    libxml2-utils
  ];
}