{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
}: let
  ver = "2.13.1";
in
  stdenv.mkDerivation rec {
    pname = "vanta-agent";
    version = ver;

    src = fetchurl {
      url = "https://vanta-agent-repo.s3.amazonaws.com/targets/versions/${version}/vanta-amd64.deb";
      hash = "sha256-rO0Xfl1MDUdJByLd3kGqAP5u6OgxbaO5MJoprgW1etc=";
    };

    nativeBuildInputs = [autoPatchelfHook dpkg];

    unpackPhase = ''
      runHook preUnpack

      dpkg-deb -x $src .

      runHook postUnpack
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -a var $out/
      cp -a etc $out/

      mkdir -p $out/bin
      ln -s $out/var/vanta/vanta-cli $out/bin/

      runHook postInstall
    '';
  }
