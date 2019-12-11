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
qmhome=$(pwd)
qmhome="/home/sales/qm/account/mwt-QM-dev"
jq="/snap/bin/jq"
outputDir="SIENA.IN"
fetchID="SP"

clear
figlet -f small "MT: Get Spot FX Rates"
echo
echo "MT: Attempt to get 'latest' spot fx rates for processing"
echo
endpoint="latest"
accessKey="c3811be81a6df1db0e14304d77b3a23d"
urlDest="http://data.fixer.io/api/"
baseCCY="EUR"
symbols="USD,JPY,GBP,BTC,CAD,AUD,XAU,CHF,MXN,NOK,DKK,RUR,RMB,HKD,CAD,CHF,DKK,GBP,HKD,JPY,NOK,SEK,SGD,USD,ZAR"
path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
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
echo "MT: path      = ["$path"]"
echo "MT: outputDir = ["$outputDir"]"
echo "MT: endpoint  = ["$endpoint"]"
echo "MT: accessKey = ["$accessKey"]"
echo "MT: urlDest   = ["$urlDest"]"
#echo "MT: baseCCY   = ["$baseCCY"]"
echo "MT: symbols   = ["$symbols"]"
echo "MT: dateID    = ["$dateID"]"
echo "MT: destFile  = ["$destFile"]"
echo "MT: rateSource= ["$rateSource"]"
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
echo "MT: request     = ["$request_cmd"]"
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
echo "MT: result    = ["$result"]"
echo "MT: rateDate  = ["$rateDate"]"
echo "MT: rateBase  = ["$rateBase"]"
echo "MT: rateRates = ["$rateRates"]"
echo "MT: noRates   = ["$noRates"]"
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
  echo "MT: > index      = ["$id"] ["$rCCY"] "$c" "$id" ["$rRate"] "$c" "$id
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
figlet -f small "MT: JOB DONE"
#
