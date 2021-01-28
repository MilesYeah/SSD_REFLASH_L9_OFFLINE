healthy drive status
```shell
[root@localhost Desktop]# intelmas show -o json -intelssd
{
	"Intel SSD D5-P4326 Series PHLL037600N715PDGN":
	{
		"Bootloader":"0020",
		"Capacity":"15362.99 GB",
		"CurrentPercent":100.00,
		"DevicePath":"/dev/nvme0n1",
		"DeviceStatus":"Healthy",
		"Firmware":"8DV10560",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":0,
		"MaximumLBA":30005842607,
		"ModelNumber":"INTEL SSDPE2NV153T8",
		"ProductFamily":"Intel SSD D5-P4326 Series",
		"SMARTEnabled":true,
		"SectorDataSize":512,
		"SerialNumber":"PHLL037600N715PDGN"
	},
	"Intel SSD DC S4600 Series BTYM72840CS6240AGN":
	{
		"Bootloader":"Property not found",
		"Capacity":"240.06 GB",
		"CurrentPercent":100.00,
		"DevicePath":"/dev/sg0",
		"DeviceStatus":"Healthy",
		"Firmware":"SCV10150",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":1,
		"MaximumLBA":468862127,
		"ModelNumber":"INTEL SSDSC2KG240G7",
		"ProductFamily":"Intel SSD DC S4600 Series",
		"SMARTEnabled":true,
		"SectorDataSize":"Property not found",
		"SerialNumber":"BTYM72840CS6240AGN"
	}
}
[root@localhost Desktop]# isdct show -o json -intelssd
{
	"Intel SSD D5-P4326 Series PHLL037600N715PDGN":
	{
		"Bootloader":"0020",
		"DevicePath":"/dev/nvme0n1",
		"DeviceStatus":"Healthy",
		"Firmware":"8DV10560",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":0,
		"ModelNumber":"INTEL SSDPE2NV153T8",
		"ProductFamily":"Intel SSD D5-P4326 Series",
		"SerialNumber":"PHLL037600N715PDGN"
	},
	"Intel SSD DC S4600 Series BTYM72840CS6240AGN":
	{
		"Bootloader":"Property not found",
		"DevicePath":"/dev/sg0",
		"DeviceStatus":"Healthy",
		"Firmware":"SCV10150",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":1,
		"ModelNumber":"INTEL SSDSC2KG240G7",
		"ProductFamily":"Intel SSD DC S4600 Series",
		"SerialNumber":"BTYM72840CS6240AGN"
	}
}
[root@localhost Desktop]# 
```





unhealthy drive status
```shell
[root@localhost Desktop]# intelmas show -o json -intelssd
{
	"Intel SSD D5-P4326 Series PHLL037600N715PDGN":
	{
		"Bootloader":"0020",
		"Capacity":"15362.99 GB",
		"CurrentPercent":100.00,
		"DevicePath":"/dev/nvme0n1",
		"DeviceStatus":"Healthy",
		"Firmware":"8DV10560",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":0,
		"MaximumLBA":30005842607,
		"ModelNumber":"INTEL SSDPE2NV153T8",
		"ProductFamily":"Intel SSD D5-P4326 Series",
		"SMARTEnabled":true,
		"SectorDataSize":512,
		"SerialNumber":"PHLL037600N715PDGN"
	},
	"Intel SSD DC S4600 Series BTYM72840CS6240AGN":
	{
		"Bootloader":"Property not found",
		"Capacity":"240.06 GB",
		"CurrentPercent":100.00,
		"DevicePath":"/dev/sg0",
		"DeviceStatus":"Healthy",
		"Firmware":"SCV10150",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":1,
		"MaximumLBA":468862127,
		"ModelNumber":"INTEL SSDSC2KG240G7",
		"ProductFamily":"Intel SSD DC S4600 Series",
		"SMARTEnabled":true,
		"SectorDataSize":"Property not found",
		"SerialNumber":"BTYM72840CS6240AGN"
	}
}
[root@localhost Desktop]# isdct show -o json -intelssd
{
	"Intel SSD D5-P4326 Series PHLL037600N715PDGN":
	{
		"Bootloader":"0020",
		"DevicePath":"/dev/nvme0n1",
		"DeviceStatus":"Healthy",
		"Firmware":"8DV10560",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":0,
		"ModelNumber":"INTEL SSDPE2NV153T8",
		"ProductFamily":"Intel SSD D5-P4326 Series",
		"SerialNumber":"PHLL037600N715PDGN"
	},
	"Intel SSD DC S4600 Series BTYM72840CS6240AGN":
	{
		"Bootloader":"Property not found",
		"DevicePath":"/dev/sg0",
		"DeviceStatus":"Healthy",
		"Firmware":"SCV10150",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":1,
		"ModelNumber":"INTEL SSDSC2KG240G7",
		"ProductFamily":"Intel SSD DC S4600 Series",
		"SerialNumber":"BTYM72840CS6240AGN"
	}
}
[root@localhost Desktop]# 
```

