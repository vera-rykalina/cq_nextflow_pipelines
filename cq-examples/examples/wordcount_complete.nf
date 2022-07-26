nextflow.enable.dsl=2

process split_file {
  input:
    path infile
  output:
    path "${infile}.line*"
  script:
    """
    split -l 1 ${infile} -d ${infile}.line
    """
}

process count_word {
  input:
    path infile
    val word
  output:
    path "${infile}.wordcount", emit: wordcount
  script:
    """
    grep -o -i ${word} ${infile} > grepresult
    cat grepresult | wc -l > ${infile}.wordcount
    """
}

process calculate_total {
  publishDir params.outdir, mode: 'copy', overwrite: true
  input:
    path infiles
  output:
    path "wordcount"
  script:
    """
    cat ${infiles} | paste -sd "+" | bc > wordcount
    """
}

workflow {
  if(!file(params.infile).exists()) {
    println("Input file ${params.infile} does not exist.")
    exit(1)
  }
  inchannel = channel.fromPath(params.infile)
  splitfiles = split_file(inchannel)
  allcounts = count_word(splitfiles.flatten(), params.word)
  calculate_total(allcounts.collect())
}
