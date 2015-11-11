# ip of namenode from argument
nameNodeIp=$1

#share dir to namenode 
rm -rf /testing2
mkdir /testing2
chmod 777 /testing2 -R
echo "/testing2 $nameNodeIp(sync,rw) " >>  /etc/exports
service nfs restart
chkconfig nfs on

#putting entry in hadoop file 
cd /etc/hadoop/
hdfs=`  cat -n hdfs-site.xml | grep '<configuration>' |  awk '{print $1 ;}' `
last=`  cat -n hdfs-site.xml | grep '</configuration>' |  awk '{print $1 ;}' `
ran1=$((hdfs+1))
ran2=$((last-1))
if [ $ran1 -ne $last ];then
sed -i "$ran1,$ran2 d" hdfs-site.xml
fi

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
sed -i "$hdfs a <value>hdfs://$nameNodeIp:9001</value>" core-site.xml
hdfs=$((hdfs+1))
sed -i "$hdfs a </property>" core-site.xml
                                                                                                                                            
#flushing iptables to avoid firewall problems
iptables -F
setenforce 0
service iptables save

#END

