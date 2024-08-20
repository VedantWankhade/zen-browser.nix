{ 
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "1.0.0-a.23";
  pname = "zen-specific";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-specific.AppImage";
    hash = "sha256-0kj1s0yznaaghyidddzq5zzjm01cnssgp0y6nxsnvmpj29agljr3=";  # Replace with actual sha256
  };

  appimageContents = appimageTools.extractType1 { inherit name src; };
in
appimageTools.wrapType1 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Zen-specific browser packaged as an AppImage";
    homepage = "https://github.com/zen-browser/desktop";
    downloadPage = "https://github.com/zen-browser/desktop/releases";
    license = lib.licenses.mit;  # Replace with the actual license
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ yourname ];  # Replace with your Nixpkgs username
    platforms = [ "x86_64-linux" ];
  };
}

