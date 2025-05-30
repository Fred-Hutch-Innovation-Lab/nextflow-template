#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def helpMessage() {
    log.info """
    Usage:
    The typical command for running the pipeline is as follows:
    ./nextflow run main.nf -c run_arguments.config

    Edit the run_arguments.config file to add run parameters
    """.stripIndent()
}

// Show help message
params.help = ""
if (params.help) {
    helpMessage()
    exit 0
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { CONCATENATE_FASTQ } from './modules/local/concatenate_fastq.nf'
include { DOWNSAMPLE } from './subworkflows/downsample_fastq.nf'
include { PARSE_SAMPLESHEET } from './subworkflows/parse_samplesheet.nf'
include { LOG_VERSIONS } from './subworkflows/log_versions.nf'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {
    ch_fastqs = PARSE_SAMPLESHEET(params.samplesheet)
    ch_versions = Channel.empty()

    CONCATENATE_FASTQ(ch_fastqs)
    DOWNSAMPLE(CONCATENATE_FASTQ.out.fastqs)

    ch_versions = ch_versions.mix(
        // CONCATENATE_FASTQ.out.versions
        DOWNSAMPLE.out.versions
    )
    LOG_VERSIONS(ch_versions)
}