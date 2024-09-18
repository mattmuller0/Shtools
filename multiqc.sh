#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --mem=16G
#SBATCH -n 1
#SBATCH -p cpu_medium
#SBATCH --export=ALL
#SBATCH --time=600
#SBATCH --output="logs/multiqc-%A_%a.out"

# MODULES
module purge
module load python/cpu/3.6.5

# SCRIPTS
multiqc $1 -o $2 -n multiqc.html

# end of script