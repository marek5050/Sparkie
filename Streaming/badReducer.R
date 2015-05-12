#! /usr/bin/Rscript
# reducer.R - Wordcount program in R
# script for Reducer (R-Hadoop integration)

trimWhiteSpace <- function(line) gsub("(^ +)|( +$)", "", line)
splitLine <- function(line) {
	val <- unlist(strsplit(line, "\t", fixed=TRUE))
	list(word = val[1], count = as.integer(val[2]))
}

env <- new.env(hash = TRUE)
con <- file("stdin", open = "r")

count <-0
cur_word<-""

while (length(line <- readLines(con, n = 10000, warn = FALSE)) > 0){
	line <- trimWhiteSpace(line)
	split <- splitLine(line)
	word <- split$word
	if(cur_word!=word){
	  cat(cur_word,"\t",count,"\n",sep="") 
	  cur_word=word
          count=split$count
	}else{
	  count=count+split$count
	}
}
cat(cur_word,"\t",count,"\n",sep="")
close(con)

