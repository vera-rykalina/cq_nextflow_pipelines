nextflow.enable.dsl = 2
  
//  container "https://depot.galaxyproject.org/singularity/"

process prefetch {
  storeDir "${params.outdir}"
  container "https://depot.galaxyproject.org/singularity/sra-tools:2.11.0--pl5262h314213e_0"
  input: 
    val accession
  output:
    path "${accession}/${accession}.sra"
  script:
    """
    prefetch $accession
    """
}

process showFile {
  publishDir "${params.outdir}", mode: "copy", overwrite: true
  input:
    path sraresult
  output:
    path "fileinfo.txt"
  script:
    """
    echo "${sraresult}" > fileinfo.txt
    """
}

workflow {
  sraresult = prefetch(params.accession)
  showFile(sraresult)
}
