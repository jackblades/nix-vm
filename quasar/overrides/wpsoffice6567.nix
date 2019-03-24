
# wps office

{ pkgs, ... }:

pkgs.wpsoffice.overrideAttrs (old: rec {
  name = "wpsoffice-10.1.0.6757";
  src = pkgs.fetchurl {
    url = "http://kdl.cc.ksosoft.com/wps-community/download/6757/wps-office_10.1.0.6757_x86_64.tar.xz";
    sha256 = "0zk2shi3ciyjnmwvixkmj2qnivkg9a86mnvn83sj9idhlgjx7002";
  };

  libPath = with pkgs; stdenv.lib.makeLibraryPath [
    xorg.libX11
    xorg.libxcb
    libpng12
    glib
    xorg.libSM
    xorg.libXext
    fontconfig
    zlib
    freetype
    xorg.libICE
    cups
    xorg.libXrender
    lzma
    corefonts
    vistafonts
  ];

  installPhase = ''
    prefix=$out/opt/kingsoft/wps-office
    mkdir -p $prefix
    cp -r . $prefix

    # Avoid forbidden reference error due use of patchelf
    rm -r $PWD

    mkdir $out/bin
    for i in wps wpp et; do
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --force-rpath --set-rpath "$prefix/office6:$libPath" \
        $prefix/office6/$i

      substitute $prefix/$i $out/bin/$i \
        --replace /opt/kingsoft/wps-office $prefix
      chmod +x $out/bin/$i

      substituteInPlace $prefix/resource/applications/wps-office-$i.desktop \
        --replace /usr/bin $out/bin
    done

    # [ CUSTOM ] rename the binaries
    mv $out/bin/et $out/bin/wps-excel
    mv $out/bin/wpp $out/bin/wps-powerpoint
    mv $out/bin/wps $out/bin/wps-word

    # China fonts
    mkdir -p $prefix/resource/fonts/wps-office $out/etc/fonts/conf.d
    # ln -s $prefix/fonts/* $prefix/resource/fonts/wps-office
    # ln -s $prefix/fontconfig/*.conf $out/etc/fonts/conf.d
    ln -s $prefix/resource $out/share
  '';
})