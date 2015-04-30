#!/usr/bin/env Rscript
############################################################################################
## K-Means
############################################################################################

library(Rhipe)
rhinit()
rhoptions(runner = 'sh /home/dotcz12/R/lib64/R/library/Rhipe/bin/RhipeMapReduce.sh',
	"HADOOP.TMP"='/user/dotcz12/tmp')

kmeans_test <- function(data_size, num_clusters, num_iterations, directory) {
    #Create data and move data to HDFS
   # input <- do.call(rbind,rep(list(matrix(rnorm(10*data_size, sd=10), ncol=2)), 20))    + matrix(rnorm(200), ncol=2)
   input<-list()
   for(i in 1:(10*data_size)) input<-c(input,list(list(rnorm(1, sd=10),rnorm(1,sd=10))));
   rhwrite(input, file=directory) 
    
    #Helper function: Euclidian distance
   # dist.fun <- function(C, P) {
   #     apply(C, 1,
   #       function(x)
   #         colSums((t(P) - x)^2))
   # }

    #Map function: Compute distances of points to centroids

    # mapper <- expression(lapply(map.values, function(P) {
    mapper <- expression(lapply(map.values, function(P) {
            dist.fun <- function(C, P) {
               lapply(C,
                 function(x){
                   colSums((t(P) - x)^2)
		})
           }

        nearest = function(P){
            if(is.null(C))
                sample(1:num_clusters, nrow(P), replace = T)
            else {
                distance <- dist.fun(C, P)
                nearest <- max.col(-distance)
            }
        }
        #rhcollect(nearest,P)
        lapply(nearest, FUN=rhcollect, value=P)
    }))

    #Reduce: Compute new centroids
    reducer <- expression(
        pre = function(reduce){
            total = NULL
        },
    	reduce = function(reduce){
            total <- if(total == NULL) (as.matrix(lapply(reduce.values, sum)))
         else (as.matrix(lapply(rbind(total, reduce.values), 2, sum)))
         }, 
         post = function(reduce){
            rhcollect(reduce.key, total)
            # lapply(reduce.key, FUN=rhcollect, value=total)
        }
    )

    
    C = NULL
      for(i in 1:num_iterations ) {
    job <- rhwatch(
        map=mapper,
        reduce = reducer,
        input=rhfmt(directory,type="sequence"), 
        output="hdfs:///user/dotcz12/kmeansout",
        mapred=NULL,
        jobname="kmeans",
        verbose=TRUE) 
        # rhex(job)  
        C = rhread("hdfs:///user/dotcz12/kmeansout")
      }
        write.table( data.frame(words=unlist(lapply(X=C,FUN="[[",1)),
                          count=unlist(lapply(X=C,FUN="[[",2))),
               file="/home/dotcz12/out/brokenfile",
               quote=FALSE,
                 append=TRUE,
               row.names=FALSE,
               col.names=FALSE,
               sep="\t"
               )
}

directory<-"hdfs:///user/dotcz12/kmeans"
rhdel(directory)
kmeans_test(1,5,5, directory)
