#!/bin/bash

MPD_VERSION=0.23.17
TODAY=$(date '+%Y-%m-%d')

echo "MPD_VERSION=${MPD_VERSION}"
echo "TODAY=${TODAY}"

# debian bookworm
docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7,linux/arm/v5 \
    --build-arg BASE_IMAGE=debian:bookworm-slim \
    --build-arg USE_GIT_BRANCH=version-${MPD_VERSION} \
    --tag giof71/mpd-compiler:bookworm-${MPD_VERSION}-${TODAY} \
    --tag giof71/mpd-compiler:bookworm-${MPD_VERSION} \
    --tag giof71/mpd-compiler:bookworm \
    --tag giof71/mpd-compiler:latest \
    --tag giof71/mpd-compiler:stable \
    --push

# ubuntu noble
docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
    --build-arg BASE_IMAGE=ubuntu:noble \
    --build-arg USE_GIT_BRANCH=version-${MPD_VERSION} \
    --tag giof71/mpd-compiler:noble-${MPD_VERSION}-${TODAY} \
    --tag giof71/mpd-compiler:noble-${MPD_VERSION} \
    --tag giof71/mpd-compiler:noble \
    --push
