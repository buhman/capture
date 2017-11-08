# capture

`capture` is a no bullshit screen capture tool.

[![circleci](https://img.shields.io/circleci/project/github/buhman/capture.svg)](https://circleci.com/gh/buhman/capture)

## installation

An install script is provided for simplicity.

```sh
$ curl -Lo- "https://raw.githubusercontent.com/buhman/capture/master/install.sh" | sudo bash
```

This is just a handfull of trivial commands that places `capture` in
`/usr/local/bin`. Feel free to copy-paste instead if you wish.

## dependencies

Dependencies are not considered during installation; you need to make these
exist on your own.

 - [`slop`](https://github.com/naelstrof/slop)
 - `ffmpeg>2.2`
 - `coreutils`
 - `bash>4.0`

## usage

Maximum simple:

```sh
capture
```

You'll get a selection rectangle, followed by the capture of that region. Press
`q` to stop the capture and finish encoding. The resulting filename will be
printed on stdout. You can capture this result to use it for further
processing/uploading.

### stdout

If you're uploading the output to elsewhere immediately; you might want to do
this.

```
capture webm - | upload_to_space
```

You can coincidentally also use other protocols like
[pipe](https://ffmpeg.org/ffmpeg-protocols.html#pipe).

### gif

Create a 320-pixel wide gif that maintains aspect ratio:

```
capture gif output.gif 320:-1
```

This is basically only useful when you want something you can embed on services
like github, otherwise webm/vp9 is massively more efficient.

## advanced usage

I try to provide sane defaults that result in acceptable-quality video with
minimum size optimized for quick sharing over the internet. If you don't like
these; the ffmpeg arguments should be easy to edit.

If you think there's a better default; open an
[issue](https://github.com/buhman/capture/issues).
