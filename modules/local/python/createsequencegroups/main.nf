process PYTHON_CREATESEQUENCEGROUPS {
    container "pgc-images.sbgenomics.com/d3b-bixu/python:2.7.13"

    input:
    path(dict)

    output:
    path('*.intervals'), emit: intervals

    when:
    task.ext.when == null || task.ext.when

    script:
    template 'create_sequence_groups.py'

    stub:
    """
    touch a.intervals
    touch b.intervals
    touch c.intervals
    touch unmapped.intervals
    """
}
