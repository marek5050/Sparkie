# SPARKR_USE_SPARK_SUBMIT=1 YARN_CONF_DIR=/etc/hadoop/conf MASTER=yarn-client SparkR-pkg-master/sparkR wordcount.R yarn-client jobnameSpark /user/dotcz12/data/book.txt ./out/wordcount_spark

library(SparkR)

time0=proc.time()

args=commandArgs(trailingOnly = TRUE)

#if(length(args) != 3){
#  cat("USE: ./sparkR wordcount.r <master> <job name> <file> <output> ")
#  q("no")
#}

# Initialize Spark context
sc <- sparkR.init(master=args[[1]],appName=args[[2]], sparkEnvir=list(spark.driver.memory="2g",spark.driver.cores="4",spark.executor.memory="11g"))
lines <- textFile(sc, args[[3]])

words <- flatMap(lines,
                 function(line) {
                   strsplit(line, " ")[[1]]
                 })
wordCount <- lapply(words, function(word) { list(word, 1L) })

counts <- reduceByKey(wordCount, "+", 2L)
output = collect(counts)
# saveAsTextFile(counts,args[[4]])
proc.time()-time0

# for (kv in output){
#   cat (kv[[1]], " : ", kv[[2]], "\n")
# }

res = as.data.frame(do.call("rbind", output))
sink("output-sparkR")
res
sink()
