# upload-mags-to-ncbi
This repo is a demonstration for depositing MAGs (metagenome-assembled genomes) in NCBI.
Note: The whole tutorial is mainly for users on HZI slurm HPC infrastructure. For other users, certain degree of customization is needed.

## Table of Contents

1. [Submission preparation](#Preparation)
2. [MAG submission through NCBI portal](#Submission)



## Preparation

1. **Organize MAGs locally** <br> 
   Move the target MAGs to a specified folder. For example, we put 22 HQ MAGs in the folder:
   `/vol/projects/khuang/repo_demo/upload-mags-to-ncbi/raw_mags`

   <div style="margin-top: 15px;"></div>

   ![raw_mags_layout](./images/raw_mags_layout.png)
   <div style="margin-bottom: 15px;"></div>
   
2. Screen adaptor with FCS tool
   We implemented FCS [(Foreign Contamination Screening) pipeline](https://github.com/ncbi/fcs) in our wrap-up script `fcs_launcher.sh` to ensure MAG quality for NCBI submission. In this step, we are using `screen_adaptor` module of `fcs_launcher.sh`:
   ```bash
   Usage: fcs_launcher.sh screen_adaptor -mags_dir [mags_folder_abspath] -opt_dir [output_folder_abspath]
   Options:

   -mags_dir    STR        Specify the absolute path of the folder containing target MAGs.
   -opt_dir     STR        Specify the absolute path of the folder to hold outputs.
   -mem         INT        Specify the memory in need (default = 12, Gb)
   -cpu         INT        Specify the number CPUs to use for processing one sample (default = 5)
   -log_dir     STR        Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)
   -time        INT        Specify the walltime (default = 24, hours)

   --help | -h             Show this help page

   !NOTE!: All inputs (including files and directories) should be given with an absolute path!
   ```

   The running command:

   ```bash
   fcs_launcher.sh screen_adaptor \
                   -mags_dir /vol/projects/khuang/repo_demo/upload-mags-to-ncbi/raw_mags \
                   -opt_dir /vol/projects/khuang/repo_demo/upload-mags-to-ncbi/screen_adaptor_opt \
                   -mem 12 -cpu 4 \
                   -log_dir /vol/projects/khuang/repo_demo/upload-mags-to-ncbi/logs2
   ```
   
   As results, in the output directory you will find each input raw MAG corresponds to one sub-directory with suffix `adtr_screen_opt`. And the MAG with adaptors being screened and cleaned is saved in `adaptor_clean_genome.fasta`. The clean genome file will be further used in the step of screening and cleaning foreign contamination. 

   Let's have a look at what outputs you shall expect from `fcs_launcher.sh screen_adaptor` module:
   <div style="margin-top: 15px;"></div>

   ![screen_adaptor_output](./images/screen_adaptor_outputs.png)
   <div style="margin-bottom: 15px;"></div>

   Now we can create a new folder `adaptor_cleaned_mags`, and move and rename (using the names of raw MAGs) the adaptor-cleaned MAGs:

   <div style="margin-top: 15px;"></div>

   ![renamed_adaptor_cleaned_mags](./images/renamed_adaptor_cleaned_mags.png)
   <div style="margin-bottom: 15px;"></div>  

3. NCBI foreign contamination screening with FCS tool
   Our wrap-up script `fcs_launcher.sh` also provides a module to screen and clean foreign contamination, `fcs_launcher.sh screen_contamination`:

   ```bash
   Usage: fcs_launcher.sh screen_contamination -mags_ncbi_tax [mags_ncbi_taxonomy_file.tsv] -opt_dir [output_folder_abspath]
   Options:
   -mags_ncbi_tax    STR        Specify the absolute path of the file containing MAG ID, MAG location, NCBI taxonomy, and NCBI taxonomy ID.
   -opt_dir          STR        Specify the absolute path of the folder to hold outputs.
   -mem              INT        Specify the memory in need (default = 512, Gb)
   -cpu              INT        Specify the number CPUs to use for processing one sample (default = 20)
   -log_dir          STR        Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)
   -time             INT        Specify the walltime (default = 12, hours)

   --help | -h             Show this help page

   !NOTE!: All inputs (including files and directories) should be given with an absolute path!
   ```

   To execute this module, the lowest [NCBI taxonomy ID](https://www.ncbi.nlm.nih.gov/taxonomy) should be assigned to each target MAG. For example, we organized NCBI taxonomy ID for each of our demo MAG as [mags_ncbi_taxonomy.tsv](./demo_data/mags_ncbi_taxonomy.tsv). Note: the input MAGs in this step should come from the output of the previous step `screen_adaptor` which is saved in the folder `adaptor_cleaned_mags`.


   The running command:

   ```bash
   fcs_launcher.sh screen_contamination \
                   -mags_ncbi_tax /vol/projects/khuang/repo_demo/upload-mags-to-ncbi/mags_ncbi_taxonomy.tsv \
                   -opt_dir /vol/projects/khuang/repo_demo/upload-mags-to-ncbi/contamination_cleaned_mags \
                   -log_dir /vol/projects/khuang/repo_demo/upload-mags-to-ncbi/logs2
   ```


## Submission

