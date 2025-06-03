#!/usr/bin/bash
module load Apptainer Nextflow
export NXF_APPTAINER_HOME_MOUNT=true;
nextflow run . -c run_arguments.config