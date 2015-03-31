#!/usr/bin/env Rscript
################################################################################
#   Simple Word Counter for Rhipe 0.73
#
#   Glenn K. Lockwood, San Diego Supercomputer Center               August 2013
################################################################################

library(Rhipe)
rhinit()
#rhoptions(runner=paste(getwd(),'/rhipe-runner.sh',sep=''))
rhoptions(runner = 'sh /home/dotcz12/R/lib64/R/library/Rhipe/bin/RhipeMapReduce.sh')

#input.file.local <- 'sample.txt'
input.user.dir <- paste('/user/',Sys.getenv('USER'),sep='')

input.file.name <- 'enwiki-latest-pages-meta-current1.xml'
input.file.hdfs <- paste(input.user.dir,'/data/',input.file.name,sep='')
output.dir.hdfs <- paste(input.user.dir,'/out/',format(Sys.time(), "%H%M%OS"),input.file.name,sep='')
output.file.local <- paste('output_',format(Sys.time(), "%H%M%OS"),input.file.name,sep='')

mapper <- expression( {
    # 'map.values' is a list containing each line of the input file
    lines <- gsub('(^\\s+|\\s+$)', '', map.values)
    keys <- unlist(strsplit(lines, split='\\s+'))
    value <- 1
    lapply(keys, FUN=rhcollect, value=value)
} )

reducer <- expression(
    # 'reduce.key' is equivalent to this_key and set by Rhipe
    # 'reduce.values' is a list of values corresponding to this_key
    # 'pre' is executed before we process a new reduce.key
    # 'reduce' is executed for 'reduce.values'
    # 'post' is executed once all reduce.values are processed
    pre = {
        running_total <- 0
    },
    reduce = {
        running_total <- sum(running_total, unlist(reduce.values))
    },
    post = {
        rhcollect(reduce.key, running_total)
    }
)

# equivalent to hadoop dfs -copyFromLocal
#rhput(input.file.local, input.file.hdfs)

# rhwatch launches the Hadoop job
rhipe.results <- rhwatch(
                        map=mapper, reduce=reducer,
                        input=rhfmt(input.file.hdfs, type="text"),
                        output=output.dir.hdfs,
                        jobname='Wordcount ')
#                        mapred=list("mapred.reduce.tasks=100","mapred.tasktracker.reduce.tasks.maximum=100","mapred.tasktracker.map.tasks.maximum=1000","mapreduce.reduce.java.opts=-Xmx12g","mapreduce.map.java.opts=-Xmx12g"))
# the mapred=... parameter is optional in rhwatch() above

# results on HDFS are in Rhipe object binary format, NOT ASCII, and must be
# read using rhread().  results becomes a list of two-item lists (key,val)
results <- rhread(paste(output.dir.hdfs, "/part-*", sep = ""))

# the data.frame() below converts list of (key,val) to a list of keys and
# a list of vals, then dumps these into a file with tab delimitation
write.table( data.frame(words=unlist(lapply(X=results,FUN="[[",1)), 
                        count=unlist(lapply(X=results,FUN="[[",2))), 
             file=output.file.local,
             quote=FALSE, 
             row.names=FALSE, 
             col.names=FALSE,
             sep="\t"
             )
