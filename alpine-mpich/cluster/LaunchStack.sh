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

export REGISTRY_ADDR=$masterNodeIP IMAGE_NAME=gianv9/docker-hpc:alpine-mpich-latest REPLICAS=$1

echo "===> Building image..."

docker-compose -f upload-image-locally.yml build

echo "===> Pushing image to the repository..."

docker-compose -f upload-image-locally.yml push

echo "===> Creatin the network and the nfs server container..."

docker-compose -f network-and-nfs.yml up -d
# docker stack deploy --compose-file network-and-nfs.yml network_and_nfs

echo "===> Deploying the cluster stack with $REPLICAS workers..."

docker stack deploy --compose-file docker-compose.yml alpine-mpich

echo "Waiting for The master to spawn..."
./wait-for-it.sh -t 60 172.17.0.1:2222 -- ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpi@172.17.0.1