#!/bin/bash
# Name: SMART-report.sh
# Purpose: Sends report of SMART status of RAID hard disks
# Syntax: SMART-report.sh
#--------------------------------------------------------
(. ~/.bashrc
echo -n "/dev/sda: "
smartctl -d scsi -H /dev/sda | grep 'SMART'
echo -n "/dev/sdb: "
smartctl -d scsi -H /dev/sdb | grep SMART
echo "Individual drives behind the RAID controller";echo
echo "============== /dev/sda ===> /dev/sg1 ============="
smartctl -d scsi --all -T permissive /dev/sg1 | grep 'SMART';echo
echo "============== /dev/sda ===> /dev/sg2 ============="
smartctl -d scsi --all -T permissive /dev/sg2 | grep 'SMART';echo
echo "============== /dev/sdb ===> /dev/sg3 ============="
smartctl -d scsi --all -T permissive /dev/sg3 | grep 'SMART';echo
echo "============== /dev/sdb ===> /dev/sg4 ============="
smartctl -d scsi --all -T permissive /dev/sg4 | grep 'SMART'
) | mail -s "SMART Result of $(hostname -f)" user@my-email.com