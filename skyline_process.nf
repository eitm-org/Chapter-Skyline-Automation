#!/usr/bin/env nextflow

process run_SkylineProcess
{

    container params.containerTags['pwiz']
    stageInMode = 'copy'

    input:
    path sky_ch
    path rawFile
    path transition_ch
    val report_ch

    publishDir "${params.outputDirectory}/skyline-report", mode: 'copy'

    output:
    path "*.csv"

    script:

    def baseName = rawFile.baseName
    """
    # symbolic link handling: make temp copy (fix from lehtiolab/nf-msconvert)    
    #${rawFile.isDirectory() ?  "mv ${rawFile} tmpdir && cp -rL tmpdir ${rawFile}" : ''} 

    wine SkylineCmd --in=$sky_ch --import-file=$rawFile --import-transition-list=$transition_ch --report-name=$report_ch --report-file=${baseName}.csv


    """
}
