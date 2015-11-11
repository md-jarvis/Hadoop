useradd $1
if [ $? -nq 0 ];then
		dialog --msgbox "User Already Exists" 8 40 
		return;
fi
echo $2 | passwd $1 --stdin > execute.txt
dialog --textbox execute.txt 0 0 
hadoop fs -mkdir /user/$1 2> execute.txt
dialog --textbox execute.txt 0 0 
chown $1 /user/$1 2> execute.txt
dialog --textbox execute.txt 0 0 
bash clienInterface.sh

chmod 777 /home/$1
sed -i " 1 i /home/$1 192.168.43.52(sync,rw) " /etc/exports
service nfs restart
chkconfig nfs on