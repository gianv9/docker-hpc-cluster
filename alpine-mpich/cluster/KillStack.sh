#!/bin/sh

docker stack rm alpine-mpich network_and_nfs

docker-compose -f network-and-nfs.yml down

# docker-compose -f launch-registry.yml down