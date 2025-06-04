#!/usr/bin/bash
module load Apptainer Nextflow
# Needed to allow apptainer to access various directories accessed by programs such as 
# mixcr that writes to /loc/scratch
export NXF_APPTAINER_HOME_MOUNT=true;
nextflow run . -c run_arguments.config