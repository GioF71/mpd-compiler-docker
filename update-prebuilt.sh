#!/bin/bash

MPD_VERSION=0.24.4

docker stop mpd-v5 && docker rm mpd-v5
docker stop mpd-v6 && docker rm mpd-v6
docker stop mpd-v7 && docker rm mpd-v7
docker stop mpd-v8 && docker rm mpd-v8
docker stop mpd-amd64 && docker rm mpd-amd64
docker create --name mpd-v5 giof71/mpd-compiler:latest-armv5 
docker create --name mpd-v6 giof71/mpd-compiler:latest-armv6 
docker create --name mpd-v7 giof71/mpd-compiler:latest-armv7
docker create --name mpd-v8 giof71/mpd-compiler:latest-armv8
docker create --name mpd-amd64 giof71/mpd-compiler:latest-amd64
docker cp mpd-v5:/app/bin/compiled/mpd assets/precompiled/arm/v5/mpd.${MPD_VERSION}.v5
docker cp mpd-v5:/app/bin/compiled/mpd-ups assets/precompiled/arm/v5/mpd.${MPD_VERSION}-ups.v5
docker cp mpd-v6:/app/bin/compiled/mpd assets/precompiled/arm/v6/mpd.${MPD_VERSION}.v6
docker cp mpd-v6:/app/bin/compiled/mpd-ups assets/precompiled/arm/v6/mpd.${MPD_VERSION}-ups.v6
docker cp mpd-v7:/app/bin/compiled/mpd assets/precompiled/arm/v7/mpd.${MPD_VERSION}.v7
docker cp mpd-v7:/app/bin/compiled/mpd-ups assets/precompiled/arm/v7/mpd.${MPD_VERSION}-ups.v7
docker cp mpd-v8:/app/bin/compiled/mpd assets/precompiled/arm/v8/mpd.${MPD_VERSION}.v8
docker cp mpd-v8:/app/bin/compiled/mpd-ups assets/precompiled/arm/v8/mpd.${MPD_VERSION}-ups.v8
docker cp mpd-amd64:/app/bin/compiled/mpd assets/precompiled/amd/64/mpd.${MPD_VERSION}.amd64
docker cp mpd-amd64:/app/bin/compiled/mpd-ups assets/precompiled/amd/64/mpd.${MPD_VERSION}-ups.amd64
