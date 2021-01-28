# encoding: utf-8

"""
@author: Robert.Ye
Date: 12/25/2020 8:55 AM
docs: 
"""

import os, re
import subprocess


# for dirpath, dirnames, filenames in os.walk("."):
#     pass

p = subprocess.Popen(['powershell', "dir"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf8')
o, e = p.communicate()

print()
