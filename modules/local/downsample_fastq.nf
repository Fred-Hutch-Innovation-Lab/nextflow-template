process DOWNSAMPLE_FASTQ {
    tag "${meta.id}"

    container "staphb/seqtk:1.4"
    
    input:
    tuple val(meta), path(fastq)
    val(downsample_target)
    
    output:
    tuple val(meta), path("*_downsampled.fastq.gz", includeInputs: false), emit: fastqs
    path "versions.yml", emit: versions
    
    script:
    // https://nf-co.re/docs/guidelines/components/modules#optional-command-arguments
    def args = task.ext.args ?: ''
    def output_prefix = fastq.baseName
    """
    seqtk sample \
        ${args} \
        ${fastq} \
        | gzip > ${output_prefix}_downsampled.fastq.gz
    
    ## https://nf-co.re/docs/guidelines/components/modules#emission-of-versions
    ## |& to capture stderr, sed to grab line containing "Version" and remove the prefix,
    ## || true because running seqtk with no arguments returns error code 1
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
    seqtk: \$( seqtk |& sed '/Version:/!d; s/Version: //' || true )
    END_VERSIONS
    """
}