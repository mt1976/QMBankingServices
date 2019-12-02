* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
      SUBROUTINE WR.COB.XML.PRE.PROCESS.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job WR.COB.XML.PRE.PROCESS
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
$INSERT I_WR.REPORTING.COMMON
$INSERT I_WR.COB.XML.PRE.PROCESS.COMMON
*-----------------------------------------------------------------------------
* Setup the parameters for BATCH.BUILD.LIST
* LIST.PARAMETERS<1> = blank, this is the list file name, NEVER enter a value here
* LIST.PARAMETERS<2> = the filename to be selected, e.g. F.ACCOUNT, BATCH.BUILD.LIST will open it
* LIST.PARAMETERS<3> = selection criteria for file, e.g. CURRENCY EQ "GBP", this first WITH is not required
*                      and will be added by BATCH.BUILD.LIST
* ID.LIST = predefined list, for example from a CONCAT file record.
*           ID.LIST will take precedence over LIST.PARAMETERS
* CONTROL.LIST = common list used by BATCH.JOB.CONTROL

      IF NOT(skipProcessing) THEN
         IF CONTROL.LIST = '' THEN

*           Set any values for CONTROL.LIST here, this is not mandatory.
*           This can be used when the select routine must be called repeatedly
*           for example
*           CONTROL.LIST = TODAY:@FM:NEXT.WORKING.DAY

            CONTROL.LIST = reportList
            repName = CONTROL.LIST<1,1>

         END ELSE
            repName = CONTROL.LIST<1,1>
         END
         
         selectionCriteria = 'REPORT.NAME EQ ':repName
         selectionCriteria:= ' AND COMPANY.ID EQ ':ID.COMPANY
         selectionCriteria:= ' AND BANK.DATE EQ ':TODAY
         selectionCriteria:= ' AND TIME.CREATED GE ':repTime

         LIST.PARAMETERS = '' ; ID.LIST = ''

         LIST.PARAMETERS<2> = FN.HOLD.CONTROL
         LIST.PARAMETERS<3> = selectionCriteria

         CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)
      
      END

      RETURN
      
*-----------------------------------------------------------------------------
   END
