# Built with arch: amd64 flavor: lxde image: ubuntu:20.04
#
# Modified from https://github.com/fcwu/docker-ubuntu-vnc-desktop/blob/develop/Dockerfile.amd64
################################################################################
# base system
################################################################################

FROM ubuntu:jammy-20221101 as system
LABEL maintainer="admin@bowenwen.com"

RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

# built-in packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
    && apt install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    supervisor sudo net-tools zenity xz-utils \
    dbus-x11 x11-utils alsa-utils \
    mesa-utils libgl1-mesa-dri \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# install tools
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    xvfb x11vnc \
    vim-tiny nano git bzip2 gpg-agent\
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# install lxde
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# additional packages
RUN apt update \
    && add-apt-repository ppa:libreoffice/ppa \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    dolphin vlc libreoffice \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# docker requirements
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated ca-certificates curl gnupg lsb-release \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# docker engine
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated docker-ce docker-ce-cli containerd.io docker-compose-plugin \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# tini to fix subreap
ARG TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# ffmpeg
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /usr/local/ffmpeg \
    && ln -s /usr/bin/ffmpeg /usr/local/ffmpeg/ffmpeg

# vs code
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    wget gpg \
    && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' \
    && rm -f packages.microsoft.gpg \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated apt-transport-https \
    && apt install -y --no-install-recommends --allow-unauthenticated code \
    && rm -rf /var/lib/apt/lists/*

# set up firefox
RUN wget -O /tmp/firefox-108.0.1.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/108.0.1/linux-x86_64/en-CA/firefox-108.0.1.tar.bz2" \
    && tar -xvf /tmp/firefox-108.0.1.tar.bz2 \
    && mv firefox /opt \
    && ln -s /opt/firefox/firefox /usr/local/bin/firefox \
    && wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications

# prepare directory
COPY rootfs /

# fix permissions
RUN chmod +x /startup.sh && \
    chmod +x /usr/local/bin/xvfb.sh

WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash

ENTRYPOINT ["/startup.sh"]