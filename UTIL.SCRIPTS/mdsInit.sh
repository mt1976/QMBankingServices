#!/bin/bash
#
# ===================================================================
# Purpose:           INITIALISE common variables
# Parameters:        one ; two ; three
#                    ---------------------------
#                    $one = (enum) load, unload
#                    $two = (string) second parameter
#                    $three = (num) expected
#                    ---------------------------
# Called From:       Scheduler
# Author:            Matt Townsend
# Notes:
# Revsion:
# ===================================================================
#

if [[ $(uname -s) == Linux ]]
then
  COMPUTER_NAME=${HOSTNAME^^}
else
  COMPUTER_NAME=$(scutil --get ComputerName)
fi

#echo "[mwt] '"$COMPUTER_NAME"'"

INIT_FILE=$PWD/UTIL.SCRIPTS/${COMPUTER_NAME^^}_mdsInit.sh

if test -f $INIT_FILE
then
# Do nothing, the login file exists and should be used as an alternative to the login_DEFAULT file.
  echo "[mwt] $INIT_FILE exists."
  . $INIT_FILE

else
# INIT_FILE=$HOME/mwt_scripts/login_DEFAULT.sh
  echo "[mwt] $INIT_FILE using fallback."
  echo "[M] INITIALISE COMMON VARS - START"q
  export qmHome="/home/sales/qm/account/mwt-QM-dev"
  export jq="/snap/bin/jq"
  export fixerAccessKey="c3811be81a6df1db0e14304d77b3a23d"
  export fredAccessKey="d4d50b886c05baa2795c363319ca64db"
  export outputDir="SIENA.IN"
  export mdsHome="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
fi

echo "[M] QMHOME         = ["$qmHome"]"
echo "[M] JQ             = ["$jq"]"
echo "[M] FIXERACCESSKEY = ["$fixerAccessKey"]"
echo "[M] FREDACCESSKEY  = ["$fredAccessKey"]"
echo "[M] OUTPUTDIR      = ["$outputDir"]"
echo "[M] MDSHOME        = ["$mdsHome"]"
echo "[M] INITIALISE COMMON VARS - DONE"
