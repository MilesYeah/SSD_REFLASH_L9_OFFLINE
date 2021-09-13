# Release notice

You will need git to get the latest code from SW lab server through below command.

* Command to update: **git pull origin master**
* Command to clone: **git clone ssh://user_pe@10.86.122.204:29418/SSDReflash.git**



<!-- ## Developer actions on each release
1. Make a copy of SSD_LIST.txt from **\\10.86.8.50\Share\TEST\FA\Yu\SSD_REFLASH_L9_OFFLINE.203.1**
2. Add **DSG L9 FW control table** in Doc folder.
3. Generate release_note.html before commit. 
-->



## **Must read on each release**
1. Be sure your system is connected to MiTAC office network, so the code update can be downloaded through Git.
2. After getting new version package, below actions need to be done:
   1. Be sure you have checked tool versions in defined in below **tool_versions**.
      1. If the tool versions don't match the definations, update the tool accordingly.
   2. Check section **history** to get the latest change note.
   3. Replace the whole package in production environment, actually you can clone or update the code directly in  environment.
   4. Be sure the **SSD_LIST.txt** is generated and updated strictly base on **DSG L9 FW control table** from intel.
   5. Be sure any update or deletion of standalone drive FW image are done, the firmware image files are now stored in **folder firmware_image**.
      1. When new FW image is provided, create a folder named after firmware version, extract the firmware package and copy all the content from the extracted package to the newly created folder.
      2. If a standalone FW image is depracated, remove the folder from firmware_image.
      3. Make some note if possible.
3. Please commit issues if any, and send me the log files after verification.


## Warnning
1. Below SSDs have `No Firmware Update Available`

   | product_code    | mm_number | product_name                                                    |
   | --------------- | --------- | --------------------------------------------------------------- |
   | SSDPD21K375GA01 | 958883    | D4800X (375GB, NVMe 2.5inch)                                    |
   | SSDPD21K750GA01 | 958884    | D4800X (750GB, NVMe 2.5inch)                                    |
   | SSDPD21K015TA01 | 958885    | D4800X (1.5TB, NVMe 2.5inch)                                    |
   | SSDPF2KX076TZ01 | 99A5DR    | SSD D7-P5510 Series (7.68TB, 2.5in PCIe 4.0 x4, 3D4, TLC)       |
   | SSDPF2KX076TZOS | 99A5D1    | SSD D7-P5510 Series (7.68TB, 2.5in PCIe 4.0 x4, 3D4, TLC, OPAL) |
   | SSDPF2KX038TZ01 | 99A5DP    | SSD D7-P5510 Series (3.84TB, 2.5in PCIe 4.0 x4, 3D4, TLC)       |
   | SSDPF2KX038TZOS | 99A5CZ    | SSD D7-P5510 Series (3.84TB, 2.5in PCIe 4.0 x4, 3D4, TLC, OPAL) |
   | SSDPF21Q016TB01 | 99A6PV    | Optane SSD DC P5800X (1.6TB, 2.5in PCIe x4, 3D XPoint)          |
   | SSDPF21Q800GB01 | 99A6PT    | Optane SSD DC P5800X (800GB, 2.5in PCIe x4, 3D XPoint)          |
   | SSDPF21Q400GB01 | 99A6PN    | Optane SSD DC P5800X (400GB, 2.5in PCIe x4, 3D XPoint)          |




## Running Environment
1. Developer: Robert.Ye (robert.ye@mic.com.tw)
2. OS requirement(either one of below)
   1. Linux RHEL7.3
   2. Linux RHEL7.5
   3. Linux RHEL7.6



## Tool Versions
1. intelmas: 
   1. version: intelmas-1.10.155-0.x86_64
   2. [download_url](https://downloadcenter.intel.com/download/30509/Intel-Memory-and-Storage-Tool-CLI-Command-Line-Interface-?v=t)
   3. IntelMAS can also be found from the follong shared path:
      1. `\\10.86.122.204\Mirror\Software\Intel\IntelMAS`
   4. note: Currently, it is mainly to get drive FW updated with the versions inside the tool.
2. issdcm: 
   1. version: issdcm-3.0.3-1.x86_64
   2. download_url, provided by intel 
   3. IntelMAS can also be found from the follong shared path:
      1. `\\10.86.122.204\Mirror\Software\Intel\ISSDCM`
   4. note: 
      1. Instead of using intelmas, Intel aggreed to load standalone firmware files through this tool on **Tue 4/13/2021 10:38 AM** **RE: L9 RAID/SSD/NIC FW Control Table for DSG Prods -2021 Apr**
3. isdct: depracated
   1. version: isdct-3.0.26.400-1.x86_64
   2. [download_url]()
   3. IntelMAS can also be found from the follong shared path:
      1. `\\10.86.122.204\Mirror\Software\Intel\ISDCT`
   4. note: **depracated**
<!-- 4. issdfut: 
   1. version: NA
   2. [download_url] NA
   3. note: need to use in a independent OS, not for this process. -->



## History

#### version 208: 2021/09/10
1. Intel released `RE: L9 RAID/SSD/NIC FW Control Table for DSG Prods -Sept_2021`
   1. Intel MAS needs a update to version `1.10`.



#### version 207.2: 2021/08/19
1. Change the waiting time from 6 to 10 seconds per HOU PE's request.
   1. `L9 RAID/SSD/NIC FW Control Table for DSG Prods -2021 Aug` `2021年8月19日 10:45`



#### version 207.1: 2021/08/13
1. `L9 RAID/SSD/NIC FW Control Table for DSG Prods -2021 Aug_V2.0` was released.
2. Deleted SSD_LIST.txt incase any mistake was made by accident which would be caused by the SSD_LIST.txt file.



#### version 207: 2021/08/09
1. **RE: L9 RAID/SSD/NIC FW Control Table for DSG Prods -2021 Aug** was released, below drives need update.
   | product_code    | mm_number | product_name                                                  | subsystem | fw_version | page_date |
   | --------------- | --------- | ------------------------------------------------------------- | --------- | ---------- | --------- |
   | SSDPE2KX010T801 | 959391    | P4510 (1TB, NVMe, 2.5inch)                                    | SSD       | VDV10182   | 2021/7/6  |
   | SSDPE2KX020T801 | 959393    | P4510 (2TB, NVMe, 2.5inch)                                    | SSD       | VDV10182   | 2021/7/6  |
   | SSDPE2KX040T801 | 959395    | SSD DC P4510 Series (4TB, NVMe, 2.5inch, 3D3, TLC)            | SSD       | VDV10182   | 2021/7/6  |
   | SSDPE2KX080T801 | 959397    | SSD DC P4510 Series (8TB, NVMe, 2.5inch, 3D3, TLC)            | SSD       | VDV10182   | 2021/7/6  |
   | SSDPE2KE016T801 | 978083    | P4610 (1.6TB, NVMe, 2.5 inch)                                 | SSD       | VDV10182   | 2021/7/6  |
   | SSDPE2KE032T801 | 978084    | P4610 (3.2TB, NVMe, 2.5 inch)                                 | SSD       | VDV10182   | 2021/7/6  |
   | SSDPE2KE064T801 | 978085    | P4610 (6.4TB, NVMe, 2.5 inch)                                 | SSD       | VDV10182   | 2021/7/6  |
   | SSDPE2KE076T801 | 963520    | P4610 (7.68TB, NVMe, 2.5 inch)                                | SSD       | VDV10182   | 2021/7/6  |
   | SSDPECKE064T801 | 999CNK    | SSD DC P4618 Series ( 6.4TB, 1/2 Height PCIe 3.1 x8, 3D2, TLC | SSD       | VDV10182   | 2021/7/6  |
   | SSDPE2KE032T8OS | 984823    | SSD DC P4610 Series (3.2TB, 2.5in PCIe 3.1 x4, 3D2, TLC)      | SSD       | VDV10182   | 2021/7/6  |
   | SSDPEWKX153T801 | 999JJ2    | P4510 (15.36TB, Ruler)                                        | SSD       | VDV10182   | 2021/7/6  |
   | SSDPF21Q016TB01 | 99A6PV    | Optane SSD DC P5800X (1.6TB, 2.5in PCIe x4, 3D XPoint)        | SSD       | L0310200   | 2021/7/6  |
   | SSDPF21Q800GB01 | 99A6PT    | Optane SSD DC P5800X (800GB, 2.5in PCIe x4, 3D XPoint)        | SSD       | L0310200   | 2021/7/6  |
   | SSDPF21Q400GB01 | 99A6PN    | Optane SSD DC P5800X (400GB, 2.5in PCIe x4, 3D XPoint)        | SSD       | L0310200   | 2021/7/6  |
2. **intel-mas-cli-tool-linux-1-9** has been released, **VDV10182** and **L0310200** are in support list. So Intel MAS needs a update to version **1.9.147**
3. Add function to disconnect drives as soon as drives are successfully updated to expected firmware version. Beta, to be verified in real production environment. 
4. After firmware update, the system would shutdown automatically. In case OP rmoves drives while the system is in a powered on status which would damage the drives.



#### version 206.4: 2021/06/028
1. `intelmas-1.8` is required as `DSG L9 FW control table_Jun2021.xlsx` is released, in which several new SSD series were added that need `intelmas-1.8`.
2. A warning is that SSDs in above warning section have `No Firmware Update Available`, 
   1. a Email has been sent to Intel for comfirmation about how to handle the FW when they are not expected.
   2. Reply from Intel **If the SSD show “No Firmware Update Available”, we don’t need to update it.  Once find SSD in this case don’t match the FW control table, you can report.**
3. Fixed a bug to checking tool versions. This is a new feature to prevent unexpected tool version applied. 
4. Add some better log recording.


#### version 205.1: 2021/05/13
1. Add function to check versions for intelmas, isdct, isdcm, if the tool version doesn't match the required, the process would pause running and prompt that the tool needs a update.



#### version 204.1: 2021/05/06
1. **RE: L9 RAID/SSD/NIC FW Control Table for DSG Prods -2021 May** has been released, and there are 3 updates to SSDs.
   1. IntelMAS needs a update to version **intelmas-1.7.130-0.x86_64**, so the 3 SSDs get expected update.



#### version 203.2: 2021/04/13
1. PE Brady reported E2010487 cannot be updated through intelmas and he has successfully updated the firmware through isdcm on P4800x. 
   1. On **L9 RAID/SSD/NIC FW Control Table for DSG Prods -2021 Apr**, Intel Jonny confirmed standalone FW image can be loaded through isdcm. 
   2. Switch back to isdcm instead of intelmas.



#### version 203.1: 2021/04/07
1. P4800X and P4801X series now needs firmware E2010487, use intelmas to load standalone firmware.
2. Firmware image files are now sotred in folder firmware_image, add folder E2010487 in firmware_image folder.


#### version 202.4: 2021/03/10
1. Move tool version definations and history to here per PE's requests.
2. Refactor package folder structure.


#### version 202.3: 2021/03/04
1. Resolve a bug to collect Pids of each updating drive.
2. If the need reboot key word is detected, a automatically reboot would be performed.
3. Add notice to show how to get or update code from Git Server
4. Intel released **DSG L9 FW control table_Mar2021_v0.3.xlsx**,
   1. Ignore the NIC, RAID, etc
   2. Support for SSDPE2KE032T8OS has been added in 202.2 with intelmas.


#### version 202.2: 2021/03/02
1. intelmas is now mainly used to update FW for normal drives, issdct is depracated and we cannot find it from ark.intel.com.
2. A more detailed log will be generated in log folder and more details will be shown on terminal while performing the process.
3. Verified on production line.


#### version 201.1: 2021/01/28
1. Add check for drive status, if it is abnormal, record a abormal message in log file.


#### version 201.0: 2020/12/11
1. Owner of this package has been transfered from Intel to MSL SW.
2. Add ProductFamily while detecting product list.
3. While updating FW, D5-P4618 series SSD would use isdct to update FW and the rest would use intelmas.



## For first time user
1. Install Git(Open Source) through installation guides on site https://git-scm.com/downloads. 
   1. Download the latest git version base on your OS and install it.
   2. Be sure check the item to **add git to PATH** while installing it.
   3. Git is a open source software and you don't need to worry that someone would charge any fees from you.
2. Open a cmd/shell terminal to execute following commands to configure your basic information, replace name and email address to your real information
   * **git config --global user.name "yourName"**
   * **git config --global user.email "yourEmail@mic.com.tw"**
3. Now your git environment is well set.
4. A sample to check whether git is well installed. Below command prompt shows windows git version 2.13.2 is installed.

    ```bat
    Windows PowerShell
    Copyright (C) Microsoft Corporation. All rights reserved.

    PS F:\Development\SSD_REFLASH_L9_OFFLINE> git --version
    git version 2.13.2.windows.1
    PS F:\Development\SSD_REFLASH_L9_OFFLINE>
    ```



## Get the latest code

### Get the latest code through command line
1. Be sure that you have successfully finished the steps in **For first time user**
2. Open a cmd/shell terminal.
3. If you want to get the code from a clean system, execute following command
   * **git clone ssh://user_pe@10.86.122.204:29418/SSDReflash.git**
4. If your system already cloned the code and you want to get the latest code from server, execute following command
   * **git pull origin master**
5. While clone or pull from server, you will need to input the password for current reporistory, contact the repository maintainer to get the password.
6. A simple to show how to colne the code from server.

    ```powershell
    PS F:\Development> cd .\temp\
    PS F:\Development\temp> ls
    PS F:\Development\temp>
    PS F:\Development\temp> git clone ssh://user_pe@10.86.122.204:29418/SSDReflash.git
    Cloning into 'SSDReflash'...
    Password authentication
    Password:
    remote: Counting objects: 49, done
    remote: Finding sources: 100% (49/49)
    remote: Getting sizes: 100% (26/26)
    remote: Total 49 (delta 15), reused 49 (delta 15) eceiving objects:  71% (35/49)
    Receiving objects: 100% (49/49), 206.85 KiB | 0 bytes/s, done.
    Resolving deltas: 100% (15/15), done.
    PS F:\Development\temp>
    ```

    ```powershell
    PS F:\Development\temp> ls


        Directory: F:\Development\temp


    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    d-----         3/3/2021   9:27 AM                SSDReflash


    PS F:\Development\temp>
    PS F:\Development\temp> cd .\SSDReflash\
    PS F:\Development\temp\SSDReflash> ls


        Directory: F:\Development\temp\SSDReflash


    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    d-----         3/3/2021   9:27 AM                Docs
    -a----         3/3/2021   9:27 AM             86 .gitignore
    -a----         3/3/2021   9:27 AM           6939 PROCESS.py
    -a----         3/3/2021   9:27 AM          12461 PROCESS.sh
    -a----         3/3/2021   9:27 AM           6737 releasenote.txt
    -a----         3/3/2021   9:27 AM         106590 SSD_FW_reflash.docx
    -a----         3/3/2021   9:27 AM           2259 SSD_LIST.txt
    -a----         3/3/2021   9:27 AM            337 trial.py


    PS F:\Development\temp\SSDReflash>
    ```


### Get the latest code through web
1. Goto below path and login with the account that the maintainer provided.
   1. http://10.86.122.204:10010/




## Brand new system setup

1.	Hardware needed: Wolfpass or BuchananPass L9 system with direct NVMe / SATA connections to HSBP.
2. OS Setup
   1. Install Linux using EST install process.
   2. Add contents of **SSD_REFLASH** to **/TEST** replacing PROCESS.sh with PROCESS.sh included.
   3. Copy all of the required drive FW images to **/TEST/firmware_image**.
   4. Install isdct rpm: **rpm –ivh isdct-*x86_64.rpm**.
   5. Install issdcm rpm: **rpm –ivh issdcm-*x86_64.rpm**.
   6. Install intelmas rpm: **rpm –ivh intemmas-*x86_64.rpm**.
   7. Install issdct rpm: **rpm –ivh issdct-*x86_64.rpm**.
3. SSD Reflash
   1. Install target SSD's.
   2. Power up the system.
   3. Update script will run automatically.
   4. Reboot system when prompted to reboot, now the reboot will be executed automatically.
   5. Verify all target drives status shown as **COMPLETE** with expected FW version.
   6. Log file captured in **log** folder in server as `/TEST/log/${STARTDATE}_${STARTTIME}_SSD_UPDATE.log`



## Intel history
```
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
```



## Ref
* [Firmware Versions for Intel® Solid State Drives and Intel® Optane™ Memory](https://www.intel.com/content/www/us/en/support/articles/000017245/memory-and-storage.html)
* `\\10.86.8.50\Share\TEST\FA\Yu\SSD_REFLASH_L9_OFFLINE.206.4`
* [Download Intel MAS](https://downloadcenter.intel.com/download/30509/Intel-Memory-and-Storage-Tool-CLI-Command-Line-Interface-?v=t)
* []()
* []()
* []()
* []()
