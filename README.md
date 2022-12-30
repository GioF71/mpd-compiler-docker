# mpd-compiler-docker

Builds mpd from source code.  
Can be used as base for other container images.

## Usage

Compiled binaries are available at the directory `/app/bin`. You will find that this directory include two files, `mpd` and `mpd-ups`.  
The latter is a patched version, which will support a new configuration parameter named `integer_upsampling` for alsa outputs. If set to `yes` and if `allowed_formats` is set, this configuration will choose the first format which is an integer multiple of the currently playing audio file.  
Example for `allowed_formats`: `"352800:*:* 384000:*:* *:dsd:*"`. Using this configuration, 44.1kHz will be upsampled to 352.8kHz and 48kHz will be upsampled to 384kHz.  
This image is used by the [mpd-alsa-docker](https://github.com/GioF71/mpd-alsa-docker) repo. Using that it should be easy to adopt this patched version of mpd.  

## Disclaimer

This is not supported by the MPD project. Use this patched version at your own risk.
