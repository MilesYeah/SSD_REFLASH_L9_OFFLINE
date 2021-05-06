#!/bin/bash
cd /TEST
export PATH=$PATH:/sbin:/usr/sbin

# https://www.intel.com/content/www/us/en/support/articles/000017245/memory-and-storage.html

# Enable extended globbing
shopt -s extglob

# series that need special tool to get FW updated.
REGX_DCT="(D5-P4618)"
REGX_FUT="(X18-M|X25-M|X25-E)"
#REGX_MAS="()"


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
    echo "-------------------------------------------------------------------------------------" >> local_log.log
    echo $1 >> local_log.log
}

function get_std_drive_firmware()
{
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
    make_pretty_log_header Detecting_Drive_firmwares
    for line in $(intelmas show -intelssd)
    do
        echo ${line} >> local_log.log
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
                echo "WARNING: Abnormal drive status: ${InitialDriveList[$SN]}, please check it, the drive FW update progress may fail." >> issdcm_${SN}.log
            fi

            cat issdcm_${SN}.log | tee -a local_log.log
            if [ $(grep -c "reboot the system" issdcm_${SN}.log) -gt 0 ]; then
                REBOOT_NEEDED=YES
                echo -e "Reboot is needed for ${SN}"
            fi

        else
            rm -f issdcm_${SN}.log
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
    for SN in "${!InitialDriveList[@]}"
    do
        echo $SN
        if [ -f issdcm_${SN}.log ]; then
            cat issdcm_${SN}.log
            if [ $(grep -c "reboot the system" issdcm_${SN}.log) -gt 0 ]; then
                REBOOT_NEEDED=YES
                echo -e "\tReboot is needed for ${SN}"
            fi
        fi
    done

    if [ $REBOOT_NEEDED == "YES" ]; then
        # read -p "Please reboot to verify the update" -n1 -s
        # read -p "Press any key to reboot the system..." -n1 -s
        init 6
        # exit
    fi

}


function log_handler()
{
    make_pretty_log_header issdcm
    issdcm version >> local_log.log

    make_pretty_log_header isdct
    isdct version >> local_log.log

    make_pretty_log_header intelmas
    intelmas version >> local_log.log

    make_pretty_log_header issdfut
    # issdfut version >> local_log.log

    make_pretty_log_header standard_firmware_list
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


echo "================================================================================"
echo "Getting standard drive firmware list"
get_std_drive_firmware


#Find target drives
echo "================================================================================"
echo "Getting drive list under updating..."
make_pretty_log_header FW_version_status_at_the_bigining
IdentifyDrives
echo -e "\nSN;INDEX;MODEL;FW;STATUS;Family;Health" | tee -a local_log.log
for SerialNumber in "${!InitialDriveList[@]}"
do
    echo "$SerialNumber;${InitialDriveList[$SerialNumber]}" | tee -a local_log.log
done


echo "================================================================================"
echo "Updating drive firmwares..."
update_drive_firmware
chk_updating_count


echo "================================================================================"
echo "Checking whether a reboot is needed..."
chk_reboot_needed


#CheckFwStatus
echo -e "\n\n\n\n\n\n================================================================================"
echo "Check final firmware status"
make_pretty_log_header FW_version_status_at_the_end
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



# echo "================================================================================"
# echo "Handle log file"
log_handler


read -p "End of the process, Hit Enter to exit and shutdown" -n1 -s
init 0


#------------------------------------------------------------------------------------------------
#                Flow End
#------------------------------------------------------------------------------------------------

