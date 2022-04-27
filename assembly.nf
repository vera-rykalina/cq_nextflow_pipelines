nextflow.enable.dsl = 2

params.hashlen = 51
params.outdir = "results"
params.indir = null

process velvet{
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/velvet:1.2.10--h7132678_5"

 input:
 path fastq
 val hashlen

 output:
 path "velvetdir"
 path "velvetdir/contigs.fa", emit: velvetcontigs

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

process quast {
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/quast%3A5.0.2--py37pl5321h09c1ff4_7"
  input:
  path infile
  output:
  path "out.txt"
  script:

  """
  echo bla > out.txt
  """
}


workflow {

  fastqchannel=inchannel = channel.fromPath("${params.indir}/*.fastq").collect()
  fastqchannel.view()
  vout = velvet(fastqchannel, params.hashlen)
  vout.velvetcontigs.view()
  quast(vout.velvetcontigs)

}
