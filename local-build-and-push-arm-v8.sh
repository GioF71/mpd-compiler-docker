#!/bin/bash

TODAY=$(date '+%Y-%m-%d')
MPD_VERSION=0.24.4

echo "TODAY=${TODAY}"

# debian bookworm
docker buildx build . \
    --platform linux/arm/v5 \
    --build-arg BASE_IMAGE=debian:bookworm-slim \
    --tag giof71/mpd-compiler:bookworm-armv8-${MPD_VERSION}-${TODAY} \
    --tag giof71/mpd-compiler:bookworm-armv8-${MPD_VERSION} \
    --tag giof71/mpd-compiler:bookworm-armv8 \
    --tag giof71/mpd-compiler:latest-armv8 \
    --tag giof71/mpd-compiler:stable-armv8 \
    --load \
    --push
