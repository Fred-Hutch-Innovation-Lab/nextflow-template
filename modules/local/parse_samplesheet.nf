workflow PARSE_SAMPLESHEET {
    take:
    samplesheet // path: [mandatory] csv
    

    main:
    Channel.fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map { row ->
            def glob_pattern = "${params.run_dir}/${row.fastq_prefix}_*.fastq*"
            def fq_files = file(glob_pattern).collect()
            if (!fq_files) {
                throw new IllegalArgumentException("No FASTQ files found for sample: ${row.sample_id} at ${glob_pattern}")
            }
            def meta = [:]
            meta.id = row.sample_id
            row.each { key, value ->
                if (key != 'sample_id' && key != 'fastq_prefix') {
                    meta[key] = value
                }
            }
            [ meta, fq_files ]
        }
        .set { ch_fastqs }
    emit:
    ch_fastqs // channel: [mandatory] meta, reads
}

