nextflow.enable.dsl = 2


process bowtie2_index {
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/bowtie2%3A2.4.5--py39hd2f7db1_2"

 input:
 path reference

 output:
 path "index*"


 script:
 """
 # building small index

 bowtie2-build ${reference} index

 """
}


process bowtie2_map {
publishDir "${params.outdir}", mode: "copy", overwrite: true
container "https://depot.galaxyproject.org/singularity/bowtie2%3A2.4.5--py39hd2f7db1_2"
  input:
  path fastq
  path index
  output:
  path "mapped.sam"
  script:
  if (fastq instanceof List) {
  """
   bowtie2 -x index -1 ${fastq[0]} -2 ${fastq[1]} -S mapped.sam
  """
 } else {
   """
   bowtie2 -x index -U ${fastq} -S mapped.sam

   """
 }
}


workflow {
reffile = channel.fromPath(params.ref)
reffile.view()
fastqs = channel.fromPath("${params.indir}/*fastq").collect()
fastqs.view()
indexchannel = bowtie2_index(reffile)
bowtie2_map(fastqs, indexchannel)
}
