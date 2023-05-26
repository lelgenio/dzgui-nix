{ pkgs, lib, stdenv, fetchFromGitHub, makeWrapper }:
stdenv.mkDerivation rec {
  pname = "dzgui";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "aclist";
    repo = "dztui";
    rev = "10c29c0542a07fb81b5922f96b416e3a2e8079cc";
    sha256 = "sha256-VmW0ohXK+9CAr4yGaA/NSW7+E1vUvZthom8MculmOEs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  runtimeDeps = with pkgs; [
    curl
    jq
    python3
    wmctrl
    xdotool
    gnome.zenity

    ## Here we don't declare steam as a dependency because
    ## we could either use the native or flatpack version
    ## and also so this does not become a non-free package
    # steam
  ];

  patches = [
    ./patches/dont-hardcode-zenity.patch
    ./patches/dont-write-desktop-entry-during-runtime.patch
    ./patches/dont-check-map-count.patch
    ./patches/send-noop-before-installing-mods.patch
  ];

  installPhase = ''
    install -DT dzgui.sh $out/bin/.dzgui-unwrapped_
    makeWrapper $out/bin/.dzgui-unwrapped_ $out/bin/dzgui \
      --prefix PATH ':' ${lib.makeBinPath runtimeDeps}

    install -DT ${./dzgui.desktop} $out/share/applications/dzgui.desktop
    install -DT images/dzgui $out/share/icons/hicolor/256x256/apps/dzgui.png
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
