#!/usr/bin/Rscript
# give each node in the cluster cls an ID number 
assignids <- function(cls) {    
   clusterApply(cls,1:length(cls), 
      function(i) myid <<- i) 
} 

# each node executes this function 
getwords <- function(basename) { 
   fname <- paste(basename,".",myid,sep="")
   words <- scan(fname,what="") 
   words
} 

# manager 
wordcount <- function(cls,basename) { 
   assignids(cls) 
   clusterExport(cls,"getwords") 
   lists <- clusterCall(cls,getwords,basename)
   freq <- table(unlist(lists));
   freq
}

# call example:
library(parallel)
c2 <- makeCluster(2)
wordcount(c2,"words")
