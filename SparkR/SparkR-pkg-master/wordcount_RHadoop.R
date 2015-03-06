# Rscript wordcount_RHadoop.R /tmp/data/20news-all/alt.atheism/54564
library(rmr2)
bp = 
  list(
    hadoop = 
      list(
        D = "mapreduce.map.memory.mb=4096",
        D = "mapreduce.reduce.memory.mb=12000",
        D = "mapreduce.map.java.opts=-Xmx3072M",
        D = "mapreduce.reduce.java.opts=-Xmx9600M",
        D = "mapreduce.tasktracker.map.tasks.maximum=1",
        D = "mapreduce.tasktracker.reduce.tasks.maximum=1"))
rmr.options(backend.parameters = bp);
rmr.options("backend.parameters")

time0 = proc.time() 
  
args=commandArgs(trailingOnly = TRUE)

if(length(args) != 1){
  cat("USE: Rscript wordcount.r <file> ")
  q("no")
}

hdfs.data = args[[1]]

map = function(key, lines){
  words.list = strsplit(lines, " ")
  words = unlist(words.list)
  
  keyval(words, 1)
}

reduce = function(word, val) {
  keyval(word, sum(val))
}

wordcount= function(input, output=NULL){
  mapreduce(input=input,
            output=output,
            input.format="text",
            map = map,
            reduce = reduce)
}

res = wordcount(hdfs.data)
proc.time()-time0

sink("ouput-RHadoop")
as.data.frame(from.dfs(res))
sink()


