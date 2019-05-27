* Version 3 02/06/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-81</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.GET.CONTRACT.ID
*-----------------------------------------------------------------------------
* This Routine is to Fetch the Contract ID for the given transaction
* reference and the Application while launching an Enquiry WR.CASH.TRANS.
*-----------------------------------------------------------------------------
* Modification History :
*
* 23/04/10 - 43554
*            Defects identified during wr testing
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB MAIN.PROCESS        ;*to get the value for the given field.

    RETURN

*
*-----------------------------------------------------------------------------
*

INITIALISE:
*** to initialise the Variables

    CACHE = 0

    FIELD.DATA = ''
    FIELD.DEFS = ''
    FIELD.ERR = ''

    RETURN

*
*-----------------------------------------------------------------------------

*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc>to get the value for the given field. </desc>

*** Get the Transaction reference and the Application name through
*** O.DATA Variable.

    TRANS.REF = FIELD(O.DATA, '#',1)
    SOURCE.REF = TRANS.REF[1,5]
    APPLN.NAME  = FIELD(O.DATA, '#',2)

    TABLE.VALUES = 'SEC.TRADE':VM:'SEC.OPEN.ORDER':VM:'SECURITY.TRANSFER':VM:'ENTITLEMENT'

    IF (APPLN.NAME MATCHES TABLE.VALUES) OR (APPLN.NAME EQ 'DX.TRADE' AND SOURCE.REF EQ 'DXTRA') THEN

        BEGIN CASE

        CASE APPLN.NAME EQ 'DX.TRADE' AND SOURCE.REF EQ 'DXTRA'
            FIELD.NAME = "CONTRACT.CODE"
            TRANS.REF = FIELD(TRANS.REF, '.',1)

        CASE APPLN.NAME EQ 'SEC.TRADE'
            FIELD.NAME = "SECURITY.CODE"

        CASE APPLN.NAME EQ 'SEC.OPEN.ORDER'
            FIELD.NAME = "SECURITY.NO"

        CASE APPLN.NAME EQ 'MM.MONEY.MARKET'
            FIELD.NAME = ""

        CASE APPLN.NAME EQ 'SECURITY.TRANSFER'
            FIELD.NAME = "SECURITY.NO"

        CASE APPLN.NAME EQ 'ENTITLEMENT'
            FIELD.NAME = "SECURITY.NO"

        END CASE

        GOSUB GET.FIELD.VALUE

        O.DATA = FIELD.DATA

    END ELSE
        O.DATA = ''

    END

    RETURN

*** </region>

*-----------------------------------------------------------------------------

**** <region name= GET.FIELD.VALUE>
GET.FIELD.VALUE:
*** <desc> to get the value for the given field </desc>

    CALL EB.GETFIELD (APPLN.NAME,TRANS.REF,FIELD.NAME,FIELD.DATA,CACHE,FIELD.DEFS,'',FIELD.ERR)
    IF FIELD.DATA EQ '' OR FIELD.ERR THEN
        GOSUB GET.VALUE.FROM.HISTORY.RECORD
    END

    RETURN

*** </region>

*-------------------------------------------------------------------------------------------------
***<region = GET.VALUE.FROM.HISTORY.RECORD>
GET.VALUE.FROM.HISTORY.RECORD:
***<desc></desc>

* If the live record can't be read, try reading the history if there is a
* History table.

    YERR = ''
    FN.HIS.FILE = 'F.':APPLN.NAME:'$HIS'
    F.HIS.FILE = ''
    CALL OPF(FN.HIS.FILE, F.HIS.FILE)

    CALL EB.READ.HISTORY.REC(F.HIS.FILE,TRANS.REF,'',YERR)

    APPLN.NAME = APPLN.NAME:'$HIS'

    CALL EB.GETFIELD (APPLN.NAME,TRANS.REF,FIELD.NAME,FIELD.DATA,CACHE,FIELD.DEFS,'',FIELD.ERR)

    RETURN

***</region>
*-----------------------------------------------------------------------------


END
