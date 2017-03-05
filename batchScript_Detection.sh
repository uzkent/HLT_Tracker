#!/bin/bash
# This is an example job file for a single core CPU bound program
# Note that all of the following statements below that begin
# with #SBATCH are actually commands to the SLURM scheduler.
# Please copy this file to your home directory and modify it
# to suit your needs.
#
# If you need any help, please email rc-help@rit.edu

# Name of the job - You'll probably want to customize this.
#SBATCH -J test_detection

# Standard out and Standard Error output files
#SBATCH -o test.output
#SBATCH -e error.output

#SBATCH --mail-user=bxu2522@rit.edu
# notify on state change: BEGIN, END, FAIL or ALL
#SBATCH --mail-type=ALL

# Request 5 minutes run time MAX, anything over will be KILLED
#SBATCH -t 0:1000:0

# Put the job in the "debug" partition and request one core
# "debug" is a limited partition.  You'll likely want to change
# it to "work" once you understand how this all works.
#SBATCH -p work -N 1 -n 1
#SBATCH --ntasks-per-node=12

# Job memory requirements in MB
#SBATCH --mem=90000

# Your job script goes below this line.
# cores=`echo $SLURM_NNODES*8 | bc`
# Create a local work directory
module load matlab
matlab -nodisplay -nosplash -nodesktop < MonteCarloRun_33.m
