#! /usr/bin/Rscript

# reducer.R - Wordcount program in R
# script for Reducer (R-Hadoop integration)

trimWhiteSpace <- function(line) gsub("(^ +)|( +$)", "", line)

splitLine <- function(line) {
  val <- unlist(strsplit(line, "\t"))
  list(word = val[1], count = as.integer(val[2]))
}

env <- new.env(hash = TRUE)

word_count <- 0
prev_word <- ""

con <- file("stdin", open = "r")
while (length(line <- readLines(con, n = 10000, warn = FALSE)) > 0) {
  val<-strsplit(line, "\n")
  for(i in seq(val)){
  line <- trimWhiteSpace(val[[i]])
   cat(line,sep="")
  }
 }
close(con)

#for (w in ls(env, all = TRUE))
#  cat(w, "\t", get(w, envir = env), "\n", sep = "")
