# Ubuntu Desktop on Docker

This is a docker image that has vs code, docker, and firefox built in to help developers to quickly jump into a virtualized linux environment to code, test, and even deploy docker containers.

This set up is for people who want to spin up a VM-like environment on a server, and keep changes to host system to a minimum when testing code on docker.

## Set up

This image set up uses the approach that installs docker binaries and daemon inside a container. To start the docker service inside a docker container, the container must have privileged access.

Docker in docker is not perfect, and can result in system instability. For most simple testing and set up, this image should work. But there are limitations where it's more advisable to simply use a regular docker installation. Read more about some of the caveats here: https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
