#!/bin/bash

#########Configure SLURM parameters##########
#SBATCH --ntasks=1
#SBATCH --partition=cpu
#SBATCH --cluster=bioinf
#########Configure SLURM parameters##########

if [ ! -z "$1" ]
then
    MAGS_NCBI_TAX=$1
fi
if [ ! -z "$2" ]
then
    OPT_DIR=$2
fi
if [ ! -z "$3" ]
then
    LOG_DIR=$3
fi

FCS_EXE="/vol/projects/khuang/tools/fcs/fcs.py"
FCS_DB="/vol/projects/khuang/databases/fcs_gs/fcs_gs_db"
PYTHON_EXE="/usr/bin/python"
export FCS_DEFAULT_IMAGE=/vol/projects/khuang/tools/fcs/fcs-gx.sif

while read line
do
   TAX_ID=$(cut -f 4 <<< $line)
   INPUT_GENOME=$(cut -f2 <<< $line)
   SUB_OPT_DIR=${OPT_DIR}/$(cut -f1 <<< $line).contam_screen_opt
   mkdir -p ${SUB_OPT_DIR}
   echo ${FCS_EXE} screen genome --fasta ${INPUT_GENOME} --out-dir ${SUB_OPT_DIR} --gx-db ${FCS_DB} --tax-id ${TAX_ID}
   ${FCS_EXE} screen genome --fasta ${INPUT_GENOME} --out-dir ${SUB_OPT_DIR} --gx-db ${FCS_DB} --tax-id ${TAX_ID}
   sleep 3
   FCS_GX_RPT=${SUB_OPT_DIR}/*fcs_gx_report.txt
   sed -i "s/FIX/SPLIT/g" ${FCS_GX_RPT}
   zcat ${INPUT_GENOME} | ${PYTHON_EXE} ${FCS_EXE} clean genome --action-report ${FCS_GX_RPT} --output ${SUB_OPT_DIR}/contam_clean_genome.fasta --contam-fasta-out ${SUB_OPT_DIR}/contam.fasta
done < <(tail -n +2 ${MAGS_NCBI_TAX})
