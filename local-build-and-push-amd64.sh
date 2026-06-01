#!/bin/bash

TODAY=$(date '+%Y-%m-%d')
MPD_VERSION=0.24.12

echo "TODAY=${TODAY}"

# debian trixie
docker buildx build . \
    --platform linux/amd64 \
    --build-arg BASE_IMAGE=debian:trixie-slim \
    --tag giof71/mpd-compiler:trixie-amd64-${MPD_VERSION}-${TODAY} \
    --tag giof71/mpd-compiler:trixie-amd64-${MPD_VERSION} \
    --tag giof71/mpd-compiler:trixie-amd64 \
    --tag giof71/mpd-compiler:latest-amd64 \
    --tag giof71/mpd-compiler:stable-amd64 \
    --load \
    --push
