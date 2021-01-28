[root@localhost ssd_refresh]# bash -x process.sh
+ cd /TEST
process.sh: line 2: cd: /TEST: No such file or directory
+ export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/usr/sbin
+ PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin:/usr/sbin
+ shopt -s extglob
+ ModelList=()
+ declare -A ModelList
+ DriveList=()
+ declare -A DriveList
+ InitialDriveList=()
+ declare -A InitialDriveList
++ date +%T
++ sed s/://g
+ STARTTIME=113911
++ date +%y%m%d
+ STARTDATE=201022
+ LOG_FILE=201022_113911_SSD_UPDATE.log
+ REBOOT_NEEDED=NO
+ echo -------------------------
-------------------------
+ echo 'FINDING DRIVES FOR UPDATE'
FINDING DRIVES FOR UPDATE
+ IdentifyDrives
+ FW_STATUS=UNKNOWN
+ IFS='
'
++ cat isdct.out
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ - Intel SSD DC P4500 Series PHLF7370008F1P0GGN - =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ - Intel SSD DC P4500 Series PHLF7370008F1P0GGN - =~ ^Index : ]]
+ regx='^ModelNumber :'
+ [[ - Intel SSD DC P4500 Series PHLF7370008F1P0GGN - =~ ^ModelNumber : ]]
+ regx='^ProductFamily :'
+ [[ - Intel SSD DC P4500 Series PHLF7370008F1P0GGN - =~ ^ProductFamily : ]]
+ regx='^SerialNumber :'
+ [[ - Intel SSD DC P4500 Series PHLF7370008F1P0GGN - =~ ^SerialNumber : ]]
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ Bootloader : 0136 =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ Bootloader : 0136 =~ ^Index : ]]
+ regx='^ModelNumber :'
+ [[ Bootloader : 0136 =~ ^ModelNumber : ]]
+ regx='^ProductFamily :'
+ [[ Bootloader : 0136 =~ ^ProductFamily : ]]
+ regx='^SerialNumber :'
+ [[ Bootloader : 0136 =~ ^SerialNumber : ]]
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ DevicePath : /dev/nvme0n1 =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ DevicePath : /dev/nvme0n1 =~ ^Index : ]]
+ regx='^ModelNumber :'
+ [[ DevicePath : /dev/nvme0n1 =~ ^ModelNumber : ]]
+ regx='^ProductFamily :'
+ [[ DevicePath : /dev/nvme0n1 =~ ^ProductFamily : ]]
+ regx='^SerialNumber :'
+ [[ DevicePath : /dev/nvme0n1 =~ ^SerialNumber : ]]
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ DeviceStatus : Healthy =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ DeviceStatus : Healthy =~ ^Index : ]]
+ regx='^ModelNumber :'
+ [[ DeviceStatus : Healthy =~ ^ModelNumber : ]]
+ regx='^ProductFamily :'
+ [[ DeviceStatus : Healthy =~ ^ProductFamily : ]]
+ regx='^SerialNumber :'
+ [[ DeviceStatus : Healthy =~ ^SerialNumber : ]]
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ Firmware : QDV101D1 =~ ^Firmware : ]]
++ echo 'Firmware : QDV101D1'
++ awk '{print $3}'
+ Firmware=QDV101D1
+ continue
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ FirmwareUpdateAvailable : The selected drive contains current firmware as of this tool release. =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ FirmwareUpdateAvailable : The selected drive contains current firmware as of this tool release. =~ ^Index : ]]
+ regx='^ModelNumber :'
+ [[ FirmwareUpdateAvailable : The selected drive contains current firmware as of this tool release. =~ ^ModelNumber : ]]
+ regx='^ProductFamily :'
+ [[ FirmwareUpdateAvailable : The selected drive contains current firmware as of this tool release. =~ ^ProductFamily : ]]
+ regx='^SerialNumber :'
+ [[ FirmwareUpdateAvailable : The selected drive contains current firmware as of this tool release. =~ ^SerialNumber : ]]
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ Index : 0 =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ Index : 0 =~ ^Index : ]]
++ echo 'Index : 0'
++ awk '{print $3}'
+ Index=0
+ continue
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ ModelNumber : INTEL SSDPE2KX010T7 =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ ModelNumber : INTEL SSDPE2KX010T7 =~ ^Index : ]]
+ regx='^ModelNumber :'
+ [[ ModelNumber : INTEL SSDPE2KX010T7 =~ ^ModelNumber : ]]
++ echo 'ModelNumber : INTEL SSDPE2KX010T7'
++ awk '{print $4}'
+ ModelNumber=SSDPE2KX010T7
+ continue
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ ProductFamily : Intel SSD DC P4500 Series =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ ProductFamily : Intel SSD DC P4500 Series =~ ^Index : ]]
+ regx='^ModelNumber :'
+ [[ ProductFamily : Intel SSD DC P4500 Series =~ ^ModelNumber : ]]
+ regx='^ProductFamily :'
+ [[ ProductFamily : Intel SSD DC P4500 Series =~ ^ProductFamily : ]]
++ echo 'ProductFamily : Intel SSD DC P4500 Series'
++ awk -F: '{print $2}'
+ ProductFamily=' Intel SSD DC P4500 Series'
+ continue
+ for line in '`cat isdct.out`'
+ regx='^Firmware :'
+ [[ SerialNumber : PHLF7370008F1P0GGN =~ ^Firmware : ]]
+ regx='^Index :'
+ [[ SerialNumber : PHLF7370008F1P0GGN =~ ^Index : ]]
+ regx='^ModelNumber :'
+ [[ SerialNumber : PHLF7370008F1P0GGN =~ ^ModelNumber : ]]
+ regx='^ProductFamily :'
+ [[ SerialNumber : PHLF7370008F1P0GGN =~ ^ProductFamily : ]]
+ regx='^SerialNumber :'
+ [[ SerialNumber : PHLF7370008F1P0GGN =~ ^SerialNumber : ]]
++ echo 'SerialNumber : PHLF7370008F1P0GGN'
++ awk '{print $3}'
+ SerialNumber=PHLF7370008F1P0GGN
+ FW_STATUS=UNKNOWN
+ DriveList["$SerialNumber"]='0,SSDPE2KX010T7,QDV101D1,UNKNOWN, Intel SSD DC P4500 Series'
+ for SerialNumber in '"${!DriveList[@]}"'
+ InitialDriveList["$SerialNumber"]='0,SSDPE2KX010T7,QDV101D1,UNKNOWN, Intel SSD DC P4500 Series'
+ for SerialNumber in '"${!InitialDriveList[@]}"'
+ echo PHLF7370008F1P0GGN '0,SSDPE2KX010T7,QDV101D1,UNKNOWN, Intel SSD DC P4500 Series'
PHLF7370008F1P0GGN 0,SSDPE2KX010T7,QDV101D1,UNKNOWN, Intel SSD DC P4500 Series
[root@localhost ssd_refresh]#
