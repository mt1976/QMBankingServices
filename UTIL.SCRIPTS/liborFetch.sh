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
#qmhome="/home/mwt"
#qmhome=$(pwd)
#qmhome="/home/sales/qm/account/mwt-QM-dev"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
initLoc=$DIR"/mdsInit.sh"
. $initLoc

#outputDir="SIENA.IN"
fetchID="LIBOR"

path=$mdsHome

#clear
figlet -f digital "[M] Fetch "$fetchID" Rate"
echo "[M] Get 'latest' "$fetchID" rate for processing"

apiKey=$fredAccessKey
dateID=$(date "+%Y%m%d")
dateFetch=$(date "+%Y-%m-%d")
#dateTo=$(date "+%d-%m-%Y" --date="1 days ago")
#outputFileName=$qmhome"/SIENA.TEMP/fred_"$fetchID"_"$dateID".tmp"

echo "[M] TODAY     = ["$dateID"]"
echo "[M] FETCH     = ["$dateFetch"]"
echo "[M] API KEY   = ["$apiKey"]"

#seriesLIST=(CHF12MD156N	CHF1MTD156N)
seriesLIST=(CHF12MD156N	CHF1MTD156N	CHF1WKD156N	CHF3MTD156N	CHF6MTD156N	CHFONTD156N	EUR12MD156N	EUR1MTD156N	EUR1WKD156N	EUR2MTD156N	EUR3MTD156N	EUR6MTD156N	EURONTD156N	GBP12MD156N	GBP1MTD156N	GBP1WKD156N	GBP2MTD156N	GBP3MTD156N	GBP6MTD156N	GBPONTD156N	JPY12MD156N	JPY1MTD156N	JPY1WKD156N	JPY2MTD156N	JPY3MTD156N	JPY6MTD156N	JPYONTD156N	USD12MD156N	USD1MTD156N	USD1WKD156N	USD2MTD156N	USD3MTD156N	USD6MTD156N	USDONTD156N
)
#seriesLIST=(CHF12MD156N	CHF1MTD156N CHF1WKD156N)
for seriesKEY in "${seriesLIST[@]}"
do
  echo "[M] SERIES ID = ["$seriesKEY"]"
  outCCY=${seriesKEY:0:3}
  outTENOR=${seriesKEY:3:2}
  outputFileName=$qmHome"/SIENA.TEMP/fred_"$fetchID"_"$seriesKEY"_"$dateID".json"
  #outputFileName="liborDataSnatched/fred_libor_"$seriesKEY"_"$dateID".json"
  echo "[M] OUT CCY   = ["$outCCY"]"

  outTENOR=${outTENOR/12/1Y}
  echo "[M] OUT TENOR = ["$outTENOR"]"
  echo "[M] OUTPUT TO = ["$outputFileName"]"

uri1="https://api.stlouisfed.org/fred/series/observations?"
uri2="series_id="$seriesKEY
uri3="&api_key="$apiKey
uri4="&realtime_start="$dateFetch
uri5="&realtime_end="$dateFetch
uri6="&file_type=json"

request_cmd=$uri1$uri2$uri3$uri4$uri5$uri6

echo "[M] request    = ["$request_cmd"]"
#
curlArgs="-sL"
# Execute the curl URL request_cmd
result=$(curl $curlArgs "$request_cmd")

echo $result > $outputFileName

noRates=$(echo $result | $jq '.count')
noRates=$((noRates-1))
rateDate=$(echo $result | $jq '.observations['$noRates'].date')
rateValu=$(echo $result | $jq '.observations['$noRates'].value')

echo "[M] No. Rates = ["$noRates"]"
echo "[M] Rate Date = ["$rateDate"]"
echo "[M] Rate Value = ["$rateValu"]"
#echo $result


destFile=""
destFile+=$qmHome
destFile+="/"
destFile+=$outputDir
destFile+="/"
destFile+="mm_"$fetchID"_rates_"
destFile+=$dateID
destFile+=".csv"
touch "$destFile"
outputFile=""
outputFile+="MM"
outputFile+=","
outputFile+="2"
outputFile+=","
outputFile+="INTEREST"
outputFile+=","
outputFile+=$outTENOR
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
outputFile+=$rateDate
echo "[M] STORE = ["$destFile"]"
echo -e "$outputFile" >> "$destFile"

done

figlet -f digital "[M] JOB DONE"
#
