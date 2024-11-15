FROM ubuntu:jammy
LABEL org.opencontainers.image.authors="radical@radical.fun" version="1.1"

# Add new user

RUN useradd -m r5reloaded

# Install dependencies

RUN dpkg --add-architecture i386 && \
    apt update -y && \
    apt upgrade -y && \
    apt install software-properties-common wget p7zip gnupg -y && \
    wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' && \
    apt update -y && \
    apt install winehq-stable=8.0.2~jammy-1 wine-stable=8.0.2~jammy-1 wine-stable-amd64=8.0.2~jammy-1 wine-stable-i386=8.0.2~jammy-1 -y

# Copy

# Server zip downloaded from announcements
COPY server.7z /home/r5reloaded

RUN chown -R r5reloaded:r5reloaded /home/r5reloaded
# Swap to new user

USER r5reloaded

# Unzip files

RUN mkdir /home/r5reloaded/server
WORKDIR /home/r5reloaded/server
RUN 7z x ../server.7z

# Delete files

USER root
RUN rm -rf /home/r5reloaded/server.7z

# Remove apt packages

RUN apt purge software-properties-common wget unzip gnupg -y \
    && apt autoremove -y \
    && rm -rf {/var/lib/apt/lists/*, /var/cache/apt/archives/*}
USER r5reloaded

# Expose ports

EXPOSE 37000/udp

# Define environment

ENV ARGS=""
ENV NAME="An R5Reloaded Server"
ENV PLAYLIST="fs_dm"
ENV WINEDEBUG="-all"
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win64
ENV WINEPREFIX=/home/r5reloaded/server/wineprefix
ENV HOME=/home/r5reloaded

ENTRYPOINT wine r5apex_ds.exe -port 37000 +launchplaylist "${PLAYLIST}" +hostname "${NAME}" ${ARGS}

