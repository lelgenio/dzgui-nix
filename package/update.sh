#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq ripgrep common-updater-scripts

set -xe

latest_commit="$(
  curl -L -s ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} https://api.github.com/repos/aclist/dztui/branches/master \
  | jq -r .commit.sha
)"

version="$(
  curl https://raw.githubusercontent.com/aclist/dztui/$latest_commit/dzgui.sh \
  | rg '^version=(.*)$' --replace '$1'
)"

update-source-version dzgui "$version" --rev=$latest_commit
