{ mkDerivation, lib, fetchFromGitHub
, cmake, extra-cmake-modules
, plasma-framework, kwindowsystem }:

let
    version = "5.9";
in

mkDerivation {
    name = "ksmoothdock-${version}";
    src = (fetchFromGitHub {
    owner = "dangvd";
    repo = "ksmoothdock";
    rev = "v${version}";
    sha256 = "1fbghyd079xk4q5na8msna5zkfg85c4ksyfqy524v2pm96dyl2dr";
    } + "/src");

    nativeBuildInputs = [
    cmake
    extra-cmake-modules
    ];

    buildInputs = [
    plasma-framework
    kwindowsystem
    ];

    postPatch = ''
    substituteInPlace CMakeLists.txt \
        --replace /usr/share/ share/
    '';

}