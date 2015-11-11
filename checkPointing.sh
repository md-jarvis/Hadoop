# ip of namenode as an argument 
nameIp=$1
cd /etc/hadoop/

ip=` ifconfig eth0 | grep 192.168. | cut -d: -f2 | cut -d" " -f1 `

hdfs=`  cat -n hdfs-site.xml | grep '<configuration>' |  awk '{print $1 ;}' `
last=`  cat -n hdfs-site.xml | grep '</configuration>' |  awk '{print $1 ;}' `
ran1=$((hdfs+1))
ran2=$((last-1))
if [ $ran1 -ne $last ];then
sed -i "$ran1,$ran2 d" hdfs-site.xml
fi

rm -rf /testing1/  

# putting configuration entry in hdfs-site.xml                                                                                                                                            
sed -i "$hdfs a <property>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>dfs.httpd.address</name>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>$nameIp:50070</value>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" hdfs-site.xml

hdfs=$((hdfs+1))
sed -i "$hdfs a <property>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>dfs.secondary.httpd.address</name>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>$ip:50090</value>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" hdfs-site.xml

hdfs=$((hdfs+1))
sed -i "$hdfs a <property>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>fs.checkpoint.dir</name>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>/testing1</value>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" hdfs-site.xml

hdfs=$((hdfs+1))
sed -i "$hdfs a <property>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>fs.checkpoint.edits.dir</name>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>/new</value>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" hdfs-site.xml

hdfs=$((hdfs+1))
sed -i "$hdfs a <property>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>fs.checkpoint.period</name>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>60</value>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" hdfs-site.xml

# get line number for entry
hdfs=`  cat -n core-site.xml | grep '<configuration>' |  awk '{print $1 ;}' `
last=`  cat -n core-site.xml | grep '</configuration>' |  awk '{print $1 ;}' `
ran1=$((hdfs+1))
ran2=$((last-1))
if [ $ran1 -ne $last ];then
sed -i "$ran1,$ran2 d" core-site.xml
fi

#put configuration entry in core-site.xml 
sed -i "$hdfs a <property>" core-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>fs.default.name</name>" core-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>hdfs://$nameIp:9001</value>" core-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" core-site.xml
                                                                                                                                            

iptables -F

#start secondary namenode
hadoop-daemon.sh stop secondarynamenode
hadoop-daemon.sh start secondarynamenode
/usr/java/jdk1.7.0_51/bin/jps

