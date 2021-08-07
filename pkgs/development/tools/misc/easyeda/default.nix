{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, unzip
, libX11, glib, nss, gtk3-x11, xlibs, alsaLib
}:

stdenv.mkDerivation rec {
  name = "easyeda-${version}";

  version = "6.4.20.6";

  src = fetchurl {
    url = "https://image.easyeda.com/files/easyeda-linux-x64-${version}.zip";
    sha256 = "714bf26bb25103642db931de4cbdb62c3d4296f2649ebf7d4bc4dab0adc124fd";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    unzip
    libX11
    glib
    nss
    gtk3-x11
    xlibs.libXdamage
    xlibs.libXtst
    xlibs.libXScrnSaver
    alsaLib
  ];

  unpackPhase = ''
    unzip $src
    unzip -d "easyeda-${version}" 'easyeda-linux-x64.zip'
  '';

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    rm *.{sh,txt}
    cd "easyeda-${version}"
    chmod +x easyeda
    cd ..
    mkdir -p $out/opt
    cp -r easyeda-${version} $out/opt/easyeda
    #install -m755 -D easyeda-${version} $out/bin/easyeda
  '';

  meta = with lib; {
    homepage = "https://easyeda.com";
    description = "PCB design tool";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ thek0tyara ];
  };
}
