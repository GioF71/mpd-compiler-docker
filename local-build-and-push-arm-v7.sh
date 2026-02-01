#!/bin/bash

TODAY=$(date '+%Y-%m-%d')
MPD_VERSION=0.24.8

echo "TODAY=${TODAY}"

# debian bookworm
docker buildx build . \
    --platform linux/arm/v7 \
    --build-arg BASE_IMAGE=debian:bookworm-slim \
    --tag giof71/mpd-compiler:bookworm-armv7-${MPD_VERSION}-${TODAY} \
    --tag giof71/mpd-compiler:bookworm-armv7-${MPD_VERSION} \
    --tag giof71/mpd-compiler:bookworm-armv7 \
    --tag giof71/mpd-compiler:latest-armv7 \
    --tag giof71/mpd-compiler:stable-armv7 \
    --load \
    --push
