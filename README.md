This repo holds a working version of [Hadoop WordCount](http://wiki.apache.org/hadoop/WordCount) app that's the 'hello world" of hadoop jobs.

The docs on the hadoop wiki are a bit unclear/miselading and I also needed to make a couple of tweaks to the script, including adding the jar to the classpath with `setJarByClass` so the full test jar can be found.

This runs successfully on the Cloudera cdh3u3 distro, and I think should also work on other recent versions such as the Apache "0.20.205.0" release.

    cd /usr/local
    curl -O http://archive.cloudera.com/cdh/3/hadoop-0.20.2-cdh3u3.tar.gz
    tar xzvf tar xzvf hadoop-0.20.2-cdh3u3.tar.gz    

And adding these things to your bashrc/zshrc:

    export HADOOP_VERSION=hadoop-0.20.2-cdh3u3
    export HADOOP_HOME="/usr/local/$HADOOP_VERSION"
    export HADOOP_INSTALL=$HADOOP_HOME
    export PATH=$PATH:$HADOOP_HOME/bin

    export HADOOP_HEAPSIZE=2000
    export HADOOP_OPTS="-server -Djava.security.krb5.realm=OX.AC.UK -Djava.security.krb5.kdc=kdc0.ox.ac.uk:kdc1.ox.ac.uk"

    alias hadoopstart='start-all.sh'
    alias hadoopstop='stop-all.sh'
    alias hadoopstatus="jps | egrep '(TaskTracker|JobTracker|DataNode|NameNode|SecondaryNameNode)'"
    
    # hadoop dfs commands
    for CMD in "ls" "cat" "tail" "rm" "rmr" "mkdir" "chown" "chmod"; do
        alias "h$CMD"="hadoop dfs -$CMD"
    done


Then making these changes to the $HADOOP_HOME/conf files:

    diff --git a/conf/core-site.xml b/conf/core-site.xml
    index 970c8fe..4a08cc2 100644
    --- a/conf/core-site.xml
    +++ b/conf/core-site.xml
    @@ -4,5 +4,14 @@
     <!-- Put site-specific property overrides in this file. -->
     
     <configuration>
    -
    +    <property>
    +        <name>hadoop.tmp.dir</name>
    +        <value>/usr/local/tmp/hadoop</value>
    +        <description>A base for other temporary directories.</description>
    +    </property>
    +     
    +    <property>
    +        <name>fs.default.name</name>
    +        <value>hdfs://localhost:8020</value>
    +    </property>    
     </configuration>
    diff --git a/conf/hdfs-site.xml b/conf/hdfs-site.xml
    index 970c8fe..37cfa0d 100644
    --- a/conf/hdfs-site.xml
    +++ b/conf/hdfs-site.xml
    @@ -4,5 +4,8 @@
     <!-- Put site-specific property overrides in this file. -->
     
     <configuration>
    -
    +    <property>
    +        <name>dfs.replication</name>
    +        <value>1</value>
    +    </property>        
     </configuration>
    diff --git a/conf/mapred-site.xml b/conf/mapred-site.xml
    index 970c8fe..21cdfbd 100644
    --- a/conf/mapred-site.xml
    +++ b/conf/mapred-site.xml
    @@ -4,5 +4,8 @@
     <!-- Put site-specific property overrides in this file. -->
     
     <configuration>
    -
    +    <property>
    +        <name>mapred.job.tracker</name>
    +        <value>localhost:8021</value>
    +    </property>    
     </configuration>
    
You can then format the hadoop file system:

    hadoop namenode -format 
 
(this will create a `dfs` directory in the directory you specified for the `hadoop.tmp.dir` property in core-site.xml. 

Then you should be able to run hadoop with:

    hadoopstart

(this command will ssh into localhost, so you might need to set up your ssh public key in your own authorized_keys file to avoid getting prompted for a password for each one)    

You should be able to get to the [job tracker](http://localhost:50030) and the [name node](http://localhost:50070) in a web browser now.

To run the wordcount sample, use these commands:

first, copy the test files into the hadoop distributed file system:
  
    bin/copy-input-to-hadoop.sh 

then, compile and jar up the `WordCount.java` application. 
    
    bin/jar.sh

lastly, run the app and see the results

    bin/run.sh

