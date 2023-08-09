process STORE_FASTA_CHUNKS{

    storeDir "${params.outdir}/${params.chunk_size}/"
    label "process_low"

    input:
    tuple val(meta), file(file)

    output:
    tuple val(meta), file("${meta.id}/$file"), emit:  stored_file
    
    script:
    """
    mkdir -p ${meta.id}/
    cp $file ${meta.id}/
    """
}

