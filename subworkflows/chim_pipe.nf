process ChimPipe {

    input:
    path left_fq
    path right_fq
    path ChimRefTarGenome
    path ChimRefTarTrans
    path ChimRefTarSim
    val sample

    output:
    path "ChimPipe_Output/", mode: 'copy'

    script:
    """
    gunzip -c ${ChimRefTarGenome} > hg19_genome_GEM.tar
    gunzip -c ${ChimRefTarTrans} > gencode_annot_v19_long_GEM.tar
    gunzip -c ${ChimRefTarSim} > gencode_v19_similarity_gn_pairs.tar
    tar -xf hg19_genome_GEM.tar
    tar -xf gencode_annot_v19_long_GEM.tar
    tar -xf gencode_v19_similarity_gn_pairs.tar

    cp ${left_fq} .
    cp ${right_fq} .

    R1=\$(find . -iname "*R1*.fastq.gz" -o -iname "*R1*.fq.gz" -maxdepth 1)
    R2=\$(find . -iname "*R2*.fastq.gz" -o -iname "*R2*.fq.gz" -maxdepth 1)
    
    ls
    echo 'checking genome'
    ls hg19_genome_GEM
    echo 'checking transcripts'
    ls gencode_annot_v19_long_GEM
    echo 'checking similarity'
    ls gencode_v19_similarity_gn_pairs
    
    mkdir ChimPipe_Output
    
    bash /ChimPipe-master/ChimPipe.sh \
        --fastq_1 \$R1 \
        --fastq_2 \$R2 \
        -g hg19_genome_GEM/hg19.chr.gem \
        -a gencode_annot_v19_long_GEM/gencode.annot.v19.long.gtf \
        -t gencode_annot_v19_long_GEM/gencode.annot.v19.long.gtf.junctions.gem \
        -k gencode_annot_v19_long_GEM/gencode.annot.v19.long.gtf.junctions.keys \
        --sample-id ${sample} \
        -o ChimPipe_Output \
        --threads ${task.cpus} \
        --similarity-gene-pairs gencode_v19_similarity_gn_pairs/gene1_gene2_alphaorder_pcentsim_lgalign_trpair_trexoniclength.txt
    """
    }