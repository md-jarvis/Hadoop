
dialog --menu "Select Your Choice" 0 40 12 1 1 "View Storage Status"  2 "View Quota Status" 3 "Put File" 4 "Browse File" 5 "Display Active TaskTrackers" 6 "Process a Job"   7 "Exit" 2>tmp.txt


ch=`cat tmp.txt` 

case "$ch" in

1)	dialog --inputbox "Enter file name" 8 40 2> tmp1.txt	
	f=`cat tmp1.txt`
	hadoop fs -du $f 2> execute.txt
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
2)
	dialog --inputbox "Enter file name" 8 40 2> tmp1.txt	
	f=`cat tmp1.txt`
	hadoop fs -count $f 2> execute.txt
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
3)	
	dialog --inputbox "Enter file name" 8 40 2> tmp1.txt	
	f=`cat tmp1.txt`
	hadoop fs -put $f / > execute.txt 
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
4)	dialog --inputbox "Enter file name" 8 40 2> tmp1.txt	
	f=`cat tmp1.txt`
	hadoop fs -cat $f > execute.txt
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
5)
	hadoop job -list-active-trackers 2> execute.txt
	dialog --textbox execute.txt 0 0
	bash clientInterface.sh
;;
6)
	processJob.sh
	bash clientInterface.sh
;;
7)
	umount /home/$USER
;;	
esac

