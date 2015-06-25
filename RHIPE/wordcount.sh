#!/usr/bin/env Rscript
################################################################################
#   Simple Word Counter for Rhipe 0.73
#
#   Glenn K. Lockwood, San Diego Supercomputer Center               August 2013
################################################################################

library(Rhipe)
rhinit()
rhoptions(runner = 'sh /home/dotcz12/R/lib64/R/library/Rhipe/bin/RhipeMapReduce.sh')

#input.file.local <- 'sample.txt'
input.user.dir <- paste('/user/',Sys.getenv('USER'),sep='')

args=commandArgs(trailingOnly = TRUE)

rhclean()

if(length(args) < 2){
  input.file.name<- 'book100.txt'
 # input.file.name <- 'enwiki-latest-pages-meta-current1.xml'
  input.testnum<-1
  num_reducers<-0
  num_mappers<-10
}else{
  input.testnum <- args[[1]] 
  input.file.name <- args[[2]]
  num_reducers<- args[[4]]
  num_mappers<- as.integer(args[[3]])
}

input.file.hdfs <- paste(input.user.dir,'/data/',input.file.name,sep='')
output.dir.hdfs <- paste(input.user.dir,'/out/',format(Sys.time(), "%H%M%OS"),input.file.name,sep='')
output.file.local <- paste('rhipe_',input.file.name,num_mappers,'M',num_reducers,'R',sep='')

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
# -Dmapred.job.name="$TEST-$MAPPER_COUNT-$REDUCER_COUNT-$INPUT" \
# -Dmapreduce.job.maps=$MAPPER_COUNT \
# -Dmapreduce.job.reduces=$REDUCER_COUNT \
# -Dmapreduce.map.java.opts=-Xmx12000M \
# -Dmapreduce.reduce.java.opts=-Xmx12000M \
# rhwatch launches the Hadoop job
#            , mapred.map.tasks=num_mappers #CDH3,4
#           , mapred.reduce.tasks=num_reducers #CDH3,4
 
 mapred = list(
            mapred.task.timeout=1
	    , mapred.max.split.size=as.integer(1024*1024*num_mappers)
            , mapreduce.job.reduces=num_reducers #CDH3,4
        )
rhipe.results <- rhwatch(
                        map=mapper, reduce=reducer,
                        input=rhfmt(input.file.hdfs, type="text"),
                        output=output.dir.hdfs,
                        jobname=paste("rhipe-",num_mappers,num_reducers,input.file.name,sep="-"),
                        mapred=mapred)

                        # mapred=list(paste("mapreduce.job.maps",num_mappers,sep='='),
            #, mapred.job.reuse.jvm.num.tasks=-1
            #, mapreduce.job.jvm.numtasks=-1
                        #   paste("mapreduce.job.reduces",num_reducers,sep='=')))
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
