{ stdenv, fetchzip, makeWrapper, unzip, oraclejre8, gtk2-x11, gtk3-x11, ... }:

stdenv.mkDerivation rec {
  name = "yEd-${version}";
  version = "3.19";

  src = fetchzip {
    url = "https://www.yworks.com/resources/yed/demo/${name}.zip";
    sha256 = "0l70pc7wl2ghfkjab9w2mbx7crwha7xwkrpmspsi5c6q56dw7s33";
  };

  nativeBuildInputs = [ makeWrapper unzip gtk2-x11 gtk3-x11 ];

  installPhase = ''
    mkdir -p $out/yed
    cp -r * $out/yed
    mkdir -p $out/bin
    makeWrapper ${oraclejre8}/bin/java $out/bin/yed \
      --add-flags "-jar $out/yed/yed.jar --" \
      --suffix-each LD_LIBRARY_PATH ':' "${gtk3-x11}/lib:${gtk2-x11}/lib"
  '';

  meta = with stdenv.lib; {
    license = licenses.unfree;
    homepage = http://www.yworks.com/en/products/yfiles/yed/;
    description = "A powerful desktop application that can be used to quickly and effectively generate high-quality diagrams";
    platforms = oraclejre8.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}