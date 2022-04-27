nextflow.enable.dsl = 2

params.hashlen = 51
params.outdir = "results"

process velvet{
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/velvet:1.2.10--h7132678_5"

 input:
 path fastq
 val hashlen

 output:
 path "velvetdir"

 script:
 if (fastq instanceof List) {

  """
  velveth velvetdir ${hashlen} -shortPaired -fastq -separate ${fastq}
  # velveth velvetdir ${hashlen} -shortPaired -fastq -separate ${fastq[0]} ${fastq[1]}
  velvetg velvetdir
  """
} else {
  """
  velveth velvetdir ${hashlen} -fastq -short ${fastq}
  velvetg velvetdir
  """
}

}

 params.indir = null

workflow {

  fastqchannel=inchannel = channel.fromPath("${params.indir}*.fastq").collect()
  fastqchannel.view()
  velvet(fastqchannel, params.hashlen)

}

// nextflow ../cq_pipelines/git_nextflow_pipelines/assembly.nf --indir ../analysis/SRR16641643_analysis/fastp/ -profile singularity

//velveth Assem_Paired 31 -shortPaired -fastq -separate SRR18130206_1_fastp.fastq  SRR18130206_2_fastp.fastq
