#! /user/bin/env nextlow

params.str = "Hello world!"

process splitLetters {
        

        output:
        file "chunk_*" into letters

        script:
        """
        printf "${params.str}" | split -b 6 - chunk_
        """
}

process convertToUpper {
 
     input:
     file x from letters.flatten()

     output:
     stdout result

     script:
     """
     rev $x 
     """ 
}

result.view{
it.trim()
}
