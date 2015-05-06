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
  set.seed(2)
  input<-list()
  for(i in 1:(10*data_size)) input<-c(input,list(list(rnorm(1, sd=10),rnorm(1,sd=10))));
  rhwrite(input, file="hdfs:///user/dotcz12/centerInput") 
  
  #Helper function: Euclidian distance
  # dist.fun <- function(C, P) {
  #     apply(C, 1,
  #       function(x)
  #         colSums((t(P) - x)^2))
  # }
  #Map function: Compute distances of points to centroids
  
  # mapper <- expression(lapply(map.values, function(P) {
  mapper<-function(k,v){
    #c<-do.call(rbind, Map(data.frame, A=k, B=v))
    #c
    #k<-kmeans(c,5)
    #map<-kmeans(map)
    #rhcollect(k$centers[1],k$B$centers[2])
    # rhcollect(length(k),length(v))
    #rhcollect(nearest,P)
    #lapply(nearest, FUN=rhcollect, value=P)
  }
 
setup=expression(
    map={
 
        load("centers.Rdata") # no need to give full path loadlo
	#Z<-load("session.Rdata")
        #C<-list(a=list(0,0),b=list(5,5),c=list(6,6))  
     }, 
   reduce={

   }) 

  mapper <- expression({
     # C=list(a=list(0,0),a=list(5,5))  
    #c<-do.call(rbind, Map(data.frame, A=map.keys, B=map.values)) 
    #rhcollect(length(map.keys),length(map.values))
    #k<-kmeans(c,5)
    #l<-data.frame(k$centers)
    #rhcollect(k$centers[1],k$centers[2])
    #for( a in 1:length(l$A)){
     # ADD=ADD+1
     # rhcollect(l$A[a],l$B[a])
    #}
 
    dist.fun <- function(C, P) {
      sapply(C,
             function(x){
		  rowSums((as.data.frame(P) - as.data.frame(x))^2)
             })
    }
    
   for(i in seq_along(map.keys)) {
          k <- map.keys[[i]]
          r <- map.values[[i]]
          P <- data.frame(X=k,Y=r)
    
    nearest = {
      if(is.null(C))
        sample(1:num_clusters, nrow(P), replace = T)
      else {
         distance <- dist.fun(C, P)
         nearest <- max.col(t(-distance))
       }
      }     
       rhcollect(nearest,P)
    #    rhcollect(length(C),P)
    }
 })
  #Reduce: Compute new centroids
  reducer <- expression(
    pre = {
        total<-NULL
    },
    reduce = {
      #total<-total+1
       centroid<-lapply(do.call(rbind, reduce.values), mean)
       rhcollect(centroid$X,centroid$Y)
      # for(i in seq_along(reduce.values))
      #   rhcollect(reduce.values[[i]]$X, reduce.values[[i]]$Y)
      #  }  
    }, 
    post = {
      #rhcollect(reduce.key,length(reduce.values))      
     # rhcollect(reduce.key,length(reduce.values))      
    }
  )
   
  #C=data.frame(list(1,2),list(2,3),list(4,3))
  #C<-list(a=list(0,0),b=list(5,5),c=list(6,6))  
   C<-NULL
   rhsave(C,num_clusters, file="hdfs:///user/dotcz12/centers.Rdata") 
  
   for(i in 1:num_iterations ){
    job <- rhwatch(
      map=mapper,
      reduce=reducer,
      input=rhfmt("hdfs:///user/dotcz12/centerInput",type="sequence"), 
      output="hdfs:///user/dotcz12/kmeansout",
      setup=setup,
      mapred=NULL,
      shared=c("hdfs:///user/dotcz12/centers.Rdata"),
      readback=TRUE,
      jobname="kmeans",
      verbose=TRUE) 
    # rhex(job) 
    # job 
    C = rhread("hdfs:///user/dotcz12/kmeansout")
    rhsave(C,num_clusters,file="hdfs:///user/dotcz12/centers.Rdata")
  }
   C
}

directory<-"hdfs:///user/dotcz12/kmeans"
#rhdel(directory)
kmeans_test(1,3,2, directory)

