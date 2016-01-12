#FROM gliderlabs/alpine
FROM alpine:latest
MAINTAINER Core Services <coreservices@namely.com>

# Install Protoc
################
RUN set -ex \
	&& apk --update --no-cache add --virtual .pb-build \
  make \
	cmake \
  autoconf \
  automake \
  curl \
  tar \
  libtool \
	g++ \
  \
	&& mkdir -p /mnt/protobufs \
	&& cd /mnt/protobufs \
	&& curl -o protobufs.tar.gz -L https://github.com/google/protobuf/releases/download/v3.0.0-beta-2/protobuf-cpp-3.0.0-beta-2.tar.gz \
	&& mkdir -p protobuf \
	&& tar -zxvf protobufs.tar.gz -C /mnt/protobufs/protobuf --strip-components=1 \
	&& cd protobuf \
	&& ./autogen.sh \
	&& ./configure \
	&& make \
	&& make install \
  && cd \
	&& rm -rf /mnt/protobufs/ \
	&& apk --no-cache add libstdc++ \
	&& apk del .pb-build \
  && rm -rf /usr/local/include \
	&& rm -rf /var/cache/apk/* \
	&& mkdir /defs

# Setup directories for the volumes that should be used
WORKDIR /defs
