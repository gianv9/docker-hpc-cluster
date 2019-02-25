#!/bin/bash
#SBATCH -n 9 # Number of cores
#SBATCH -N 5 # Ensure that all cores are on one machine
#SBATCH -t 0-00:05 # Runtime in D-HH:MM
#SBATCH -p pd # Partition to submit to
prun Send3
prun Dispose

