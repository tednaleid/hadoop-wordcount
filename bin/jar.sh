# might need to replace the hadoop version jar below if you don't have this
if [ ! -d out ]; then
    mkdir out
fi

HADOOP_JAR=$HADOOP_HOME/hadoop-core-0.20.2-cdh3u3.jar

if [ ! -f $HADOOP_JAR ]; then
    echo "missing hadoop jar $HADOOP_JAR, please change to the appropriate path"
    exit 1
fi

javac -classpath $HADOOP_JAR -d out src/org/myorg/WordCount.java && jar -cvf wordcount.jar -C out/ .
