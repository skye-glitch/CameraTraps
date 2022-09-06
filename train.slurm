#!/bin/bash
#SBATCH -J mdv5Train           # Job name
#SBATCH -o logs/mdv5Train.o%j       # Name of stdout output file
#SBATCH -e logs/mdv5Train.e%j       # Name of stderr error file
#SBATCH -p rtx            # Queue (partition) name
#SBATCH -N 2               # Total # of nodes (must be 1 for serial)
#SBATCH -n 2
#SBATCH -t 47:30:00        # Run time (hh:mm:ss)
#SBATCH -A Deep-Learning-at-Sca       # Allocation name (req'd if you have more than 1)
#SBATCH --mail-type=all    # Send email at begin and end of job
#SBATCH --mail-user=sli@tacc.utexas.edu


NODEFILE=/tmp/hostfile
scontrol show hostnames  > $NODEFILE

eval "$(conda shell.bash hook)"
conda activate cameratraps-detector

GPU_PER_NODE=4

if [[ -z "${NODEFILE}" ]]; then
    RANKS=$NODEFILE
    NNODES=1
else
    MAIN_RANK=$(head -n 1 $NODEFILE)
    RANKS=$(tr '\n' ' ' < $NODEFILE)
    NNODES=$(< $NODEFILE wc -l)
fi

mpiexec.hydra -np $NNODES -ppn 1 /work2/07980/sli4/frontera/ICICLE/yolov5/train.sh  --ngpus $GPU_PER_NODE --nnodes $NNODES --master $MAIN_RANK


