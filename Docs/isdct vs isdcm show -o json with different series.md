[root@localhost ~]# intelmas show -o json -intelssd
{
	"Intel SSD PHLL0376":
	{
		"Bootloader":"Property not found",
		"Capacity":"15362.99 GB",
		"CurrentPercent":"Property not found",
		"DevicePath":"/dev/sg0",
		"DeviceStatus":"Unknown",
		"Firmware":"0560",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":0,
		"MaximumLBA":30005842607,
		"ModelNumber":"INTEL SSDPE2NV15",
		"ProductFamily":"Intel SSD",
		"SMARTEnabled":"Property not found",
		"SectorDataSize":"Property not found",
		"SerialNumber":"PHLL0376"
	},
	"Intel SSD DC S4600 Series BTYM72840CS6240AGN":
	{
		"Bootloader":"Property not found",
		"Capacity":"240.06 GB",
		"CurrentPercent":100.00,
		"DevicePath":"/dev/sg1",
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
[root@localhost ~]# isdct show -o json -intelssd
{
	"Intel SSD DC S4600 Series BTYM72840CS6240AGN":
	{
		"Bootloader":"Property not found",
		"DevicePath":"/dev/sg1",
		"DeviceStatus":"Healthy",
		"Firmware":"SCV10150",
		"FirmwareUpdateAvailable":"The selected drive contains current firmware as of this tool release.",
		"Index":0,
		"ModelNumber":"INTEL SSDSC2KG240G7",
		"ProductFamily":"Intel SSD DC S4600 Series",
		"SerialNumber":"BTYM72840CS6240AGN"
	}
}
[root@localhost ~]#
