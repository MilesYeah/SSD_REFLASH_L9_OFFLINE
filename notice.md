# Release notice

You will need git to get the latest code from SW lab server through below command.
Command: git pull origin master

1. Be sure you have checked the tool versions defined in `function tool_versions` in `PROCESS.sh`.
   1. If the tool versions don't match the definations, update the tool accordingly.
2. Check `function history` to get the latest change information in `PROCESS.sh`.
3. Replace the whole package in the real execution environment, actually you can clone or update the code directly from the execution environment.



## For first time user
1. Install Git(Open Source) through installation guides on site https://git-scm.com/downloads. Download the latest git version base on your OS and install it.
   1. Git is a open source software and you don't need to care about the policies of you company which may charge 
2. Open a cmd/shell terminal to execute following commands to configure your basic information, replace name and email address to your real information
   * git config --global user.name "robert"
   * git config --global user.email "robert.ye@mic.com.tw"
3. Now your git environment is well set.
4. A sample to check whether git is well installed. Below command prompt shows windows git version 2.13.2 is installed.
    ```bat
    Windows PowerShell
    Copyright (C) Microsoft Corporation. All rights reserved.

    PS F:\Development\SSD_REFLASH_L9_OFFLINE> git --version
    git version 2.13.2.windows.1
    PS F:\Development\SSD_REFLASH_L9_OFFLINE>
    ```



## Get the latest code through command line
1. Be sure that you have successfully finished the steps in `For first time user`
2. Open a cmd/shell terminal.
3. If you want to get the code from a clean system, execute following command
   * git clone ssh://user_pe@10.86.122.204:29418/SSDReflash.git
4. If your system already cloned the code and you want to get the latest code from server, execute following command
   * git pull origin master
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






## Get the latest code through web
1. Goto below path and log in base on the account that the maintainer provided.
   1. http://10.86.122.204:10010/
2. 