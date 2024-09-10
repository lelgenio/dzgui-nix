{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, curl
, jq
, python3
, wmctrl
, xdotool
, gnome
, gobject-introspection
, wrapGAppsHook
}:
stdenv.mkDerivation rec {
  pname = "dzgui";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "aclist";
    repo = "dztui";
    rev = "c2c7b37b904a05cdf0c86dbf3d22ef91728577b9";
    sha256 = "sha256-iC/c2MBFjvT0wVnKlpX4kL7fVa3BbjpmbEyjCU+aUyY=";
  };

  postPatch = ''
    sed -i 's@/usr/bin/zenity@zenity@g' dzgui.sh
    sed -i '/    check_map_count/d' dzgui.sh
    sed -i '/    check_version/d' dzgui.sh
    sed -i '/    write_desktop_file >/d' dzgui.sh
  '';

  nativeBuildInputs = [
    makeWrapper
    gobject-introspection
    wrapGAppsHook
  ];

  runtimeDeps = [
    curl
    jq
    (python3.withPackages (p: with p; [
      pygobject3
    ]))

    wmctrl
    xdotool
    gnome.zenity

    ## Here we don't declare steam as a dependency because
    ## we could either use the native or flatpack version
    ## and also so this does not become a non-free package
    # steam
  ];

  installPhase = ''
    install -DT dzgui.sh $out/bin/dzgui

    install -DT ${./dzgui.desktop} $out/share/applications/dzgui.desktop
    install -DT images/dzgui $out/share/icons/hicolor/256x256/apps/dzgui.png
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH ':' ${lib.makeBinPath runtimeDeps}
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/pronovic/banner";
    description = "DayZ TUI/GUI server browser";
    license = licenses.gpl3;

    longDescription = ''
      DZGUI allows you to connect to both official and modded/community DayZ
      servers on Linux and provides a graphical interface for doing so.
    '';

    platforms = platforms.all;
  };
}
