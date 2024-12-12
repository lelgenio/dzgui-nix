#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq ripgrep common-updater-scripts

set -xe

latest_commit="$(
  curl -L -s https://codeberg.org/api/v1/repos/aclist/dztui/branches/dzgui \
  | jq -r .commit.id
)"

version="$(
  curl https://codeberg.org/aclist/dztui/raw/commit/$latest_commit/dzgui.sh \
  | rg '^version=(.*)$' --replace '$1'
)"

update-source-version dzgui "$version" --rev=$latest_commit
