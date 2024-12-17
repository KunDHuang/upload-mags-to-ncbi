# upload-mags-to-ncbi
This repo is a demonstration for depositing MAGs (metagenome-assembled genomes) in NCBI.
Note: The whole tutorial is mainly for users on HZI slurm HPC infrastructure. For other users, certain degree of customization is needed.

## Table of Contents

1. [Submission preparation](#Preparation)
2. [MAG submission through NCBI portal](#Submission)



## Preparation

1. **Organize MAGs locally** 
   Move the target MAGs to a specified folder. For example, we put 22 HQ MAGs in the folder:
   `/vol/projects/khuang/repo_demo/upload-mags-to-ncbi/raw_mags`

   <div style="margin-top: 15px;"></div>

   ![raw_mags_layout](./images/raw_mags_layout.png)
   <div style="margin-bottom: 15px;"></div>
   
2. Screen adaptor with FCS tool

3. Assign NCBI taxonomy to each MAG

3. NCBI foreign contamination screening with FCS tool



## Submission

