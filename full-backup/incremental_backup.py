#!/usr/bin/python3
import os
import re
import argparse

from datetime import datetime

parser = argparse.ArgumentParser(description="make an incremental backup")
parser.add_argument("dir", help="directory to backup")
parser.add_argument("-o", dest="output", default=".", help="output directory")
parser.add_argument("-X", dest="exclude", default="exclude-files.txt", help="files to exclude")
parser.add_argument("--no-exclude", dest="use_exclude", action="store_false",
        help="do not use exclude file")

args = parser.parse_args()
date = datetime.now().strftime("%Y-%m-%d")


if args.use_exclude and not os.path.isfile(args.exclude):
    raise RuntimeError("exclude file do not exist")

if not os.access(args.output, os.X_OK | os.W_OK):
    raise RuntimeError("cannot write to output directory")

files = os.listdir(args.output)
first = True
backup_id = 0

for file in files:
    if re.match("backup_[0-9]{4}-[0-9]{2}-[0-9]{2}_full.tar.gz", file):
        first = False
    match = re.match("backup_[0-9]{4}-[0-9]{2}-[0-9]{2}_incremental_([0-9]{3}).tar.gz", file)
    if match:
        if int(match.group(1)) > backup_id:
            backup_id = int(match.group(1))
backup_id += 1


command = f"tar -g {args.output}/tar_snapshot "

if args.use_exclude:
    command += f"-X {args.exclude} "

command += f"-czpvf {args.output}/backup_{date}_"

if first:
    command += "full.tar.gz "
else:
    command += f"incremental_{str(backup_id).zfill(3)}.tar.gz "

command += f"-C {args.dir} ."

print(command)

if not first:
    os.system(f"cp {args.output}/tar_snapshot {args.output}/tar_snapshot.bak")
os.system(command)

print("fin!")
