include { downsample_fastq } from '../modules/local/downsample_fastq.nf'

workflow DOWNSAMPLE {
    take: 
        ch_fastqs // channel: [mandatory] meta, reads

    main:  
        ch_fastqs
            .flatMap { meta, fq_list ->
                fq_list.collect { fq -> [ meta, fq ] }
            }
            .set { ch_fastq_individuals }
        ch_grouped_downsampled = downsample_fastq(ch_fastq_individuals, params.downsample_target)
            .groupTuple()
    emit: 
        fastqs = ch_grouped_downsampled // channel: [mandatory] meta, reads
}