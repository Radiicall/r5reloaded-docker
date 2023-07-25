FROM nvidia/cuda:12.2.0-runtime-rockylinux9
LABEL org.opencontainers.image.authors="radical@radical.fun" version="1.0"

# Copy

# Server zip downloaded from announcements
COPY server.zip /root/
# https://github.com/ColombianGuy/r5_flowstate/archive/refs/heads/r5_flowstate.zip renamed to flowstate-scripts.zip
COPY flowstate-scripts.zip /root/
# https://github.com/ColombianGuy/r5_flowstate/releases/latest Flowstate.-.Required.Files.zip renamed to flowstate.zip
COPY flowstate.zip /root/

# Install dependencies

RUN dnf install epel-release unzip -y
RUN dnf install wine -y

# Unzip files

RUN mkdir /root/server
WORKDIR /root/server
RUN unzip -o ../server.zip && unzip -o ../flowstate.zip
WORKDIR /root/server/platform/scripts
RUN unzip -o ../../../flowstate-scripts.zip
WORKDIR /root/server

# Expose ports

EXPOSE 37000

# Define environment

ENV ARGS=""
ENV NAME="An R5Reloaded Server"
ENV PLAYLIST="custom_tdm"

ENTRYPOINT wine r5apex_ds.exe -port 37000 -launchplaylist ${PLAYLIST}  -hostname ${NAME} ${ARGS}

