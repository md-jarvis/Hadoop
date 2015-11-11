#!/bin/bash/

#scanning devices  
scan()
{
        nmap -p22 192.168.43.52/24 | grep "Nmap scan" | awk '{print $5}'
}


#sorting According to RAM 
sort_ip_ram()
{
	local line=` wc -l totalIp1.txt | cut -d" " -f1 `
	rm -f ipRam.txt
	for((i=1;i<=line;i++))
	do
		local ll=$i\p
		local ip=` sed -n "$ll" totalIp1.txt `
		local ram=` sshpass -p redhat ssh -o StrictHostKeyChecking=no $ip free -m | grep Mem: | awk '{print $2}' `
		if [ $ram -ge 0 ];then
			echo "$ip  $ram" >> ipRam.txt
		fi
	done

	sort -k 2 ipRam.txt > ip_ram_sort.txt
}


#list all ip for dialog 
list_ip()
{
local line=` cat totalip.txt | wc -l `
for((i=1;i<=line;i++))
	do
	j=$i\p
	a=`sed -n "$j" totalip.txt `
	echo -n "$i $a "
	echo off
done 
}



#total ip connected with network 
scan > totalIp.txt
own=` ifconfig eth0 | grep 192.168. | cut -d":" -f2 | cut -d" " -f1 `
l=`cat -n totalIp.txt | grep $own | awk '{ print $1 }' `
sed -i " $l d " totalIp.txt
cat totalIp.txt | grep 192.168. > totalIp1.txt

#soretd ip according to ram 
sort_ip_ram
cat ip_ram_sort.txt | cut -d" " -f1 > totalip.txt
cat totalip.txt

#total number ips 
line=` cat totalip.txt | wc -l `



#NAMENODE
dialog --backtitle "Hadoop Installation" \
	--title "NAMENODE" \
       --radiolist "SELECT ONE FOR NAMENODE "  0 0 $line \
	`list_ip ` 2>/tmp/namenode.txt


if [ $? -eq 0 ];then
	choice=`cat /tmp/namenode.txt`
	j=$choice\p
	namenodeIp=`sed -n "$j" totalip.txt `
	
	j=$choice
	sed -i " $j d " totalip.txt
	#configuration of namenode
	sshpass -p redhat ssh -o StrictHostKeyChecking=no $namenodeIp 'bash -s' < namenode.sh
fi


#secondary NAMENODE 
line=$((line-1))
dialog --backtitle "Hadoop Installation" \
	--title "SECONDARY NAMENODE" \
       --radiolist "SELECT ONE FOR SECONDARY NAMENODE "  0 0 $line \
	`list_ip ` 2>/tmp/namenode.txt


if [ $? -eq 0 ];then
	choice=`cat /tmp/namenode.txt`
	j=$choice\p
	second=`sed -n "$j" totalip.txt `
	
	j=$choice
	sed -i " $j d " totalip.txt
	#configuration of namenode
	sshpass -p redhat ssh -o StrictHostKeyChecking=no $second 'bash -s' < checkPointing.sh $namenodeIp
fi


#JOB TRACKER 
line=$((line-1))
dialog --backtitle "Hadoop Installation" \
	--title "JOBTRACKER" \
       --radiolist "SELECT ONE FOR JOBTRACKER "  0 0 $line \
	`list_ip ` 2>/tmp/jobtracker.txt

if [ $? -eq 0 ];then
	choice=`cat /tmp/jobtracker.txt`
	j=$choice\p
	JobtrackerIp=`sed -n "$j" totalip.txt `
	
	j=$choice
	sed -i " $j d " totalip.txt
	#configuratiion job tracker
	sshpass -p redhat ssh -o StrictHostKeyChecking=no $jobtrackerIp 'bash -s' < jobtracker.sh $namenodeIp
fi


#Task Tracker
line=$((line-1))
dialog --backtitle "Hadoop Installation" \
	--title "TASKTRACKER" \
       --checklist "SELECT ONE FOR TASKTRACKER "  0 0 $line \
	`list_ip ` 2>/tmp/jobtracker.txt
if [ $? -eq 0 ];then
sel=` cat namenode.txt | wc -w `
for((j=1;j<=sel;j++))
do
	t=f$j
	a=` cat namenode.txt | cut -d" " -$t `
	len=` echo $a | wc -c `
	len=$((len-3))
	ch=${a:1:$len}
	$j=$ch\p
	tasktrackerIp=`sed -n "$j" totalip.txt `
	
	# job tracker setup
	sshpass -p redhat ssh -o StrictHostKeyChecking=no $tasktrackerIp 'bash -s' < tasktracker.sh $jobtrackerIp
done
fi


#DATANODE
dialog --backtitle "Hadoop Installation" \
	--title "DATANODE" \
       --checklist "SELECT ONE FOR DATANODE "  0 0 $line \
	`list_ip ` 2>/tmp/jobtracker.txt
if [ $? -eq 0 ];then
sel=` cat namenode.txt | wc -w `
for((j=1;j<=sel;j++))
do
	t=f$j
	a=` cat namenode.txt | cut -d" " -$t `
	len=` echo $a | wc -c `
	len=$((len-3))
	ch=${a:1:$len}
	$j=$ch\p
	datanodeIp=`sed -n "$j" totalip.txt `
	
	# job tracker setup
	sshpass -p redhat ssh -o StrictHostKeyChecking=no $datanodeIp 'bash -s' < datanode.sh $namenodeIp
done
fi

#END 
