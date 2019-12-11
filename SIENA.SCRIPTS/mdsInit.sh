#!/bin/bash
#
# ===================================================================
# Purpose:           Fetches Spot FX Rates from fixer.io
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
qmhome="/home/sales/qm/account/mwt-QM-dev"
jq="/snap/bin/jq"
fixerAccessKey="c3811be81a6df1db0e14304d77b3a23d"
outputDir="SIENA.IN"
export qmhome
export jq
export fixerAccessKey
export outputDir
