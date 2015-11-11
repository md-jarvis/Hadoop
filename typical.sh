
#function for scanning devices  
scan()
{
        nmap -p22 192.168.43.54/24 | grep "Nmap scan" | awk '{print $5}'
}


#sorting According to RAM 
sort_ip_ram()
{
	local line=` wc -l totalIp1.txt | cut -d" " -f1 `
	rm -f ipRam.txt
	for((i=2;i<=line;i++))
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

#total ip connected with network  
scan > totalIp.txt
own=` ifconfig eth0 | grep 192.168. | cut -d":" -f2 | cut -d" " -f1 `
l=`cat -n totalIp.txt | grep $own | awk '{ print $1 }' `
sed -i " $l d " totalIp.txt
l=`cat -n totalIp.txt | grep 192.168.43.1 | awk '{ print $1 }' `
sed -i " $l d " totalIp.txt
l=`cat -n totalIp.txt | grep 192.168.43.118 | awk '{ print $1 }' `
sed -i " $l d " totalIp.txt
l=`cat -n totalIp.txt | grep 192.168.43.83 | awk '{ print $1 }' `
sed -i " $l d " totalIp.txt
cat totalIp.txt | grep 192.168. > totalIp1.txt

# soretd ip according to ram 
sort_ip_ram
cat ip_ram_sort.txt | cut -d" " -f1 > totalip.txt
cat totalip.txt

#total number ipes 
line=` cat totalip.txt | wc -l `

#high availablity
# ip of namenode
namenodeIp=` sed -n '2p' totalip.txt `
myip=` sed -n '1p' totalip.txt `
sshpass -p redhat ssh -o StrictHostKeyChecking=no $myip 'bash -s' < highavailablity.sh $namenodeIp
sshpass -p redhat scp moniter $myip:/



#Setup NAMENODE 
#configuration of namenode
sshpass -p redhat ssh -o StrictHostKeyChecking=no $namenodeIp 'bash -s' < namenode.sh $myip


#setup JOBTRACKER
# ip of job tracker
jobtrackerIp=` sed -n '2p' totalip.txt `
#configuratiion job tracker
sshpass -p redhat ssh -o StrictHostKeyChecking=no $jobtrackerIp 'bash -s' < jobtracker.sh $namenodeIp


#secondary Namenode 

# ip of secondary namenode
#second=` sed -n '3p' totalip.txt `
#configuratiion job secondary
#sshpass -p redhat ssh -o StrictHostKeyChecking=no $second 'bash -s' < checkPointing.sh $namenodeIp


#setup DATANODE and TASKTRACKER
for((i=3;i<=line;i++))
do
	a=$i\p
        ip=` sed -n "$a" totalip.txt `
        sshpass -p redhat ssh -o StrictHostKeyChecking=no $ip 'bash -s' < dataTask.sh $namenodeIp $jobtrackerIp

done


#Setup CLIENT OF CLUSTER 
bash client.sh $namenodeIp $jobtrackerIp

#showing details whatever is done during installation process
echo "Moniter $myip"
echo "nameNode $namenodeIp"
echo "jobTracker $namenodeIp"

#END OF PROCESS OF INSTALLATION
