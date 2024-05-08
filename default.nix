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
  version = "5.2.3";

  src = fetchFromGitHub {
    owner = "aclist";
    repo = "dztui";
    rev = "release/${version}";
    sha256 = "sha256-fXFu2p9jxYfmsrQ1DBbd6pLcgRs/8HJiH6t4A5KevyQ=";
  };

  postPatch = ''
    sed -i 's@/usr/bin/zenity@zenity@g' dzgui.sh
    sed -i '/    check_map_count/d' dzgui.sh
    sed -i '/    check_version/d' dzgui.sh
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
