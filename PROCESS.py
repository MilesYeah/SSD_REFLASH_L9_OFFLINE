#!/usr/bin/env python
import concurrent
import multiprocessing
import os
import re
import subprocess
import datetime
import json
import logging
import threading
import time

from concurrent.futures import ThreadPoolExecutor, wait, FIRST_COMPLETED, ALL_COMPLETED
from collections import OrderedDict
from logging.handlers import RotatingFileHandler

# series that need special tool to get FW updated.
REGX_DCT = "(D5-P4618)"
REGX_FUT = "(X18-M|X25-M|X25-E)"
# REGX_MAS = "()"

NEED_REBOOT = False

DATE_TIME_START = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
LOG_FILE = f"{DATE_TIME_START}_SSD_UPDATE.log"
LOG_PATH = os.path.join('.', "log")
if not os.path.exists(LOG_PATH):
    os.makedirs(LOG_PATH)

logging.basicConfig(level=logging.INFO)
format_1 = '%(asctime)s|%(levelname)s|%(name)s: %(message)s'
format_2 = '%(name)s|%(levelname)s: %(message)s'
fmt_1 = logging.Formatter(format_1)
fmt_2 = logging.Formatter(format_2)
handler_file = RotatingFileHandler(filename=os.path.join(LOG_PATH, LOG_FILE),
                                   mode="w", encoding='utf8', maxBytes=1024*1024*512, backupCount=100)
handler_file.setLevel(logging.INFO)
handler_file.setFormatter(fmt=fmt_1)
handler_console = logging.StreamHandler()
handler_console.setLevel(logging.DEBUG)
handler_console.setFormatter(fmt=fmt_2)
logger = logging.getLogger("ssd_refresh")
logger.addHandler(handler_file)
logger.addHandler(handler_console)


STR_PASS = """
         PPPPP     AA     SSS    SSS          
         PP  PP    AA    S   S  S   S         
         PP   P   A  A   S      S             
         PP  PP   A  A    SSS    SSS          
         PPPPP    A  A       S      S         
         PP       AAAA       S      S         
         PP      A    A  S   S  S   S         
         PP      A    A   SSS    SSS"""

STR_FAIL = """
        FFFFFFF   AA    IIIIII  LL     
        FF        AA      II    LL     
        FF       A  A     II    LL     
        FFFFF    A  A     II    LL     
        FF       A  A     II    LL     
        FF       AAAA     II    LL     
        FF      A    A    II    LL     
        FF      A    A  IIIIII  LLLLLLL"""


STD_DRIVE_FWS = OrderedDict()
with open("SSD_LIST.txt", 'r') as f:
    for line in f.readlines():
        if "=" in line:
            model, fw = line.strip().split("=")
            STD_DRIVE_FWS[model] = fw


def get_drive_list():
    drive_list = OrderedDict()
    cmd = ["intelmas", "show", "-o", "json", "-intelssd"]
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf8')
    out, err = p.communicate()
    json_dict = json.loads(out)
    for ssd_brief, ssd_d in json_dict.items():
        drive_list[ssd_brief] = HandlerSSD(ssd_d)
        # print(drive_list[ssd_brief].fw_bin_fpn)
    return drive_list


class HandlerSSD(object):
    def __init__(self, d):
        self.logger = logger
        self.data = d

        self._fw_tool = None

        self.fw_ver_curr = self.data.get("Firmware", None)
        self.index = self.data.get("Index", None)
        self.model = self.data.get("ModelNumber", None)
        self.prod_family = self.data.get("ProductFamily", None)
        self.serial_number = self.data.get("SerialNumber", None)

    def __repr__(self):
        return f"{self.index}, {self.model}, {self.fw_ver_curr}, {self.fw_status}, {self.prod_family}"

    @property
    def fw_ver_std(self):
        return STD_DRIVE_FWS.get(self.model, None)

    @property
    def fw_tool(self):
        tool = None
        if re.search(REGX_DCT, self.prod_family, re.I):
            tool = "isdct"
        elif re.search(REGX_FUT, self.prod_family, re.I):
            tool = "issdfut"
        else:
            tool = "intelmas"
        return tool

    @property
    def fw_bin_fpn(self):
        fpn = None
        for dirpath, dirnames, filenames in os.walk('.'):
            if self.fw_ver_std is not None and self.fw_ver_std in dirpath:
                for fn in filenames:
                    if fn.endswith("bin"):
                        fpn = os.path.join(dirpath, fn)
                        break
            if fpn:
                break
        return fpn

    @property
    def fw_status(self):
        status = "UNKNOWN"
        if self.fw_ver_std:
            if self.fw_ver_curr == self.fw_ver_std:
                status = "COMPLETE"
            else:
                status = "NEED"
        return status

    @property
    def cmd_fw_upd(self):
        if self.fw_bin_fpn:
            # issdcm -drive_index $Index -firmware_update $FW_image
            cmd = ["issdcm", "-drive_index", self.index, '-firmware_update', self.fw_bin_fpn]
        else:
            cmd = [self.fw_tool, "load", "-f", "-intelssd", self.serial_number]
        if None in cmd:
            cmd = None
        return cmd

    def ssd_fw_upd(self):
        if self.fw_status == "COMPLETE":
            self.logger.info(f"No need to update FW for current drive: {self}")
        else:
            # self.logger.info(f"Updating fw: {self.cmd_fw_upd}")
            p = subprocess.Popen(self.cmd_fw_upd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf8')
            out, err = p.communicate()
            if re.findall("reboot the system", out, re.I):
                NEED_REBOOT = True
                self.logger.info(f"{self} needs a system OS reboot so FW takes effects.")
            # if err:
                # self.logger.error(f'FW update failed on "{self}" for:"{err}"')
            self.logger.info(f"FW updating: {self.cmd_fw_upd}\n{err}\n{out}")


def upd_ssd_fws():
    with ThreadPoolExecutor(max_workers=multiprocessing.cpu_count()) as t:
        tasks = [t.submit(obj_ssd.ssd_fw_upd) for brief_ssd, obj_ssd in DRIVE_LIST_START.items()]
        concurrent.futures.wait(tasks)
        while True:
            count = len(tasks)
            for task in tasks:
                if not task.running():
                    count -= 1
            if count < 1:
                break
            else:
                logger.info(f"Currently {count} drives are still being updated.")
                time.sleep(5)

    if NEED_REBOOT:
        os.system("reboot")


def chk_after_flash():
    logger.info("SN,INDEX,MODEL,FW,STATUS")
    for ssd_brief_start, obj_ssd_start in DRIVE_LIST_START.items():
        obj_ssd_end = DRIVE_LIST_END.get(ssd_brief_start, None)
        if obj_ssd_end is not None and obj_ssd_end.serial_number is not None:
            logger.info(f"{obj_ssd_end}")
        else:
            logger.error(f"{obj_ssd_start.serial_number},{obj_ssd_start.index},UNKNOWN,MISSING")


if __name__ == "__main__":
    DRIVE_LIST_START = get_drive_list()
    upd_ssd_fws()
    DRIVE_LIST_END = get_drive_list()
    chk_after_flash()

