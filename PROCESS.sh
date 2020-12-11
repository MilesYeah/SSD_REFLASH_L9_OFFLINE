#!/bin/bash
cd /TEST
export PATH=$PATH:/sbin:/usr/sbin

# Enable extended globbing
shopt -s extglob

declare -A ModelList=()
IFS=$'\n'
for line in $(cat SSD_LIST.txt); do
	drive=$(echo $line | awk -F= '{print $1}')	
	fw=$(echo $line | awk -F= '{print $2}' | tr -d '\n' | tr -d '\r')	
	ModelList[$drive]=$fw
done

#ModelList["SSDPE2KX020T7"]="QDV10150" #MD17120849-005
#ModelList["SSDPE2KE016T7"]="QDV10150" #MD17120849-002
#ModelList["SSDPE21K375GA"]="QDV10150" #MD17120849-006 
#ModelList["SSDPE2KX010T7"]="QDV10150" #J30917-101 
#ModelList["SSDSC2BB150G7"]="N2010121" #MD17120849-004
#ModelList["SSDSC2BB480G7"]="N2010121" #MD17120849-004
#ModelList["SSDSC2BB240G7"]="N2010121" #J11256-002
#ModelList["SSDSCKJB480G7"]="N2010121" #MD17120248-001
#ModelList["SSDSC2KB240G7"]="SCV10111" #MD7503INT02
#ModelList["SSDSC2KB480G7"]="SCV10111" #J52618-000
#ModelList["SSDSC2KG480G7"]="SCV10111" #J52602-000
#ModelList["SSDSC2KB960G7"]="SCV10111" #J52619-000


declare -A DriveList=()

STARTTIME="$( date +"%T" | sed s/://g )"
STARTDATE="$( date +"%y%m%d")"
LOG_FILE="${STARTDATE}_${STARTTIME}_SSD_UPDATE.log"

IdentifyDrives() {
	FW_STATUS="UNKNOWN"	
	IFS=$'\n'
	for line in $(isdct show -intelssd)
	do
		regex="^Firmware :"
        if [[ $line =~ $regex ]]; then
			Firmware=$(echo $line | awk '{print $3}')
		fi
		regex="^ModelNumber"
        if [[ $line =~ $regex ]]; then
			ModelNumber=$(echo $line | awk '{print $4}')
		fi
		regex="^SerialNumber"
        if [[ $line =~ $regex ]]; then
			SerialNumber=$(echo $line | awk '{print $3}')
			if [ "${ModelList["$ModelNumber"]}" != "" ]; then
				if [ "$Firmware" == "${ModelList["$ModelNumber"]}" ]; then
					FW_STATUS="COMPLETE"
				else
					FW_STATUS="NEED"
				fi
			
				DriveList["$SerialNumber"]="$Index,$ModelNumber,$Firmware,$FW_STATUS" 
			fi
			FW_STATUS="UNKNOWN"	
		fi
		regex="^Index"
        if [[ $line =~ $regex ]]; then
			Index=$(echo $line | awk '{print $3}')
		fi
	done
}

#Find target drives
echo "-------------------------"
echo "FINDING DRIVES FOR UPDATE"
IdentifyDrives
declare -A InitialDriveList=()
for SN in "${!DriveList[@]}"
do
	InitialDriveList["$SN"]="${DriveList["$SN"]}"
done

for SerialNumber in "${!InitialDriveList[@]}"
do
	echo $SerialNumber ${InitialDriveList[$SerialNumber]}
done

#UpdateFW
Pids=()
REBOOT_NEEDED=NO
for SN in "${!InitialDriveList[@]}"
do
	Index=$(echo ${InitialDriveList[$SN]}|awk -F, '{print $1}')
	Model=$(echo ${InitialDriveList[$SN]}|awk -F, '{print $2}')
	Status=$(echo ${InitialDriveList[$SN]}|awk -F, '{print $4}')
	FW="${ModelList["$Model"]}"
	if [ "$Status" != "COMPLETE" ]; then
		if [ -d ${FW} ]; then
			#FW_image=$(find ${Model}/*.bin)
			FW_image=$(find ${FW}/*.bin)
			nohup echo -n Y | issdcm -drive_index $Index -firmware_update $FW_image  > issdcm_${SN}.log &
			#issdcm_pid=$!
			Pids+=($!)
		else
			nohup echo -n Y | isdct load -intelssd $SN > issdcm_${SN}.log &
			#issdcm_pid=$!
			Pids+=($!)
		fi
	else
		rm -f issdcm_${SN}.log
	fi
done

DriveUpdatingCnt=${#Pids[@]}
while [ $DriveUpdatingCnt -gt 0 ]
do
	DriveUpdatingCnt=0
	for pid in ${Pids[@]}
	do
		pidCnt=$( ps -o pid | grep -c $pid )
		DriveUpdatingCnt=$(( $DriveUpdatingCnt + $pidCnt ))
	done
	echo "$DriveUpdatingCnt drives updating FW"
	sleep 10
done


for SN in "${!InitialDriveList[@]}"
do
	if [ -f issdcm_${SN}.log ]; then
		cat issdcm_${SN}.log
		if [ $(grep -c "reboot the system" issdcm_${SN}.log) -gt 0 ]; 
		then
			REBOOT_NEEDED=YES
		fi
	fi
done

if [ $REBOOT_NEEDED == "YES" ]; then
	read -p "Please reboot to verify the update" -n1 -s
	exit
fi


#CheckFwStatus
echo ""
echo ""
echo "------------------------------------------------------------------"
echo "FINAL FW STATUS"
IdentifyDrives
echo "SN,INDEX,MODEL,FW,STATUS" | tee $LOG_FILE
for SN in "${!InitialDriveList[@]}"
do
	Index=$(echo ${InitialDriveList[$SN]}|awk -F, '{print $1}')
	if [ "${DriveList[$SN]}" == "" ]; then
		echo "$SN,$Index,UNKNOWN,MISSING" | tee -a $LOG_FILE
	else
		echo "$SN,${DriveList[$SN]}" | tee -a $LOG_FILE
	fi
done

wput -q $LOG_FILE ftp://128.101.1.1/tstcom/STATINID/LOG/
read -p "Hit ENTER to exit" -n1 -s

: <<'HISTORY'
v101.0: Adding "SSDSC2BB150G7"="N2010121"
v102.0: Adding SSDSC2KB240G7, FW=SCV10111 with issdcm support
v103.0: Adding SSDSC2KB480G7, FW SCV10111; SSDPE2KX010T7, FW QDV10150
v104.0: Adding SSDSC2BB240G7, FW N2010121, J11256-002
v105.0: Adding SSDSC2KG480G7, FW SCV10111, J52602-000
               SSDSC2BB240G7, FW N2010121, J11256-002
v106.0: Adding SSDSCKJB480G7, FW N2010121, J27336-001
v107.0: Adding SSDSC2KB960G7, FW SCV10111, J52619-000
v108.0: Moving drive list to separate file. 
        For updates using issdcm, use single FW folder instead of model folder
	Performing parallel updates
v108.1: Removing line ending when parsing SSD_LIST.txt

HISTORY
