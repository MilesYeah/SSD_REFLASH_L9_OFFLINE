#!/bin/bash
cd /TEST
export PATH=$PATH:/sbin:/usr/sbin

# https://www.intel.com/content/www/us/en/support/articles/000017245/memory-and-storage.html


if [ -z $1 ]; then
    DEBUG=FALSE
else
    DEBUG=TRUE
fi


# Enable extended globbing
shopt -s extglob

# series that need special tool to get FW updated.
REGX_DCT="(D5-P4618)"
REGX_FUT="(X18-M|X25-M|X25-E)"
#REGX_MAS="()"


VERSION_INTELMAS="1.10.155"
VERSION_ISDCT="3.0.26.400"
VERSION_ISSDCM="3.0.3"

# store required fw version
declare -A ModelList=()
# parse drive list at the beginning: "$Index,$ModelNumber,$Firmware,$FW_STATUS,$ProductFamily"
declare -A DriveList=()
# drive list while need an update
declare -A InitialDriveList=()
# Array to store drive update process ID
Pids=()


REBOOT_NEEDED=NO

STARTTIME="$( date +"%T" | sed s/://g )"
STARTDATE="$( date +"%y%m%d")"
LOG_FILE="./log/${STARTDATE}_${STARTTIME}_SSD_UPDATE.log"
if [ ! -d "log" ]; then
    mkdir log
fi






#------------------------------------------------------------------------------------------------
#                Function definition start
#------------------------------------------------------------------------------------------------
function debug_quit()
{
    echo "Debug point, quit now..."

    exit
}



function pauseToCheck(){
    if [ -z $1 ]; then
        msg="Debug point, Ctrl+C to quit..."
    else
        msg=$1
    fi

    read -p "${msg}" -n1 -s

}



function show_pass()
{
    echo ""
    echo         PPPPP     AA     SSS    SSS          
    echo         PP  PP    AA    S   S  S   S         
    echo         PP   P   A  A   S      S             
    echo         PP  PP   A  A    SSS    SSS          
    echo         PPPPP    A  A       S      S         
    echo         PP       AAAA       S      S         
    echo         PP      A    A  S   S  S   S         
    echo         PP      A    A   SSS    SSS
    echo ""

}



function show_fail()
{
    echo ""
    echo        FFFFFFF   AA    IIIIII  LL     
    echo        FF        AA      II    LL     
    echo        FF       A  A     II    LL     
    echo        FFFFF    A  A     II    LL     
    echo        FF       A  A     II    LL     
    echo        FF       AAAA     II    LL     
    echo        FF      A    A    II    LL     
    echo        FF      A    A  IIIIII  LLLLLLL
    echo ""

}



function make_pretty_log_header()
{
    # $1 is log header message
    # $2 is log header level, the smaller the more ---
    if [[ $2 = "3" ]]; then
        echo -e "------------------------------\n" >> local_log.log
    elif [[ $2 = "2" ]]; then
        echo -e "\n------------------------------------------------------------\n" >> local_log.log
    else
        echo -e "\n\n\n------------------------------------------------------------------------------------------\n" >> local_log.log
    fi

    echo $1 >> local_log.log
}



function check_tool_version()
{

    echo "================================================================================"
    echo "Checking whether tool versions are expected"

    rpm -qa > app_list
    if [ `grep -i intelmas app_list | grep -c "${VERSION_INTELMAS}"` -lt 1 ]; then
        echo "intelmas version: `grep -i intelmas app_list`"
        read -p "Unexpected intelmas version, please update it..."
        exit 1
    fi

    if [ `grep -i isdct app_list | grep -c "${VERSION_ISDCT}"` -lt 1 ]; then
        echo "isdct version: `grep -i isdct app_list`"
        read -p "Unexpected isdct version, please update it..."
        exit 1
    fi

    if [ `grep -i issdcm app_list | grep -c "${VERSION_ISSDCM}"` -lt 1 ]; then
        echo "issdcm version: `grep -i issdcm app_list`"
        read -p "Unexpected issdcm version, please update it..."
        exit 1
    fi

}



function get_std_drive_firmware()
{
    echo "================================================================================"
    echo "Getting standard drive firmware list"

    IFS=$'\n'
    for line in $(cat SSD_LIST.txt); do
        drive=$(echo $line | awk -F= '{print $1}')	
        fw=$(echo $line | awk -F= '{print $2}' | tr -d '\n' | tr -d '\r')	
        ModelList[$drive]=$fw
    done

    echo ""
    echo "#-----------------------------"
    echo "Standard drive firmware list"
    for drive in ${!ModelList[@]}
    do
        echo ${drive} : ${ModelList[$drive]}
    done

}

IdentifyDrives() {
    FW_STATUS="UNKNOWN"	
    IFS=$'\n'
    make_pretty_log_header Detecting_Drive_firmwares 2
    date >> local_log.log
    intelmas show -o json -intelssd >> local_log.log
    for line in $(intelmas show -intelssd)
    do
        # echo ${line} >> local_log.log
        regx="^DeviceStatus :"
        if [[ $line =~ $regx ]]; then
            DeviceStatus=$(echo $line | awk '{print $3}')
            continue
        fi

        regx="^Firmware :"
        if [[ $line =~ $regx ]]; then
            Firmware=$(echo $line | awk '{print $3}')
            continue
        fi

        regx="^Index :"
        if [[ $line =~ $regx ]]; then
            Index=$(echo $line | awk '{print $3}')
            continue
        fi

        regx="^ModelNumber :"
        if [[ $line =~ $regx ]]; then
            ModelNumber=$(echo $line | awk '{print $4}')
            continue
        fi

        regx="^ProductFamily :"
        if [[ $line =~ $regx ]]; then
            ProductFamily=$(echo $line | awk -F: '{print $2}')
            continue
        fi

        regx="^SerialNumber :"
        if [[ $line =~ $regx ]]; then
            SerialNumber=$(echo $line | awk '{print $3}')
            # echo SerialNumber: ${SerialNumber}
            if [ "${ModelList["$ModelNumber"]}" != "" ]; then
                if [ "$Firmware" == "${ModelList["$ModelNumber"]}" ]; then
                    FW_STATUS="COMPLETE"
                else
                    FW_STATUS="NEED"
                fi
                DriveList["$SerialNumber"]="$Index;$ModelNumber;$Firmware;$FW_STATUS;$ProductFamily;$DeviceStatus"
            fi
            FW_STATUS="UNKNOWN"	
        fi

        # if [ $SerialNumber ]; then 
        #     echo $SerialNumber: ${DriveList["$SerialNumber"]}
        # fi
    done

    # copy drive array to a new array
    for SerialNumber in "${!DriveList[@]}"
    do
        InitialDriveList["$SerialNumber"]="${DriveList["$SerialNumber"]}"
    done

}


function update_drive_firmware()
{
    echo "================================================================================"
    echo "Updating drive firmwares..."
    make_pretty_log_header "Updating Firmware for each drive..." 2
    date >> local_log.log

    #UpdateFW
    for SN in "${!InitialDriveList[@]}"
    do
        Index=$(echo ${InitialDriveList[$SN]} | awk -F ";" '{print $1}')
        Model=$(echo ${InitialDriveList[$SN]} | awk -F ";" '{print $2}')
        FW_STATUS=$(echo ${InitialDriveList[$SN]} | awk -F ";" '{print $4}')
        ProductFamily=$(echo ${InitialDriveList[$SN]} | awk -F ";" '{print $5}')
        DeviceStatus=$(echo ${InitialDriveList[$SN]} | awk -F ";" '{print $6}')
        FW="${ModelList["$Model"]}"

        # echo $Index, $Model, $FW_STATUS, $ProductFamily, $DeviceStatus, $FW

        echo "--> Updating firmware for: ${SN}" >> issdcm_${SN}.log
        if [ "$FW_STATUS" != "COMPLETE" ]; then
            if [ -d ${FW} ]; then
                #FW_image=$(find ${Model}/*.bin)
                FW_image=$(find firmware_image/${FW}/*.bin)
                echo "Using issdcm to load local FW image to drive ${SN}..."
                nohup echo -n Y | issdcm -drive_index $Index -firmware_update $FW_image  > issdcm_${SN}.log &
                # echo "Using intelmas to load local FW image to drive ${SN}..."
                # nohup echo -n Y | intelmas load –source ${FW_image} –intelssd ${Index}  > issdcm_${SN}.log &

                # issdcm_pid=$!
                # Pids+=($!)
            else
                if [[ $ProductFamily =~ $REGX_DCT ]]; then
                    echo "Using isdct to update REGX_DCT FW. For ${SN}..."
                    nohup echo -n Y | isdct load -intelssd ${SN} > issdcm_${SN}.log &
                elif [[ $ProductFamily =~ $REGX_FUT ]]; then
                    echo "Using issdfut to update REGX_FUT FW. For ${SN}..."
                    nohup echo -n Y | echo "issdfut works outside of the operating system, drive FW need to be updated outside of this process."  > issdcm_${SN}.log &
                else
                    echo "Using intelmas to update REGX_MAS FW. For ${SN}..."
                    nohup echo -n Y | intelmas load -intelssd ${SN} > issdcm_${SN}.log &
                fi
            fi
            Pids+=($!)

            if [ "${DeviceStatus}" != "Healthy" ]; then
                echo "ERROR: Abnormal drive status: ${InitialDriveList[$SN]}, please check it, the drive FW update progress may fail." >> issdcm_${SN}.log
            fi

            if [ $(grep -c "reboot the system" issdcm_${SN}.log) -gt 0 ]; then
                REBOOT_NEEDED=YES
                echo -e "Reboot is needed for ${SN}"
            fi

        else
            echo -e "\tCurrent drive contains the expected firmware version..." >> issdcm_${SN}.log
        fi
    done

}



function chk_updating_count()
{
    sleep 2
    DriveUpdatingCnt=${#Pids[@]}
    echo "Currently $DriveUpdatingCnt drives are updating FW..."
    while [ $DriveUpdatingCnt -gt 0 ]
    do
        sleep 5
        echo '--------------------------------------'
        echo "Current Running Pids..."
        DriveUpdatingCnt=0
        for pid in "${Pids[@]}"
        do
            pidCnt=$( ps -o pid | grep -c $pid )
            DriveUpdatingCnt=$(( $DriveUpdatingCnt + $pidCnt ))
            echo -e "\tPid: $pid, associated process count: $pidCnt"
        done
        echo "$DriveUpdatingCnt drives updating FW"
    done
    # read -p "Pause to check how many drives are updating fw..." -n1 -s

}


function chk_reboot_needed()
{
    echo "================================================================================"
    echo "Checking whether a reboot is needed..."

    for SN in "${!InitialDriveList[@]}"
    do
        echo $SN
        if [ -f issdcm_${SN}.log ]; then
            # cat issdcm_${SN}.log
            if [ $(grep -c "reboot the system" issdcm_${SN}.log) -gt 0 ]; then
                REBOOT_NEEDED=YES
                echo -e "\tReboot is needed for ${SN}"
            fi

            cat issdcm_${SN}.log | tee -a local_log.log
            rm -f issdcm_${SN}.log
        fi
    done

    if [ $REBOOT_NEEDED == "YES" ]; then
        # read -p "Please reboot to verify the update" -n1 -s
        # read -p "Press any key to reboot the system..." -n1 -s
        sleep 2

        if [ $DEBUG == "TRUE" ]; then
            pauseToCheck "After SSD FW programming, pause to check before reboot.."
        fi

        init 6
        # exit
    fi

}


function disconnect_drives() {
    make_pretty_log_header "Drive mount info" 2

    make_pretty_log_header "list drive block info before umount(fdisk -l)..." 3
    fdisk -l >> local_log.log

    make_pretty_log_header "list drive block info before umount..." 3
    lsblk -O >> local_log.log
    boot_drive=`lsblk | grep boot | awk '{print substr($1,3,3)}'| uniq`
    echo Got boot drive: $boot_drive >> local_log.log

    make_pretty_log_header "umount drives.." 3
    partitions=`lsblk -p | egrep -v "${boot_drive}|disk|NAME" | awk '{print substr($1, 3,10)}'`
    echo ${partitions}
    for drive in ${partitions}
    do
        echo umount drive: $drive >> local_log.log
        umount $drive |  tee -a local_log.log
    done

    connt=0
    driver_unloaded=false
    while [ $count -lt 10 ]
    do
        echo "Unload NVME drivers..."

        modprobe -r nvme
        if [ $? -eq 0 ]; then
            driver_unloaded=true
            echo "Nvme driver are successfully removed..."
            break
        fi
        sleep 2
    done
    echo "Driver unloading status: ${driver_unloaded}" >> local_log.log

    make_pretty_log_header "list drive block info after umount..." 3
    lsblk -O >> local_log.log

}


function log_handler()
{
    make_pretty_log_header issdcm 2
    issdcm version >> local_log.log

    make_pretty_log_header isdct 2
    isdct version >> local_log.log

    make_pretty_log_header intelmas 2
    intelmas version >> local_log.log

    make_pretty_log_header issdfut 2
    # issdfut version >> local_log.log

    make_pretty_log_header standard_firmware_list 2
    cat SSD_LIST.txt >> local_log.log

    mv local_log.log ${LOG_FILE}
    # wput -q ${LOG_FILE} ftp://128.101.1.1/tstcom/STATINID/LOG/

}


function process_started()
{
    echo "Started process..."
}
#------------------------------------------------------------------------------------------------
#                Function definition End
#------------------------------------------------------------------------------------------------






#------------------------------------------------------------------------------------------------
#                Flow Start
#------------------------------------------------------------------------------------------------

check_tool_version


get_std_drive_firmware


#Find target drives
echo "================================================================================"
echo "Getting drive list under updating..."
make_pretty_log_header "FW version status at the beginning..."
IdentifyDrives
echo -e "\nSN;INDEX;MODEL;FW;STATUS;Family;Health" | tee -a local_log.log
for SerialNumber in "${!InitialDriveList[@]}"
do
    echo "$SerialNumber;${InitialDriveList[$SerialNumber]}" | tee -a local_log.log
done


update_drive_firmware


chk_updating_count


chk_reboot_needed


#CheckFwStatus
echo -e "\n\n\n\n\n\n================================================================================"
echo "Check final firmware status"
make_pretty_log_header "FW version status at the end..."
IdentifyDrives
echo -e "\nSN;INDEX;MODEL;FW;STATUS;Family;Health" | tee -a local_log.log
for SN in "${!InitialDriveList[@]}"
do
    # echo ${InitialDriveList[$SN]}
    # sleep 10
    Index=$(echo ${InitialDriveList[$SN]}|awk -F ";" '{print $1}')
    if [ "${DriveList[$SN]}" == "" ]; then
        echo "$SN;$Index;UNKNOWN;MISSING;Unknown;Unknown;Unknown" | tee -a local_log.log
    else
        echo "$SN;${DriveList[$SN]}" | tee -a local_log.log
    fi
done


disconnect_drives


# echo "================================================================================"
# echo "Handle log file"
log_handler

echo "End of the process, system will be shutdown in 10s, then you can remove the drives..."
# read -p "End of the process, Hit Enter to exit and shutdown, then you can remove the drives..." -n1 -s
sleep 10
init 0


#------------------------------------------------------------------------------------------------
#                Flow End
#------------------------------------------------------------------------------------------------

