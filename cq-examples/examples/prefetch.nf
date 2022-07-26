nextflow.enable.dsl = 2

process prefetch {
  publishDir "${params.outdir}", mode: "copy", overwrite: true
  container "docker://ncbi/sra-tools"
  input: 
    val accession
  output:
    path "$accession", emit: sradir 
  script:
    """
    prefetch $accession
    """
}

workflow {
  prefetch(params.accession)
}
