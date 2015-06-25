library(rmr2);
bp = rmr.options("backend.parameters");
#bp$hadoop[1] = "mapreduce.map.java.opts=-Xmx1024M";
#bp$hadoop[2] = "mapreduce.reduce.java.opts=-Xmx512M";
bp$hadoop[1] = "mapred.tasktracker.map.tasks.maximum=1";
bp$hadoop[2] = "mapred.tasktracker.reduce.tasks.maximum=1";
#bp$hadoop[3] = "mapreduce.map.memory.mb=1280";
#bp$hadoop[4] = "mapreduce.reduce.memory.mb=2560";
rmr.options(backend.parameters = bp);
rmr.options("backend.parameters")

#groups = rbinom(100, n = 500, prob = 0.5)
#tapply(groups, groups, length)

groups = rbinom(100, n = 500, prob = 0.5)
groups = to.dfs(groups)
result = mapreduce(input = groups, map = function(k,v) keyval(v, 1),
                   reduce = function(k,vv) keyval(k, length(vv)))
print(result())
print(from.dfs(result))
