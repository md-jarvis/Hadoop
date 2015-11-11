tar -xzf apache-hive-0.13.1-bin.tar.gz 
mv apache-hive-0.13.1-bin hive

sed -i " 1 i export HIVE_HOME=/root/client/hive/ " /root/.bashrc 
l=$((l+1))
sed -i " 1 i  PATH=$PATH:/root/client/hive/bin/ " /root/.bashrc 
source /root/.bashrc 

