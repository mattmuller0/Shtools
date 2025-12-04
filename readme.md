# Shtools - Shell Tools for BigPurple HPC

A collection of shell scripts and utilities for working with the SLURM BigPurple High-Performance Computing (HPC) environment at NYU Langone Health.

## Repository Organization

```
Shtools/
├── bin/                    # CLI tools (add to PATH)
│   ├── bpcn               # Request and connect to compute nodes
│   ├── bpdownload         # Download data from BigPurple
│   ├── bpupload           # Upload data to BigPurple
│   └── bpinfo             # Show cluster and job queue status
└── scripts/               # Templates to copy and customize
    ├── bioinformatics/    # SLURM array jobs and Perl utilities
    ├── general/           # Utility scripts
    └── parallel/          # Spark on SLURM setup
```

### CLI Tools (`bin/`)

Standalone executables for interacting with BigPurple from your local machine:

| Tool | Description |
|------|-------------|
| `bpcn` | Request a compute node and configure SSH ProxyJump for easy access via `ssh cn` |
| `bpdownload` | rsync wrapper to download files from BigPurple |
| `bpupload` | rsync wrapper to upload files to BigPurple |
| `bpinfo` | Display cluster node info and your job queue |

### Template Scripts (`scripts/`)

**Copy and customize** for each project - don't run directly from repo:

#### Bioinformatics (`scripts/bioinformatics/`)

- `fastp.sh` - SLURM array job for FASTQ quality control
- `kallisto.sh` - SLURM array job for RNA-seq quantification
- `samtools.sh` - SLURM array job for samtools depth calculations
- `multiqc.sh` - Run MultiQC for quality control reports
- `fastq_functions.sh` - Functions for FASTQ file handling
- `featureCounts_functions.sh` - Process featureCounts output files
- `gather_fastqs.pl` - Perl script to collect and organize FASTQ files
- `get_references.pl` - Perl script to generate reference genome settings

#### General (`scripts/general/`)

- `download_urls.sh` - Download files from a list of URLs
- `join-many.sh` - Join multiple tab/comma-separated files

#### Parallel (`scripts/parallel/`)

- `spark.sh` - Configure Spark cluster on SLURM (source, don't execute)
- `spark_jupyter.sh` - SLURM job for Jupyter with Spark

## Installation

```bash
git clone https://github.com/mattmuller0/Shtools.git
```

Add the `bin/` directory to your PATH in `~/.zshrc`:

```bash
export PATH="$HOME/src/Shtools/bin:$PATH"
```

### SSH Configuration

The tools require an `hpc` host alias in your SSH config. Add to `~/.ssh/config`:

```
Host hpc
    HostName bigpurple.hpc.nyumc.org
    User your_username
    IdentityFile ~/.ssh/your_key
```

The `bpcn` script will automatically:
- Create `~/.ssh/config.d/` directory if needed
- Add `Include ~/.ssh/config.d/*` to your SSH config
- Write compute node config to `~/.ssh/config.d/bpcn`

To use a different SSH host alias:

```bash
export BPCN_SSH_HOST=my_hpc_alias
```

## Usage

### Connecting to a Compute Node

```bash
# Request a compute node (8GB/CPU, 4 CPUs = 32GB total, 4 hour limit)
bpcn -m 8GB -c 4 -t 4:00:00

# Dry run - show what would be submitted
bpcn -n -m 8GB -c 4

# Cancel your current compute node job
bpcn -k

# Show help
bpcn -h
```

After the job starts, connect with:

```bash
ssh cn
```

### File Transfer

```bash
# Download from BigPurple
bpdownload -r /gpfs/data/yourlab/project -l ./local_dir

# Upload to BigPurple
bpupload -l ./local_dir -r /gpfs/data/yourlab/project
```

### Cluster Status

```bash
bpinfo
```

## Requirements

- SSH access to BigPurple HPC with `hpc` host alias configured
- macOS or Linux

## License

MIT License
