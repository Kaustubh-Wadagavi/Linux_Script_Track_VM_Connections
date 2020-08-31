#! /bin/bash

getData()
{
	echo "Reading Data"
	touch output.txt
	now=$(date)
	echo "--------------------------------------------------------------------------------------------------------------">>output.txt
	echo "$now">>output.txt
	echo "--------------------------------------------------------------------------------------------------------------">>output.txt
	echo "$(netstat)">netstat.txt 
}

countTotalNumberOfTime_WaitConnections()
{
	countTotalNumberOfTimeWaitConnections=$(grep "TIME_WAIT" $file | wc -l)
	if [[ $countTotalNumberOfTimeWaitConnections -ge 3 ]]
	then 
			echo -e "\nTotal Number Of TIME_WAIT connections are :" $countTotalNumberOfTimeWaitConnections
	else
			echo -e "\nThere is no TIME_WAIT Connections on VM"
	   	exit
	fi
}

readAndCalculateData()
{	
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++">>output.txt
	echo "Connections ESTABLISHED and TIME_WAIT">>output.txt
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++">>output.txt
	echo "Procto Recv-Q Send-Q Local Address                Foreign Address                   State                     ">>output.txt
	while IFS=" " read a1 a2 a3 a4 a5 a6
	do 
		if [ "$a6" == "ESTABLISHED" ] || [ "$a6" == "TIME_WAIT" ] 
		then
				echo "$a1    $a2    $a3       $a4       $a5           $a6">>output.txt
		fi
	done <"$file"
}

touch netstat.txt
file=netstat.txt
getData
countTotalNumberOfTime_WaitConnections
readAndCalculateData
rm netstat.txt
echo "Data Saved in output.txt File"
