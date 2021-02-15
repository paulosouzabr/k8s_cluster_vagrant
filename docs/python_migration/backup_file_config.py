#!/usr/bin/env pytho3

import os
import os.path
import shutil

def check_file_config():
    if os.path.isfile('./Vagrantfile'):
        print("File exist\n")
    else:
        print("File not exist\n")

def backup_file():
    path_backup_file = '/tmp/vagrant_backup_tmp'
    path_config_file = './Vagrantfile'
    if os.path.exists(path_backup_file):
        shutil.rmtree(path_backup_file)
        os.mkdir(path_backup_file)
        print(f"Successfully created the directory {path_backup_file}\n")
    else:
        os.mkdir(path_backup_file)
        print(f"Successfully created the directory {path_backup_file}\n")

    source_file = path_config_file
    destination_file = path_backup_file + '/Vagrantfile'
    shutil.copyfile(source_file, destination_file)
    listdir_backup = os.listdir(path_backup_file)
    print(listdir_backup)

check_file_config()
backup_file()