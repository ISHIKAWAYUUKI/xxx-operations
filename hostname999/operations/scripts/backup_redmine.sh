#!/bin/bash

######################################################################
# Backup redmine data.
# 
# description...
# 
######################################################################


######################################################################
# main.
######################################################################
#
# initialize.
#
now=$(date '+%Y%m%d%H')
script_name=$(basename ${0})

base_dir=$(cd $(dirname ${0})/../ && pwd) 
conf_path=${base_dir}/conf/ope.conf
log_path="${base_dir}/log/${script_name%.*}_${now}.log"

source ${conf_path}
source ${base_dir}/scripts/com_logger.sh
if [ -z ${RM_BACKUP_DIR} ]; then
  echo "RM_BACKUP_DIR is not defined. exit."
  exit 1
fi

com_logger "I9999" "start process."
com_logger "I9999" "conf=${conf_path}" 


#
# backup dababase.
#
com_logger "I9999" "backup database."
mysqldump -u ${RM_DB_USER} -p${RM_DB_PASS} ${RM_DB_NAME} \
  | gzip > ${RM_BACKUP_DIR}/redmine_db_${now}.gz
if [ $? -ne 0 ]; then
  com_logger "E9999" "backup database error occurred. exit."
  exit 1
fi


#
# backup uploaded files.
#
com_logger "I9999" "backup uploaded files."
cd "${RM_HOME}"
tar -zcvf "${RM_BACKUP_DIR}/redmine_files_${now}.tar.gz" "files"
if [ $? -ne 0 ]; then
  com_logger "E9999" "backup uploaded files error occurred. exit."
  exit 1
fi


#
# rotate backup files
#
com_logger "I9999" "rotate backup files."
find ${RM_BACKUP_DIR}/ -mtime +${RM_BACKUP_GENE} -type f -exec rm -f {} \;
if [ $? -ne 0 ]; then
  com_logger "E9999" "rotate backup files error occurred. exit."
  exit 1
fi


com_logger "I9999" "process finished normally. exit=0"
exit 0


#####################################################################
# function usage().
#
# echo usage. 
#
#####################################################################
function usage() {
  echo ""
  echo "Usage: ${script_name}"
  echo ""
  echo "Options:"
  echo "  This script has no options."
  echo ""
}
 
