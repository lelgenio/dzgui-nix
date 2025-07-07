{
  lib,
  stdenv,
  pkgs,
  fetchFromGitea,
  makeWrapper,
  curl,
  jq,
  python3,
  wmctrl,
  xdotool,
  gnome,
  gobject-introspection,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "dzgui";
  version = "5.8.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "aclist";
    repo = "dztui";
    rev = "321384dc7bd44339568a3f63630e5fc13a644fc9";
    hash = "sha256-eXNjxv7oLHer1raj0WgIi6OCrXVtkeiFJFGsg2F+FjI=";
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
    (python3.withPackages (p: with p; [ pygobject3 ]))

    wmctrl
    xdotool
    # TODO: remove 24.05 compatibility when it goes EOL
    (pkgs.zenity or gnome.zenity)

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
    homepage = "https://codeberg.org/aclist/dztui";
    description = "DayZ TUI/GUI server browser";
    license = licenses.gpl3;

    longDescription = ''
      DZGUI allows you to connect to both official and modded/community DayZ
      servers on Linux and provides a graphical interface for doing so.
    '';

    platforms = platforms.all;
  };
}
