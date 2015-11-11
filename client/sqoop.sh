tar -xzf sqoop-1.4.5.bin__hadoop-1.0.0.tar.gz  
mv sqoop-1.4.5.bin__hadoop-1.0.0 sqoop
tar mysql-connector-java-5.1.35.tar.gz
cp mysql-connector-java-5.1.35/mysql-connector-java-5.1.35-bin.jar /root/client/sqoop/lib/


sed -i " 1 i  export SQOOP_HOME=/root/client/sqoop/ " /root/.bashrc
sed -i " 1 i  export HADOOP_COMMON_HOME=/usr/ " /root/.bashrc
sed -i " 1 i  export HADOOP_MAPRED_HOME=/etc/hadoop/ " /root/.bashrc
sed -i " 1 i  PATH=$PATH:/root/client/sqoop/bin/ " /root/.bashrc
source /root/.bashrc
sqoop version
sqoop help  

