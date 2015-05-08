#!/bin/bash

######################################################################
# function com_logger().
# 
# description...
#
# arguments:
#   $1 message_id: message id.
#   $2 message_text: message text.
# 
# dependent valiables:
#   $log_path :mandatory. logfile path.
#   $script_name :optional. caller scirpt name.
# 
######################################################################

function com_logger() {

  if [ $# -ne 2 ]; then
    echo "argments error. exit."
    exit 1
  fi

  _logdate=$(date '+%Y-%m-%d %H:%M:%S')
  echo "${_logdate} func=${script_name} pid=$$ ${1} ${2}" >> ${log_path}

  return
}

