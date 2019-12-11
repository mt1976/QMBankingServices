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
echo "[M] INITIALISE COMMON VARS"
export qmhome="/home/sales/qm/account/mwt-QM-dev"
export jq="/snap/bin/jq"
export fixerAccessKey="c3811be81a6df1db0e14304d77b3a23d"
export outputDir="SIENA.IN"
echo "[M] INITIALISE COMMON VARS - DONE"
