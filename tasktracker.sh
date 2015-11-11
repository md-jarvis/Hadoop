#put configuration entry in mapred-site.xml 
cd /etc/hadoop/
sed -i "$hdfs a <property>" mapred-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>mapred.job.tracker</name>" mapred-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>$1:9002</value>" mapred-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" mapred-site.xml

#start tasktracker 
hadoop-daemon.sh stop tasktracker
hadoop-daemon.sh start tasktracker

# display status 
 /usr/java/jdk1.7.0_51/bin/jps
exit
