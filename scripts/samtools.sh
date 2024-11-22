#!/bin/bash
#SBATCH -J samtools_chord
#SBATCH --mem=12G
#SBATCH -n 1
#SBATCH -p cpu_short
#SBATCH --array=1-217
#SBATCH --export=ALL
#SBATCH --time=600
#SBATCH --output="logs/samtools_depth-%A_%a.out"

# MODULES
module purge
module load samtools/1.9-new

# SCRIPTS
# make an outdir directory for the files
if [ ! -d "output/depth" ]; then
  mkdir -p "output/depth"
fi

files='/gpfs/data/bergerlab/mm12865/transcript_splicing_platelet/output/get_read_names/chord_files.txt'
infile=$(awk "NR==$SLURM_ARRAY_TASK_ID" $files)
outfile=$(basename $infile)
echo Running Samtools depth on $infile
samtools depth $infile > "output/depth/"$outfile"_depth.txt"
echo Output saved to $outfile"_depth.txt"
# end of script
