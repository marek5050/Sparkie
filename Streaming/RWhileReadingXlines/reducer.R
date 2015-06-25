#! /usr/bin/Rscript

# mapper.R - Wordcount program in R
# script for Mapper (R-Hadoop integration)

trimWhiteSpace <- function(line) gsub("(^ +)|( +$)", "", line)
splitIntoWords <- function(line) unlist(strsplit(line, "[[:space:]]+"))

## **** could wo with a single readLines or in blocks
con <- file("stdin", open = "r")
whileCount <-0
forCount<-0

while (length(line <- readLines(con, n = 1000, warn = FALSE)) > 0) {
 whileCount<-whileCount+1

  line <- trimWhiteSpace(line)
  words <- splitIntoWords(line)
  ## **** can be done as 
# cat(paste(words, "\t1\n", sep=""), sep="")
 for (w in words){
     forCount<-forCount+1
     cat(w,"\t",whileCount," ",forCount,"\n",sep="")
#  if(nchar(trimWhiteSpace(w)) >0 & w!=' ' && w!='\t') cat(w, "\t1\n", sep="") 
 }
}

close(con)
