#!/bin/bash
#SBATCH -n 3 # Number of cores
#SBATCH -N 2 # Ensure that all cores are on one machine
#SBATCH -t 0-00:05 # Runtime in D-HH:MM
#SBATCH -p pd # Partition to submit to
prun Send1
prun Dispose

