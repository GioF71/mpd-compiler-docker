#!/bin/bash

TODAY=$(date '+%Y-%m-%d')
MPD_VERSION=0.24.5

echo "TODAY=${TODAY}"

# debian bookworm
docker buildx build . \
    --platform linux/amd64 \
    --build-arg BASE_IMAGE=debian:bookworm-slim \
    --tag giof71/mpd-compiler:bookworm-amd64-${MPD_VERSION}-${TODAY} \
    --tag giof71/mpd-compiler:bookworm-amd64-${MPD_VERSION} \
    --tag giof71/mpd-compiler:bookworm-amd64 \
    --tag giof71/mpd-compiler:latest-amd64 \
    --tag giof71/mpd-compiler:stable-amd64 \
    --load \
    --push
