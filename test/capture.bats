#!/usr/bin/env bats

load test_helper


@test "capture webm generates webm" {
  stop_capture $fifo &

  cat $fifo | capture webm $tmpfile

  codec_name=$(probe $tmpfile | jq -r '.streams[0].codec_name')

  [ "${codec_name//[[:blank:]]/}" = "vp9" ]
}


@test "capture gif generates gif" {
  stop_capture $fifo &

  cat $fifo | capture gif $tmpfile

  codec_name=$(probe $tmpfile | jq -r '.streams[0].codec_name')

  [ "${codec_name//[[:blank:]]/}" = "gif" ]
}
