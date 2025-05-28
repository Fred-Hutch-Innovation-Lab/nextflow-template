include { DOWNSAMPLE_FASTQ } from '../modules/local/downsample_fastq.nf'

workflow DOWNSAMPLE {
    take: 
        ch_fastqs // channel: [mandatory] meta, reads

    main:  
        ch_fastqs
            .flatMap { meta, fq_list ->
                fq_list.collect { fq -> [ meta, fq ] }
            }
            .set { ch_fastq_individuals }
        DOWNSAMPLE_FASTQ(ch_fastq_individuals, params.downsample_target)
        ch_grouped_downsampled = DOWNSAMPLE_FASTQ.out.fastqs
            .groupTuple()
    emit: 
        fastqs = ch_grouped_downsampled // channel: [mandatory] meta, reads
}