import sys
from operator import add

from pyspark import SparkContext

print >> sys.stdout, sys.argv[1], " " , sys.argv[2] , " " , sys.argv[3]

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print >> sys.stderr, "Usage: wordcount <name> <file> <output file>"
        exit(-1)
    sc = SparkContext(appName=sys.argv[1])
    lines = sc.textFile(sys.argv[2], 1)
    counts = lines.flatMap(lambda x: x.split(' ')) \
                  .map(lambda x: (x, 1)) \
                  .reduceByKey(add)
    output = counts.collect()

    counts.saveAsTextFile(sys.argv[3])
	
    sc.stop()
