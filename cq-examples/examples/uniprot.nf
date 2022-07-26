#! /user/bin/env nextlow

params.ids = file("uniprot_ids.txt")

process splitIds {

     output:
     file "chunk_*" into uniprots
     script:

     """
       split -l 1 ${params.ids} chunk_
     """
}

process getUniprot {
 
     input:
     file x from uniprots.flatten()

     output:
     stdout result

     script:
     """
     cat ${x}
     """ 
}

result.view{
it.trim()
}



