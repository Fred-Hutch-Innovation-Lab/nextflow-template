process concatenate_fastq {
    // tag "${meta.id}"
    
    input:
    tuple val(meta), path(fastqs)
    
    output:
    tuple val(meta), path("${meta.id}.fastq.gz") emit: concatenated
    
    when:
    fastqs.size() > 1
    
    shell:
    '''
    zcat !{fastqs.join(' ')} | gzip -c > ${meta.id}.fastq.gz
    '''
} 