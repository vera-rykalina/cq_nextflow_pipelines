#! /user/bin/env nextlow

params.ids =file("uniprot_ids.txt")

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

     shell:
     '''
     CONTENTS=$(cat !{x})
     curl https://www.uniprot.org/uniprot/${CONTENTS}.fasta
     '''
}

result.view{it.trim()}


