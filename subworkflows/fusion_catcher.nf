process FusionCatcher {
    
    input:
    path left_fq
    path right_fq
    path ref_db

    output:
    path "FusionCatcher_Output/", mode: 'copy'

    publishDir "${params.fusion_catcher_output_dir}""

    script:
    """
    tar -xzf ${ref_db}
    
    ls -lhtr   
    
    mkdir fastq
    cp ${left_fq} fastq
    cp ${right_fq} fastq
    mkdir FusionCatcher_Output
    
    # Check fusion catcher directory(s)
    echo 'checking fusion catcher directory(s)'
    echo 'ls /opt/fusioncatcher/v1.33/tools/'
    ls /opt/fusioncatcher/v1.33/tools/
    
    echo 'checking subdirectories'
    ls */
    
    /opt/fusioncatcher/v1.33/bin/fusioncatcher.py \
        -d human_v102 \
        -i fastq/ \
        -o FusionCatcher_Output/ \
        -p ${task.cpus} \
        -Z
        
    echo 'ls'
    ls
    echo 'pwd'
    pwd
    echo 'ls FusionCatcher_Output'
    ls FusionCatcher_Output
    """
    
    container:
    "clinicalgenomics/fusioncatcher:1.33"
}