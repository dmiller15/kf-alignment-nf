#!/usr/bin/env nextflow

params.fastq_meta = ""

workflow {
    in_fq = Channel.fromPath(params.fastq_meta).splitCsv(header: true).map { row -> files = []; files.add(file(row.reads, checkIfExists: true)); if (row.mates) files.add(file(row.mates, checkIfExists: true)); tuple(files, row.rg_str, row.interleaved) }

    in_fq.view()
}
