# Shtools - Shell Tools for BigPurple HPC

This repository contains a collection of shell scripts and utility functions for working with the SLURM BigPurple High-Performance Computing (HPC) environment at NYU Langone Health.

## Repository Organization

### Root Scripts

- `bpcn` - Connect to BigPurple compute nodes with custom resource requirements
- `bpdownload` - Download data from BigPurple to local machine
- `bpupload` - Upload data from local machine to BigPurple

### Template Scripts Directory

#### Bioinformatics Scripts

Located in `bioinformatics`:

- `fastp.sh` - SLURM job for FASTQ quality control with fastp
- `fastq_functions.sh` - Functions for FASTQ file handling
- `featureCounts_functions.sh` - Process featureCounts output files
- `gather_fastqs.sh` - Perl script to collect and organize FASTQ files
- `get_references` - Generate reference genome settings
- `kallisto.sh` - SLURM job for RNA-seq quantification with Kallisto
- `multiqc.sh` - Run MultiQC for quality control report generation
- `samtools.sh` - SLURM job for samtools depth calculations

#### General Utility Scripts

Located in `general`:

- `download_urls.sh` - Functions to download files from URLs
- `general_functions.sh` - Common utility shell functions
- `generate_scripts.sh` - Generate SLURM job scripts for R and Python
- `join-many.sh` - Join multiple tab or comma-separated files

#### Parallel Computing Scripts

Located in `parallel`:

- `spark_jupyter.sh` - SLURM job script for setting up Jupyter with Spark
- `spark.sh` - Configure Spark cluster on SLURM

## Installation

Clone this repository to your local machine:

```bash
git clone https://github.com/mattmuller0/Shtools.git
```

## Usage

### Connecting to BigPurple

To connect to a BigPurple compute node with custom resource requirements, use the `bpcn` script:

```bash
bpcn -m 8G -n 1 -t 4:00:00
```

This command will request 8GB of memory, 1 CPU, and a time limit of 4 hours. You can adjust these parameters as needed.

### BPCN Script Setup

In order to use the bpcn script, you need to edit your .zshrc file to see the bpcn alias or autoload the script. You can do this by adding the following lines to your .zshrc file:

```bash
fpath=(/path/to/Shtools $fpath)
autoload -Uz bpcn
```

or by setting up an alias in your .zshrc file:

```bash
alias bpcn='/path/to/Shtools/bpcn'
```

It is currently set to look for the **hpc** host in your ssh config file. Once that is done, you need to add an include header for `~/.ssh/configx` to your `~/.ssh/config` file. Here is an example of what your config file might look like:

```bash
include ~/.ssh/configx

Host *
    ForwardAgent yes
    AddKeysToAgent yes

Host hpc
    HostName bigpurple.hpc.nyumc.org
    User your_username
    IdentityFile ~/.ssh/your_key
```

## Requirements

- SSH access to BigPurple HPC environment
- SSH key configured for secure access with hostname **hpc**

## Contributing

Feel free to submit issues or pull requests with improvements or new features.

## License

MIT (what even is a license?)