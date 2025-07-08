#!/usr/bin/env nextflow

process run_individual_ReportProcess
{

    container 'kruttika39/xcms_newbuild:tinytex-install'

    input:
    path input_ch
    path markdown_ch
    path skylineReport_ch
    path function_ch
    path logo_ch

    publishDir "${params.outputDirectory}/Individual_QC_reports", mode: 'copy'

    output:
    path '*.pdf'
    path '**/*.png'

    script:

    """

    Rscript $input_ch $markdown_ch $skylineReport_ch $function_ch $logo_ch ${params.outputDirectory}

    """



}

