#!/bin/bash

# Function to count the number of reads in a fastq file
count_reads() {
    local fastq_file="$1"
    local num_reads=$(grep -c "^@" "$fastq_file")
    echo "Number of reads in $fastq_file: $num_reads"
}

# Function to merge lanes of fastq files
merge_fastq_files() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: merge_fastq_files <input_directory> <output_directory>"
        return 1
    fi

    local input_dir=$1
    local output_dir=$2

    for i in $(find "$input_dir" -type f -name "*.fastq.gz" | while read F; do basename "$F" | rev | cut -c 22- | rev; done | sort | uniq)
    do
        echo "Merging R1"
        cat "$input_dir/$i"_L00*_R1_001.fastq.gz > "$output_dir/$i"_ME_L001_R1_001.fastq.gz

        echo "Merging R2"
        cat "$input_dir/$i"_L00*_R2_001.fastq.gz > "$output_dir/$i"_ME_L001_R2_001.fastq.gz
    done
}