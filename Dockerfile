ARG BASE_IMAGE="${BASE_IMAGE}"
FROM ${BASE_IMAGE} AS BASE

ARG USE_APT_PROXY
ARG USE_GIT_BRANCH="${USE_GIT_BRANCH:-v0.23.x}"

RUN mkdir -p /app/conf

COPY app/conf/01-apt-proxy /app/conf/

RUN echo "USE_APT_PROXY=["${USE_APT_PROXY}"]"

RUN if [ "${USE_APT_PROXY}" = "Y" ]; then \
    echo "Builind using apt proxy"; \
    cp /app/conf/01-apt-proxy /etc/apt/apt.conf.d/01-apt-proxy; \
    cat /etc/apt/apt.conf.d/01-apt-proxy; \
    else \
    echo "Building without apt proxy"; \
    fi

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

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
RUN meson . output/release -Ddocumentation=disabled -Dtest=false -Dsystemd=disabled -Dpcre=enabled
RUN meson configure output/release
RUN ninja -C output/release
RUN mkdir /app/bin
RUN cp /source/MPD/output/release/mpd /app/bin/mpd
RUN git checkout ${USE_GIT_BRANCH}-ups
RUN ninja -C output/release
RUN cp /source/MPD/output/release/mpd /app/bin/mpd-ups

ARG BASE_IMAGE="${BASE_IMAGE}"
FROM ${BASE_IMAGE} AS INTERMEDIATE

ARG USE_APT_PROXY

RUN mkdir -p /app/conf

COPY app/conf/01-apt-proxy /app/conf/

RUN echo "USE_APT_PROXY=["${USE_APT_PROXY}"]"

RUN if [ "${USE_APT_PROXY}" = "Y" ]; then \
    echo "Builind using apt proxy"; \
    cp /app/conf/01-apt-proxy /etc/apt/apt.conf.d/01-apt-proxy; \
    cat /etc/apt/apt.conf.d/01-apt-proxy; \
    else \
    echo "Building without apt proxy"; \
    fi

RUN apt-get update

# install upstream mpd, for dependencies
RUN apt-get -y install mpd --no-install-recommends

RUN apt-get install -y --no-install-recommends libsidplay2 \
    libsidutils0 \
    libresid-builder-dev \
    libaudiofile-dev

RUN if [ "${USE_APT_PROXY}" = "Y" ]; then \
        rm /etc/apt/apt.conf.d/01-apt-proxy; \
    fi

RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /app/bin/compiled -p

COPY --from=BASE /app/bin/mpd* /app/bin/compiled/

FROM scratch
COPY --from=INTERMEDIATE / /

LABEL maintainer="GioF71"
LABEL source="https://github.com/GioF71/mpd-compiler-docker"

RUN echo "yes" > /app/conf/integer_upsampling_support.txt
RUN echo "/app/bin/compiled/mpd" > /app/conf/mpd-compiled-path.txt
RUN echo "/app/bin/compiled/mpd-ups" > /app/conf/mpd-compiled-ups-path.txt

# there is not a lot to see here, this is a base image
# so I am setting bash as the entrypoint
ENTRYPOINT [ "/bin/bash" ]
