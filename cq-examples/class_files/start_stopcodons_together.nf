nextflow.enable.dsl=2
//enabling the syntax extension for example worklow

process codoncount { // you can name the process as you wish
  publishDir "${params.outdir}", mode: 'copy', overwrite: true
  input: // we need it here, but not every process needs input
    tuple path(infile), val(codon) // adjusted to take a tuple as an input
    //path infile // path to the input file, needs to be path,
    //val codon // a string given, no path, no link, no file
  output:
    path "${infile}.${codon}.count" // exact name of produced file on line 13
  script:
    """
    grep -io ${codon} ${infile} | wc -l > ${infile}.${codon}.count
    """
    // grep finds the given string in a given file
    // -o only taking the string, and not the whole line
    // -i case-insensitive
    // wc -l counts lines
}

workflow {
  fastachannel = channel.fromPath(params.infasta)
  codons = channel.fromList(["ATG", "TCA", "TAA", "TGA"])
  // creating value channel from list
  combined_channel = fastachannel.combine(codons)
  combined_channel2 = codons.combine(fastachannel).view()
  // makes a product of the fastachannel and codons channel
  codoncount(combined_channel)
}
