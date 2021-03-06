#!/bin/bash
# This script checks the health of disks
#  https://rhau.se/2012/11/08/disk-check-script/
#Define a friendly name for this machine
mname="$1"
 
#Location to temporary store the error log
logloc="/root/scripts"
#Set default for not sendig mails
sendm="0"
 
# Disks to check
disks="/dev/sda
/dev/sdb"
 
# Setting up path
PATH="$PATH:/usr/bin:/usr/sbin"
 
# variable containing all needed commands
needed_commands="smartctl awk mail"
 
# Checking if all needed programs are available on system
for command in $needed_commands
do
  if ! hash "$command" > /dev/null 2>&1
  then
    echo "$command not found on system" 1>&2
    exit 1
  fi
done
 
# Checking disk
for disk in $disks
do
  # Creating a array with results
  declare -a status=(`smartctl -a -d ata $disk | awk '/Reallocated_Sector_Ct/ || /Seek_Error_Rate/ { print $2" "$NF }'`)
  # Checking that we do not have any Reallocated Sectors
  if [ "${status[1]}" -ne 0 ]
  then
    echo "$mname Warning: Disk $disk has errors! ${status[0]} ${status[1]} ${status[2]} ${status[3]}. Following complete smartctl output." >> diskerror.log
    smartctl -a -d ata $disk >> $logloc/diskerror.log
    failed=("${failed[@]}" "$disk")
    sendm="1"
  fi
done
 
#Send an e-mail if needed containing the failed diks (fdisks) info.
if [ $sendm == 1 ]; then
  fdisks=${failed[@]}
  mail -s "$mname Disks $fdisks are about to fail." user@localhost < $logloc/diskerror.log
  rm -rf $logloc/diskerror.log
fi