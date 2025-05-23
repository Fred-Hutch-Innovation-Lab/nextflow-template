nextflow.enable.dsl=2

workflow parse_samplesheet {
    take:
    samplesheet
    run_dir

    main:
    Channel.fromPath(samplesheet)
        .splitCsv(header: true)
        .map { row ->
            def glob_pattern = "${run_dir}/${row.fastq_prefix}_*.fastq*"
            def fq_files = file(glob_pattern).collect()
            tuple(row.fastq_prefix, fq_files)
        }
        .map { prefix, fq_files ->
            def groups = fq_files.groupBy { it.name.find(/(R1|R2|I1|I2)/) }
            def read_groups = groups.collect { read_id, files ->
                [read_id, files]
            }
            tuple(prefix, read_groups)
        }
        .set { fastqs_ch }

    emit:
    fastqs = fastqs_ch
}

