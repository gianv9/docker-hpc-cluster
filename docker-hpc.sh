#!/bin/bash

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
                #     LOGIN=1
                # if [[ CHANGED_DIRECTORY == 1 ]];then

                # else
                #         cd $DEFAULT_PROJECT_LOCATION
                # fi
                # ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpiuser@172.17.0.1
                # exit 0
                #     break
                shift
                if test $# -gt 0; then
                #     REPLICAS=$1
                        # exit 0
                        case $1 in
                        alpine_mpich)
                                # IMAGE_NAME=${alpine_mpich[0]}
                                cd ${alpine_mpich[1]}
                                # CHANGED_DIRECTORY=1
                                # STACK_TAG=${alpine_mpich[2]}
                        ;;
                        ubuntu_openmpi)
                                # IMAGE_NAME=${ubuntu_openmpi[0]}
                                cd ${ubuntu_openmpi[1]}
                                # CHANGED_DIRECTORY=1
                                # STACK_TAG=${ubuntu_openmpi[2]}
                        ;;
                        *)      
                                echo -e "\e[91m===> Unkown image $1!"
                                echo -e "\e[93m===> using default image alpine_mpich instead\e[0m"
                                break
                                # exit 0
                        ;;
                        esac
                else
                        echo -e "\e[91m===> -l|--login"
                        echo -e "===> No image specified"
                        echo -e "\e[93m===> Using default image $IMAGE_NAME instead\e[0m"
                        cd ${alpine_mpich[1]}
                        sleep .5
                #     REPLICAS=4
                fi
                # Make sure the key has the right permissions
                chmod 0600 ssh/id_rsa*
                ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpiuser@172.17.0.1
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
                #     REPLICAS=$1
                        # exit 0
                        case $1 in
                        alpine_mpich)
                                IMAGE_NAME=${alpine_mpich[0]}
                                cd ${alpine_mpich[1]}
                                CHANGED_DIRECTORY=1
                                STACK_TAG=${alpine_mpich[2]}
                        ;;
                        ubuntu_openmpi)
                                IMAGE_NAME=${ubuntu_openmpi[0]}
                                cd ${ubuntu_openmpi[1]}
                                CHANGED_DIRECTORY=1
                                STACK_TAG=${ubuntu_openmpi[2]}
                        ;;
                        *)      
                                echo -e "\e[91m===> Unkown image $1!"
                                echo -e "\e[93m===> using default image alpine_mpich instead\e[0m"
                                break
                        ;;
                        esac
                else
                        echo -e "\e[91m===> -i|--image"
                        echo -e "===> No image specified"
                        echo -e "\e[93m===> Using default image $IMAGE_NAME instead\e[0m"
                        sleep .5
                #     REPLICAS=4
                fi
                shift
                ;;
            -n|--node-replicas)
                shift
                if test $# -gt 0; then
                        $REPLICAS=$1
                        # exit 0
                else
                        echo -e "\e[91m===> -wr|--worker-replicas"
                        echo -e "===> No parameter specified"
                        echo -e "\e[93m===> Using default, $REPLICAS replicas instead\e[0m"
                        sleep .5
                #     REPLICAS=4
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
                        # echo "no soundfile specified"
                        # exit 1
                fi
                shift
                ;;
            -d|--down)
                shift
                if test $# -gt 0; then
                # cd $DEFAULT_PROJECT_LOCATION
                docker stack rm $1 
                # exit 0
                else
                        echo -e "\e[91m===> No stack name specified\e[0m"
                        echo -e "\e[93m===> Trying the default stack name\e[0m"
                        docker stack rm $STACK_TAG
                        # STACK_TAG='docker-hpc'
                        # echo "no soundfile specified"
                fi
                # echo -e "\e[93m===> Removing The cluster network\e[0m"
                # docker-compose -f network-and-nfs.yml down
                shift
                exit 0
                ;;
            --np|--no-push)
                shift
                #     LOGIN=1
                # ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpiuser@172.17.0.1
                # return 0
                #     break
                NO_PUSH=1
                shift
                ;;
            --nb|--no-build)
                shift
                #     LOGIN=1
                # ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpiuser@172.17.0.1
                # return 0
                #     break
                NO_BUILD=1
                shift
                ;;
            *)
                shift
                # echo -e "\e[91m===>-st|--stack-tag"
                echo -e "\e[91m===> Unknown option $1"
                echo -e "===> Exiting now\e[0m"
                shift
                exit 1
                ;;
        esac
    done
fi



if [[ $CHANGED_DIRECTORY != 1 ]];then
        cd $DEFAULT_PROJECT_LOCATION
fi

# set the environment variables so docker-compose and docker stack deploy can use them
# export REGISTRY_ADDR=$masterNodeIP
echo -e "\e[93m===> Environment variables:"
echo -e "IMAGE_NAME=$IMAGE_NAME\nSTACK_TAG=$STACK_TAG\nREPLICAS=$REPLICAS\nThe current dir is $(pwd)\e[0m"
export IMAGE_NAME REPLICAS STACK_TAG

# masterNodeIP=$(docker node inspect --format '{{.Status.Addr}}' `hostname`)
# masterNodeIP=$(ip route get 1 | awk '{print $7;exit}')
# masterNodeID=$(docker node inspect --format '{{.ID}}' `hostname`)

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

echo -e "\n\033[33;7m\e[1;32m===> Creating the network and the nfs server container...\e[0m"

# docker-compose -f network-and-nfs.yml up -d
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

echo -e "\n\033[33;7m\e[1;32m===>Waiting for The master to spawn..."
echo -e "\e[93m===> Press CTRL-C if automatic login does not occur"
echo -e "\e[93m===> Then login by using 'docker-hpc.sh -l $STACK_TAG'\n\e[0m"
./wait-for-it.sh -t 120 172.17.0.1:2222 -- 'ssh -i ssh/id_rsa -o "StrictHostKeyChecking no" -p 2222 mpiuser@172.17.0.1' 2> /dev/null