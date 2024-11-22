#!/bin/bash -l
 
#SBATCH -J fastp
#SBATCH --mem=25G
#SBATCH -n 8
#SBATCH -p cpu_medium
#SBATCH --array=1-217
#SBATCH --export=ALL
#SBATCH --time=600
#SBATCH --output="logs/fastp-%A_%a.out"

#date
d1=$(date +%s)

# Modules
module purge
module load fastp/0.22.0
module load python/cpu/3.6.5

#### CODE BELOW ####
echo 'HOSTNAME:' $HOSTNAME

path='/gpfs/data/bergerlab/Platelets_mouse_human_mix_May2023'

# set up for paired end
read1=`sed -n "${SLURM_ARRAY_TASK_ID}p" data/sample_names.txt | cut -d' ' -f 1`
read2=`sed -n "${SLURM_ARRAY_TASK_ID}p" data/sample_names.txt | cut -d' ' -f 2`
sample=`sed -n "${SLURM_ARRAY_TASK_ID}p" data/sample_names.txt | cut -d' ' -f 3`
echo 'Mapping sample:' $sample

input1=$path/data/raw_data/$read1.fastq.gz
input2=$path/data/raw_data/$read2.fastq.gz
output1=data/clean/$read1.fastq.gz
output2=data/clean/$read2.fastq.gz

echo 'Running fastp on sample:' $input
fastp -w 8 -i $input1 -I $input2 -o $output1 -O $output2 -h data/clean/$sample.fastp.html -j data/clean/$sample.fastp.json


#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1)))
hour=$(echo - | awk '{print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)