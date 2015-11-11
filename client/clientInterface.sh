createUser()
{
	ip=192.168.43.102
	dialog --inputbox "Please Enter Username" 8 40 2> tmp1.txt
 	user=`cat tmp1.txt`
	dialog --insecure --passwordbox "Please Enter password" 8 40 2> tmp2.txt
	pass=`cat tmp2.txt`
	sshpass -p redhat ssh -o StrictHostKeyChecking=no $ip 'bash-s' < createuser.sh $user $pass
	mkdir /home/$user
	mount -t nfs 192.168.43.102:/home/$user /home/$user 
	cp -r user /home/$user	
}

checkpoint()
{
	hadoop dfsadmin -safemode enter > tmp1.txt
	a=`cat tmp1.txt`
	dialog --infobox "$a" 0 0
	hadoop dfsadmin -safemode get > tmp1.txt
	a=`cat tmp1.txt`
	dialog --infobox "$a" 0 0
	hadoop dfsadmin -saveNamespace > tmp1.txt
	hadoop dfsadmin -safemode leave > tmp1.txt
	dialog --msgbox "Successfull" 0 0
}
#createUser()
#{
#	dialog --inputbox "Please Enter Username" 8 40 2> tmp1.txt
# 	user=`cat tmp1.txt`
#	dialog --insecure --passwordbox "Please Enter password" 8 40 2> tmp2.txt
#	pass=`cat tmp2.txt`
#	useradd $user 2> execute.txt
#	#dialog --textbox execute.txt 0 0
#	if [ $? -nq 0 ];then
#		dialog --msgbox "User Already Exists" 8 40 
#		return;
#	fi

#	echo $pass | passwd $user --stdin > execute.txt
#	dialog --textbox execute.txt 0 0 
#	hadoop fs -mkdir /user/$user 2> execute.txt
#	#dialog --textbox execute.txt 0 0
#	chown $user /user/$user 2> execute.txt
#	#dialog --textbox execute.txt 0 0
#	bash clientInterface.sh
#}

setQuota()
{
	dialog --menu "Select Your Choice" 0 0 2 1 "Space Quota" 2 "Storage Quota"  2>tmp1.txt
	
	choice=`cat tmp1.txt`

	case $choice in
	1)
		dialog --inputbox "Enter number of files" 8 40 2> tmp1.txt
 		files=`cat tmp1.txt`
		dialog --inputbox "Enter Username" 8 40 2> tmp1.txt
		usr=`cat tmp1.txt`
		hadoop dfsadmin -setQuota $files /user/$usr > execute.txt
		a= `cat execute.txt | wc -l`
		if [ $a -ne 0 ]
		then
		dialog --textbox execute.txt 0 0
		fi		
		if [ $? -eq 0 ];then
			dialog --msgbox "Successfully Done" 8 23
		else
			dialog --msgbox "User does not exists" 8 40 
		fi
	;;
	2)
		dialog --inputbox "Enter Space Size" 8 40 2> tmp1.txt
 		files=`cat tmp1.txt`
		dialog --inputbox "Enter Username" 8 40 2> tmp1.txt
		usr=`cat tmp1.txt`
                hadoop dfsadmin -setSpaceQuota $files /user/$usr > execute.sh
		dialog --textbox execute.txt 0 0
                if [ $? -eq 0 ];then
                	dialog --msgbox "Successfully Done" 8 20 
		else
			dialog --msgbox "User does not exists" 8 20 
		fi
        ;;

	esac
	bash clientInterface.sh
}

setBlockSize()
{
	dialog --inputbox "Enter block Size:" 8 40 2> tmp1.txt
 	block=`cat tmp1.txt`
	
	line=` cat -n hdfs-site.xml | grep "</configuration>" | cut -d" " -f1 ` 
	sed -i " i $line <property><name>dfs.block.size</name><value>$block</value></property>" hdfs-site.xml 
	bash clientInterface.sh
	
}

setReplication()
{
	dialog --inputbox "Enter the number of replicas" 8 40 2> tmp1.txt
 	rapl=`cat tmp1.txt`
	
	line=` cat -n hdfs-site.xml | grep "</configuration>" | cut -d" " -f1 `
        sed -i " i $line <property><name>dfs.raplication</name><value>$rapl</value><property>" hdfs-site.xml
	bash clientInterface.sh

}




dialog --menu "Select Your Choice" 0 40 12 1 "Create User" 2 "Set Quota" 3 "View Storage Status"  4 "View Quota Status" 5 "Put File" 6 "Browse File" 7 "set Block Size" 8 "Set Number of Replications" 9 "Display Active TaskTrackers" 10 "Process a Job" 11 "Install Frameworks" 12 "Checkpoint" 13 "Exit" 2>tmp.txt


ch=`cat tmp.txt` 

case "$ch" in
1)
	createUser
;;
2)
	setQuota
;;
3)	dialog --inputbox "Enter file name" 8 40 2> tmp1.txt	
	f=`cat tmp1.txt`
	hadoop fs -du $f > execute.txt
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
4)
	dialog --inputbox "Enter file name" 8 40 2> tmp1.txt	
	f=`cat tmp1.txt`
	hadoop fs -count $f > execute.txt
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
5)	
	dialog --inputbox "Enter file name" 8 40 2> tmp1.txt	
	f=`cat tmp1.txt`
	hadoop fs -put $f / > execute.txt 
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
6)	dialog --inputbox "Enter file name" 8 40 2> tmp1.txt	
	f=`cat tmp1.txt`
	hadoop fs -cat $f > execute.txt
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
7)
	setBlockSize
;;
8)
	setReplication
;;
9)
	hadoop job -list-active-trackers > execute.txt
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
10)
	bash processJob.sh
	bash clientInterface.sh
;;
11)
	bash framework.sh
	bash clientInterface.sh
;;
12)
	checkpoint
	bash clientInterface.sh
	
;;	
13)
esac

