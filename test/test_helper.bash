setup () {
  export tmpfile="$(mktemp)"
  export tmpdir="$(mktemp -d)"
  export fifo="${tmpdir}/fifo"
  mkfifo "$fifo"

  _OLDPATH="$PATH"
  export PATH="$BATS_TEST_DIRNAME/fakebin:$PATH"
}

capture () {
  "$BATS_TEST_DIRNAME/capture" "$@"
}

stop_capture () {
  /usr/bin/sleep 1

  printf "q\n" > "$1"
}

probe () {
  ffprobe -v warning "$1" -show_entries stream -show_entries format -print_format json
}

teardown () {
  #rm "$tmpfile"
  rm "$fifo"
  rmdir "$tmpdir"

  export PATH="$_OLDPATH"
}
