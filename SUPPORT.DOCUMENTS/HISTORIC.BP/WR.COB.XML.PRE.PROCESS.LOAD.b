* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-124</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE WR.COB.XML.PRE.PROCESS.LOAD
*-----------------------------------------------------------------------------
* Load routine to setup the common area for the multi-threaded Close of Business
* job WR.COB.XML.PRE.PROCESS
*-----------------------------------------------------------------------------
* Modifications:
*-----------------------------------------------------------------------------
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
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_WR.REPORTING.COMMON
    $INSERT I_WR.COB.XML.PRE.PROCESS.COMMON
    $INSERT I_F.WR.PARAMETER
    $INSERT I_F.BATCH ; * Prefix BAT.
    $INSERT I_F.ENQUIRY.REPORT ; * Prefix ENQ.REP.
*-----------------------------------------------------------------------------
* Open files to be used in the WR.COB.XML.PRE.PROCESS routine as well as standard variables.

    GOSUB initialise
    GOSUB getReportList
    GOSUB getTimeStamp

    RETURN

*-----------------------------------------------------------------------------
*** <region name= initialise>
initialise:
*** <desc> </desc>

    FN.ENQUIRY.REPORT = 'F.ENQUIRY.REPORT'
    F.ENQUIRY.REPORT = ''
    CALL OPF(FN.ENQUIRY.REPORT,F.ENQUIRY.REPORT)

    FN.HOLD.CONTROL = 'F.HOLD.CONTROL'
    F.HOLD.CONTROL = ''
    CALL OPF(FN.HOLD.CONTROL,F.HOLD.CONTROL)

    FN.REPORT.CONTROL = 'F.REPORT.CONTROL'
    F.REPORT.CONTROL = ''
    CALL OPF(FN.REPORT.CONTROL,F.REPORT.CONTROL)
    
    FN.HOLD = '&HOLD&'
    F.HOLD = ''
    CALL OPF(FN.HOLD,F.HOLD)
    
    FN.ENQUIRY = 'F.ENQUIRY'
    F.ENQUIRY = ''
    CALL OPF(FN.ENQUIRY,F.ENQUIRY)
    
    FN.ENQUIRY.REPORT = 'F.ENQUIRY.REPORT'
    F.ENQUIRY.REPORT = ''
    CALL OPF(FN.ENQUIRY.REPORT,F.ENQUIRY.REPORT)
    
    FN.WR.PARAMETER = 'F.WR.PARAMETER'
    F.WR.PARAMETER = ''
    CALL OPF(FN.WR.PARAMETER,F.WR.PARAMETER)    
    
    FN.BATCH = 'F.BATCH'

    IF UNASSIGNED(skipProcessing) THEN
        skipProcessing = @FALSE
    END
    
    enquiryReportList = ''
    reportList = ''

* Read the company-level WR.PARAMETER record

    R.WR.PARAMETER = ''
    YERR = ''
    CALL EB.READ.PARAMETER(FN.WR.PARAMETER,'N','',R.WR.PARAMETER,'',F.WR.PARAMETER,YERR)

    IF YERR THEN

* Read the system-level WR.PARAMETER record

        R.WR.PARAMETER = ''
        YERR = ''
        CALL EB.READ.PARAMETER(FN.WR.PARAMETER,'N','',R.WR.PARAMETER,'SYSTEM',F.WR.PARAMETER,YERR)

        IF YERR THEN
            skipProcessing = @TRUE
        END
    END
    
    repTime = R.WR.PARAMETER<WrParameter_RepTime>
    
    GOSUB openXmlDirAsFile

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= openXmlDirAsFile>
openXmlDirAsFile:
*** <desc>Open the output path as a file </desc>

    GOSUB getXmlDir

    IF NOT(skipProcessing) THEN
        FN.XMLOUT = xmlDir
        F.XMLOUT = ''
        CALL OPF(FN.XMLOUT,F.XMLOUT)
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= getXmlDir>
getXmlDir:
*** <desc>Get the xml path </desc>

    xmlDir = R.WR.PARAMETER<WrParameter_T24ReportingFile>

    IF xmlDir = '' THEN
        skipProcessing = @TRUE
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= getReportList>
getReportList:
*** <desc>Get the list of reports </desc>

    GOSUB getCurrentBatchRec
    GOSUB getEnquiryReportIds
    GOSUB getReportControlIds

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= getCurrentBatchRec>
getCurrentBatchRec:
*** <desc>Get the current batch record so we can process the enquiries </desc>

    IF NOT(skipProcessing) THEN
        BATCH.ID = BATCH.INFO<1>
        R.BATCH = ''
        YERR = ''
        CALL F.READ(FN.BATCH,BATCH.ID,R.BATCH,F.BATCH,YERR)
    END ELSE
        R.BATCH = ''
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= getEnquiryReportIds>
getEnquiryReportIds:
*** <desc>Get the enquiry reports run against this batch record </desc>

    jobList = R.BATCH<BAT.JOB.NAME>
    statusList = R.BATCH<BAT.JOB.STATUS>
    dataList = R.BATCH<BAT.DATA>
    
    numJobs = DCOUNT(jobList,VM)
    FOR jobNo = 1 TO numJobs
       IF jobList<1,jobNo> = 'WR.COB.REP.CREATE' AND statusList<1,jobNo> = 2 THEN
          jobData = dataList<1,jobNo>
          GOSUB processJobData
       END
    NEXT jobNo

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= processJobData>
processJobData:
*** <desc>Get ENQUIRY.REPORT ids from the DATA field against the job</desc>

    LOOP
    REMOVE jobDataField FROM jobData SETTING exists
    WHILE jobDataField : exists DO
       IF jobDataField[1,4] = 'ENQ ' THEN
          repName = FIELD(FIELD(jobDataField,'ENQ ',2),' ',1)
          enquiryReportList<-1> = repName
       END
    REPEAT    

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= getReportControlIds>
getReportControlIds:
*** <desc>Get REPORT.CONTROL ids from the ENQUIRY.REPORT records</desc>

    LOOP
    REMOVE ENQUIRY.REPORT.ID FROM enquiryReportList SETTING exists
    WHILE ENQUIRY.REPORT.ID : exists DO
       GOSUB readEnquiryReport
       reportControlId = R.ENQUIRY.REPORT<ENQ.REP.REPORT.CONTROL>
       IF reportControlId NE '' THEN
          LOCATE reportControlId IN reportList SETTING repPos ELSE
             reportList<-1> = reportControlId
          END
       END
    REPEAT    

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= readEnquiryReport>
readEnquiryReport:
*** <desc>Read the ENQUIRY.REPORT record</desc>

    R.ENQUIRY.REPORT = ''
    YERR = ''
    CALL F.READ(FN.ENQUIRY.REPORT,ENQUIRY.REPORT.ID,R.ENQUIRY.REPORT,F.ENQUIRY.REPORT,YERR)

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= getTimeStamp>
getTimeStamp:
*** <desc>Get timestamp in format as defined in WR.PARAMETER </desc>

    timeStamp.style = R.WR.PARAMETER<WrParameter_TimestampStyle>

    timeStamp = ''

    BEGIN CASE

        CASE timeStamp.style = 'YYYYMMDDHHMMSS'
            time = OCONV(TIME(),'MTS')
            time = time[1,2]:time[4,2]:time[7,2]
            timeStamp = TODAY : time

    END CASE

    RETURN

*** </region>
*-----------------------------------------------------------------------------
    END
