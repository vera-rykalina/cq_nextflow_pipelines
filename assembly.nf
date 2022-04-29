nextflow.enable.dsl = 2

params.hashlen = 51
params.outdir = "results"
params.indir = null
params.with_quastref = false

process velvet{
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/velvet:1.2.10--h7132678_5"

 input:
 path fastq
 val hashlen

 output:
 path "velvetdir"
 path "velvetdir/velvetcontigs.fa", emit: velvetcontigs

 script:
 if (fastq instanceof List) {

  """
  velveth velvetdir ${hashlen} -shortPaired -fastq -separate ${fastq}
  # velveth velvetdir ${hashlen} -shortPaired -fastq -separate ${fastq[0]} ${fastq[1]}
  velvetg velvetdir
  mv velvetdir/contigs.fa velvetdir/velvetcontigs.fa
  """
} else {
  """
  velveth velvetdir ${hashlen} -fastq -short ${fastq}
  velvetg velvetdir
  mv velvetdir/contigs.fa velvetdir/velvetcontigs.fa

  """
  }
}

process spades {
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/spades%3A3.15.4--h95f258a_0"
  input:
  path fastq

  output:
  path "spades_out"
  path "spades_out/spadescontigs.fasta", emit: spadescontigs
  script:
  if (fastq instanceof List) {
  """
  spades.py --only-assembler -1 ${fastq[0]} -2 ${fastq[1]} -o spades_out
  mv spades_out/contigs.fasta spades_out/spadescontigs.fasta
  """
} else{
  """
  spades.py --only-assembler -s ${fastq} -o spades_out
  mv spades_out/contigs.fasta spades_out/spadescontigs.fasta
  """
}
}



process quast {
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/quast%3A5.0.2--py37pl5321h09c1ff4_7"
  input:
  path infile
  output:
  path "quast_results"
  script:

  """
  quast ${infile}
  """
}


process quast_ref {
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/quast%3A5.0.2--py37pl5321h09c1ff4_7"
  input:
  path infile
  path ref
  output:
  path "quast_results"
  script:

  """
  quast ${infile} -r ${ref}
  """
}


workflow {
  fastqchannel = channel.fromPath("${params.indir}/*.fastq").collect()
  //fastqchannel.view()
  vout = velvet(fastqchannel, params.hashlen)
  sout=spades(fastqchannel)
  allcontigs = vout.velvetcontigs.concat(sout.spadescontigs).collect()
  //vout.velvetcontigs.view()
  if (params.with_quastref){
    reference = channel.fromPath(params.with_quastref)
    quast_ref(allcontigs, reference)
  } else {
  quast(allcontigs)
}

}
