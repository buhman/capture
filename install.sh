#!/usr/bin/env bash
set -e


fetch_source () {
  curl -Lo- https://github.com/buhman/capture/archive/master.tar.gz \
      | tar xz -C "$tmpdir" --strip-components=1
}


order66 () {
  local tmpdir="$(mktemp -d)"

  cd "$tmpdir"

  fetch_source "$tmpdir"

  install -Dm755 src/capture.sh /usr/local/bin/capture
}


order66
