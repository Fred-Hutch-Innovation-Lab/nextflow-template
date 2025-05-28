Template for creating new Nextflow pipelines compatible with Apptainer and SLURM. Intended for use on HPCs. 

The template is structured such that the `main.nf` holds just high-level workflow structure, while the minutia of channel management is handeled in subworkflows. While the nf-core docs suggest subworkflows should have at least 2 processes, I'm choosing to use sub-workflows for all processes to keep the main workflow easy to read. 

`main.nf > subworkflows > processes (modules) > scripts (bin)` 

# Profiles

Use `-profile slurm` to have jobs submitted to the HPC job scheduler.
