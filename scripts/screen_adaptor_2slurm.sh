#!/bin/bash

#########Configure SLURM parameters##########
#SBATCH --ntasks=1
#SBATCH --partition=cpu
#SBATCH --cluster=bioinf
#########Configure SLURM parameters##########

if [ ! -z "$1" ]
then
    MAG_DIR=$1
fi
if [ ! -z "$2" ]
then
    OPT_DIR=$2
fi
if [ ! -z "$3" ]
then
    LOG_DIR=$3
fi

export TINI_SUBREAPER=1
FCS_EXE="/vol/projects/khuang/tools/fcs/run_fcsadaptor.sh"
FCS_SIF="/vol/projects/khuang/tools/fcs/fcs-adaptor.sif"

MAGS_ARRAY=($(find ${MAG_DIR} -type f))


INDEX=$((SLURM_ARRAY_TASK_ID - 1))
MAG_FILE=${MAGS_ARRAY[${INDEX}]}
MAG_SCREEN_OPT_DIR=${OPT_DIR}/$(basename ${MAG_FILE}).adtr_screen_opt
mkdir -p ${MAG_SCREEN_OPT_DIR}

echo ${FCS_EXE} --fasta-input ${MAG_FILE} --output-dir ${MAG_SCREEN_OPT_DIR} --prok --container-engine singularity --image ${FCS_SIF}

${FCS_EXE} --fasta-input ${MAG_FILE} --output-dir ${MAG_SCREEN_OPT_DIR} --prok --container-engine singularity --image ${FCS_SIF}



