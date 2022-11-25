#!/bin/bash
cd /TEST
export PATH=$PATH:/sbin:/usr/sbin
export THOME="/TEST"
export FPN_FLOWLOG=${THOME}/flowlog

# https://www.intel.com/content/www/us/en/support/articles/000017245/memory-and-storage.html


if [ -z $1 ]; then
    DEBUG=FALSE
else
    DEBUG=TRUE
    echo DEBUG=TRUE >> ${FPN_FLOWLOG}
fi


# Enable extended globbing
shopt -s extglob


STATUS=PASSED


# series that need special tool to get FW updated.
REGX_DCT="(D5-P4618)"
REGX_FUT="(X18-M|X25-M|X25-E)"
REGX_MAS="(emptyList)"
REGX_SST="(P4510)"

VERSION_SST="1.3.208"
VERSION_INTELMAS="2.1.352"
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



show_message () {
    # echo -e "\033[32m"$1"\033[0m"
    echo -e "$1"
    # echo ""
}

show_section () {
    echo -e "\n\n##############################################################################"
    echo -e "\t$1"
    echo -e "##############################################################################\n"
}

show_section_sub () {
    echo -e "\n=========================================="
    echo -e "\t$1"
    echo -e "==========================================\t"
}

clear_previous_testing_data () {
    show_section "Cleaning previous files..."
    cd ${THOME}

    show_section_sub "Previous files"
    ls

    [ ! -z $SN ] && ls | grep -Ei "${SN}" | xargs rm -f
    [ ! -z $BIKSN ] && ls | grep -Ei "${BIKSN}" | xargs rm -f
    ls | grep -Ei "\.qry|\.aaa|\.bbb|\.ccc|\.ddd|\.log|\.tmp|\.cfg|\.dump|NULL" | xargs rm -f

    rm -f ${FPN_FLOWLOG}

    echo "OK."

    show_section_sub "Files after cleaning"
    ls

    flowlog_item_alter "CLR_DATA" "YES"
    # pause_check "Check after clearing previous testing data."
    return 0
}


function flowlog_item_alter () {
    # first parameter: item name
    # second parameter: item value
    # if item name has aleady been set in file flowlog, this function would change the item value to be the item value
    # if item name is not set in file flowlog, this function would add this item in flowlog
    local para=$1
    local new_v=$2
    count=`grep -w $para ${FPN_FLOWLOG} | wc -l`
    if [ $count -eq 0 ]; then
        echo "$1=$2" >> ${FPN_FLOWLOG}
    else
        sed -i "s/^${para}=.*$/${para}=${new_v}/g" ${FPN_FLOWLOG}
    fi

}

function variable_get_from_flowlog () {
    show_message "Show flowlog file content.."
    cat ${FPN_FLOWLOG}
    if [ -e ${FPN_FLOWLOG} ]; then
        # source ${FPN_FLOWLOG}
        for line in `cat ${FPN_FLOWLOG}`
        do
            para=`echo $line | awk -F= '{print $1}'`
            value=`echo $line | awk -F= '{print $2}'`
            eval "export $para=\"$value\""
        done
    fi
}



function make_pretty_log_header()
{
    # $1 is log header message
    # $2 is log header level, the smaller the more ---
    if [[ $2 = "3" ]]; then
        echo -e "------------------------------" >> local_log.log
    elif [[ $2 = "2" ]]; then
        echo -e "\n------------------------------------------------------------" >> local_log.log
    else
        echo -e "\n\n===================================================================================================" >> local_log.log
    fi

    echo $1 >> local_log.log
    echo -e "\n" >> local_log.log
}



function check_tool_version()
{

    echo "================================================================================"
    echo "Checking whether tool versions are expected"

    rpm -qa > app_list
    if [ `egrep -wi sst app_list | grep -c "${VERSION_SST}"` -lt 1 ]; then
        echo "SST version: `egrep -wi sst app_list`"
        read -p "Unexpected SST version, please update it..."
        exit 1
    fi

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
    make_pretty_log_header "Detecting_Drive_firmwares on boot #${BOOT_COUNT}" 2
    date >> local_log.log
    sst show -o json -ssd >> local_log.log
    for line in $(sst show -ssd)
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
                flowlog_item_alter "$SerialNumber" "$Index;$ModelNumber;$Firmware;$FW_STATUS;$ProductFamily;$DeviceStatus"
            fi
            FW_STATUS="UNKNOWN"
            if [[ $FW_STATUS != "COMPLETE" ]] && [[ $BOOT_COUNT -ne 0 ]]; then
                show_message "FW update progress failed"
                STATUS=FALIED
            fi
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
    make_pretty_log_header "Updating Firmware for each drive on boot #${BOOT_COUNT}..." 2
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
                elif [[ $ProductFamily =~ $REGX_MAS ]]; then
                    echo "Using intelmas to update REGX_MAS FW. For ${SN}..."
                    nohup echo -n Y | intelmas load -intelssd ${SN} > issdcm_${SN}.log &
                elif [[ $ProductFamily =~ $REGX_SST ]]; then
                    echo "Using sst to update REGX_SST FW. For ${SN}..."
                    nohup echo -n Y | sst load -ssd ${SN} > issdcm_${SN}.log &
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
        ((BOOT_COUNT++))
        flowlog_item_alter BOOT_COUNT $BOOT_COUNT

        if [ $DEBUG == "TRUE" ]; then
            pauseToCheck "After SSD FW programming, pause to check before reboot.."
        fi

        show_message "Now we will reboot in 6 seconds after SSD FW update."
        sleep 6
        init 6
        # exit
    fi

}


function disconnect_drives() {
    make_pretty_log_header "Drive mount info" 2

    make_pretty_log_header "list drive block info before umount(fdisk -l)..." 3
    fdisk -l >> local_log.log

    make_pretty_log_header "list drive block info before umount..." 3
    lsblk >> local_log.log
    boot_drive=`lsblk | grep boot | awk '{print substr($1,3,3)}'| uniq`
    echo Got boot drive: $boot_drive >> local_log.log

    make_pretty_log_header "umount drives.." 3
    partitions=`lsblk -p | egrep -v "${boot_drive}|disk|NAME" | awk '{print substr($1, 3,10)}'`
    echo ${partitions}
    for partition in ${partitions}
    do
        echo umount partition: $partition >> local_log.log
        umount $partition |  tee -a local_log.log
    done

    # connt=0
    NVME_DRIVER_UNLOADED=false
    while true
    do
        echo "Unload NVME drivers..."

        modprobe -r nvme
        if [ $? -eq 0 ]; then
            NVME_DRIVER_UNLOADED=true
            echo "Nvme driver are successfully removed..."
            break
        fi
        sleep 2
    done
    echo "Driver unloading status: ${NVME_DRIVER_UNLOADED}" >> local_log.log

    make_pretty_log_header "list drive block info after umount..." 3
    lsblk >> local_log.log

}


function log_handler()
{
    make_pretty_log_header issdcm 2
    issdcm version >> local_log.log

    make_pretty_log_header isdct 2
    isdct version >> local_log.log

    make_pretty_log_header intelmas 2
    intelmas version >> local_log.log

    make_pretty_log_header sst 2
    sst version >> local_log.log

    make_pretty_log_header issdfut 2
    # issdfut version >> local_log.log

    make_pretty_log_header flow_log 2
    cat flowlog >> local_log.log

    make_pretty_log_header standard_firmware_list 2
    cat SSD_LIST.txt >> local_log.log

    make_pretty_log_header "File list in /TEST/" 2
    ls -l ${THOME}/ >> local_log.log

    make_pretty_log_header "Environment variables" 2
    export >> local_log.log

    flowlog_item_alter "BOOT_COUNT" "0"
    mv local_log.log ${LOG_FILE}
    # wput -q ${LOG_FILE} ftp://128.101.1.1/tstcom/STATINID/LOG/

    make_pretty_log_header "Linux OS info" 2
    uname -a >> local_log.log
    cat /etc/redhat-release >> local_log.log

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


get_std_drive_firmware
variable_get_from_flowlog

show_message "Boot up for ${BOOT_COUNT}th time"
# Check the boot count to control test flow.
if [ -z ${BOOT_COUNT} ] || [ ${BOOT_COUNT} -eq 0 ]; then
    check_tool_version
    clear_previous_testing_data

    export BOOT_COUNT=0
    flowlog_item_alter BOOT_COUNT $BOOT_COUNT

fi


#Find target drives
show_section "Getting drive list under updating..."
make_pretty_log_header "FW version status at the beginning on boot #${BOOT_COUNT}..."
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
show_section "Check final firmware status"
make_pretty_log_header "FW version status at the end on boot #${BOOT_COUNT}..."
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


show_section "Handle log file"
log_handler


echo "End of the process, system will be shutdown in 10s, then you can remove the drives..."
# read -p "End of the process, Hit Enter to exit and shutdown, then you can remove the drives..." -n1 -s
sleep 10

if [ $DEBUG == "TRUE" ]; then
    pauseToCheck "After SSD FW programming, pause to check before reboot.."
fi

init 0


#------------------------------------------------------------------------------------------------
#                Flow End
#------------------------------------------------------------------------------------------------

