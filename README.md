# Ubuntu Desktop on Docker

This is a docker image that has vs code, docker, and firefox built in to help developers to quickly jump into a virtualized linux environment to code, test, and even deploy docker containers.

This set up is for people who want to spin up a VM-like environment on a server, and keep changes to host system to a minimum when testing code on docker.


## Getting started

1. Clone and build 

```
git clone https://github.com/bowenwen/ubuntu-desktop.git
cd ubuntu-desktop
git pull
docker build -t ubuntu-desktop:latest .
```

2. Start the container

```
docker container run -p 5900:5900 ubuntu-desktop:latest -d
```

Note that -p forward port from the container to host such that `-p [host_port]:[container_port]`; `-d` runs the container in dettached mode, so updates are not captured in your terminal. You may use `-v [/host/volume/location]:[/container/storage]` to specify volume mounting if you wish to persist any files within your container to your host so you don't lose any changes when you remove your containers.

3. Optional: add a cron task

Open terminal, then edit the cron task (password required for root)

```
sudo crontab -e
```

Enter the following as a example of checking if docker container has became unhealthy, if so, restart the entire compose stack (see `docker.autoheal.sh` script included in rootfs folder for more information):

```
5 * * * * /usr/local/bin/docker.autoheal.sh
```

Congratulations, you have a VM inside your computer that you can schedule tasks, install applications, and run commands, without it affecting your host machine.


## Disclaimer

This image set up uses the approach that installs docker binaries and daemon inside a container. To start the docker service inside a docker container, the container must have privileged access.

Docker in docker is not perfect, and can result in system instability. For most simple testing and set up, this image should work. But there are limitations where it's more advisable to simply use a regular docker installation. Read more about some of the caveats here: https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
