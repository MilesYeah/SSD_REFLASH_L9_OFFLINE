import logging
import os
import re
import pandas


FPN = None
for fn in os.listdir('.'):
    if os.path.isdir(fn):
        continue
    if re.findall('\.(xlsx|xls)$', fn, re.I):
        FPN = os.path.abspath(fn)

if FPN is None:
    exit(1)

xl = pandas.ExcelFile(FPN)
df = xl.parse(xl.sheet_names[0])

LinesNew = {}
for index in df.index:
    line = df.loc[index]
    if re.findall("SSD", line.subsystem, re.I):
        pc = line.product_code
        if len(pc) > 13:
            pc = line.product_code[:13]
        # if line.product_code.endswith("01"):
        #     pc = re.sub("01$", "", line.product_code)
        fw = line.fw_version
        if " " in line.fw_version:
            fw = str(line.fw_version.split()[0]).strip()
        fw_line = f"{pc}={fw}\n"
        if pc not in LinesNew:
            LinesNew[pc] = fw_line
        # logging.debug(fw_line)

LinesOld = {}
with open("SSD_List.txt", mode='r') as f:
    temp = list(set(f.readlines()))
    temp = sorted(temp)
    LinesOld = {k.split("=")[0]: k for k in temp}

with open("SSD_List.new.fromXLSX.txt", mode='w', encoding='utf8') as f:
    LinesNew = dict(sorted(LinesNew.items(), key=lambda x: x[0]))
    f.writelines(LinesNew.values())

for k, v in LinesOld.items():
    if k not in LinesNew:
        LinesNew[k] = v

with open("SSD_List.new.txt", mode='w', encoding='utf8') as f:
    LinesNew = dict(sorted(LinesNew.items(), key=lambda x: x[0]))
    f.writelines(LinesNew.values())

with open("SSD_List.old.txt", mode='w', encoding='utf8') as f:
    f.writelines(LinesOld.values())
    pass
