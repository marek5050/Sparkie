#!/usr/bin/env Rscript
#https://github.com/glennklockwood/paraR/blob/master/streaming/wordcount-streaming-reducer.R#
options(warn=-1)

last_key <- ""
running_total <- 0
stdin <- file('stdin','r')
#stdout<- file("stdout",open='rw')
#stdout2 <- pipe(" awk -v var='$mycol_new' -F $'\t' 'BEGIN {OFS = FS} {print}'", open='r')

outputCount <- function(word,count){
            cat(last_key,'\t',running_total,'\n',sep='')
}


while ( length(line <- readLines(stdin, n=1 , warn=FALSE)) > 0 ) {
   # line <- gsub('(^\\s+)|(\\s+$)', '', line)
    keyvalue <- unlist(strsplit(line, split='\t', fixed=TRUE))
    this_key <- keyvalue[[1]]
    value <- as.numeric(keyvalue[[2]])

    if ( identical(last_key,this_key) ) {
        running_total <- running_total + value
    }
    else {
        if ( !identical(last_key,"") ) {
	  outputCount(last_key,value)
	}
        running_total <- value
        last_key <- this_key
    }
}

if ( last_key == this_key ) {
            outputCount(last_key,running_total)
}
close(stdin)
