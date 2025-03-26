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
2025-03-27|Bump to mpd 0.24.2 (see issue [#56](https://github.com/GioF71/mpd-compiler-docker/issues/56))
2025-03-23|Bump to mpd 0.24.1 (see issue [#54](https://github.com/GioF71/mpd-compiler-docker/issues/54))
2025-02-07|Bump to mpd 0.23.17 (see issue [#50](https://github.com/GioF71/mpd-compiler-docker/issues/50))
2024-12-27|Bump to mpd 0.23.16 (see issue [#48](https://github.com/GioF71/mpd-compiler-docker/issues/48))
2024-06-13|Add support for noble (see issue [#46](https://github.com/GioF71/mpd-compiler-docker/issues/46))
2023-12-22|Dropped lunar builds (see issue [#44](https://github.com/GioF71/mpd-compiler-docker/issues/44))
2023-12-22|Bump to mpd 0.23.15 (see issue [#42](https://github.com/GioF71/mpd-compiler-docker/issues/42))
2023-10-11|Add support for mantic (see issue [#39](https://github.com/GioF71/mpd-compiler-docker/issues/39))
2023-10-10|Unified github workflow (see issue [#36](https://github.com/GioF71/mpd-compiler-docker/issues/36))
2023-10-10|Bump to mpd 0.23.14 (see issue [#37](https://github.com/GioF71/mpd-compiler-docker/issues/37))
2023-08-29|Debian builds for arm/v5 instead of v6 (see issue [#34](https://github.com/GioF71/mpd-compiler-docker/issues/34))
2023-07-21|Slim down image size, fix workflow warnings
2023-07-20|Apt install commands optimization (see issue [#31](https://github.com/GioF71/mpd-compiler-docker/issues/31))
2023-07-20|Dropped `bullseye` and `jammy` builds (see issue [#29](https://github.com/GioF71/mpd-compiler-docker/issues/29))
