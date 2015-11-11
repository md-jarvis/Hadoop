cd /etc/hadoop/
ip=` ifconfig eth0 | grep 192.168. | cut -d: -f2 | cut -d" " -f1 `

hdfs=`  cat -n mapred-site.xml | grep '<configuration>' |  awk '{print $1 ;}' `
last=`  cat -n mapred-site.xml | grep '</configuration>' |  awk '{print $1 ;}' `
ran1=$((hdfs+1))
ran2=$((last-1))
if [ $ran1 -ne $last ];then
sed -i "$ran1,$ran2 d" mapred-site.xml
fi

sed -i "$hdfs a <property>" mapred-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>mapred.job.tracker</name>" mapred-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>$ip:9002</value>" mapred-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" mapred-site.xml

hdfs=`  cat -n core-site.xml | grep '<configuration>' |  awk '{print $1 ;}' `
last=`  cat -n core-site.xml | grep '</configuration>' |  awk '{print $1 ;}' `
ran1=$((hdfs+1))
ran2=$((last-1))
if [ $ran1 -ne $last ];then
sed -i "$ran1,$ran2 d" core-site.xml
fi

sed -i "$hdfs a <property>" core-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>fs.default.name</name>" core-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>hdfs://$1:9001</value>" core-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" core-site.xml

iptables -F
setenforce 0
service iptables save

hadoop-daemon.sh stop jobtracker
hadoop-daemon.sh start jobtracker

/usr/java/jdk1.7.0_51/bin/jps

