#!/bin/bash

######################################################################
# Backup jenkins configuration.
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
if [ -z ${JK_BACKUP_DIR} ] ; then
  echo "JK_BACKUP_DIR is not defined. exit."
  exit 1
fi

com_logger "I9999" "start process."
com_logger "I9999" "conf=${conf_path}" 


#
# create tmp directory.
#
com_logger "I9999" "try to create tmp directory."
tmp_dir="${base_dir}/tmp/jenkins_backup_${now}"
rm -rf "${tmp_dir}"
if [ $? -ne 0 ]; then
  com_logger "E9999" "cannot remove tmp dir. exit. tmp_dir=${tmp_dir}"
  exit 1
fi

mkdir -p "${tmp_dir}/users"
mkdir -p "${tmp_dir}/jobs"
mkdir -p "${tmp_dir}/plugins"

com_logger "I9999" "tmp directories are created. tmp_dir=${tmp_dir}"


#
# copy configuration files to tmp dir.
#
com_logger "I9999" "copy configuration files."
cp -p "${JK_HOME}/"*.xml "${tmp_dir}"
cp -pR "${JK_HOME}/users/"* "${tmp_dir}/users"
cp -pR "${JK_HOME}/plugins/"* "${tmp_dir}/plugins"
ls -1 ${JK_HOME}/jobs | while read _job_name
do
  mkdir -p "${tmp_dir}/jobs/${_job_name}"
  cp -p "${JK_HOME}/jobs/${_job_name}/"*.xml "${tmp_dir}/jobs/${_job_name}"
done


#
# archive copies to backup directory. 
#
com_logger "I9999" "archive copies to backup directory."
cd "${tmp_dir}/.."
tar -zcvf "${JK_BACKUP_DIR}/jenkins_backup_${now}.tar.gz" "jenkins_backup_${now}"
if [ $? -ne 0 ]; then
  com_logger "E9999" "backup error occurred. exit."
  exit 1
fi


#
# rotate backup files.
#
com_logger "I9999" "rotate backup files."
find ${JK_BACKUP_DIR}/ -mtime +${JK_BACKUP_GENE} -type f -exec rm -f {} \;
if [ $? -ne 0 ]; then
  com_logger "E9999" "rotate backup files error occurred. exit."
  exit 1
fi


#
# clean up.
#
rm -rf "${tmp_dir}"
if [ $? -ne 0 ]; then
  com_logger "W9999" "cannot remove tmp dir. tmp_dir=${tmp_dir}."
fi
com_logger "I9999" "clean up tmp directory. tmp_dir=${tmp_dir}"


com_logger "I9999" "process finished normally. exit=0"
exit 0


#####################################################################
# function usage().
#
# echo usage. 
#####################################################################
function usage() {
  echo ""
  echo "Usage: ${script_name}"
  echo ""
  echo "Options:"
  echo "  This script has no options."
  echo ""
}
 
