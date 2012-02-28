working version of [Hadoop WordCount] app that's the 'hello world" of hadoop jobs.

The docs on the hadoop wiki are a bit unclear/miselading and I also needed to make a couple of tweaks to the script, including adding the jar to the classpath.

This runs successfully on 

    cd /usr/local
    curl -O http://archive.cloudera.com/cdh/3/hadoop-0.20.2-cdh3u3.tar.gz
    tar xzvf cloudera-demo-vm-cdh3u3-vmware.tar.gz    

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
    +        <value>/Volumes/home/hadoop</value>
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


Then you should be able to run hadoop with:

    hadoopstart

And then run these commands to get the wordcount going:

    bin/copy-input-to-hadoop.sh 
    bin/jar.sh
    bin/run.sh

