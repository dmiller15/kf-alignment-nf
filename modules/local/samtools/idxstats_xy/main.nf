process SAMTOOLS_IDXSTATS_XY {
    tag ""
    label 'process_low'
    container "pgc-images.sbgenomics.com/d3b-bixu/samtools:1.9"

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path('*.ratio.txt'), emit: xy_ratio
    tuple val(meta), path('*.idxstats.txt'), emit: idxstats 

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    samtools \\
        idxstats \\
        $bam > ${bam.getBaseName()}.idxstats.txt \\
    && awk '{ \\
        if(\$1 == "chrX") {x_rat = \$3/\$2; X_reads = \$3;}; \\
        if(\$1 == "chrY") {y_rat = \$3/\$2; Y_reads = \$3;}; \\
        } END { \\
        printf "Y_reads_fraction %f\\nX:Y_ratio %f\\nX_norm_reads %f\\nY_norm_reads %f\\nY_norm_reads_fraction %f", Y_reads/(X_reads+Y_reads), x_rat/y_rat, x_rat, y_rat, y_rat/(x_rat+y_rat) \\
        }' ${bam.getBaseName()}.idxstats.txt > ${bam.getBaseName()}.ratio.txt
    """

    stub:
    """
    touch test.ratio.txt
    touch test.idxstats.txt
    """
}
