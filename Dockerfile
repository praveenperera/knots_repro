############################################################
# Stage 1 – Build everything with Guix                     #
############################################################
FROM ubuntu:22.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive

USER root

# SYSTEM DEPS
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      netbase \
      guix \
      build-essential \
      curl \
      git \
      cpio \
      python3 \
      gnupg \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# BUILD ARGS
ARG KNOTS_TAG=v28.1.knots20250305    
ARG XCODE_XIP=Xcode_15.xip          

RUN groupadd --system guix && \
    useradd  --system --gid guix \
             --home-dir /home/guix \
             --create-home \
             --shell /bin/bash \
             guix

RUN mkdir -p /var/log/guix /gnu/store /var/guix \
    /home/guix  \
    /home/guix/.cache/guix/checkouts \
    /home/guix/.config/guix \
    /home/guix/.guix-profile \
    /home/guix/.cache/guix && \
    chown guix:guix /var/log/guix -R && \
    chown guix:guix /var/guix -R && \
    chown guix:guix /gnu/store -R && \
    chown guix:guix /home/guix -R

USER guix
ENV HOME=/home/guix

WORKDIR /home/guix
COPY --chown=guix:guix ${XCODE_XIP} /home/guix/

# apple‑sdk‑tools + cpio extractioprn
RUN git clone https://github.com/bitcoin-core/apple-sdk-tools && \
    python3 apple-sdk-tools/extract_xcode.py -f /home/guix/${XCODE_XIP} | cpio -d -i

############################################################
#      --- Clone Knots and prepare the SDK tar ---         #
############################################################
RUN git clone https://github.com/bitcoinknots/bitcoin knots && \
    cd knots && git checkout "${KNOTS_TAG}" && \
    /home/guix/knots/contrib/macdeploy/gen-sdk /home/guix/Xcode.app

# # Move & untar the generated “extracted‑SDK‑with‑libcxx‑headers.tar.gz”
RUN mkdir -p /home/guix/MacOS-SDKs && \
    mv /home/guix/knots/Xcode-*-extracted-SDK-with-libcxx-headers.tar.gz /home/guix/MacOS-SDKs && \
    tar -C /home/guix/MacOS-SDKs -xf /home/guix/MacOS-SDKs/*.tar.gz

# Clean up xcode stuff
RUN rm -rf /home/guix/Xcode.app && rm -rf /home/guix/Xcode_15.xip

# Setup env vars for guix build
RUN mkdir -p /home/guix/depends-SOURCES_PATH /home/guix/depends-BASE_CACHE
ENV SOURCES_PATH=/home/guix/depends-SOURCES_PATH
ENV BASE_CACHE=/home/guix/depends-BASE_CACHE
ENV SDK_PATH=/home/guix/MacOS-SDKs


RUN echo 'export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"' >> /home/guix/.profile && \
    echo 'export GUIX_PROFILE="$HOME/.config/guix/current"' >> /home/guix/.profile && \
    echo 'export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"' >> /home/guix/.bashrc && \
    echo 'export GUIX_PROFILE="$HOME/.config/guix/current"' >> /home/guix/.bashrc 

WORKDIR /home/guix/knots
COPY container_scripts/build.sh /home/guix/knots/build.sh
