# Release notice

You will need git to get the latest code from SW lab server through below command.
Command: `git pull origin master`


## `Must read`
1. Be sure your system is connected to MiTAC office network.
2. After getting new version package, below actions need to be done:
   1. Be sure you have checked tool versions in defined in below `tool_versions`.
      1. If the tool versions don't match the definations, update the tool accordingly.
   2. Check below `history` to get the latest change information.
   3. Replace the whole package in the real execution environment, actually you can clone or update the code directly from the execution environment.
   4. Be sure the `SSD_LIST.txt` is generated and updated strictly base on `DSG L9 FW control table` from intel.
   5. Be sure any update or deletion of drive FW image are done.



## Running Environment
1. Developer: Robert.Ye (robert.ye@mic.com.tw)
2. OS requirement(either one of below)
   1. Linux RHEL7.3
   2. Linux RHEL7.5
   3. Linux RHEL7.6



## tool_versions
1. isdct: 
   1. version: isdct-3.0.26.400-1.x86_64
   2. download_url: 
   3. note: depracated
2. intelmas: 
   1. version: intelmas-1.5.113-0.x86_64
   2. download_url: https://downloadcenter.intel.com/download/30259/Intel-Memory-and-Storage-Tool-CLI-Command-Line-Interface-
   3. note: 
3. issdcm: 
   1. version: issdcm-3.0.3-1.x86_64
   2. download_url: provided by intel
   3. note: to update firmware with specified firmware image
4. issdfut: 
   1. version: 
   2. download_url: 
   3. note: need to use in a independent OS, not for this process.



## history

v 202.4: 2021/03/10
1. Move tool version definations and history to here per PE's requests.
2. Refactor package folder structure.


v 202.3: 2021/03/04
1. Resolve a bug to collect Pids of each updating drive.
2. If the need reboot key word is detected, a automatically reboot would be performed.
3. Add notice to show how to get or update code from Git Server
4. Intel released `DSG L9 FW control table_Mar2021_v0.3.xlsx`,
   1. Ignore the NIC, RAID, etc
   2. Support for SSDPE2KE032T8OS has been added in 202.2 with intelmas.

v 202.2: 2021/03/02
1. intelmas is now mainly used to update FW for normal drives, issdct is depracated and we cannot find it from ark.intel.com.
2. A more detailed log will be generated in log folder and more details will be shown on terminal while performing the process.
3. Verified on production line.

v 201.1: 2021/01/28
1. Add check for drive status, if it is abnormal, record a abormal message in log file.

v 201.0: 2020/12/11
1. Owner of this package has been transfered from Intel to MSL SW.
2. Add ProductFamily while detecting product list.
3. While updating FW, D5-P4618 series SSD would use isdct to update FW and the rest would use intelmas.



## For first time user
1. Install Git(Open Source) through installation guides on site https://git-scm.com/downloads. 
   1. Download the latest git version base on your OS and install it.
   2. Be sure check the item to `add git to PATH` while installing it.
   3. Git is a open source software and you don't need to worry that someone would charge any fees from you.
2. Open a cmd/shell terminal to execute following commands to configure your basic information, replace name and email address to your real information
   * `git config --global user.name "robert"`
   * `git config --global user.email "robert.ye@mic.com.tw"`
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
1. Be sure that you have successfully finished the steps in `For first time user`
2. Open a cmd/shell terminal.
3. If you want to get the code from a clean system, execute following command
   * `git clone ssh://user_pe@10.86.122.204:29418/SSDReflash.git`
4. If your system already cloned the code and you want to get the latest code from server, execute following command
   * `git pull origin master`
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

1.	Hardware needed
   1. Wolfpass or BuchananPass L9 system with direct NVMe / SATA connections to HSBP.
2. OS Setup
   1. Update isdct-* in EST/PROCESS to included isdct-3.0.17.
   2. Install Linux using EST install process.
   3. Add contents of `SSD_REFLASH` to `/TEST` replacing PROCESS.sh with PROCESS.sh included.
   4. Copy all of the required drive FW images to `/TEST`.
   5. Install issdcm rpm `rpm –ivh issdcm-*x86_64.rpm`.
   6. Install intelmas rpm `rpm –ivh intemmas-*x86_64.rpm`.
   7. Install issdct rpm `rpm –ivh issdct-*x86_64.rpm`.
3. SSD Reflash
   1. Install target SSD's.
   2. Power up the system.
   3. Update script will run automatically.
   4. Reboot system when prompted to reboot, now the reboot will be executed automatically.
   5. Verify all target drives status shown as `COMPLETE` with expected FW version.
   6. Log file captured in `log` folder in server as `./log/${STARTDATE}_${STARTTIME}_SSD_UPDATE.log`
