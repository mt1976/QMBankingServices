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
outputDir="SIENA.IN"
fetchID="CPI"

path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

clear


figlet -f small "MT: Fetch "$fetchID" Rate"
echo
echo "MT: Attempt to get 'latest' "$fetchID" rate for processing"
echo
apiKey="d4d50b886c05baa2795c363319ca64db"
dateID=$(date "+%Y%m%d")
dateFetch=$(date "+%Y-%m-%d")
#dateTo=$(date "+%d-%m-%Y" --date="1 days ago")
outputFileName=$qmpath"/SIENA.TEMP/fred_"$fetchID"_"$dateID".tmp"

echo "MT: TODAY     = ["$dateID"]"
echo "MT: FETCH     = ["$dateFetch"]"
echo "MT: API KEY   = ["$apiKey"]"

#seriesLIST=(CHF12MD156N	CHF1MTD156N)
seriesLIST=(GBRCPIALLMINMEI CPALCY01USQ661N)
#seriesLIST=(CHF12MD156N	CHF1MTD156N CHF1WKD156N)
for seriesKEY in "${seriesLIST[@]}"
do
  echo "MT: SERIES ID = ["$seriesKEY"]"
  outCCY=${seriesKEY:0:3}
  outTENOR=${seriesKEY:3:2}
  outputFileName=$qmpath"/SIENA.TEMP/fred_"$fetchID"_"$seriesKEY"_"$dateID".json"
  echo "MT: OUT CCY   = ["$outCCY"]"

  outTENOR=${outTENOR/12/1Y}
  outCCY=${outCCY/CPA/USA}

  echo "MT: OUT TENOR = ["$outTENOR"]"
  echo "MT: OUTPUT TO = ["$outputFileName"]"

uri1="https://api.stlouisfed.org/fred/series/observations?"
uri2="series_id="$seriesKEY
uri3="&api_key="$apiKey
uri4="&realtime_start="$dateFetch
uri5="&realtime_end="$dateFetch
uri6="&file_type=json"

request_cmd=$uri1$uri2$uri3$uri4$uri5$uri6

echo "MT: request    = ["$request_cmd"]"
#
curlArgs="-sL"
# Execute the curl URL request_cmd
result=$(curl $curlArgs "$request_cmd")

echo $result > $outputFileName

noRates=$(echo $result | jq '.count')
noRates=$((noRates-1))
rateDate=$(echo $result | jq '.observations['$noRates'].date')
rateValu=$(echo $result | jq '.observations['$noRates'].value')

echo "MT: No. Rates = ["$noRates"]"
echo "MT: Rate Date = ["$rateDate"]"
echo "MT: Rate Value = ["$rateValu"]"
#echo $result


destFile=""
destFile+=$qmpath
destFile+="/"
destFile+=$outputDir
destFile+="/"
destFile+="mm_"$fetchID"_rates_"
destFile+=$dateID
destFile+=".csv"
outputFile=""
outputFile+="MM"
outputFile+=","
outputFile+="2"
outputFile+=","
outputFile+="INDEX"
outputFile+=","
outputFile+="ON"
outputFile+=","
outputFile+=","
outputFile+="SIMU"
outputFile+=","
outputFile+=$outCCY
outputFile+=","
outputFile+=""
outputFile+=","
outputFile+=$rateValu
outputFile+=","
outputFile+=$rateValu
outputFile+=",Market,0,A,"
outputFile+=$rateDate","$fetchID
echo -e "$outputFile" >> "$destFile"
done
figlet -f small "MT: JOB DONE"
#
