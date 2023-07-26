# R5Reloaded Docker
This runs R5Reloaded from a docker container, this makes setting up servers a bit easier

## Setup

### Install

1. Clone this directory `git clone https://github.com/Radiicall/r5reloaded-docker.git`
2. Grab a server zip file from the #announcements channel in the <a href="https://discord.gg/r5reloaded">R5Reloaded</a> server
3. Grab Flowstate.-.Required.Files.zip from <a href="https://github.com/ColombianGuy/r5_flowstate/releases/latest">here</a>
4. Grab scripts from <a href="https://github.com/ColombianGuy/r5_flowstate/archive/refs/heads/r5_flowstate.zip">here</a>
5. Place all the files in the cloned directory
6. Rename the server zip to `server.zip`, rename Flowstate.-.Required.Files.zip to `flowstate.zip` and rename r5_flowstate.zip to `flowstate-scripts.zip`
7. Run `docker build -t r5reloaded-server -f Dockerfile` while still in the cloned directory

### Configuration

Inside the docker-compose file you'll see the environment variables, these can be changed to configure the server

### Running

Run the docker compose file `docker compose -p r5reloaded up -d`
