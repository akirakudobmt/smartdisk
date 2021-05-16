# https://help.ubuntu.com/community/Smartmontools
# Script by Meliorator. irc://irc.freenode.net/Meliorator
# modified by Ranpha
[ ! "$@" ] && echo "Usage: $0 type [type] [type]"

# Create folder log
# TODO: Add log with date time
[ ! -e smart-logs ] && mkdir smart-logs
[ ! -d smart-logs ] && Can not create smart-logs dir && exit 1

a=0

# Scan disk and select type of test
# TODO: ref https://github.com/prometheus-community/node-exporter-textfile-collector-scripts/blob/master/smartmon.sh
for t in "$@"; do

        case "$t" in
                offline)  l=error;;
                short|long)  l=selftest;;
                *) echo $t is an unrecognised test type. Skipping... && continue
        esac

       for hd in  /dev/disk/by-id/ata*; do
                r=$(( $(smartctl -t $t -d ata $hd | grep 'Please wait' | awk '{print $3}') ))
                echo Check $hd - $t test in $r minutes
                [ $r -gt $a ] && a=$r
       done
     echo "Waiting $a minutes for all tests to complete"
                sleep $(($a))m

        for hd in /dev/disk/by-id/ata*; do
                smartctl -l $l -d ata $hd 2>&1 >> smart-logs/smart-${t}-${hd##*/}.log
        done

        
done

for i in {1..10}; do
        sleep .01
        echo -n -e \\a
done

echo "All tests have completed"

# Testing drives behind MegaRAID
# for i in {0..23}; do sudo smartctl -x /dev/sda -d megaraid,$i >>./OUTPUT; done
# 
# smartctl -i -d megaraid,0 /dev/sda
# TODO: check RAID https://www.cyberciti.biz/faq/linux-checking-sas-sata-disks-behind-adaptec-raid-controllers/
# TODO: https://www.abort-retry-fail.com/2018/11/22/using-smartctl-to-monitor-the-adaptec-2405-raid-controller-disks/
# https://www.thomas-krenn.com/en/wiki/Smartmontools_with_MegaRAID_Controller

# Checking a drive for SMART Capability
# sudo smartctl -i /dev/sda 

# Enabling SMART
# sudo smartctl -s on /dev/sda 

# Testing a Drive
# To find an estimate of the time it takes to conduct each test
# sudo smartctl -c /dev/sda 
# The most useful test is the extended test (long)
# sudo smartctl -t long /dev/sda 
# smartctl --test=short /dev/sda
# smartctl --test=long /dev/sda
# smartctl -a /dev/sda 
# Others mode
# sudo smartctl -t select,10-20
# https://linuxconfig.org/how-to-check-an-hard-drive-health-from-the-command-line-using-smartctl

# Results
# drive's test statistics
# sudo smartctl -l selftest /dev/sda 
# detailed SMART information for an IDE drive
# sudo smartctl -a /dev/sda 
# detailed SMART information for a SATA drive
# sudo smartctl -a -d ata /dev/sda
# https://www.cyberciti.biz/tips/linux-find-out-if-harddisk-failing.html
# Check overall disk PASS
# smartctl -d ata -H /dev/sdb
# Display Overall health of the Disk
# smartctl -H /dev/sda
# Detail fail
# smartctl --attributes --log=selftest /dev/sda
# Dislay error
# https://www.linuxtechi.com/smartctl-monitoring-analysis-tool-hard-drive/