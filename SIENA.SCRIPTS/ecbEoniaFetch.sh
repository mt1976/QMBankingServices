#!/bin/bash
#
# ===================================================================
# Purpose:           Fetches Spot ECB EONIA Rates from fixer.io
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

#qmpath="/home/mwt"
qmpath=$(pwd)
qmpath="/home/sales/qm/account/mwt-QM-dev"
outputDir="SIENA.IN"
fetchID="EONIA"

path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

clear
figlet -f small "MT: Fetch ECB EONIA Rate"
echo
echo "MT: Attempt to get 'latest' EONIA rate for processing"
echo
dateID=$(date "+%Y%m%d")
#dateFrom=$(date "+%d-%m-%Y" --date="2 days ago")
#dateTo=$(date "+%d-%m-%Y" --date="1 days ago")
dateFrom=$(date -v -2d "+%d-%m-%Y")
dateTo=$(date -v -1d "+%d-%m-%Y")

fetchID="EONIA"
#outputFileName="ecbDataSnatched/ecb_EONIA_"$dateID".xml"

outputFileName=$qmpath"/SIENA.TEMP/ecb_"$fetchID"_"$dateID".xml"

seriesKEY="198.EON.D.EONIA_TO.RATE"
echo "MT: TODAY     = ["$dateID"]"
echo "MT: FROM      = ["$dateFrom"]"
echo "MT: TO        = ["$dateTo"]"
request_cmd="https://sdw.ecb.europa.eu/quickviewexport.do?trans=N&start="$dateFrom"&end="$dateTo"&SERIES_KEY="$seriesKEY"&type=sdmx"
echo "MT: request   = ["$request_cmd"]"
#
curlArgs="-sL"
# Execute the curl URL request_cmd
result=$(curl $curlArgs "$request_cmd")

echo $result > $outputFileName
#echo $result

test="OBS_VALUE="
startPOS=$(awk -v a="$result" -v b="$test" 'BEGIN{print index(a,b)}')
testLEN=${#test}
#echo $test
#echo $startPOS
#echo $testLEN
let extractStart=$startPOS+10
#echo $extractStart
extractONE=${result:extractStart:testLEN}
#echo $extractONE
test="\""
quotePOS=$(awk -v a="$extractONE" -v b="$test" 'BEGIN{print index(a,b)}')
#echo $quotePOS
let quoteEND=$quotePOS-1
rRate=${extractONE:0:quoteEND}

echo "MT: EONIA     = ["$rRate"]"

# Right, lets store this bugger



destFile=""
destFile+=$qmpath
destFile+="/"
destFile+=$outputDir
destFile+="/"
destFile+="mm_"$fetchID"_rates_"
destFile+=$dateID
destFile+=".csv"

outputFile+="MM"
outputFile+=","
outputFile+="2"
outputFile+=","
outputFile+="INTEREST"
outputFile+=","
outputFile+="ON"
outputFile+=","
outputFile+=","
outputFile+="SIMU"
outputFile+=","
outputFile+="EUR"
outputFile+=","
outputFile+="EUR"
outputFile+=","
outputFile+=$rRate
outputFile+=","
outputFile+=$rRate
outputFile+=",Market,0,A,"
outputFile+=$dateFrom

echo -e "$outputFile" >> "$destFile"

figlet -f small "MT: JOB DONE"
#
