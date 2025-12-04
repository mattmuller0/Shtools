#!/bin/bash -l

#SBATCH -J kallisto
#SBATCH --mem=25G
#SBATCH -n 8
#SBATCH -p cpu_medium
#SBATCH --array=1-217
#SBATCH --export=ALL
#SBATCH --time=600
#SBATCH --output="logs/kallisto-%A_%a.out"

set -e  # Exit on error

##############################################
# CONFIGURATION - Edit these for your project
##############################################
INPUT_PATH="data/chord_clean"
OUTPUT_PATH="output/kallisto/chord"
SAMPLE_FILE="data/chord_sample_names.txt"
TRANSCRIPTOME_INDEX="/gpfs/data/igorlab/ref/hg38/kallisto.idx"
##############################################

# Start timing
d1=$(date +%s)

# Modules
module purge
module load kallisto/0.46.2

echo "HOSTNAME: $HOSTNAME"
echo "SLURM_JOBID: $SLURM_JOBID"

# Create output directory if it doesn't exist
mkdir -p "${OUTPUT_PATH}"

# Validate sample file exists
if [[ ! -f "${SAMPLE_FILE}" ]]; then
    echo "Error: Sample file not found: ${SAMPLE_FILE}" >&2
    exit 1
fi

# Validate transcriptome index exists
if [[ ! -f "${TRANSCRIPTOME_INDEX}" ]]; then
    echo "Error: Transcriptome index not found: ${TRANSCRIPTOME_INDEX}" >&2
    exit 1
fi

# Get the sample ID from the array task ID
read1=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_FILE}" | cut -d' ' -f 1)
read2=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_FILE}" | cut -d' ' -f 2)
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_FILE}" | cut -d' ' -f 3)
echo "Mapping sample: $sample"

# Define input files
input1="${INPUT_PATH}/${read1}.fastq.gz"
input2="${INPUT_PATH}/${read2}.fastq.gz"

# Validate input files exist
if [[ ! -f "$input1" ]]; then
    echo "Error: Input file not found: $input1" >&2
    exit 1
fi
if [[ ! -f "$input2" ]]; then
    echo "Error: Input file not found: $input2" >&2
    exit 1
fi

# Run Kallisto
kallisto quant -i "${TRANSCRIPTOME_INDEX}" \
    -o "${OUTPUT_PATH}/${sample}" \
    "$input1" \
    "$input2"

echo "Kallisto job for sample ${sample} completed successfully."
  
# End timing
d2=$(date +%s)
sec=$((d2 - d1))
hour=$(echo - | awk '{print '$sec'/3600}')
echo "Runtime: $hour hours (${sec}s)"
