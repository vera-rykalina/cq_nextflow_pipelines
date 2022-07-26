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
  publishDir params.outdir, mode: 'copy', overwrite: true
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

workflow {
  inchannel = channel.fromPath(params.infile)
  splitfiles = split_file(inchannel)
  count_word(splitfiles.flatten(), params.word)
}
