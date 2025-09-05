#!/usr/bin/env nextflow

//
// msconvert.nf
//


process msconvertVersion 
{
    container params.containerTags['pwiz']
    publishDir "${params.outputDirectory}/versions"

    output:
    path output

    script:
    output = "msconvert_versions.yml"

    """
    echo -n 'msconvert_version: ' >> $output
    wine msconvert 2>&1 | grep 'release' | awk '{print \$3}' >> $output
    echo "msconvert_container_tag: ${params.containerTags['pwiz']}" >> $output
    """
}


process msconvertProcess 
{
    container params.containerTags['pwiz']
    publishDir "${params.outputDirectory}/mzml", mode: 'copy'
    stageInMode = 'copy'
 
    input:
    path rawFile

    output:
    path output 

    script:
    output = "${rawFile.baseName}.*"

    //println "msconvertArgs: ${params.msconvertArgs}"

    """
    # symbolic link handling: make temp copy (fix from lehtiolab/nf-msconvert)    
    #${rawFile.isDirectory() ?  "mv ${rawFile} tmpdir && cp -rL tmpdir ${rawFile}" : ''}
 
    wine msconvert ${params.msconvertArgs} ${params.msconvertArgs2} ${params.msconvertArgs3} $rawFile
    """
}
