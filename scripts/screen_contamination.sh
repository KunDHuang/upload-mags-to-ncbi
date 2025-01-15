###### This module is to launch a batch of MAGs to SLURM for contamination screening ######
############ Screening MAGs using FCS pipeline in a parallel manner #######################
###########################################################################################

help_page () {
    echo ""
    echo " Usage: fcs_launcher.sh screen_contamination -mags_ncbi_tax [mags_ncbi_taxonomy_file.tsv] -opt_dir [output_folder_abspath]"
    echo " Options:"
    echo ""
    echo " -mags_ncbi_tax    STR        Specify the absolute path of the file containing MAG ID, MAG location, NCBI taxonomy, and NCBI taxonomy ID."
    echo " -opt_dir          STR        Specify the absolute path of the folder to hold outputs."
    echo " -mem              INT        Specify the memory in need (default = 512, Gb)"
    echo " -cpu              INT        Specify the number CPUs to use for processing one sample (default = 20)"
    echo " -log_dir          STR        Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)"
    echo " -time             INT        Specify the walltime (default = 12, hours)"
    echo ""
    echo " --help | -h             Show this help page"
    echo ""
    echo " !NOTE!: All inputs (including files and directories) should be given with an absolute path!"
    echo "";
}

# set default parameters
cpu=4; mags_ncbi_tax="false"; opt_dir="false"; time=12; mem=512
log_dir="/vol/cluster-data/khuang/slurm_logs"
while true; do
    case "$1" in
        -mags_ncbi_tax) mags_ncbi_tax=$2; shift 2;;
        -opt_dir) opt_dir=$2; shift 2;;
        -mem) mem=$2; shift 2;;
        -cpu) cpu=$2; shift 2;;
        -log_dir) log_dir=$2; shift 2;;
        -time) time=$2; shift 2;;
        -h | --help) help_page; exit 1; shift 1;;
        --) help_page; exit 1; shift; break ;;
        *) break;;
    esac
done

# Examine required parameters are entered
if [ "$mags_ncbi_tax" = "false" ] || [ "$opt_dir" = "false" ]; then
    help_page
    echo "Error: inputs are missing in [mags_ncbi_tax] or [opt_dir]!"
    exit 1
fi

echo "logs will be saved in ${log_dir}..."
mkdir -p ${log_dir}

SLURM_FCS_CONTAMINATION=$(dirname "$0")/screen_contamination_2slurm.sh
SLURM_STDOUT="$log_dir"/%x_%j_%a.out
SLURM_STDERR="$log_dir"/%x_%j_%a.err
SLURM_JOBNAME="screen_contamination"

sbatch --array=1 --job-name=${SLURM_JOBNAME} \
       --cpus-per-task=${cpu} --mem=${mem}g --time=${time}:00:00 \
       --error=${SLURM_STDERR} --output=${SLURM_STDOUT} \
       ${SLURM_FCS_CONTAMINATION} ${mags_ncbi_tax} ${opt_dir} ${log_dir}
