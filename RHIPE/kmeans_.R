#--------------Iter.R Code--------------------------------------------------------------------- 
library(Rhipe) 
 # providing the initial centres 
firstCenter<-c(16929,28295) 
secondCenter<-c(34357,44202) 
thirdCenter<-c(47667,64978) 
 #writing the centers to a file 

write("Initial Centers",file="IterativeMR/centers",append=TRUE) 
write(firstCenter,file=" /IterativeMR/centers",append=TRUE) 
write(secondCenter,file="IterativeMR/centers",append=TRUE) 
write(thirdCenter,file="IterativeMR/centers",append=TRUE) 
  
write("---------------------------------------------",file="IterativeMR/centers",append=TRUE)
rhsave(firstCenter,secondCenter,thirdCenter,file="data/centers.Rdata") 

 for( j in 1:10) 
 { 
         #deleting the output file of the map reduce job 
 #       rhdel("/out01") if the out01 doesnt exit and if  trying to 
#delete then it will throw the error and doesnt continue with the next 
#statement.Need to delete this file for subsequent iteration so for the 
#first iteration don’t delete the file. Also  preserve this file for 
#the final output 
 if( j > 1) 
      rhdel("/out01") 
      source("/home/drilldown/RKmeans/IterativeMR/kmd.R") 
   # reading the output and calculating the new centers and replacing the previous center 

 output<-rhread("/out01/part-r-00000") 
 centers<-list(output[[1]][[1]],output[[2]][[1]],output[[3]][[1]]) 
 center1<-c(mean(output[[1]][[2]]$col.x),mean(output[[1]][[2]]$col.y)) 
 center2<-c(mean(output[[2]][[2]]$col.x),mean(output[[2]][[2]]$col.y)) 
 center3<-c(mean(output[[3]][[2]]$col.x),mean(output[[3]][[2]]$col.y)) 

  for(i in 1:length(centers)) 
       { 
                 if ( identical(centers[[i]],firstCenter)) 
                 { 
                         firstCenter = center1 
                 } 
               else if(identical(centers[[i]], secondCenter)) 
                 { 
                         secondCenter = center2 

                  } 
                 else if (identical(centers[[i]],thirdCenter)) 
                  { 
                          thirdCenter = center3 
                  } 
         } 

  #writing the new centers to a file 
write(paste("Center After iteration",j,sep=":"),file="IterativeMR/centers",append=TRUE)      
write(firstCenter,file="IterativeMR/centers",append=TRUE) 
write(secondCenter,file="IterativeMR/centers",append=TRUE) 
write(thirdCenter,file="IterativeMR/centers",append=TRUE) 
write("---------------------------------------------",file="/home/drilldown/RKmeans/IterativeMR/centers",append=TRUE) 

#deleting the previous centers and output 
rhdel("data/centers.Rdata") 

#saving the new centers 
rhsave(firstCenter,secondCenter,thirdCenter,file="data/centers.Rdata") 
 } 


#-------------------------------------- Kmean.R--------------------------------------------------- 
library(Rhipe) 
rhinit() 
map.setup = expression({ 
    load("centers.Rdata") # no need to give full path 
 }) 

map<-expression({ 
 y<-do.call("rbind",lapply(map.values,function(r){ 
  as.numeric(strsplit(r," ")[[1]]) 
 })) 

 if(nrow(y) > 0) 
 { 
 col.x = y[,1] 
 col.y = y[,2] 
 c1<-firstCenter 
 c2<-secondCenter 
 c3<-thirdCenter 
 centerMat<-rbind(c1,rbind(c2,c3)) 

 #forming the full data frame 
 d<-data.frame(col.x=col.x,col.y=col.y,stringsAsFactors=FALSE) 

 #Appeding the center matrix to the top of the data frame 
 dmat<-rbind(centerMat,as.matrix(d)) 

 #Finding the euclidean distance 
 reqMat<-(as.matrix(dist(dmat,method="euclidean")))[4:nrow(y),1:3] 

 #creating three data frame for three different centers 
 d1<-data.frame()#data frame for centre1 
 d2<-data.frame()#data frame for centre2 
 d3<-data.frame()#data frame for centre3 

 for( i in 1:nrow(reqMat) ) 
 { 
      minimum = which.min(reqMat[i,]) 
      if(minimum==1)      d1<-rbind(d1,d[i, ]) 
      else if(minimum==2) d2<-rbind(d2,d[i, ]) 
      else if(minimum==3) d3<-rbind(d3,d[i, ]) 
 } 
  rhcollect(c1,d1) 
  rhcollect(c2,d2) 
  rhcollect(c3,d3) 
 } 
 }) 

 reduce<-expression( 
    pre = { collect<-NULL } , 
 reduce = { 
               collect<-rbind(collect,do.call("rbind",reduce.values)) 
            }, 
   post = { 
                rhcollect(reduce.key,collect) 
           } 
   ) 
 mapred<- 
list(rhipe_map_buff_size=20,mapred.task.timeout=0,mapred.reduce.tasks=) 

ifolder="/km" 
ofolder="/out01" 
z<- rhmr(map=map,reduce=reduce,inout=c("text","sequence"),ifolder=ifolder,
  ofolder=ofolder,setup=map.setup, 
  shared=c("data/centers.Rdata"),
  mapred=mapred,
  jobname="kairo") 
rhex(z) 