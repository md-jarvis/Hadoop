tar -xzf pig-0.12.1.tar.gz 
mv pig-0.12.1 pig

sed -i " 1 i  export PIG_HOME=/root/client/pig/ " /root/.bashrc 
l=$((l+1))
sed -i " 1 i PATH=$PATH:/root/client/pig/bin/ " /root/.bashrc 
source /root/.bashrc 

