#!/bin/sh

# Display the greeting message
printf '
\e[1;33m     ___           ___         ___
\e[1;33m    /__/\         /  /\       /  /\
\e[1;33m    \  \:\       /  /::\     /  /:/     \e[1;32m                  ##\e[1;34m        .
\e[1;33m     \__\:\     /  /:/\:\   /  /:/      \e[1;32m            ## ## ##\e[1;34m       ==
\e[1;33m ___ /  /::\   /  /:/~/:/  /  /:/  ___  \e[1;32m         ## ## ## ##\e[1;34m      ===
\e[1;33m/__/\  /:/\:\ /__/:/ /:/  /__/:/  /  /\ \e[1;34m     /""""""""""""""""\___/ ===
\e[1;33m\  \:\/:/__\/ \  \:\/:/   \  \:\ /  /:/  \e[0m~~~\e[1;34m{\e[0m~~ ~~~~ ~~~ ~~~~ ~~ ~ \e[1;34m/  ===\e[0m-~
\e[1;33m \  \::/       \  \::/     \  \:\  /:/  \e[1;34m     \______ o          __/
\e[1;33m  \  \:\        \  \:\      \  \:\/:/   \e[1;34m       \    \        __/
\e[1;33m   \  \:\        \  \:\      \  \::/    \e[1;34m        \____\______/
\e[1;33m    \__\/         \__\/       \__\/'
sleep .5
# printf "\e[5m"
printf '\e[33m
     ___           ___           ___           ___           ___
    /  /\         /__/\         /  /\         /  /\         /__/\
   /  /:/_       _\_ \:\       /  /::\       /  /::\       |  |::\
  /  /:/ /\     /__/\ \:\     /  /:/\:\     /  /:/\:\      |  |:|:\
 /  /:/ /::\   _\_ \:\ \:\   /  /:/~/::\   /  /:/~/:/    __|__|:|\:\
/__/:/ /:/\:\ /__/\ \:\ \:\ /__/:/ /:/\:\ /__/:/ /:/___ /__/::::| \:\
\  \:\/:/~/:/ \  \:\ \:\/:/ \  \:\/:/__\/ \  \:\/:::::/ \  \:\~~\__\/
 \  \::/ /:/   \  \:\ \::/   \  \::/       \  \::/~~~~   \  \:\
  \__\/ /:/     \  \:\/:/     \  \:\        \  \:\        \  \:\
    /__/:/       \  \::/       \  \:\        \  \:\        \  \:\
    \__\/         \__\/         \__\/         \__\/         \__\/'
sleep .5
# echo -e "holiwis"
printf '
\033[33;7m\e[1;32m
                            Developed by:                            
                 Gianfranco Verrocchi & José Hernández               
\e[0m'

sleep 1.8

IMAGE_NAME=gianv9/docker-hpc:alpine-mpich-latest
STACK_TAG=docker-hpc

if [ $# -eq 0 ];then
    echo -e "\e[93m===>No parameters specified"
    echo -e "Staring cluster using the default parameters"
    echo -e "Default stack name 'docker-hpc'\e[0m"
    # set the environment variables so docker-compose and docker stack deploy can use them
    # REGISTRY_ADDR=$masterNodeIP
    REPLICAS=4
    # echo "Exiting now..."
    # exit 0
else
    while [ $# -gt 0 ]; do
        case "$1" in
            -l|--login)
                    LOGIN=1
                    break
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
            -wr|--worker-replicas)
                    shift
                    if test $# -gt 0; then
                            REPLICAS=$1
                            # exit 0
                    else
                            echo -e "\e[91m===> -wr|--worker-replicas"
                            echo -e "===> No parameter specified"
                            echo -e "===> Using default (4) instead\e[0m"
                            sleep .5
                            REPLICAS=4
                    fi
                    shift
                    ;;
            -tg|--stack-tag)
                    shift
                    if test $# -gt 0; then
                            STACK_TAG=$1
                    else
                            echo -e "\e[91m===>-st|--stack-tag"
                            echo -e "===> Stack Tag not Specified"
                            echo -e "===> Setting the stack tag to docker-hpc\e[0m"
                            STACK_TAG='docker-hpc'
                            # echo "no soundfile specified"
                            # exit 1
                    fi
                    shift
                    ;;
            -d|--down)
                    shift
                    if test $# -gt 0; then
                        docker stack rm network_and_nfs $1 
                        exit 0
                    else
                            echo -e "\e[91m===> No stack name specified\e[0m"
                            echo -e "\e[93m===> Trying the default stack name\e[0m"
                            docker stack rm network_and_nfs docker-hpc
                            # STACK_TAG='docker-hpc'
                            # echo "no soundfile specified"
                    fi
                    echo -e "\e[93m===> Removing The cluster network\e[0m"
                    docker-compose -f network-and-nfs.yml down
                    exit 0
                    shift
                    ;;
            *)
                    break
                    ;;
        esac
    done
fi



if [[ $LOGIN == 1 ]];then
    ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpi@172.17.0.1
    return 0
fi

# set the environment variables so docker-compose and docker stack deploy can use them
export REGISTRY_ADDR=$masterNodeIP IMAGE_NAME REPLICAS STACK_TAG

# masterNodeIP=$(docker node inspect --format '{{.Status.Addr}}' `hostname`)
# masterNodeIP=$(ip route get 1 | awk '{print $7;exit}')
# masterNodeID=$(docker node inspect --format '{{.ID}}' `hostname`)

# echo "master IP: $masterNodeIP"
# echo "master ID: $masterNodeID"

# NODE_IP=$masterNodeIP
# docker stack deploy --compose-file launch-registry.yml registry

# export NODE_IP=172.17.0.1
# docker-compose -f launch-registry.yml up -d


echo -e "\n\033[33;7m\e[1;32m===> Building image...\e[0m"

docker-compose -f upload-image-locally.yml build

echo -e "\n\033[33;7m\e[1;32m===> Pushing image to the repository...\e[0m"

docker-compose -f upload-image-locally.yml push

echo -e "\n\033[33;7m\e[1;32m===> Creatin the network and the nfs server container...\e[0m"

docker-compose -f network-and-nfs.yml up -d
# docker stack deploy --compose-file network-and-nfs.yml network_and_nfs

printf '
 --------------------------------------------------------------------
|                 ##        .                      ##        .       |
|           ## ## ##       ==                ## ## ##       ==       |
|        ## ## ## ##      ===             ## ## ## ##      ===       |
|    /""""""""""""""""\___/ ===       /""""""""""""""""\___/ ===     |
|~~~{~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===-~~~{~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===-~~|
|    \______ o          __/           \______ o          __/         |
|      \    \        __/                \    \        __/            |
|       \____\______/                    \____\______/               |
|        M A S T E R                      W O R K E R x ' && printf "$REPLICAS\t     |\n\
 --------------------------------------------------------------------\n"

echo -e "\n\033[33;7m\e[1;32m===> Deploying the cluster stack $STACK_TAG with $REPLICAS workers...\e[0m"

docker stack deploy --compose-file docker-compose.yml $STACK_TAG

echo -e "\n\033[33;7m\e[1;32m===>Waiting for The master to spawn...\n\e[0m"
./wait-for-it.sh -t 60 172.17.0.1:2222 -- ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpi@172.17.0.1 2> /dev/null