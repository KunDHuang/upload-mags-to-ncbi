#!/bin/bash

##########Configure SLURM parameters##########
#SBATCH --ntasks=1
#SBATCH --partition=cpu
#SBATCH --cluster=bioinf
##########Configure SLURM parameters##########

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


FCS_EXE="/vol/projects/khuang/tools/fcs/run_fcsadaptor.sh"
FCS_SIF="/vol/projects/khuang/tools/fcs/fcs-adaptor.sif"

MAGS_ARRAY=()
# Populate the array with the absolute paths of files
for MAG in "$MAG_FOLDER"/*; do
  if [[ -e "$MAG" ]]; then  # Check if the file exists
    MAGS_ARRAY+=("$(readlink -f "$MAG")")
  fi
done

MAG_FILE=${MAGS_ARRAY[$SLURM_ARRAY_TASK_ID]}
MAG_SCREEN_OPT_DIR=${OPT_DIR}/$(basename ${MAG_FILE}).adtr_screen_opt
mkdir -p ${MAG_SCREEN_OPT_DIR}

echo ${FCS_EXE} --fasta-input ${MAG_FILE} --output_dir ${OPT_DIR}/${MAG_SCREEN_OPT_DIR} --prok --container-engine singularity --image ${FCS_SIF}


exec > ${LOG_DIR}/"screen_adaptor_${MAG_FILE}.output" 2> "screen_adaptor_${MAG_FILE}.error"




