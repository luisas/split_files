#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

include { STORE_FASTA_CHUNKS } from "./modules/local/store_fasta_chunks.nf"

workflow pipeline {

    ch_fastas = Channel.fromPath( params.infiles )
                       .map{ file -> tuple(  [id: file.baseName], file ) }.view()

    ch_fastas = ch_fastas.splitFasta( by: params.chunk_size, file: true )
    STORE_FASTA_CHUNKS(ch_fastas)
    ch_fastas = STORE_FASTA_CHUNKS.out.stored_file.map{
                                                            meta, fastafile -> 
                                                            def tmp = meta.clone()
                                                            tmp.group = tmp.id
                                                            tmp.id = tmp.id + "_" + fastafile.baseName.split("\\.")[1]
                                                            return [tmp, fastafile] 
                                                        }

}


workflow {
  pipeline()
}


