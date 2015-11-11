dialog --menu "Select Your Choice" 70 50 11 1 "HIVE" 2 "Pig" 3 "Sqoop"  2>/tmp/frame.txt

ch=` cat /tmp/frame.txt `

	case $ch in
	1)
		#sshpass -p redhat scp apache-hive-0.13.1-bin.tar.gz root@clientIp:/
		bash hive.sh 
	;;
	2)
		#sshpass -p redhat scp pig-0.12.1.tar.gz root@clientIp:/
		bash pig.hive.sh 
	;;
	3)
		#sshpass -p redhat scp sqoop-1.4.5.bin__hadoop-1.0.0.tar.gz root@clientIp:/
		bash sqoop.sh
	;;
	esac
