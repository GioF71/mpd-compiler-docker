#!/bin/bash

TODAY=$(date '+%Y-%m-%d')
MPD_VERSION=0.24.5

echo "TODAY=${TODAY}"

# debian bookworm
docker buildx build . \
    --platform linux/arm/v6 \
    --build-arg BASE_IMAGE=debian:bookworm-slim \
    --tag giof71/mpd-compiler:bookworm-armv6-${MPD_VERSION}-${TODAY} \
    --tag giof71/mpd-compiler:bookworm-armv6-${MPD_VERSION} \
    --tag giof71/mpd-compiler:bookworm-armv6 \
    --tag giof71/mpd-compiler:latest-armv6 \
    --tag giof71/mpd-compiler:stable-armv6 \
    --load \
    --push
