FROM ubuntu:latest
LABEL org.opencontainers.image.authors="radical@radical.fun" version="1.1"

# Add new user

RUN useradd -m r5reloaded

# Install dependencies

RUN dpkg --add-architecture i386 && \
    apt update -y && \
    apt upgrade -y && \
    apt install software-properties-common wget unzip gnupg -y && \
    wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' && \
    apt update -y && \
    apt install winehq-stable -y

# Copy

# Server zip downloaded from announcements
COPY server.zip /home/r5reloaded
# https://github.com/ColombianGuy/r5_flowstate/archive/refs/heads/r5_flowstate.zip renamed to flowstate-scripts.zip
ADD https://github.com/ColombianGuy/r5_flowstate/archive/refs/heads/r5_flowstate.zip /home/r5reloaded/flowstate-scripts.zip
# https://github.com/ColombianGuy/r5_flowstate/releases/latest Flowstate.-.Required.Files.zip renamed to flowstate.zip
ADD https://github.com/ColombianGuy/r5_flowstate/releases/latest/download/FS4.1.-.Required.Files.zip /home/r5reloaded/flowstate.zip

RUN chown -R r5reloaded:r5reloaded /home/r5reloaded
# Swap to new user

USER r5reloaded

# Unzip files

RUN mkdir /home/r5reloaded/server
WORKDIR /home/r5reloaded/server
RUN unzip -o ../server.zip
RUN unzip -o ../flowstate-scripts.zip && \
    cp -r r5_flowstate-r5_flowstate/* platform/scripts
WORKDIR /home/r5reloaded/server
RUN unzip -o ../flowstate.zip

# Delete files

USER root
RUN rm -rf /home/r5reloaded/server.zip /home/r5reloaded/flowstate.zip /home/r5reloaded/flowstate-scripts.zip

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

