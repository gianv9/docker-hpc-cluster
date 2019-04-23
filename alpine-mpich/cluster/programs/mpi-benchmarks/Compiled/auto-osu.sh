#!/bin/bash

# This script receives exactly one parameter: 
# a path to a folder containing the compiled osu-micro-benchmarks.
# That folder should contain:
#     collective
#     one-sided
#     pt2pt
#     results
#     startup

if [[ $# != 1 ]]; then
    echo -e "You must provide exactly ONE argument (a folder name)\nexiting now..."
    exit 1
fi

if [ ! -d ./$1 ]; then
    echo -e "Directory ./$1 doesn't exist!\nexiting now..."
    # exit 1
fi

mkdir results

cd $1
for j in $(ls)
do
    # Ignore the results folder and the executable
    # if [[ $j == "results" || $j == "auto-osu.sh" ]]; then
    #     continue
    # fi
    echo "---> $j tests"
    echo "======================================"
    sleep 2
    cd $j
    file="$j"_results
    # detect p2p tests (two nodes needed)
    if [[ $j == "one-sided" || $j == "pt2pt" ]]; then
        args="-np 2"
    fi
    for i in $(ls)
    do
        echo "Running test: $i" | tee -a ../../results/$file
        echo "--------------------------------"| tee -a ../../results/$file
        echo "mpirun $args ./$i | tee -a ../../results/$file"
        mpirun $args ./$i | tee -a ../../results/$file
        echo -e "--------------------------------\n--------------------------------\n\n" | tee -a ../../results/$file
    done
    cd ../
    echo -e "\n======================================\n======================================\n\n"
done