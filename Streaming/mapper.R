#!/usr/bin/env Rscript
#https://github.com/glennklockwood/paraR/blob/master/streaming/wordcount-streaming-mapper.R
options(warn=-1)

outputCount= function(key, value) {
    cat(key,'\t',value,'\n',sep='')
}

stdin <- file('stdin', open='r')

while ( length(line <- readLines(stdin, n=1, warn=FALSE)) > 0 ) {
    #line <- gsub('(^\\s+|\\s+$)', '', line)
    keys <- unlist(strsplit(line, split=' ',fixed=TRUE))
    value <- 1
    lapply(keys, FUN=outputCount, value=value)
}
close(stdin)
