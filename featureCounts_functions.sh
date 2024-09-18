#!/bin/bash

process_feature_count_files() {
    local pattern="$1"
    
    # Get the list of featureCount files matching the regex pattern
    feature_count_files=(*$pattern)
    echo "Found ${#feature_count_files[@]} files matching $pattern"

    # Iterate over each featureCount file
    for feature_count_file in "${feature_count_files[@]}"; do
        # Extract the gene counts and create a cleaned file
        cat "$feature_count_file" | sed '1d' | cut -f12 > "${feature_count_file%}_clean.txt"
    done

    # Get the first featureCount file to extract gene names
    first_feature_count_file="${feature_count_files[0]}"

    # Extract gene names and save to genes.txt
    cut -f1 "$first_feature_count_file" > genes.txt

    # Use paste to combine gene names and cleaned featureCount files
    paste genes.txt "${feature_count_files[@]/%/_clean.txt}" > featureCounts.txt

    # Remove temporary cleaned files
    rm -f "${feature_count_files[@]/%/_clean.txt}"
}