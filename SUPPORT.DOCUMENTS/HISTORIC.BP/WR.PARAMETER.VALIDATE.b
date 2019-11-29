* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
* <Rating>-132</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE WR.PARAMETER.VALIDATE
*-----------------------------------------------------------------------------
!** Template FOR validation routines
* @author aleggett@temenos.com
* @stereotype validator
* @package infra.eb
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
*
* 04/11/09 - RTC7136 - aleggett@temenos.com
*            7137: Create parameter table WR.PARAMETER
*            7530: New Parameter(s) in WR.PARAMETER
*            Creation
*
* 18/11/09 - RTC8044 - aleggett@temenos.com
*            8044: ORC Connectivity - Initialisation: Changes to WR.PARAMETER
*
* 14/12/09 - RTC9662 - aleggett@temenos.com
*            9662: Create row and line separator variables for WR COB data export
*            Allow setup of row and column separators
*
* 18/01/09 - RTC14142 - aleggett@temenos.com
*            Show path correctly if directory not created directly in .run
*
* 23/04/10 - 19078
*            Defects identified during wr testing
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.WR.PARAMETER

    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE

    RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
* TODO - Add the validation code here.
* Set AF, AV and AS to the field, multi value and sub value and invoke STORE.END.ERROR
* Set ETEXT to point to the EB.ERROR.TABLE

*      AF = MY.FIELD.NAME                 <== Name of the field
*      ETEXT = 'EB-EXAMPLE.ERROR.CODE'    <== The error code
*      CALL STORE.END.ERROR               <== Needs to be invoked per error

* Check T24 reporting file/path fields

    AF = WrParameter_T24ReportingFile
    pf = WrParameter_T24ReportingPath
    GOSUB checkT24FileAndPath

* Check Report pdf report file/path fields

    AF = WrParameter_RepDocumentFile
    pf = WrParameter_RepDocumentPath
    GOSUB checkT24FileAndPath

* Check Error log file/path fields

    AF = WrParameter_ErrorLogFile
    pf = WrParameter_ErrorLogPath
    GOSUB checkT24FileAndPath

* Check Data Archive file/path fields

    AF = WrParameter_DataArchiveFile
    pf = WrParameter_DataArchivePath
    GOSUB checkDataArchivePath

* Check csv row/column delimiter fields - these must not contain the same delimiters

    AF = WrParameter_CsvColDelimiter
    DUP.CHECK.AF = AF:FM:WrParameter_CsvRowDelimiter
    CALL DUP.FLDS(DUP.CHECK.AF)

    RETURN

*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***

    FN.VOC = 'VOC'
    F.VOC = ''
    CALL OPF(FN.VOC,F.VOC)
*
    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= Process Message>
PROCESS.MESSAGE:
    BEGIN CASE
    CASE MESSAGE EQ ''        ;* Only during commit...
        BEGIN CASE
        CASE V$FUNCTION EQ 'D'
            GOSUB VALIDATE.DELETE
        CASE V$FUNCTION EQ 'R'
            GOSUB VALIDATE.REVERSE
        CASE OTHERWISE        ;* The real VALIDATE...
            GOSUB VALIDATE
        END CASE
    CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER'     ;* During authorisation and verification...
        GOSUB VALIDATE.AUTHORISATION
    END CASE
*
    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.DELETE>
VALIDATE.DELETE:
* Any special checks for deletion

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.REVERSE>
VALIDATE.REVERSE:
* Any special checks for reversal

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.AUTHORISATION>
VALIDATE.AUTHORISATION:
* Any special checks for authorisation

    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= checkDataArchivePath>
checkDataArchivePath:
*** <desc>check Data Archive Path </desc>

    arcPath = R.NEW(AF)
    doArchive = (R.NEW(WrParameter_DataArchiving) = 'Archive')

* Archive path must be set if data archiving has been set to 'Archive'

    IF doArchive AND arcPath = '' THEN
       ETEXT = 'WR-PATH.MAND.WHEN.ARC.SET'
       CALL STORE.END.ERROR
    END ELSE
       GOSUB checkT24FileAndPath
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= checkT24FileAndPath>
checkT24FileAndPath:
*** <desc>check T24FileAndPath </desc>

    T24.Path = R.NEW(AF)

    IF T24.Path NE '' THEN
       GOSUB checkT24.Path
       IF ETEXT = '' AND R.NEW(pf) = '' THEN
          GOSUB defaultPathFld
       END
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= checkT24.Path>
checkT24.Path:

* Check the T24 path

    OPENPATH T24.Path TO path.fv THEN
       CONVERT '/' TO '\' IN T24.Path
       noSeps = COUNT(T24.Path,'\')        ;* 19078
       chkDir = FIELD(T24.Path,'\',noSeps+1)
       OPEN chkDir TO F.chkDir THEN
           STATUS chkArr FROM F.chkDir ELSE
           chkArr = ''
       END
       IF NOT(chkArr<21> MATCHES "1":VM:"19":VM:"UD") THEN
          ETEXT = 'EB-INVALID.TYPE.FILE.NAME'
       END
       END ELSE
          READ VOC.REC FROM F.VOC,chkDir ELSE
             VOC.REC = ''
          END
          IF VOC.REC<2> NE T24.Path THEN
             ETEXT = "OF-INVALID.VOC" : FM : VOC.REC<2>
          END
       END
    END ELSE
       ETEXT = "OF-INVALID.PATH"
    END

    IF ETEXT NE '' THEN
       CALL STORE.END.ERROR
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= defaultPathFld>
*** <desc>Default Path Field as absolute path based on file field. </desc>
defaultPathFld:

    locPath = T24.Path

* If we've got a relative path, add the rest of the path to it to make it absolute

    BEGIN CASE

       CASE locPath[1,1] # '/' OR locPath[1,1] # '\'
          path.voc = SYSTEM(1009)
          loc.run = INDEX(path.voc,'.run',1)
          path.end = loc.run + 4
          path.run = path.voc[1,path.end]

       CASE 1
          path.run = ''

    END CASE

    R.NEW(pf) = path.run:locPath

    RETURN

*** </region>
*-----------------------------------------------------------------------------
END
