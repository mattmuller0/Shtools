#!/bin/bash -l

#SBATCH -J fastp
#SBATCH --mem=25G
#SBATCH -n 8
#SBATCH -p cpu_medium
#SBATCH --array=1-217
#SBATCH --export=ALL
#SBATCH --time=600
#SBATCH --output="logs/fastp-%A_%a.out"

set -e  # Exit on error

##############################################
# CONFIGURATION - Edit these for your project
##############################################
PROJECT_PATH="path/to/your/project"
INPUT_DIR="${PROJECT_PATH}/data/raw_data"
OUTPUT_DIR="data/clean"
SAMPLE_FILE="data/sample_names.txt"
THREADS=8
##############################################

# Start timing
d1=$(date +%s)

# Modules
module purge
module load fastp/0.22.0
module load python/cpu/3.6.5

#### CODE BELOW ####
echo "HOSTNAME: $HOSTNAME"

# Create output directory if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Validate sample file exists
if [[ ! -f "${SAMPLE_FILE}" ]]; then
    echo "Error: Sample file not found: ${SAMPLE_FILE}" >&2
    exit 1
fi

# Set up for paired end
read1=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_FILE}" | cut -d' ' -f 1)
read2=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_FILE}" | cut -d' ' -f 2)
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${SAMPLE_FILE}" | cut -d' ' -f 3)
echo "Mapping sample: $sample"

input1="${INPUT_DIR}/${read1}.fastq.gz"
input2="${INPUT_DIR}/${read2}.fastq.gz"
output1="${OUTPUT_DIR}/${read1}.fastq.gz"
output2="${OUTPUT_DIR}/${read2}.fastq.gz"

# Validate input files exist
if [[ ! -f "$input1" ]]; then
    echo "Error: Input file not found: $input1" >&2
    exit 1
fi
if [[ ! -f "$input2" ]]; then
    echo "Error: Input file not found: $input2" >&2
    exit 1
fi

echo "Running fastp on sample: $sample"
fastp -w "${THREADS}" -i "$input1" -I "$input2" -o "$output1" -O "$output2" \
    -h "${OUTPUT_DIR}/${sample}.fastp.html" -j "${OUTPUT_DIR}/${sample}.fastp.json"


# End timing
d2=$(date +%s)
sec=$((d2 - d1))
hour=$(echo - | awk '{print '$sec'/3600}')
echo "Runtime: $hour hours (${sec}s)"