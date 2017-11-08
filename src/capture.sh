#!/usr/bin/env bash
set -e

#
# from discussion in #ffmpeg, the conclusions on best intermediate/realtime formats were
#
#   - video format: ffv1 or utvideo
#   - container format: nut
#

scale="-1:-1"
fps="15"
raw_video="-vf fps=$fps -c:v utvideo -f nut"
raw_video_container=".nut"

webm_video="-pix_fmt yuv420p -c:v libvpx-vp9 -crf 25 -b:v 0 -f webm"

tmpdir="/var/tmp"


# capture_raw ./foo.nut
capture_raw () {
  local output="$1" dimensions

  dimensions=$(slop -f "-s %wx%h -i $DISPLAY+%x,%y")

  # would it be cleaner if I passed dimensions instead of doing this here?
  countdown

  # I'd love to split slop output into a variable, but bash makes too hard

  ffmpeg -y -hide_banner -f x11grab $dimensions $raw_video "$output"
}


# encode_gif ./input.nut ./output.gif
encode_gif () {
  local input="$1" output="$2" palette

  palette=$(mktemp -p/tmp --suffix .png)
  filters="fps=$fps,scale=$scale:flags=lanczos"

  ffmpeg -y -v warning -i "$input" -vf "$filters,palettegen" -y "$palette"
  ffmpeg -y -hide_banner -i "$input" -i "$palette" -lavfi "$filters [x]; [x][1:v] paletteuse" -f gif "$output"

  rm $palette
}


# encode_webm ./input.nut ./output.webm
encode_webm () {
  local input="$1" output="$2"

  ffmpeg -y -hide_banner -i "$input" -vf "scale=$scale" $webm_video "$output"
}


countdown () {
  for i in {3..1}; do
    printf "$i.."
    sleep 1
  done
}


# capture webm ./output.webm
# capture gif ./output.gif 640:-1
capture () {
  local tmpfile output

  tmpfile=$(mktemp -p"$tmpdir" --suffix "$raw_video_suffix")
  output="$2"

  if [ -z "$2" ]; then
      output=$(mktemp -p"$tmpdir" --suffix ".webm")
  fi

  scale="${3:-$scale}"

  capture_raw "$tmpfile"

  case $1 in
      webm)
          encode_webm "$tmpfile" "$output"
          ;;
      gif)
          encode_gif "$tmpfile" "$output"
          ;;
      *)
          encode_webm "$tmpfile" "$output"
          ;;
  esac

  rm "$tmpfile"

  if [ -z "$2" ]; then
      printf "\n" >&2
      printf "$output"
      printf "\n" >&2
  fi
}


# remove this line if you want to source this file instead
eval " ${0##*/}" "$@"
