#!/bin/bash

# Function to generate a bash script for R
generate_sbatch_rscript() {
    local output_file=$1
    local error_file=$2
    local partition=$3
    local r_script=$5

    # set default values
    if is_variable_empty "$output_file"; then
        output_file="output.txt"
    fi
    if is_variable_empty "$error_file"; then
        error_file=$(echo "$output_file" | sed 's/output/error/g')
    fi
    if is_variable_empty "$partition"; then
        partition="cpu_medium"
    fi
    # make sure there is an r script
    if is_variable_empty "$r_script"; then
        echo "Error: no R script provided"
        return 1
    fi

    touch "$output_file"
    echo "#!/bin/bash" >> "$output_file"
    echo "#SBATCH --job-name=your_job_name" >> "$output_file"
    echo "#SBATCH --output=$output_file" >> "$output_file"
    echo "#SBATCH --error=$error_file" >> "$output_file"
    echo "#SBATCH --partition=$partition" >> "$output_file"
    echo "#SBATCH --nodes=1" >> "$output_file"
    echo "#SBATCH --cpus-per-task=4" >> "$output_file"
    echo "#SBATCH --mem=32G" >> "$output_file"
    echo "#SBATCH --time=600" >> "$output_file"
    echo "#SBATCH --mail-type=ALL" >> "$output_file"
    echo "#SBATCH --mail-user=mm12865@nyu.edu" >> "$output_file"
    echo "" >> "$output_file"
    echo "module purge" >> "$output_file"
    echo "module load r/4.1.2" >> "$output_file"
    echo "" >> "$output_file"
    echo "Rscript $r_script" >> "$output_file"
}

# Function to generate an sbatch script for Python
generate_python_script() {
    local output_file=$1
    local error_file=$2
    local partition=$3
    local python_script=$5

    # set default values
    if is_variable_empty "$output_file"; then
        output_file="output.txt"
    fi
    if is_variable_empty "$error_file"; then
        error_file=$(echo "$output_file" | sed 's/output/error/g')
    fi
    if is_variable_empty "$partition"; then
        partition="cpu_medium"
    fi
    # make sure there is an r script
    if is_variable_empty "$python_script"; then
        echo "Error: no Python script provided"
        return 1
    fi

    touch "$output_file"
    echo "#!/bin/bash" >> "$output_file"
    echo "#SBATCH --job-name=your_job_name" >> "$output_file"
    echo "#SBATCH --output=$output_file" >> "$output_file"
    echo "#SBATCH --error=$error_file" >> "$output_file"
    echo "#SBATCH --partition=$partition" >> "$output_file"
    echo "#SBATCH --nodes=1" >> "$output_file"
    echo "#SBATCH --cpus-per-task=4" >> "$output_file"
    echo "#SBATCH --mem=32G" >> "$output_file"
    echo "#SBATCH --time=600" >> "$output_file"
    echo "#SBATCH --mail-type=ALL" >> "$output_file"
    echo "#SBATCH --mail-user=mm12865@nyu.edu" >> "$output_file"
    echo "" >> "$output_file"
    echo "module purge" >> "$output_file"
    echo "# ADD BELOW THE MODULES YOU NEED TO LOAD" >> "$output_file"
    echo "" >> "$output_file"
    echo "python $python_script" >> "$output_file"
}