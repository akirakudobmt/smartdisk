PATH=$(pwd)
TIMESTAMP='date "+%Y-%m-%d %H:%M:%S"'
LOGDATE='date "+%Y_%m_%d"'
LOGDIR=${PATH}/hpe-log
LOGFILE="${LOGDIR}/hpe_${LOGDATE}.log"

get_version_smartclt(){
    echo "Script was called with get_device_name"
    sudo smartctl -V | head -n1 | awk '$1 == "smartctl" {print $2}'
}

get_device_name(){
    echo "Script was called with get_device_name"
    # smartctl --scan
}

get_device_info(){
    echo "Script was called with get_device_info"
    # smartctl -i /dev/
}

check_device_health(){
    echo "Script was called with check_device_health"
    # smartctl -H /dev/
}

check_raid_device_health(){
    echo "Script was called with check_raid_device_health"
    # Testing drives behind MegaRAID
    # for i in {0..23}; do sudo smartctl -x /dev/sda -d megaraid,$i >>./OUTPUT; done
    # 
    # smartctl -i -d megaraid,0 /dev/sda
    # TODO: check RAID https://www.cyberciti.biz/faq/linux-checking-sas-sata-disks-behind-adaptec-raid-controllers/
    # TODO: https://www.abort-retry-fail.com/2018/11/22/using-smartctl-to-monitor-the-adaptec-2405-raid-controller-disks/
    # https://www.thomas-krenn.com/en/wiki/Smartmontools_with_MegaRAID_Controller
}

run_test(){
    echo "Script was called with run_test"
    # 'smartctl --test = short /dev/'
}

get_results(){
    echo "Script was called with get_results"
    # 'smartctl -l selftest /dev/'
}

get_results_detail(){
    echo "Script was called with get_results"
}

save_results_to_file(){
    echo "Script was called with save_results_to_file"
    [ ! -e smart-logs ] && mkdir smart-logs
    [ ! -d smart-logs ] && Can not create smart-logs dir && exit 1
    # Run command # bash ${CC_PATH}/_func.sh 123 $1 >> ${LOGFILE} 2>&1
}

send_email(){
    echo "Script was called with send_email"
}

### Main script starts here
# get_version_smartclt
# get_device_name
# get_device_info
# check_device_health
# run_test
# get_results
save_results_to_file
# send_email

