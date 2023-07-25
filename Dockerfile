FROM ubuntu:latest
LABEL org.opencontainers.image.authors="radical@radical.fun" version="1.0"

# Add new user

RUN useradd -m r5reloaded

# Copy

# Server zip downloaded from announcements
COPY server.zip /home/r5reloaded
# https://github.com/ColombianGuy/r5_flowstate/archive/refs/heads/r5_flowstate.zip renamed to flowstate-scripts.zip
COPY flowstate-scripts.zip /home/r5reloaded
# https://github.com/ColombianGuy/r5_flowstate/releases/latest Flowstate.-.Required.Files.zip renamed to flowstate.zip
COPY flowstate.zip /home/r5reloaded

# Install dependencies

RUN dpkg --add-architecture i386 && \
    apt update -y && \
    apt upgrade -y && \
    apt install software-properties-common wget unzip gnupg -y && \
    wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' && \
    apt update -y && \
    apt install winehq-stable -y

# Swap to new user

USER r5reloaded

# Unzip files

RUN mkdir /home/r5reloaded/server
WORKDIR /home/r5reloaded/server
RUN unzip -o ../server.zip && unzip -o ../flowstate.zip
WORKDIR /home/r5reloaded/server/platform/scripts
RUN unzip -o ../../../flowstate-scripts.zip
WORKDIR /home/r5reloaded/server

# Expose ports

EXPOSE 37000/UDP

# Define environment

ENV ARGS=""
ENV NAME="An R5Reloaded Server"
ENV PLAYLIST="custom_tdm"
ENV WINEDEBUG="-all"
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win64
ENV WINEPREFIX=/home/r5reloaded/server/wineprefix
ENV HOME=/home/r5reloaded

ENTRYPOINT wine r5apex_ds.exe -port 37000 -launchplaylist ${PLAYLIST} +hostname ${NAME} ${ARGS}

