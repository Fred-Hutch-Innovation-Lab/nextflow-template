process CONCATENATE_FASTQ {
    tag "${meta.id}"

    container "python:3.13.3"
    
    input:
    tuple val(meta), path(fastqs)
    
    output:
    tuple val(meta), path("*.fastq.gz", includeInputs: false), emit: fastqs
    
    script:
    """
    concatenate_fastq.py \
        --files ${fastqs.join(' ')} \
        --sampleID ${meta.id} \
        --copy_method symlink \
        --output .
    """
} 