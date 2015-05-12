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
   # input <- do.call(rbind,rep(list(matrix(rnorm(10*data_size, sd=10), ncol=2)), 20))
   #     + matrix(rnorm(200), ncol=2)
      input<-list(list(1,2), list(3,4), list(4,5), list(100,3))

     rhwrite(input, directory) 
    
    #Map function: Compute distances of points to centroids
    kmeans.map <- expression(
#lapply(map.values, function(P) {
    #Helper function: Euclidian distance
   {
    dist.fun <- function(C, P) {
        lapply(C,
          function(x)
            colSums((t(P) - x)^2))
    }
   for(i in seq_along(map.keys)) {
          k <- map.keys[[i]]
          r <- map.values[[i]]
          P <- list(k,r)
   
    
    rhcollect(k,r)
  }  
 })

    #Reduce: Compute new centroids
    kmeans.reduce <- expression(
         pre=   {total = NULL}, 
        reduce= {
                
                #  total <- if(total == NULL) t(as.matrix( lapply(reduce.values, sum)))
                #            else t(as.matrix( lapply(rbind(total, reduce.values), sum)))
	}, 
        post={rhcollect(reduce.key, length(reduce.values))})
    
    C = NULL
    for(i in 1:num_iterations ) {
       # job <- rhmr(map=kmeans.map,
       #     reduce = kmeans.reduce,
       #     inout=c("text","sequence"),
       #     ifolder=directory, ofolder="/output",
       #     mapred=mapred, jobname="kmeans") 
       # rhex(job)
  
    job <- rhwatch(
        map=kmeans.map,
        reduce = kmeans.reduce,
        input=rhfmt(directory,type="sequence"), 
        output="hdfs:///user/dotcz12/kmeansout",
        mapred=NULL,
	readback=TRUE,
        jobname="kmeans",
        verbose=T)
        C = rhread("hdfs:///user/dotcz12/kmeansout")
    }
    C
}

directory<-"hdfs:///user/dotcz12/kmeans"
#rhdel(directory)
kmeans_test(1,5,1, directory)
