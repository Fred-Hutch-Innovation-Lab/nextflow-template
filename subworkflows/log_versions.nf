def processVersionsFromYAML(yaml_file) {
    def yaml = new org.yaml.snakeyaml.Yaml()
    def versions = yaml.load(yaml_file).collectEntries { k, v -> [k.tokenize(':')[-1], v] }
    return yaml.dumpAsMap(versions).trim()
}

//
// Get workflow version for pipeline
//
// def workflowVersionToYAML() {
//     return """
//     Workflow:
//         ${workflow.manifest.name}: ${getWorkflowVersion()}
//         Nextflow: ${workflow.nextflow.version}
//     """.stripIndent().trim()
// }

//
// Get channel of software versions used in pipeline in YAML format
//
def softwareVersionsToYAML(ch_versions) {
    return ch_versions.unique().map { version -> processVersionsFromYAML(version) }.unique()//.mix(Channel.of(workflowVersionToYAML()))
}

workflow LOG_VERSIONS {
    take: 
        ch_versions // channel: [mandatory] version_files

    main:  
        // def processVersionsFromYAML(yaml_file) {
        //     def yaml = new org.yaml.snakeyaml.Yaml()
        //     def versions = yaml.load(yaml_file).collectEntries { k, v -> [k.tokenize(':')[-1], v] }
        //     return yaml.dumpAsMap(versions).trim()
        // }
        // ch_versions
        //     .unique()
        //     // .map { version -> processVersionsFromYAML(version) }
        //     .unique()
            // // .mix(Channel.of(workflowVersionToYAML()))
            softwareVersionsToYAML(ch_versions)
                .collectFile(
                    storeDir: "${params.outdir}",
                    name: 'versions.yml', //'nf_core_' + 'scdownstream_software_' + 'mqc_' + 
                    sort: true,
                    newLine: true,
                )
                .set { ch_collated_versions }
    emit: 
        ch_collated_versions = ch_collated_versions // channel: [mandatory] versions.yml
}