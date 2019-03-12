#!/bin/sh
export STACK_TAG=docker-hpc
export REPLICAS=4
export IMAGE_NAME=gianv9/docker-hpc:ubuntu-openmpi-latest
docker stack deploy --compose-file docker-compose.yml $STACK_TAG
echo 'Please wait a couple of minutes until the cluster finishes configuring itself'
sleep 30
echo 'Adding node IP addresses'
# ./wait-for-it.sh 172.17.0.1:$( source echo_head_port.sh ) -- ssh -i ssh/id_rsa.mpi -p $( source echo_head_port.sh ) root@172.17.0.1 'sh -c "./get_hosts Test_mpi_node > /etc/openmpi/openmpi-default-hostfile"'
./wait-for-it.sh 172.17.0.1:$( source echo_head_port.sh ) -- docker exec -it Test_mpi_head.1.$(docker service ps -f 'name=Test_mpi_head.1' Test_mpi_head -q --no-trunc | head -n1) sh -c "./get_hosts Test_mpi_node > /etc/openmpi/openmpi-default-hostfile"
# sleep 10s
echo 'Cluster successfully configured'
echo 'Logging in'
sleep 5s
chmod 0600 ssh/id_rs*
ssh -i ssh/id_rsa.mpi -p $( source echo_head_port.sh ) mpiuser@172.17.0.1
