#!/usr/bin/env nextflow

process run_SkylineProcess
{

    container params.containerTags['pwiz']

    input:
    path sky_ch
    path rawFile
    val report_ch

    publishDir "${params.outputDirectory}/skyline-report", mode: 'copy'

    output:
    path "*.csv"

    script:

    def baseName = rawFile.baseName
    """
 

    wine SkylineCmd --in=$sky_ch --import-file=$rawFile --report-name=$report_ch --report-file=${baseName}.csv


    """
}
