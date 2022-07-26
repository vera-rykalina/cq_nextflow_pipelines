nextflow.enable.dsl=2

process count_word {
  publishDir "/tmp/", mode: 'copy', overwrite: true
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
  inchannel = channel.fromPath("/Users/vera/Desktop/CQ/NGS/cq-examples/data/hat_full_of_sky.txt")
  count_word(inchannel, "you")
}
