nextflow.enable.dsl = 2

params.indir = null
params.accession = null



workflow {

  fastqchannel=inchannel = channel.fromPath("${params.indir}*.fastq")
  fastqchannel.view()
}


// /home/cq/NGS/testing/results_multy/fastp - here are my fastq files
// nextflow ../cq_pipelines/git_nextflow_pipelines/assembly.nf --indir /home/cq/NGS/testing/results_multy/fastp/
