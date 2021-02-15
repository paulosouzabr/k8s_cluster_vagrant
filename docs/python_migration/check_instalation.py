#!/usr/bin/env python3

import os
import subprocess
import glob

def check_os_version():
    os_release_file = glob.glob('/etc/*-release')
    for item in os_release_file:
        with open(item, 'r') as file:
            for line in file:
                line = line.rstrip()
                matches = subprocess.call(['/bin/grep', line, item])
                print(matches)

check_os_version()