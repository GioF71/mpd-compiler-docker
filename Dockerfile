ARG BASE_IMAGE="${BASE_IMAGE:-debian:bullseye-slim}"
FROM ${BASE_IMAGE} AS BASE
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
RUN apt-get -y install meson
RUN apt-get -y install g++
RUN apt-get -y install libfmt-dev
RUN apt-get -y install libpcre2-dev
RUN apt-get -y install libmad0-dev
RUN apt-get -y install libmpg123-dev
RUN apt-get -y install libid3tag0-dev
RUN apt-get -y install libflac-dev
RUN apt-get -y install libvorbis-dev
RUN apt-get -y install libopus-dev
RUN apt-get -y install libogg-dev
RUN apt-get -y install libadplug-dev
RUN apt-get -y install libaudiofile-dev
RUN apt-get -y install libsndfile1-dev
RUN apt-get -y install libfaad-dev
RUN apt-get -y install libfluidsynth-dev
RUN apt-get -y install libgme-dev
RUN apt-get -y install libmikmod-dev
RUN apt-get -y install libmodplug-dev
RUN apt-get -y install libmpcdec-dev
RUN apt-get -y install libwavpack-dev
RUN apt-get -y install libwildmidi-dev
RUN apt-get -y install libsidplay2-dev
RUN apt-get -y install libsidutils-dev
RUN apt-get -y install libresid-builder-dev
RUN apt-get -y install libavcodec-dev
RUN apt-get -y install libavformat-dev
RUN apt-get -y install libmp3lame-dev
RUN apt-get -y install libtwolame-dev
RUN apt-get -y install libshine-dev
RUN apt-get -y install libsamplerate0-dev
RUN apt-get -y install libsoxr-dev
RUN apt-get -y install libbz2-dev
RUN apt-get -y install libcdio-paranoia-dev
RUN apt-get -y install libiso9660-dev
RUN apt-get -y install libmms-dev
RUN apt-get -y install libzzip-dev
RUN apt-get -y install libcurl4-gnutls-dev
RUN apt-get -y install libyajl-dev
RUN apt-get -y install libexpat-dev
RUN apt-get -y install libasound2-dev
RUN apt-get -y install libao-dev
RUN apt-get -y install libjack-jackd2-dev
RUN apt-get -y install libopenal-dev
RUN apt-get -y install libpulse-dev
RUN apt-get -y install libshout3-dev
RUN apt-get -y install libsndio-dev
RUN apt-get -y install libmpdclient-dev
RUN apt-get -y install libnfs-dev
RUN apt-get -y install libupnp-dev
RUN apt-get -y install libavahi-client-dev
RUN apt-get -y install libsqlite3-dev
RUN apt-get -y install libsystemd-dev
RUN apt-get -y install libgtest-dev
RUN apt-get -y install libboost-dev
RUN apt-get -y install libicu-dev
RUN apt-get -y install libchromaprint-dev
RUN apt-get -y install libgcrypt20-dev
RUN apt-get -y install git

RUN mkdir /source
WORKDIR /source
RUN git clone https://github.com/GioF71/MPD.git
WORKDIR /source/MPD
RUN meson . output/release --buildtype=debugoptimized -Db_ndebug=true
RUN meson configure output/release
RUN ninja -C output/release
