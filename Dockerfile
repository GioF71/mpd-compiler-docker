ARG BASE_IMAGE=debian:bookworm-slim

FROM ${BASE_IMAGE} AS base
ARG USE_GIT_BRANCH=version-0.24.5

RUN apt-get update

# libraries needed for building
RUN apt-get -y install meson \
    g++ \
    libfmt-dev \
    libpcre2-dev \
    libmad0-dev \
    libmpg123-dev \
    libid3tag0-dev \
    libflac-dev \
    libvorbis-dev \
    libopus-dev \
    libogg-dev \
    libadplug-dev \
    libaudiofile-dev \
    libsndfile1-dev \
    libfaad-dev \
    libfluidsynth-dev \
    libgme-dev \
    libmikmod-dev \
    libmodplug-dev \
    libmpcdec-dev \
    libwavpack-dev \
    libwildmidi-dev \
    libsidplay2-dev \
    libsidutils-dev \
    libresid-builder-dev \
    libavcodec-dev \
    libavformat-dev \
    libmp3lame-dev \
    libtwolame-dev \
    libshine-dev \
    libsamplerate0-dev \
    libsoxr-dev \
    libbz2-dev \
    libcdio-paranoia-dev \
    libiso9660-dev \
    libmms-dev \
    libzzip-dev \
    libcurl4-gnutls-dev \
    libyajl-dev \
    libexpat-dev \
    libasound2-dev \
    libao-dev \
    libjack-jackd2-dev \
    libopenal-dev \
    libpulse-dev \
    libshout3-dev \
    libsndio-dev \
    libmpdclient-dev \
    libnfs-dev \
    libupnp-dev \
    libavahi-client-dev \
    libsqlite3-dev \
    libsystemd-dev \
    libgtest-dev \
    libboost-dev \
    libicu-dev \
    libchromaprint-dev \
    libgcrypt20-dev \
    git

RUN mkdir /source
WORKDIR /source
RUN git clone https://github.com/GioF71/MPD.git --branch ${USE_GIT_BRANCH}
WORKDIR /source/MPD
RUN meson setup . output/release --buildtype=release -Db_ndebug=false
RUN ninja -C output/release
RUN mkdir -p /app/bin
RUN cp /source/MPD/output/release/mpd /app/bin/mpd
RUN git checkout ${USE_GIT_BRANCH}-ups
RUN ninja -C output/release
RUN cp /source/MPD/output/release/mpd /app/bin/mpd-ups

FROM ${BASE_IMAGE} AS intermediate

RUN apt-get update

# install upstream mpd, for dependencies
RUN apt-get -y install mpd --no-install-recommends

RUN apt-get install -y --no-install-recommends libsidplay2 \
    libsidutils0 \
    libresid-builder-dev \
    libaudiofile-dev

RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /app/bin/compiled -p

COPY --from=base /app/bin/mpd* /app/bin/compiled/

FROM scratch
COPY --from=intermediate / /

LABEL maintainer="GioF71"
LABEL source="https://github.com/GioF71/mpd-compiler-docker"

RUN mkdir -p /app/conf
RUN echo "yes" > /app/conf/integer_upsampling_support.txt
RUN echo "/app/bin/compiled/mpd" > /app/conf/mpd-compiled-path.txt
RUN echo "/app/bin/compiled/mpd-ups" > /app/conf/mpd-compiled-ups-path.txt

# there is not a lot to see here, this is a base image
# so I am setting bash as the entrypoint
ENTRYPOINT [ "/bin/bash" ]
