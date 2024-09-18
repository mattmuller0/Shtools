#!/bin/bash -l
 
#SBATCH -J fastp
#SBATCH --mem=25G
#SBATCH -n 8
#SBATCH -p cpu_medium
#SBATCH --array=1-217
#SBATCH --export=ALL
#SBATCH --time=600
#SBATCH --output="logs/kallisto-%A_%a.out"

#date
d1=$(date +%s)

# Modules
module purge
module load kallisto/0.46.2

echo $HOSTNAME
echo "SLURM_JOBID: " $SLURM_JOBID


### Indexing needed for Kallisto
# Set the path to the input files (replace with your actual path)
INPUT_PATH="data/chord_clean"

# Set the path to the output directory (replace with your actual path)
OUTPUT_PATH="output/kallisto/chord"
if [ ! -d ${OUTPUT_PATH} ]; then
    mkdir -p ${OUTPUT_PATH}
fi

# Replace 'transcriptome_index' with the actual path to your Kallisto index
TRANSCRIPTOME_INDEX="/gpfs/data/igorlab/ref/hg38/kallisto.idx"

# Get the sample ID from the array task ID
read1=`sed -n "${SLURM_ARRAY_TASK_ID}p" data/chord_sample_names.txt | cut -d' ' -f 1`
read2=`sed -n "${SLURM_ARRAY_TASK_ID}p" data/chord_sample_names.txt | cut -d' ' -f 2`
sample=`sed -n "${SLURM_ARRAY_TASK_ID}p" data/chord_sample_names.txt | cut -d' ' -f 3`
echo 'Mapping sample:' $sample

# Run Kallisto
kallisto quant -i ${TRANSCRIPTOME_INDEX} \
    -o ${OUTPUT_PATH}/${sample} \
    ${INPUT_PATH}/${read1}.fastq.gz \
    ${INPUT_PATH}/${read2}.fastq.gz

echo "Kallisto job for sample ${sample} completed hopefully well."

# RUN KALLISTO HERE
  
#date
d2=$(date +%s)
sec=$(( ( $d2 - $d1)))
hour=$(echo - | awk '{print '$sec'/3600}')
echo Runtime: $hour hours \($sec\s\)
