#!/usr/bin/Rscript

library(rmr2)

args=commandArgs(trailingOnly = TRUE) 

jobname<-args[[1]]
mapper_count<-args[[2]]
reducer_count<-args[[3]]
input.file<-args[[4]]


bp =
  list(
    hadoop =
      list(
        D = paste("mapred.job.name=", jobname, sep=''),
        D = "mapreduce.map.memory.mb=11500",
        D = "mapreduce.reduce.memory.mb=11500",
        D = "mapreduce.map.java.opts=-Xmx11500M",
        D = "mapreduce.reduce.java.opts=-Xmx11500M",
        D = "mapreduce.tasktracker.map.tasks.maximum=1",
        D = "mapreduce.tasktracker.reduce.tasks.maximum=1",
        D = paste("mapreduce.job.maps=", mapper_count, sep=''),
        D = paste("mapred.job.reduces=", reducer_count, sep='')
                                        ))


rmr.options(backend.parameters = bp);

rmr.options("backend.parameters")

wordcount = 
    function(input, output = NULL, pattern = " "){
        wc.map = function(., lines) {
            keyval(unlist(strsplit(
               x = lines,
               split = pattern)),1)}

 	wc.reduce = function(word, counts ) {
	    keyval(word, sum(counts))}
	      
	mapreduce(input = input,
            output = output,
            input.format = "text",
	    map = wc.map,
            reduce = wc.reduce,
	    combine = T, 
            verbose = TRUE)}


#output.file.local<-cat("rhadoop_M",mapper_count,"R",reducer_count,input.file,sep="")
#result<-wordcount(input.file)
wordcount(input.file)
#results<-from.dfs(result)

#write.table( data.frame(words=unlist(lapply(X=results,FUN="[[",1)),
#                         count=unlist(lapply(X=results,FUN="[[",2))),
#              file=jobname,
#              quote=FALSE,
#              row.names=FALSE,
#              col.names=FALSE,
#              sep="\t"
              )
