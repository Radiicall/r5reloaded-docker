# R5Reloaded Docker
This runs R5Reloaded from a docker container, this makes setting up servers a bit easier

## Setup

### Install

1. Clone this directory `git clone https://github.com/Radiicall/r5reloaded-docker.git`
2. Grab a server zip file from the #announcements channel in the <a href="https://discord.gg/r5reloaded">R5Reloaded</a> server
3. Place server[.]zip in the cloned directory
4. Rename the server zip to `server.zip`
5. Run `docker build -t r5reloaded-server .` while still in the cloned directory

### Configuration

Inside the docker-compose file you'll see the environment variables, these can be changed to configure the server

### Running

Run the docker compose file `docker compose -p r5reloaded up -d`
