#!/usr/bin/env Rscript

# Calculate wordcount (https://github.com/RevolutionAnalytics/rmr2/blob/master/docs/tutorial.md)
# Requires rmr package (https://github.com/RevolutionAnalytics/RHadoop/wiki).

library(rmr2)

bp = rmr.options("backend.parameters");
#bp$hadoop[1] = "mapreduce.map.java.opts=-Xmx1024M";
#bp$hadoop[2] = "mapreduce.reduce.java.opts=-Xmx512M";
bp$hadoop[1] = "mapred.tasktracker.map.tasks.maximum=1";
bp$hadoop[2] = "mapred.tasktracker.reduce.tasks.maximum=1";
#bp$hadoop[3] = "mapreduce.map.memory.mb=1280";
#bp$hadoop[4] = "mapreduce.reduce.memory.mb=2560";
rmr.options(backend.parameters = bp);
rmr.options("backend.parameters")

wordcount = 
  function(
    input, 
    output = NULL, 
    pattern = " "){
    wc.map = 
      function(., lines) {
        keyval(
          unlist(
            strsplit(
              x = lines,
              split = pattern)),
          1)}
    wc.reduce =
      function(word, counts ) {
        keyval(word, sum(counts))}

    mapreduce(
      input = input ,
      output = output,
      input.format = "text",
      map = wc.map,
      reduce = wc.reduce,
      combine = T)}

from.dfs(wordcount("enwiki-latest-abstract1.xml"))
