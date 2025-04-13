#!/bin/bash

TODAY=$(date '+%Y-%m-%d')
MPD_VERSION=0.24.3

echo "TODAY=${TODAY}"


# debian bookworm
docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7,linux/arm/v5 \
    --build-arg BASE_IMAGE=debian:bookworm-slim \
    --tag giof71/mpd-compiler:bookworm-${MPD_VERSION}-${TODAY} \
    --tag giof71/mpd-compiler:bookworm-${MPD_VERSION} \
    --tag giof71/mpd-compiler:bookworm \
    --tag giof71/mpd-compiler:latest \
    --tag giof71/mpd-compiler:stable \
    --push
