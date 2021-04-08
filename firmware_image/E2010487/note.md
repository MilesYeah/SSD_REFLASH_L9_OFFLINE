
发件人: Liu, ZichaoX <zichaox.liu@intel.com> 
发送时间: 2021年4月6日 14:12
收件人: MSL_PE_Intel_L9 <MSL_PE_Intel_L9@mic.com.tw>; brady.tang (湯立爭 - MSL) <brady.tang@mic.com.tw>; yu.xia (夏雨 - MSL) <Yu.Xia@mic.com.tw>; chiatung.chen (陳家棟 - MCT) <chiatung.chen@mic.com.tw>; mason25.chen (陳浩元 - MCT) <mason25.chen@mic.com.tw>; cecilia.liang (梁穎欣 - MSL) <cecilia.liang@mic.com.tw>; peter.w.chen (陳永騰 - MCT) <peter.w.chen@mic.com.tw>; wende.liang (梁文德 - MSL) <wende.liang@mic.com.tw>; chihping.ken (根誌平 - MCT) <Chihping.Ken@mic.com.tw>; liya.zeng (曾文英 - MSL) <liya.zeng@mic.com.tw>; erica.chang (張滋純 - MCT) <erica.chang@mic.com.tw>; tess.wang (王彥婷 - MCT) <tess.wang@mic.com.tw>; vica.weng (翁乙薰 - MCT) <vica.weng@mic.com.tw>; Guo, Jianhua <jianhua.guo@intel.com>; robert.ye (葉翔 - MSL) <robert.ye@mic.com.tw>; jency.li (黎欽妮 - MSL) <jency.li@mic.com.tw>; jeko.cheng (張健浩 - MSL) <jeko.cheng@mic.com.tw>; EBUMSL_SW <EBUMSL_SW@mic.com.tw>
抄送: Yao, Donne <donne.yao@intel.com>; Wang, Xushui <xushui.wang@intel.com>; Liu, Grace <grace.liu@intel.com>; Ren, Lei <lei.ren@intel.com>; Luey Ng <luey.chon.ng@intel.com>; Tan, Suan Siew <suan.siew.tan@intel.com>; Lee, Dennis Lidan <dennis.lidan.lee@intel.com>; Allen Hu <allen.hu@intel.com>; Cook, Steven C <steven.c.cook@intel.com>; Breton Rodriguez, Diego Antonio <diego.antonio.breton.rodriguez@intel.com>; Nataraja, Shibani <shibani.nataraja@intel.com>; Hurwitz, Roger A <roger.a.hurwitz@intel.com>; Fan, Qi XinX <qi.xinx.fan@intel.com>; Fang, TaoX <taox.fang@intel.com>; Kuhner, Keller <keller.kuhner@intel.com>; Campbell, Wesley <wesley.campbell@intel.com>; Figo Wang(王佩5516) <wang.pei@inspur.com>; Dammon Zhang (张鹏)-云数据中心集团 <zhang_peng01@inspur.com>; Liu, Yinan <yinanliu@inspur.com>; ivy.wu (吳芃樺 - MCT) <ivy.wu@mic.com.tw>; Liu, ZichaoX <zichaox.liu@intel.com>
主题: RE: L9 RAID/SSD/NIC FW Control Table for DSG Prods -2021 Apr

Hi MiTAC guys,

                         Here is the RAID/SSD/NIC FW control table release for Apr_2021. Please go ahead for the L9 implement and let me know if any problem. Thanks!
                          
  RAID/NIC/SSD FWs:

| product_code    | mm_number | product_name                                            | subsystem | fw_version   | page_date |
| --------------- | --------- | ------------------------------------------------------- | --------- | ------------ | --------- |
| RS3DC040        | 934644    | RAID Controller RS3DC040                                | RAID      | 24.21.0-0132 | 3/15/2021 |
| RS3DC080        | 934643    | RAID Controller RS3DC080                                | RAID      | 24.21.0-0132 | 3/15/2021 |
| RS3SC008        | 928223    | RAID Controller RS3SC008                                | RAID      | 24.21.0-0132 | 3/15/2021 |
| RMS3CC040       | 932473    | RAID Module RMS3CC040                                   | RAID      | 24.21.0-0132 | 3/15/2021 |
| RMS3CC080       | 999L36    | RAID Module RMS3CC080                                   | RAID      | 24.21.0-0132 | 3/15/2021 |
| X540T1          | 914246    | Network Adapter X540-T1                                 | NIC       | 26.2         | 3/31/2021 |
| X550T1          | 940116    | Network Adapter X550-T1                                 | NIC       | 3.3          | 3/31/2021 |
| X550T2          | 940128    | Network Adapter X550-T2                                 | NIC       | 3.3          | 3/31/2021 |
| X710DA2         | 933206    | Network Adapter X710-DA2                                | NIC       | 8.3          | 3/31/2021 |
| X710DA4FH       | 932575    | Intel Ethernet Converged Network Adapter X710-DA4       | NIC       | 8.3          | 3/31/2021 |
| X710T4          | 943052    | Network Adapter X710-T4                                 | NIC       | 8.3          | 3/31/2021 |
| XL710QDA1       | 932583    | Network Adapter XL710-QDA1                              | NIC       | 8.3          | 3/31/2021 |
| XL710QDA2       | 932586    | Network Adapter XL710-QDA2                              | NIC       | 8.3          | 3/31/2021 |
| XXV710DA1       | 948653    | Network Adapter XXV710-DA1                             | NIC       | 8.3          | 3/31/2021 |
| XXV710DA2       | 948651    | Network Adapter XXV710-DA2                              | NIC       | 8.3          | 3/31/2021 |
| X710DA4G2P5     | 945033    | Intel Ethernet Converged Network Adapter X710-DA4       | NIC       | 8.3          | 3/31/2021 |
| X722DA2         | 959973    | Network Adapter X722-DA2                                | NIC       | 8.3          | 3/31/2021 |
| X722DA4FH       | 959964    | Network Adapter X722-DA4                                | NIC       | 8.3          | 3/31/2021 |
| SSDPED1K375GA01 | 953028    | P4800X Series (375GB, PCIe)                             | SSD       | E2010487     | 3/8/2021  |
| SSDPE21K375GA01 | 953030    | P4800X (375GB, NVMe, 2.5inch)                           | SSD       | E2010487     | 3/8/2021  |
| SSDPE21K750GA01 | 956965    | P4800X Series (750GB, NVMe, 2.5inch)                    | SSD       | E2010487     | 3/8/2021  |
| SSDPED1K750GA01 | 956982    | P4800X Series (750GB, NVMe, PCIe)                       | SSD       | E2010487     | 3/8/2021  |
| SSDPE21K015TA01 | 956980    | P4800X (1.5TB, NVMe, 2.5 inch)                         | SSD       | E2010487     | 3/8/2021  |
| SSDPED1K015TA01 | 956989    | P4800X (1.5TB, NVMe, PCIe)                              | SSD       | E2010487     | 3/8/2021  |
| SSDPE21K100GA01 | 975993    | SSD DC P4801X Series (100GB, 2.5in PCIe x4, 3D XPoint™) | SSD       | E2010487     | 3/8/2021  |
| SSDPE21K100GA01 | 975993    | SSD DC P4801X Series (100GB, 2.5in PCIe x4, 3D XPoint™) | SSD       | E2010487     | 3/8/2021  |
| SSDPE21K100GA01 | 975993    | SSD DC P4801X Series (100GB, 2.5in PCIe x4, 3D XPoint™) | SSD       | E2010487     | 3/8/2021  |
| SSDPE21K100GA01 | 975993    | SSD DC P4801X Series (100GB, 2.5in PCIe x4, 3D XPoint™) | SSD       | E2010487     | 3/8/2021  |
| MDTPE21K750GA01 | 980780    | P4800X-IMDT (750GB, NVMe, 2.5 inch)                     | SSD       | E2010487     | 3/8/2021  |
| MDTPE21K375GA01 | 980778    | P4800X-IMDT (375GB, NVMe, 2.5 inch)                     | SSD       | E2010487     | 3/8/2021  |
| MDTPE21K015TA01 | 980782    | P4800X-IMDT (1.5TB, NVMe, 2.5 inch)                     | SSD       | E2010487     | 3/8/2021  |
| MDTPED1K375GA01 | 980784    | P4800X-IMDT (375GB, NVMe, PCIe)                         | SSD       | E2010487     | 3/8/2021  |
| MDTPED1K750GA01 | 980786    | P4800X-IMDT (750GB, NVMe, PCIe)                         | SSD       | E2010487     | 3/8/2021  |
| MDTPED1K015TA01 | 980789    | P4800X-IMDT (1.5TB, NVMe, PCIe)                         | SSD       | E2010487     | 3/8/2021  |










P4800X/P4801 Firmware Upgrade Package:to Firmware E2010487
March 2021


Firmware E2010487 is based on E2010485 (MR4) with addition of the CRC error fix reported by some customers on specific platform.

If the current FW version is below E2010435 than upgrade to the version E2010435 or later first, and then upgrade to the version E2010487. Please do power cycle system right after firmware upgrade, in order to make the new firmware E2010487 take effect

Once the firmware E2010487 is installed on the drive it can NOT be downgraded to a version lower than E2010485, ex. FW downgrade to version E2010435 in not allowed.

Firmware E2010487 has VMware ESXi/vSAN 7.0 U1 and Windows WHQL certification available


```
Download the Intel Memory And Storage (IntelMAS) tool for your OS from Intel Download Center and install it on the target system following the Installation Guide included into the downloaded package.
Execute these commands:
# intelmas show -intelssd
Note the index of your P4800X/P4801X drive X. In the example below the index is number 0.

# intelmas load –source E2010487_EB3B0438_WFEM01M0_signed.bin –intelssd X
For the example above the command will look like 
# intelmas load –source E2010487_EB3B0438_WFEM01M0_signed.bin –intelssd 0
# Power Cycle
Note: To apply the new firmware the system MUST be power cycled.
Verify the new firmware is running on the drive:
# intelmas show –intelssd -X
```


```
Firmware update with open-sourced nvme-cli tool:
# nvme list
# nvme fw-download /dev/nvmeXn1 –f E2010487_EB3B0438_WFEM01M0_signed.bin
Note: you have to identify your P4800X/P4801X controler number X by “nvme list“
# nvme fw-activate /dev/nvme0n1 -s 1 -a 1
# Power cycle
Note: We have new boot loader EB3B0438 since firmware E2010475, it requires system power cycle to make new bootloader take effective.
# nvme list
```

