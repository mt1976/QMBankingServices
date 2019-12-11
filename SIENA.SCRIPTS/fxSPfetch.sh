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
#qmhome="/home/mwt"
#qmhome=$(pwd)
#qmhome="/home/sales/qm/account/mwt-QM-dev"
#jq="/snap/bin/jq"
#outputDir="SIENA.IN"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "[M] i'm in  = "$DIR
initloc=$DIR+"mdsInit.sh"
echo "[M] initLoc = "$initLoc
. $initLoc


clear
figlet -f small "[M] Get Spot FX Rates"
echo
echo "[M] Attempt to get 'latest' spot fx rates for processing"
echo
fetchID="SP"
endpoint="latest"
accessKey=$fixerAccessKey
urlDest="http://data.fixer.io/api/"
baseCCY="EUR"
symbols="USD,JPY,GBP,BTC,CAD,AUD,XAU,CHF,MXN,NOK,DKK,RUR,RMB,HKD,CAD,CHF,DKK,GBP,HKD,JPY,NOK,SEK,SGD,USD,ZAR"
path=$mdsHome
newline="\n"
dateID=$(date "+%Y%m%d%H%M")
rateSource="2"

destFile=""
destFile+=$qmhome
destFile+="/"
destFile+=$outputDir
destFile+="/"
destFile+="fx_"$fetchID"_rates_"
destFile+=$dateID
destFile+=".csv"

#
#echo $fileHDR
echo "[M] qmhome         = ["$qmhome"]"
echo "[M] jq             = ["$jq"]"
echo "[M] fixerAccessKey = ["$fixerAccessKey"]"
echo "[M] path           = ["$path"]"
echo "[M] outputDir      = ["$outputDir"]"
echo "[M] endpoint       = ["$endpoint"]"
echo "[M] accessKey      = ["$accessKey"]"
echo "[M] urlDest        = ["$urlDest"]"
#echo "[M] baseCCY   = ["$baseCCY"]"
echo "[M] symbols        = ["$symbols"]"
echo "[M] dateID         = ["$dateID"]"
echo "[M] destFile       = ["$destFile"]"
echo "[M] rateSource     = ["$rateSource"]"
#
# Build URL request_cmd
request_cmd=$urlDest
request_cmd+=$endpoint
request_cmd+="?"
request_cmd+="access_key="$accessKey
#Can't request_cmd base currency quotes from the fixer.io engine (without a subscription)
#request_cmd+="&"
#request_cmd+="base="$baseCCY
request_cmd+="&"
request_cmd+="symbols="$symbols
#
echo "[M] request     = ["$request_cmd"]"
#
curlArgs=""
# Execute the curl URL request_cmd
result=$(curl $curlArgs "$request_cmd")
#
rateDate=$(echo $result | $jq -r '.date')
rateBase=$(echo $result | $jq -r '.base')
rateRates=$(echo $result | $jq '.rates')
noRates=$(echo $result | $jq '.rates|length')
#
echo "[M] result    = ["$result"]"
echo "[M] rateDate  = ["$rateDate"]"
echo "[M] rateBase  = ["$rateBase"]"
echo "[M] rateRates = ["$rateRates"]"
echo "[M] noRates   = ["$noRates"]"
#
outputFile=""
#
# Now parse each currency to generate csv row data
for ((c=1;c<=$noRates;c++))
do
#
  id="$(($c-1))"
  rCCY=$(echo $result | $jq -r '.rates | keys | .['$id']')
  rRate=$(echo $result | $jq -r '.rates.'$rCCY)
#
  echo "[M] > index      = ["$id"] ["$rCCY"] "$c" "$id" ["$rRate"] "$c" "$id
#
  outputFile+="FX"
  outputFile+=","
  outputFile+=$rateSource
  outputFile+=","
  outputFile+="FXSPOT"
  outputFile+=","
  outputFile+="SP"
  outputFile+=","
  outputFile+=","
  outputFile+="SIMU"
  outputFile+=","
  outputFile+=$rateBase
  outputFile+=","
  outputFile+=$rCCY
  outputFile+=","
  outputFile+=$rRate
  outputFile+=","
  outputFile+=$rRate
  outputFile+=",Market,0,A,"$dateID
  outputFile+=$newline
#
done
#
# File has been merged and built - Now Output File array to the destination file
#
#rm "$destFile"
echo -e "$outputFile" >> "$destFile"
figlet -f small "[M] JOB DONE"
#
