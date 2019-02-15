#!/bin/bash

docker stack deploy --compose-file docker-compose.yml Test
echo 'Please wait a couple of minutes until the cluster finishes configuring itself'
sleep 2m
echo 'Adding node IP addresses'
docker exec -it Test_mpi_head.1.$(docker service ps -f 'name=Test_mpi_head.1' Test_mpi_head -q --no-trunc | head -n1) sh -c "./get_hosts Test_mpi_node > /etc/openmpi/openmpi-default-hostfile"
sleep 10s
echo 'Cluster successfully configured'
