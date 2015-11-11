#ip of master node or high availablity node 
master=$1

cd /etc/hadoop/

ip=` ifconfig eth0 | grep 192.168. | cut -d: -f2 | cut -d" " -f1 `

hdfs=`  cat -n hdfs-site.xml | grep '<configuration>' |  awk '{print $1 ;}' `
last=`  cat -n hdfs-site.xml | grep '</configuration>' |  awk '{print $1 ;}' `
ran1=$((hdfs+1))
ran2=$((last-1))
if [ $ran1 -ne $last ];then
sed -i "$ran1,$ran2 d" hdfs-site.xml
fi

umount /testing2
rm -rf /testing2
mkdir /testing2

mount -t nfs $master:/testing2 /testing2
sed -i "$hdfs a <property>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <name>dfs.name.dir</name>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a <value>/testing2</value>" hdfs-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" hdfs-site.xml

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
sed -i "$hdfs a <value>hdfs://$ip:9001</value>" core-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" core-site.xml
                                                                                                                                            

iptables -F
setenforce 0
service iptables save

hadoop-daemon.sh stop namenode
echo "Y" | hadoop namenode -format

hadoop-daemon.sh start namenode
/usr/java/jdk1.7.0_51/bin/jps

