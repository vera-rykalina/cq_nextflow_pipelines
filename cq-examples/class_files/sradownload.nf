nextflow.enable.dsl = 2

//  container "https://depot.galaxyproject.org/singularity/"

// everyting
// the main difference between storeDir and publishDir:
// store dir SKIPS the process if the file exists at destination
// publishDir RUNS the process, and overwrites the file to the destination

// container: if mentioned
// AND -profile singularity is given on a command line
// AND we have nextflow.config with singularity instruction
// if singularity image is not in the singularity cache directory
// it is downloaded to the singularity cacheDir (mentioned in nextflow.config)
// if singularity image is in the cacheDir, it will be started when starting a process

process prefetch {
  storeDir "${params.outdir}" //storing moves the output of the process to store directory from the work folder
  container "https://depot.galaxyproject.org/singularity/sra-tools:2.11.0--pl5262h314213e_0"
  input:
    val sra_id
  output:
    path "${sra_id}/${sra_id}.sra" // this folder structure is the special one produced by prefeth!
  script:
    """
    prefetch ${sra_id} # produces the SRR*/SRR*.sra
    """
}

process fastqdump {
  container "https://depot.galaxyproject.org/singularity/sra-tools:2.11.0--pl5262h314213e_0"
  publishDir "${params.outdir}", mode: "copy", overwrite: true // copies output to the mentioned dir.
  input:
    path infile_sra // this file path will be linked into a working dir of this process!
  output:
    path "${infile_sra.getSimpleName()}.fastq" // SRR*.fastq
  script:
    """
    fasterq-dump "${infile_sra}" # translates to fastq-dump SRR*.sra
    """
}

workflow {
  // starting process prefetch with a value channel params.accession from command line (--accession)
  // throw the prefetch output path into a channel called sraresult
  // pipe the sraresult channel into the process fastqdump
  sraresult = prefetch(params.accession)
  fastqdump(sraresult)
}
