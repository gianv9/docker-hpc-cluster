#!/bin/sh

# masterNodeIP=$(docker node inspect --format '{{.Status.Addr}}' `hostname`)
# masterNodeIP=$(ip route get 1 | awk '{print $7;exit}')
# masterNodeID=$(docker node inspect --format '{{.ID}}' `hostname`)

# echo "master IP: $masterNodeIP"
# echo "master ID: $masterNodeID"

# NODE_IP=$masterNodeIP
# docker stack deploy --compose-file launch-registry.yml registry

# export NODE_IP=172.17.0.1
# docker-compose -f launch-registry.yml up -d

docker-compose -f upload-image-locally.yml build

docker-compose -f upload-image-locally.yml push

export REGISTRY_ADDR=$masterNodeIP
export IMAGE_NAME=gianv9/docker-hpc:alpine-mpich-latest
export REPLICAS=$1

docker stack deploy --compose-file docker-compose.yml test

echo "Waiting for The master to spawn..."
./wait-for-it.sh 172.17.0.1:2222 -- ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpi@172.17.0.1