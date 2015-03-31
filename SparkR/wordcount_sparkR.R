# YARN_CONF_DIR=/etc/hadoop/conf MASTER=yarn-client SparkR-pkg-master/sparkR wordcount_sparkR.R yarn-client /tmp/data/20news-all/alt.atheism/54564

# MASTER=spark-yarn YARN_CONF_DIR=/etc/hadoop/conf ./SparkR-pkg-master/sparkR wordcount_sparkR.R yarn-client /tmp/data/20news-all/alt.atheism/54564

library(SparkR)

time0=proc.time()

args=commandArgs(trailingOnly = TRUE)

if(length(args) != 2){
  cat("USE: ./sparkR wordcount.r <master> <file> ")
  q("no")
}

# Initialize Spark context
sc=sparkR.init(args[[1]],"RWordCount")

lines = textFile(sc, args[[2]])

words = flatMap(lines, 
                function(line){
                  strsplit(line, " ")[[1]]
})

wordCount = lapply(words, 
                   function(word){
                      list(word, 1L)
})

count = reduceByKey(wordCount, "+", 2L)

output = collect(count)
proc.time()-time0

# for (kv in output){
#   cat (kv[[1]], " : ", kv[[2]], "\n")
# }

#res = as.data.frame(do.call("rbind", output))
#sink("output-sparkR")
#res
#sink()

