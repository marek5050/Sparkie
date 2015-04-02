#!/usr/bin/Rscript

library(rmr2)

args=commandArgs(trailingOnly = TRUE) 



bp =
  list(
    hadoop =
      list(
        D = paste("mapred.job.name=", args[[1]], sep=''),
        D = "mapreduce.map.memory.mb=11500",
        D = "mapreduce.reduce.memory.mb=11500",
        D = "mapreduce.map.java.opts=-Xmx11500M",
        D = "mapreduce.reduce.java.opts=-Xmx11500M",
        D = "mapreduce.tasktracker.map.tasks.maximum=1",
        D = "mapreduce.tasktracker.reduce.tasks.maximum=1",
        D = paste("mapreduce.job.maps=", args[[2]], sep=''),
        D = paste("mapred.reduce.tasks=", args[[3]], sep='')
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

wordcount(args[[4]])
