# mpd-compiler-docker

Builds mpd from source code, specifically [this fork of MPD](https://github.com/gioF71/MPD).  
Can be used as base for other container images.

## Reference

This repo creates builds for [MPD](https://musicpd.org/).

## Links

Source code on [GitHub](https://github.com/GioF71/mpd-compiler-docker)  
Images on [DockerHub](https://hub.docker.com/r/giof71/mpd-compiler)

## Usage

Compiled binaries are available at the directory `/app/bin`. You will find that this directory include two files, `mpd` and `mpd-ups`.  
The latter is a patched version, which will support a new configuration parameter named `integer_upsampling` for alsa outputs. If set to `yes` and if `allowed_formats` is set, this configuration will choose the first format which is an integer multiple of the currently playing audio file.  
Example for `allowed_formats`: `"352800:*:* 384000:*:* *:dsd:*"`. Using this configuration, 44.1kHz will be upsampled to 352.8kHz and 48kHz will be upsampled to 384kHz.  
This image is used by the [mpd-alsa-docker](https://github.com/GioF71/mpd-alsa-docker) repo. Using that it should be easy to adopt this patched version of mpd.  

## Disclaimer

This is not supported by the [MPD](https://musicpd.org/) project. Use this patched version at your own risk.

## Change History

See the following table for changes starting from 2023-07-20.

Date|Major Changes
:---|:---
2023-07-20|Dropped `bullseye` and `jammy` builds (see issue [#29](https://github.com/GioF71/mpd-compiler-docker/issues/29))
