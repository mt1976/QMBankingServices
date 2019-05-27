* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-99</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE WR.COB.XML.PRE.PROCESS(ID)
*-----------------------------------------------------------------------------
* Multi-threaded Close of Business routine
*-----------------------------------------------------------------------------
* Modification History:
*
* 05/11/09 - RTC7136 - aleggett@temenos.com
*            7138: Create multi-threaded job to select HOLD.CONTROL and process
*
* 19/11/09 - RTC8079 - aleggett@temenos.com
*            8079: ORC Connectivity - Initialisation
*            Move skipProcessing to I_WR.PROCESSING.COMMON
*
* 02/12/09 - RTC7785 - aleggett@temenos.com
*            7785: PWMCR - COB Engine - Some enquiries not returning data even
*            though workfile has data.
*            Timestamp should be common for all WR reports processed during COB run.
*
* 16/12/09 - RTC9861 - aleggett@temenos.com
*            9861: WR COB processing deletes hardcopy even if it is to be retained
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_WR.REPORTING.COMMON
    $INSERT I_WR.COB.XML.PRE.PROCESS.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.WR.PARAMETER
*-----------------------------------------------------------------------------
* Perform the transaction/contract processing in this routine. All files & standard
* variables should be setup in WR.COB.XML.PRE.PROCESS and passed using the named common I_WR.COB.XML.PRE.PROCESS.EOD.COMMON

    GOSUB readHoldReport

    GOSUB processXml

    RETURN

*-----------------------------------------------------------------------------
*** <region name= readHoldReport>
*** <desc>read the report from &HOLD& </desc>
readHoldReport:

    HOLD.ID = ID

    R.HOLD = ''
    YERR = ''
    CALL F.READ(FN.HOLD,HOLD.ID,R.HOLD,F.HOLD,YERR)

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= processXml>
*** <desc>Process the XML and save to output path </desc>
processXml:

    validXml = @TRUE
    enqName = ''

    xmlRecord = ''
    LOOP
        REMOVE dataLine FROM R.HOLD SETTING exists
    WHILE dataLine:exists AND validXml DO
        GOSUB processDataLine
    REPEAT

    IF enqName = '' THEN
        validXml = @FALSE
    END

    IF validXml THEN
        GOSUB writeXml
        GOSUB writeCsv
        GOSUB deleteHeldData
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= processDataLine>
*** <desc>process a line of data from the raw report </desc>
processDataLine:

    startPos = 0
    lenDataLine = LEN(dataLine)
    LOOP
        endPos = lenDataLine-startPos
        startPos += 1
        thisChar = dataLine[startPos,1]
    WHILE thisChar NE '<' AND thisChar NE '>' AND endPos GE 1 DO REPEAT

    dataLine = dataLine[startPos,endPos]

    IF dataLine[1,1] = '>' THEN
        dataLineTag = ''
    END ELSE
        dataLineTag = FIELD(dataLine,'<',2)
        dataLineTag = FIELD(dataLineTag,'>',1)
        dataLineTag = FIELD(dataLineTag,'=',1)
    END

    BEGIN CASE
        CASE dataLineTag = 'dataSet name'
            GOSUB convertEnquiryName
            xmlRecord := dataLine
        CASE dataLineTag NE ''
            xmlRecord := dataLine
    END CASE

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= convertEnquiryName>
*** <desc>convert data set name from enquiry id to short description (node name) </desc>
convertEnquiryName:

    startPos = LEN(dataLineTag)+4
    endPos = LEN(dataLine)-startPos-1
    ENQUIRY.ID = dataLine[startPos,endPos]
    GOSUB readEnqName

    IF enqName NE '' THEN
        dataLine = CHANGE(dataLine,ENQUIRY.ID,enqName)
    END ELSE
        validXml = @FALSE
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= readEnqName>
*** <desc>read the enquiry and get the enquiryName </desc>
readEnqName:

* Read the ENQUIRY record to get the node name

    R.ENQUIRY = ''
    YERR = ''
    CALL F.READ(FN.ENQUIRY,ENQUIRY.ID,R.ENQUIRY,F.ENQUIRY,YERR)

    enqName = R.ENQUIRY<Enquiry_ShortDesc>

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= writeXml>
*** <desc>Write the formatted XML to output path </desc>
writeXml:

    us = '_'
    CustRef = '00000'

* timeStamp has been set in .LOAD routine and passed via common

    nodeName = enqName
    unique = HOLD.ID
    suffix = '.xml'

    XMLOUT.ID = CustRef:us:timeStamp:us:nodeName:us:unique:suffix

    R.XMLOUT = xmlRecord

    CALL F.WRITE(FN.XMLOUT,XMLOUT.ID,R.XMLOUT)

    lastRecordId = XMLOUT.ID

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= writeCsv>
*** <desc>Write the csv file to the output path </desc>
writeCsv:

    suffix = '.csv'
    CSVOUT.ID = CustRef:us:timeStamp:us:nodeName:us:unique:suffix

    csvRecord = xmlRecord

    CALL WR.TRANSFORM.XML.TO.CSV(csvRecord)

    IF csvRecord NE '' THEN
        R.CSVOUT = csvRecord
        CALL F.WRITE(FN.XMLOUT,CSVOUT.ID,R.CSVOUT)
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= deleteHeldData>
*** <desc>delete data from &HOLD& if appropriate </desc>
deleteHeldData:

* Don't delete if the user has requested that we hold these reports

    IF R.WR.PARAMETER<WrParameter_RetainHardcopy> NE 'YES' THEN

        CALL F.DELETE(FN.HOLD,HOLD.ID)
        CALL F.DELETE(FN.HOLD.CONTROL,HOLD.ID)

        HOLD.ID := '.FULL'
        R.HOLD = ''
        YERR = ''
        CALL F.READ(FN.HOLD,HOLD.ID,R.CHECK,F.HOLD,YERR)

        IF NOT(YERR) THEN
            CALL F.DELETE(FN.HOLD,HOLD.ID)
        END

    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------

    END
