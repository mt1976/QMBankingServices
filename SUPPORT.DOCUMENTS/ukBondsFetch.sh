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

path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
fetchID="ukBonds"
clear
figlet -f small "MT: Fetch "$fetchID" Data"
echo
echo "MT: Attempt to get 'latest' "$fetchID" data for processing"
echo
apiKey=""
dateID=$(date "+%Y%m%d")
dateFetch=$(date "+%Y-%m-%d")
#dateTo=$(date "+%d-%m-%Y" --date="1 days ago")
outputFileName=$fetchID"DataSnatched/fred_"$fetchID"_"$dateID".tmp"
mergedFileName="ratesDataSnatched/"$fetchID"_data_"$dateID".csv"

echo "MT: TODAY     = ["$dateID"]"
echo "MT: FETCH     = ["$dateFetch"]"
#echo "MT: API KEY   = ["$apiKey"]"

#seriesLIST=(CHF12MD156N	CHF1MTD156N)
seriesLIST=(D1A)
#seriesLIST=(CHF12MD156N	CHF1MTD156N CHF1WKD156N)
for seriesKEY in "${seriesLIST[@]}"
do
  echo "MT: SERIES ID = ["$seriesKEY"]"
  outCCY=${seriesKEY:0:3}
  outTENOR=${seriesKEY:3:2}
  outputFileName=$fetchID"DataSnatched/fred_"$fetchID"_"$seriesKEY"_"$dateID".xml"
#  echo "MT: OUT CCY   = ["$outCCY"]"

  outTENOR=${outTENOR/12/1Y}
  outCCY=${outCCY/CPA/USA}

#  echo "MT: OUT TENOR = ["$outTENOR"]"
  echo "MT: OUTPUT TO = ["$outputFileName"]"

#https://www.dmo.gov.uk/data/XmlDataReport?reportCode=D1A

uri1="https://www.dmo.gov.uk/data/XmlDataReport?"
uri2="reportCode="$seriesKEY
#uri3="&api_key="$apiKey
#uri4="&realtime_start="$dateFetch
#uri5="&realtime_end="$dateFetch
#uri6="&file_type=json"

request_cmd=$uri1$uri2$uri3$uri4$uri5$uri6

echo "MT: request   = ["$request_cmd"]"
echo "MT: outFileNn = ["$outputFileName"]"
#
curlArgs="-sL"
# Execute the curl URL request_cmd
result=$(curl $curlArgs "$request_cmd")

echo $result > $outputFileName
parse_cmd=""
parse_cmd+=$(cat ni_xml_prefix.xml)
parse_cmd+=$(xmlstarlet sel -t -m "//View_GILTS_IN_ISSUE" -o "[RECORD]" -o '[KEYFIELD name="name"]' -v "@INSTRUMENT_NAME" -o '[/KEYFIELD],[FIELD name="type"]' -v "@INSTRUMENT_TYPE" -o '[FIELD],[FIELD name="currency.code"]GBP[/FIELD][FIELD name="issuer.firm"]Q[/FIELD][FIELD name="issuer.centre"]_LE[/FIELD][FIELD name="issue.date"]' -v "@FIRST_ISSUE_DATE" -o '[/FIELD][FIELD name="maturity.date"]"' -v "@REDEMPTION_DATE" -o '[/FIELD],[FIELD name="parent.deal.type"]' -v "@INSTRUMENT_TYPE" -o '[/FIELD],[FIELD name="securityID"]' -v "@ISIN_CODE" -o "[/FIELD][/RECORD]" -n $outputFileName)
parse_cmd+=$(cat ni_xml_suffix.xml)
echo $parse_cmd
#noRates=$(echo $result | jq '.count')
#noRates=$((noRates-1))
#rateDate=$(echo $result | jq '.observations['$noRates'].date')
#rateValu=$(echo $result | jq '.observations['$noRates'].value')

#echo "MT: No. Rates = ["$noRates"]"
#echo "MT: Rate Date = ["$rateDate"]"
#echo "MT: Rate Value = ["$rateValu"]"
#echo $result
outputDir="dataOutput/"

destFile=""
destFile+=$path
destFile+="/"
destFile+=$outputDir
destFile+="ukBonds_"$fetchID"_data_"
destFile+=$dateID
destFile+=".xml"
echo "MT: destFile  = ["$destFile"]"
echo "MT: write     = [1]"
echo -e "${parse_cmd//[/<}" >> "$destFile"
echo "MT: read      = [0]"
stage1=$(<"$destFile")
echo "MT: write     = [2]"
echo -e "${stage1//]/>}" >> "$destFile"

done
figlet -f small "MT: JOB DONE"
#
