#!/usr/bin/env nextflow

include {msconvertVersion; msconvertProcess} from './msconvert'
include {run_SkylineProcess} from './skyline_process'
include {run_individual_ReportProcess} from './individual_report_process'

def usage() 
{
"""
    Current Usage: nextflow run main.nf -params-file params.yml
    Usage: [nextflow run] [/path/to/mspipe/]main.nf --rawFiles "/path/to/raw_files"

    Notes:
    - "/path/to/raw_files" must be in quotes (to pass as single string to Nextflow)
    - args to msconvert must be extra-quoted or Nextflow will interpret as boolean
        --msconvertArgs '"--text"'
"""
}

workflow reportVersions
{
    msconvertVersion()
}



workflow processRawFiles
{

    // create raw file channel

    rawFileChannel = Channel.fromPath(params.rawFiles, type:'any')
    rawFileChannel.view {"raw file input: " + it}


    // raw -> mzml conversion
    
    mzmlChannel = msconvertProcess(rawFileChannel)


    // raw -> Skyline report

    sky_ch = Channel.fromPath(params.skylineArgs2)    
    report_ch = Channel.value(params.skylineArgs)


    skylineChannel = run_SkylineProcess(sky_ch.first(), rawFileChannel, report_ch)
    skylineChannel.view {"Skyline output: " + it}


    // skyline_report -> Individual Rmarkdown QC reports
    

    input_ch = Channel.fromPath(params.skyline_rmd_input)
    markdown_ch = Channel.fromPath(params.rmd_script) 
    function_ch = Channel.fromPath(params.function_script)
    //RT_ch = Channel.fromPath(params.rt_input)
    //formula_ch = Channel.fromPath(params.formula_input)
    logo_ch = Channel.fromPath(params.logo)

    run_individual_ReportProcess(input_ch.first(), markdown_ch.first(), skylineChannel, function_ch.first(),  logo_ch.first())


}


workflow
{
    reportVersions()    
    processRawFiles()
    
    
}



def writeFields(object, filename) 
{
    def file = new File("$params.outputDirectory/nextflow/$filename")

    def fields = object.class.declaredFields.grep {!it.synthetic}

    fields.each {
        def name = it.name
        def value = object."$name"
        file.append "$name: $value\n"
    }
}


workflow.onComplete 
{
    // write out pipeline metadata
    // https://www.nextflow.io/docs/latest/metadata.html

    writeFields(workflow, "metadata_workflow.txt")
    writeFields(nextflow, "metadata_nextflow.txt")
}


workflow.onError 
{
    println "onError handler"
}


