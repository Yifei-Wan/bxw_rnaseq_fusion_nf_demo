/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { StarFusion } from '../subworkflows/StarFusion'
18include { FusionCatcher } from '../subworkflows/FusionCatcher'
19include { ChimPipe } from '../subworkflows/ChimPipe'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_bxw_rnaseq_fusion_nf_demobxw_rnaseq_fusion_nf_demo_pipeline'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow BXW_RNASEQ_FUSION_NF_DEMOBXW_RNASEQ_FUSION_NF_DEMO {

    take input_fastq 

    main:
    //
    // Collate and save software versions
    //
    softwareVersionsToYAML(ch_versions)
        .collectFile(
            storeDir: "${params.outdir}/pipeline_info",
            name:  'bxw_rnaseq_fusion_nf_demobxw_rnaseq_fusion_nf_demo_software_'  + 'mqc_'  + 'versions.yml',
            sort: true,
            newLine: true
        ).set { ch_collated_versions }
    
    // Run Fusion Callers
    // Conditionally run StarFusion if requested
    if ( params.RunStarFusion ) {
        StarFusion(input_fastq, genome_lib: params.genome_lib, add_memory: params.add_memory)
    }

    // Conditionally run FusionCatcher if requested
    if ( params.RunFusionCatcher ) {
        FusionCatcher(input_fastq, ref_db: params.ref_db, add_memory: params.add_memory)
    }

}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
