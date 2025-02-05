process StarFusion {

    input:
    path left_fq, optional: true
    path right_fq, optional: true
    path fastq_pair_tar_gz, optional: true
    path genome
    val fusion_inspector, optional: true
    val min_FFPM = 0.1
    val docker = "trinityctat/starfusion:1.10.1"

    output:
    path "StarFusion_Output/", mode: 'copy'

    publishDir "${params.startfusion_output_dir}""

    script:
    """
    set -ex
    shopt -s nullglob

    mkdir -p StarFusion_Output

    if [[ ! -z "${fastq_pair_tar_gz}" ]]; then
        # untar the fq pair
        mv ${fastq_pair_tar_gz} reads.tar.gz
        tar xvf reads.tar.gz

        left_fq=(*_1.fastq* *_1.fq*)
    
        if [[ ! -z "*_2.fastq*" ]] || [[ ! -z "*_2.fq*" ]]; then
             right_fq=(*_2.fastq* *_2.fq*)
        fi
    else
        left_fq="${left_fq}"
        right_fq="${right_fq}"
    fi

    if [[ -z "${left_fq[0]}" && -z "${right_fq[0]}" ]]; then
        echo "Error, not finding fastq files here"
        ls -ltr
        exit 1
    fi

    left_fqs=$(IFS=, ; echo "${left_fq[*]}")
    
    read_params="--left_fq ${left_fqs}"
    if [[ "${right_fq[0]}" != "" ]]; then
      right_fqs=$(IFS=, ; echo "${right_fq[*]}")   
      read_params="${read_params} --right_fq ${right_fqs}"
    fi
    
    mkdir -p genome_dir

    tar xf ${genome} -C genome_dir --strip-components 1

    /usr/local/src/STAR-Fusion/STAR-Fusion \
      --genome_lib_dir `pwd`/genome_dir/ctat_genome_lib_build_dir \
      ${read_params} \
      --output_dir StarFusion_Output/ \
      --CPU ${task.cpus} \
      ${fusion_inspector ? "--FusionInspector ${fusion_inspector}" : ""} \
      --min_FFPM ${min_FFPM}
    """
}