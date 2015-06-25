library(rmr2);
bp = rmr.options("backend.parameters");
bp$hadoop[1] = "mapred.tasktracker.map.tasks.maximum=1";
bp$hadoop[2] = "mapred.tasktracker.reduce.tasks.maximum=1";
rmr.options(backend.parameters = bp);
rmr.options("backend.parameters")

n=10000
num=c(rnorm(n=n,mean=0), rnorm(n=n,mean=1),
      rnorm(n=n,mean=2), rnorm(n=n,mean=3))
groups=rep(0:3,each=n)
s=proc.time()
tapply(num,groups,mean)
proc.time()-s

dat=cbind(num,groups)
input=to.dfs(dat)
map=function(k,v){
  val=v[,1]
  key=v[,2]
  keyval(key,val)
}
reduce=function(k,v){
  keyval(k,mean(v))
}

s=proc.time()
res=mapreduce(input=input,map=map,reduce=reduce)
print(res())
print(from.dfs(res))
proc.time()-s




