FROM ubuntu:jammy
LABEL org.opencontainers.image.authors="radical@radical.fun" version="2.0"

# Add new user

RUN useradd -m r5reloaded

# Copy

COPY --chown=r5reloaded:r5reloaded ./server/ ./winehq.key /home/r5reloaded/server/

# Install dependencies

RUN dpkg --add-architecture i386 && \
    apt update -y && \
    apt upgrade -y && \
    apt install software-properties-common gnupg -y && \
    cat /home/r5reloaded/server/winehq.key | apt-key add - && \
    apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' && \
    apt update -y && \
    apt install winehq-stable wine-stable wine-stable-amd64 wine-stable-i386 -y && \
    apt purge software-properties-common gnupg -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /home/r5reloaded/server/winehq.key

# Swap to new user

USER r5reloaded

WORKDIR /home/r5reloaded/server

# Expose ports

EXPOSE 37000/udp

# Define environment

ENV ARGS="" \
    NAME="An R5Reloaded Server" \
    PLAYLIST="fs_dm" \
    WINEDEBUG="-all" \
    DEBIAN_FRONTEND=noninteractive \
    WINEARCH=win64 \
    WINEPREFIX=/home/r5reloaded/server/wineprefix \
    HOME=/home/r5reloaded \
    PORT=37000

ENTRYPOINT wine r5apex_ds.exe -noconsole -port ${PORT} +launchplaylist "${PLAYLIST}" +hostname "${NAME}" ${ARGS}

