#!/usr/bin/env bash

##########################################################################################
#############Master script of launching FCS modules to SLURM HPC clusters#################
##########################################################################################

VERSION="1.0.0"

FCS_SCRIPTS_DIR="/vol/projects/khuang/repos/upload-mags-to-ncbi/scripts"

help_page () {
    echo ""
    echo "Pipeline version: v=$VERSION"
    echo "Usage: fcs_launcher.sh [module]"
    echo ""
    echo " Modules:"
    echo " screen_adaptor          Screen the genome for adaptors"
    echo " clean_adaptor           Clean adaptors detected in the genome"
    echo " screen_contamination    Screen the genome for contamination"
    echo " clean_contamination     Clean contaminations detected in the genome"
    echo ""
    echo " --help | -h            Show this help page"
    echo "";}

##########################################################################################
########################Read command arguments and run modules############################
##########################################################################################

if [ "$1" = screen_adaptor ]; then
    echo fcs_launcher.sh screen_adaptor ${@:2}
    ${FCS_SCRIPTS_DIR}/screen_adaptor.sh ${@:2}
elif [ "$1" = clean_adaptor ]; then
    echo fcs_launcher.sh clean_adaptor ${@:2}
    # ${FCS_SCRIPTS_DIR}/fcs_launcher.sh ${@:2}
elif [ "$1" = screen_contamination ]; then
    echo fcs_launcher.sh screen_contamination ${@:2}
    # ${FCS_SCRIPTS_DIR}/fcs_launcher.sh ${@:2}
elif [ "$1" = clean_contamination ]; then
    echo fcs_launcher.sh clean_contamination ${@:2}
    # ${FCS_SCRIPTS_DIR}/fcs_launcher.sh ${@:2}
elif [ "$1" = "-h"] || [ "$1" == "--help" ]; then
    help_page
else
    help_page
    echo "Please choose a right module!"
    exit 1
fi

##########################################################################################
######################################### END ############################################
##########################################################################################

