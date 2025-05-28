process downsample_fastq {
    tag "${meta.id}"

    container "staphb/seqtk:1.4"
    
    input:
    tuple val(meta), path(fastq)
    val(downsample_target)
    
    output:
    tuple val(meta), path("*_downsampled.fastq.gz", includeInputs: false)
    
    script:
    """
    seqtk sample \
        -s100 \
        ${fastq} \
        ${downsample_target} \
        | gzip > ${fastq.baseName}_downsampled.fastq.gz
    """
}