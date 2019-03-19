#!/bin/bash

# Load ASCII ART variables
. ./docker-hpc.asciiart

# Display the greeting message
printf "$HPC_AA"
sleep .5
printf "$SWARM_AA"
sleep .5
printf "$AUTHORS_AA"

sleep 1.8

NodeRole=$(docker node inspect --format '{{.Spec.Role}}' `hostname`)

if [[ $NodeRole != 'manager' ]];then
        echo -e "\e[91m===> This node must be a manager to use this script!..."
        exit 1
fi

SHARED_FOLDER=programs



# Include config variables if the file exists
if [ -f ./docker-hpc.conf ];then
    echo -e "\e[93m===> Importing Variables from docker-hpc.conf \e[0m"
    . ./docker-hpc.conf
else
        echo -e "\e[93m===> File docker-hpc.conf not found!"
        echo -e "===> Setting default parameters...\e[0m"
        alpine_mpich=(gianv9/docker-hpc:alpine-mpich-latest ./alpine-mpich/cluster alpine-mpich)
        ubuntu_openmpi=(gianv9/docker-hpc:ubuntu-openmpi-latest ./UbuntuOpenMPI ubuntu-openmpi)
        DEFAULT_PROJECT_LOCATION=${alpine_mpich[1]}
        IMAGE_NAME=${alpine_mpich[0]}
        STACK_TAG=${alpine_mpich[2]}
        REPLICAS=4
        CLUSTER_LOGIN_COMMAND='ssh -q -i ssh/id_rsa -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" -p 2222 mpiuser@172.17.0.1'
        # LOGIN=0
fi

if [ $# -eq 0 ];then
    echo -e "\e[93m===> No parameters specified"
    echo -e "===> Staring cluster using the default parameters...\e[0m"

#     echo -e "Default stack name 'docker-hpc'\e[0m"
    # set the environment variables so docker-compose and docker stack deploy can use them
    # REGISTRY_ADDR=$masterNodeIP
    # echo "Exiting now..."
    # exit 0
else
    while [ $# -gt 0 ]; do
        case "$1" in
            -l|--login)
                shift
                if test $# -gt 0; then
                        case $1 in
                        alpine-mpich)
                                cd ${alpine_mpich[1]}
                        ;;
                        ubuntu-openmpi)
                                cd ${ubuntu_openmpi[1]}
                        ;;
                        *)      
                                echo -e "\e[91m===> Unkown image $1!"
                                echo -e "\e[93m===> using default image alpine-mpich instead\e[0m"
                                break
                        ;;
                        esac
                else
                        echo -e "\e[91m===> -l|--login"
                        echo -e "===> No image specified"
                        echo -e "\e[93m===> Using default image $IMAGE_NAME instead\e[0m"
                        cd ${alpine_mpich[1]}
                        sleep .5
                fi
                # Make sure the key has the right permissions
                chmod 0600 ssh/id_rsa*
                eval $CLUSTER_LOGIN_COMMAND
                shift
                exit 0
                ;;
            -h|--help)
                echo "This is a script for Launching docker-hpc clusters"
                echo ""
                echo "Usage: "
                echo "docker-hpc [options] [parameters]"
                echo " "
                echo "options:"
                echo "-h  | --help                      Show this help message"
                echo "-wr | --worker-replicas number    Set the number of worker nodes replicas to be spawned"
                echo "-tg | --stack-tag name            Set the name of the stack to be deployed"
                echo "-d  | --down stack-tag            Remove a stack "
                exit 0
                ;;
            -i|--image)
                shift
                if test $# -gt 0; then
                        case $1 in
                        alpine-mpich)
                                IMAGE_NAME=${alpine_mpich[0]}
                                cd ${alpine_mpich[1]}
                                STACK_TAG=${alpine_mpich[2]}
                                CHANGED_DIRECTORY=1
                        ;;
                        ubuntu-openmpi)
                                IMAGE_NAME=${ubuntu_openmpi[0]}
                                cd ${ubuntu_openmpi[1]}
                                STACK_TAG=${ubuntu_openmpi[2]}
                                CHANGED_DIRECTORY=1
                        ;;
                        *)      
                                echo -e "\e[91m===> Unkown image $1!"
                                echo -e "\e[93m===> using default image alpine-mpich instead\e[0m"
                                break
                        ;;
                        esac
                else
                        echo -e "\e[91m===> -i|--image"
                        echo -e "===> No image specified"
                        echo -e "\e[93m===> Using default image $IMAGE_NAME instead\e[0m"
                        sleep .5
                        cd $DEFAULT_PROJECT_LOCATION
                fi
                # Make sure the key has the right permissions
                chmod 0600 ssh/id_rsa*
                shift
                ;;
            -n|--node-replicas)
                shift
                if test $# -gt 0; then
                        $REPLICAS=$1
                else
                        echo -e "\e[91m===> -wr|--worker-replicas"
                        echo -e "===> No parameter specified"
                        echo -e "\e[93m===> Using default, $REPLICAS replicas instead\e[0m"
                        sleep .5
                fi
                shift
                ;;
            -s|--stack-tag)
                shift
                if test $# -gt 0; then
                        $STACK_TAG=$1
                else
                        echo -e "\e[91m===>-st|--stack-tag"
                        echo -e "===> Stack Tag not Specified"
                        echo -e "\e[93m===> Setting the stack tag to docker-hpc\e[0m"
                        $STACK_TAG='docker-hpc'
                fi
                shift
                ;;
            -d|--down)
                shift
                if test $# -gt 0; then
                docker stack rm $1
                else
                        echo -e "\e[91m===> No stack name specified\e[0m"
                        echo -e "\e[93m===> Trying the default stack name\e[0m"
                        docker stack rm $STACK_TAG
                fi

                echo -e "\e[93m===> Removing The cluster network and nfs server\e[0m"
                case $1 in
                        alpine-mpich)
                                cd ${alpine_mpich[1]}
                        ;;
                        ubuntu-openmpi)
                                cd ${ubuntu_openmpi[1]}
                        ;;
                        *)      
                                echo -e "\e[91m===> Unkown image $1!"
                                echo -e "\e[93m===> using default image alpine-mpich instead\e[0m"
                                cd $DEFAULT_PROJECT_LOCATION
                                # break
                        ;;
                esac
                CHANGED_DIRECTORY=1
                # docker-compose -f nfs-server.yml down
                NodeID=$(docker node inspect --format '{{.ID}}' `hostname`)
                echo -e "\n\033[33;7m\e[1;32m===> Removing node ($NodeID) tag 'script_bearer=true'\e[0m"
                docker node update --label-rm script_bearer $NodeID
                shift
                exit 0
                ;;
            --np|--no-push)
                shift
                NO_PUSH=1
                shift
                ;;
            --nb|--no-build)
                shift
                NO_BUILD=1
                shift
                ;;
            *)
                shift
                echo -e "\e[91m===> Unknown option $1"
                echo -e "===> Exiting now\e[0m"
                shift
                exit 1
                ;;
        esac
    done
fi

if [[ CHANGED_DIRECTORY != 1 ]];then
        cd $DEFAULT_PROJECT_LOCATION
fi

SCRIPT_BEARER_IP=$(docker node inspect --format '{{.Status.Addr}}' `hostname`)
CURRENT_DIR=$(pwd)

# ok...the node is a manager...
# but how many nodes are there?
SWARM_SIZE=$(docker node ls -q|wc -l)
if [[ $SWARM_SIZE == 1 ]]; then
# if the swarm size is one, that means there is only one docker runtime to allocate the resources
# so it doesn't make any sense to sshfs to itself
# then we tell the workers to mount the same local volume as the master
# a local folder
# Option one modifies the interfaces...we won't use this for now...
# # ... docker-compose.yml
#         docker-compose -f docker-compose.yml up -d
        SHARED_FOLDER=./$SHARED_FOLDER
else
# otherwise we tell the workers to use the master node shared folder through the volume
# ... docker-swarm-stack.yml
        SHARED_FOLDER=sshfs
fi

# set the environment variables so docker-compose and docker stack deploy can use them
# export REGISTRY_ADDR=$SCRIPT_BEARER_IP
echo -e "\e[93m===> Environment variables:"
echo -e "IMAGE_NAME=$IMAGE_NAME\nSTACK_TAG=$STACK_TAG\nREPLICAS=$REPLICAS\nThe current dir is $CURRENT_DIR\nThis node ip is $SCRIPT_BEARER_IP\e[0m"
export IMAGE_NAME REPLICAS STACK_TAG CURRENT_DIR SCRIPT_BEARER_IP SHARED_FOLDER

# masterNodeIP=$(ip route get 1 | awk '{print $7;exit}')


NodeID=$(docker node inspect --format '{{.ID}}' `hostname`)
echo -e "\n\033[33;7m\e[1;32m===> Tagging node ($NodeID) as 'script_bearer=true' before deployment\e[0m"
docker node update --label-add script_bearer=true $NodeID
echo -e "\n\033[33;7m\e[1;32m===> Node tagged:\e[0m"
docker node inspect $NodeID -f '{{ .Spec.Labels }}'


# echo "master IP: $masterNodeIP"
# echo "master ID: $masterNodeID"

# NODE_IP=$masterNodeIP
# docker stack deploy --compose-file launch-registry.yml registry

# export NODE_IP=172.17.0.1
# docker-compose -f launch-registry.yml up -d

if [[ $NO_BUILD != 1 ]];then
        echo -e "\n\033[33;7m\e[1;32m===> Building image...\e[0m"
        docker-compose -f build-and-upload.yml build
fi

if [[ $NO_PUSH != 1 ]];then
        echo -e "\n\033[33;7m\e[1;32m===> Pushing image to the repository...\e[0m"
        docker-compose -f build-and-upload.yml push
fi


# docker stack deploy --compose-file network-and-nfs.yml network_and_nfs

printf  "$WHALES_TOP_AA $REPLICAS\t     |\n$WHALES_BOTTOM_AA"

# echo -e "\n\033[33;7m\e[1;32m===> Creating the network and the nfs server container...\e[0m"
# docker-compose -f nfs-server.yml up -d

# sudo mount -v 192.168.1.62:/ /opt/nfs/volumes/debug

echo -e "\n\033[33;7m\e[1;32m===> Waiting for previous cluster networks to die...\e[0m"
# docker network rm "$STACK_TAG"_default
while [[ $(docker network ls --format {{.Name}} -f name=ubuntu-openmpi_default) != "" ]]; do
printf "."
sleep 1
done

echo -e "\n\033[33;7m\e[1;32m===> Deploying the cluster stack $STACK_TAG with $REPLICAS workers...\e[0m"
docker stack deploy --compose-file docker-compose-swarm-stack.yml $STACK_TAG

echo -e "\n\033[33;7m\e[1;32m===> Waiting for the master node to spawn..."
echo -e "\e[93m===> Press CTRL-C if automatic login does not occur"
echo -e "\e[93m===> Then login by using 'docker-hpc.sh -l $STACK_TAG'\n\e[0m"
./wait-for-it.sh -t 0 172.17.0.1:2222 -- \
        echo -e "\n\033[33;7m\e[1;32m===> Cluster Master Node is Ready\n\e[0m" 2> /dev/null
eval $CLUSTER_LOGIN_COMMAND