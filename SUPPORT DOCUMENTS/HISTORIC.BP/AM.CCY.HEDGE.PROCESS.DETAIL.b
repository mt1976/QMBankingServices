* <Rating>-320</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE AM.CCY.HEDGE.PROCESS.DETAIL(THIS.ID, THIS.ACTION)
*-----------------------------------------------------------------------------
* Routine to handle the AM.CCY.HEDGE.REQUEST RCLC or ORDR operations
*-----------------------------------------------------------------------------
*** <region name= Modifications>
*** <desc>Modifications</desc>
*
* 13/03/09 - BG_100022664
*            Created
*
**** </region>
*-----------------------------------------------------------------------------

    GOSUB INITIALISE   ; * Initialise
    GOSUB MAIN.PROCESS ; * Main process

    RETURN

*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
*** <desc>Initialise</desc>
INITIALISE:

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AM.CCY.HEDGE.REQUEST
$INSERT I_F.AM.CCY.HEDGE.DETAIL
$INSERT I_F.ACCOUNT
$INSERT I_F.CATEGORY
$INSERT I_F.FOREX
$INSERT I_F.AM.PARAMETER
$INSERT I_F.USER

    ETEXT = ''

    FN.AM.CCY.HEDGE.REQUEST = 'F.AM.CCY.HEDGE.REQUEST'
    F.AM.CCY.HEDGE.REQUEST  = ''
    CALL OPF(FN.AM.CCY.HEDGE.REQUEST, F.AM.CCY.HEDGE.REQUEST)

    FN.AM.CCY.HEDGE.DETAIL = 'F.AM.CCY.HEDGE.DETAIL'
    F.AM.CCY.HEDGE.DETAIL  = ''
    CALL OPF(FN.AM.CCY.HEDGE.DETAIL, F.AM.CCY.HEDGE.DETAIL)

    FN.SEC.ACC.MASTER = 'F.SEC.ACC.MASTER'
    F.SEC.ACC.MASTER  = ''
    CALL OPF(FN.SEC.ACC.MASTER, F.SEC.ACC.MASTER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY  = ''
    CALL OPF(FN.CATEGORY, F.CATEGORY)

    FN.FOREX = 'F.FOREX$NAU'
    F.FOREX  = ''
    CALL OPF(FN.FOREX, F.FOREX)

    FN.AM.PARAMETER = 'F.AM.PARAMETER'
    F.AM.PARAMETER  = ''
    CALL OPF(FN.AM.PARAMETER,F.AM.PARAMETER)
    CALL F.READ(FN.AM.PARAMETER, ID.COMPANY, R.AM.PARAMETER, F.AM.PARAMETER, ER)

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc>Main process</desc>

    ETEXT = ''
    CALL F.READ(FN.AM.CCY.HEDGE.DETAIL, THIS.ID, R.AM.CCY.HEDGE.DETAIL, F.AM.CCY.HEDGE.DETAIL, ETEXT)
    IF NOT(ETEXT) THEN

        BEGIN CASE

            CASE THIS.ACTION EQ 'RCLC'
                GOSUB RECALCULATE.DETAIL.RECORDS

            CASE THIS.ACTION EQ 'ORDR'
                GOSUB CREATE.ORDERS

        END CASE

    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*
*** Recalculation Section
*
*-----------------------------------------------------------------------------
*** <region name= RECALCULATE.DETAIL.RECORDS>
RECALCULATE.DETAIL.RECORDS:
*** <desc>Recalculate detail records for new hedge factor</desc>

* Set up variables for later use
    ORIGINAL.RECORD  = R.AM.CCY.HEDGE.DETAIL
    REF.CCY          = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.REF.CCY>
    OPERATION.TYPE   = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.OPERATION.TYPE>
    EXPOSURE.CCY     = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.EXPOSURE.CCY>

* Retrieve the transaction threshold so that we can ensure PROP.TRA.AMT does not exceed it.
    TXN.THRESHOLD    = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.TXN.THRESHOLD>

* Convert the transaction threshold from reference currency into exposure currency for calculation purposes
* Note - calculation performed in exposure currency.
    THIS.CCY1 = REF.CCY
    THIS.CCY2 = EXPOSURE.CCY
    THIS.AMOUNT = TXN.THRESHOLD
    THIS.RATE = ''
    GOSUB CONVERT.AMOUNT
    TXN.THRESHOLD.EXPCCY = THIS.AMOUNT

    MIN.CASH.AMT     = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.MIN.CASH.AMT> ; * REF CCY
* Revalue MIN.CASH.AMT from LCCY to THIS.CCY
    THIS.CCY    = EXPOSURE.CCY
    THIS.AMOUNT = MIN.CASH.AMT ; * LCCY
    GOSUB CALCULATE.CCY.AMOUNT ; * Convert THIS.AMOUNT expressed in LCCY to THIS.CCY

    THIS.CCY.MIN.CASH.AMT = THIS.AMOUNT; * ACB - Account Minimum Balance
    IF THIS.CCY.MIN.CASH.AMT EQ '' THEN
        THIS.CCY.MIN.CASH.AMT = 0
    END

    EXPOSED.POSN     = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.EXPOSED.POSN> ; * EPO - Exposed Position
    EXPOSED.CASHBAL  = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.EXPOSED.CASHBAL> ; * ACB - Cash Account Total Balance
    EXPOSED.TOTAL    = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.EXPOSED.TOTAL>
    ROUNDING.SIZE    = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ROUNDING.SIZE>
    PROP.SPOT.RATE   = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.PROP.SPOT.RATE>
    PROP.FWD.RATE    = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.PROP.FWD.RATE> ; * Probably 0
    PROP.HEDGE.FCTR  = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.PROP.HEDGE.FCTR>
    PROP.TRA.AMT     = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.PROP.TRA.AMT>
    ACT.HEDGE.FCTR   = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ACT.HEDGE.FCTR>; * HEF - Hedge Factor
    ACT.SPOT.RATE    = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ACT.SPOT.RATE> ; * FXS - Forex Spot Rate
    ACT.FWD.RATE     = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ACT.FWD.RATE> ;  * FXF - Forex Forward Rate

    IF ACT.HEDGE.FCTR GT 100 THEN
        ACT.HEDGE.FCTR = 100
        R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ACT.HEDGE.FCTR> = ACT.HEDGE.FCTR
    END

    IF ACT.HEDGE.FCTR NE PROP.HEDGE.FCTR THEN ; * Recalculate PROP.TRA.AMT
        R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.PROP.HEDGE.FCTR> = ACT.HEDGE.FCTR
        IF OPERATION.TYPE[1,1] EQ 'S' THEN
            * For Swap operations ignore EXPOSED.CASHBAL
            PROP.TRA.AMT = ((EXPOSED.POSN * ACT.HEDGE.FCTR) / 100)
        END ELSE
            * For Forward operations include EXPOSED.CASHBAL
            PROP.TRA.AMT = ((EXPOSED.TOTAL * ACT.HEDGE.FCTR) / 100)
        END
        IF ROUNDING.SIZE THEN ; * Only round if a rounding factor has been chosen
            PROP.TRA.AMT = INT(PROP.TRA.AMT / ROUNDING.SIZE)
            PROP.TRA.AMT = (PROP.TRA.AMT * ROUNDING.SIZE)
        END
        CALL EB.ROUND.AMOUNT(EXPOSURE.CCY, PROP.TRA.AMT, "", "")
    END

    IF PROP.TRA.AMT LT TXN.THRESHOLD.EXPCCY THEN
        * PROP.TRA.AMT must exceed TXN.THRESHOLD or be set to zero
        PROP.TRA.AMT = 0
    END

    IF NOT(ACT.SPOT.RATE) THEN
        * Reset ACT.SPOT.RATE from PROP.SPOT.RATE
        ACT.SPOT.RATE = PROP.SPOT.RATE
    END

    IF NOT(ACT.FWD.RATE) THEN ; * Reset ACT.FWD.RATE from PROP.FWD.RATE
        ACT.FWD.RATE = PROP.FWD.RATE
    END

    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.REQUIRE.RECALC> = 'No'
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.PROP.TRA.AMT>   = PROP.TRA.AMT
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ACT.SPOT.RATE>  = ACT.SPOT.RATE
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.FWD.SELL.AMT>   = PROP.TRA.AMT

    NARRATIVE = ''

    IF ACT.FWD.RATE GT 0 THEN
        THIS.AMOUNT = PROP.TRA.AMT ; * Expressed in EXPOSURE.CCY
        THIS.CCY1   = EXPOSURE.CCY
        THIS.CCY2   = REF.CCY
        THIS.RATE   = ACT.FWD.RATE
        NARRATIVE := 'Forward sell ': EXPOSURE.CCY: ' ': THIS.AMOUNT: ' @ ': THIS.RATE: '. '
        GOSUB CONVERT.AMOUNT ; * Convert THIS.AMOUNT from THIS.CCY1 to THIS.CCY2
        R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.FWD.BUY.AMT> = THIS.AMOUNT
    END

    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ACT.FWD.RATE>   = ACT.FWD.RATE

    IF (OPERATION.TYPE[1,1] EQ 'F') OR (EXPOSED.CASHBAL GE 0) THEN
        * There should be no spot transaction when the exposed cash balance
        * is in credit or for Forward hedging operation
        R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.SPOT.BUY.AMT> = 0
        R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.SPOT.SELL.AMT> = 0
    END ELSE
        IF ACT.SPOT.RATE GT 0 THEN
            THIS.BUY.AMT = ABS(EXPOSED.CASHBAL - THIS.CCY.MIN.CASH.AMT)

            * Check what type of change has triggered this recalculation
            GOSUB DETERMINE.RECORD.CHANGES

            R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.SPOT.BUY.AMT> = THIS.BUY.AMT
            THIS.AMOUNT = THIS.BUY.AMT ; * Expressed in EXPOSURE.CCY
            THIS.CCY1   = EXPOSURE.CCY
            THIS.CCY2   = REF.CCY
            THIS.RATE   = ACT.SPOT.RATE
            NARRATIVE := 'Spot buy ': EXPOSURE.CCY: ' ': THIS.AMOUNT: ' @ ': THIS.RATE: '.'
            GOSUB CONVERT.AMOUNT ; * Convert THIS.AMOUNT from THIS.CCY1 to THIS.CCY2
            R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.SPOT.SELL.AMT> = THIS.AMOUNT
        END
    END

    NARRATIVE := @VM: R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.NARRATIVE>
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.NARRATIVE> = NARRATIVE

    GOSUB POPULATE.AUDIT.FIELDS
    CALL F.WRITE(FN.AM.CCY.HEDGE.DETAIL, THIS.ID, R.AM.CCY.HEDGE.DETAIL)

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= DETERMINE.RECORD.CHANGES>
DETERMINE.RECORD.CHANGES:
*** <desc>Determine the effect of changes to this record</desc>
*
* Use this subroutine to decide whether to keep the value of SPOT.BUY.AMT
* as submitted, or to calculate/recalculate it.
*
    OLD.SPOT.BUY.AMT = ORIGINAL.RECORD<AM.HDG.DT.SPOT.BUY.AMT>
    SPOT.BUY.CHANGE  = (THIS.BUY.AMT NE OLD.SPOT.BUY.AMT)

    BEGIN CASE

        CASE NOT(OLD.SPOT.BUY.AMT)
            * If the field has been cleared, do nothing field will be reset

        CASE SPOT.BUY.CHANGE
            * If SPOT.BUY.AMT has changed, this has been overridden by user
            * so keep that value stored in ORIGINAL.RECORD...
            THIS.BUY.AMT = ORIGINAL.RECORD<AM.HDG.DT.SPOT.BUY.AMT>

    END CASE

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*
*** Order Creation Section
*
*-----------------------------------------------------------------------------
*** <region name= CREATE.ORDERS>
CREATE.ORDERS:
*** <desc>Create FOREX orders for this request</desc>

    HEDGE.CUSTOMER = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.HEDGE.CUSTOMER>
    OPERATION.TYPE = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.OPERATION.TYPE>
    TXN.THRESHOLD  = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.TXN.THRESHOLD> + 0 ; * LCCY
    PROP.TRA.AMT   = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.PROP.TRA.AMT>
    ACT.FWD.RATE   = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ACT.FWD.RATE>
    ACT.SPOT.RATE  = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ACT.SPOT.RATE>
    EXPOSURE.CCY   = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.EXPOSURE.CCY>
    REF.CCY        = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.REF.CCY>
    TRADED.DATE    = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.TRADED.DATE>
    VALUE.DATE     = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.VALUE.DATE>
    FWD.BUY.AMT    = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.FWD.BUY.AMT>
    FWD.SELL.AMT   = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.FWD.SELL.AMT>
    SPOT.BUY.AMT   = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.SPOT.BUY.AMT>
    SPOT.SELL.AMT  = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.SPOT.SELL.AMT>
    PORTFOLIO.NO   = FIELD(R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.HEDGE.PORTFOLIO>,"-",2)

    THIS.AMOUNT = TXN.THRESHOLD
    THIS.CCY    = REF.CCY
    GOSUB CALCULATE.CCY.AMOUNT

    IF FWD.SELL.AMT GT THIS.AMOUNT THEN
        * Do not create any FOREX deals if FWD.SELL.AMT < TXN.THRESHOLD

        IF OPERATION.TYPE[1,1] = 'F' THEN
            * Create a FOREX Forward order
            GOSUB CREATE.FOREX.FORWARD.RECORD ; * Create a FOREX forward order
        END ELSE
            * Create a FOREX Swap order
            GOSUB CREATE.FOREX.FORWARD.RECORD ; * Create a FOREX forward order
            IF SPOT.BUY.AMT GT 0 THEN
                * Do not create any 0 value FOREX spot deals
                GOSUB CREATE.FOREX.SPOT.RECORD ; * Create a FOREX spot order
            END
        END

        GOSUB UPDATE.DETAIL.RECORD.AS.ORDERED ; * Update the detail record to show ordered

    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= CREATE.FOREX.FORWARD.RECORD>
CREATE.FOREX.FORWARD.RECORD:
*** <desc>Create a FOREX forward order</desc>

    GOSUB GET.UNIQUE.FOREX.ID

    FOREX.VERSION = 'FOREX,AM.CASH.MGMT'

    R.FOREX = ''

    R.FOREX<FX.DEAL.TYPE>        = 'FW'
    R.FOREX<FX.COUNTERPARTY>     = HEDGE.CUSTOMER
    R.FOREX<FX.VALUE.DATE.BUY>   = VALUE.DATE
    R.FOREX<FX.CURRENCY.BOUGHT>  = EXPOSURE.CCY
    R.FOREX<FX.CURRENCY.SOLD>    = REF.CCY
    R.FOREX<FX.AMOUNT.BOUGHT>    = FWD.SELL.AMT
    R.FOREX<FX.VALUE.DATE.SELL>  = VALUE.DATE
    R.FOREX<FX.SPOT.RATE>        = ACT.SPOT.RATE
    R.FOREX<FX.FORWARD.RATE>     = ACT.FWD.RATE
    R.FOREX<FX.DEAL.DATE>        = TRADED.DATE
    R.FOREX<FX.TRANSACTION.TYPE> = 'FW'
    R.FOREX<FX.LOCAL.REF>        = R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.LOCAL.REF>
    R.FOREX<FX.PORTFOLIO.NUMBER> = PORTFOLIO.NO

    GOSUB SET.FOREX.AUDIT

    THIS.REQUEST.ID           = FIELD(THIS.ID, '*', 1)
    R.FOREX<FX.NOTES>         = "CCY Hedge ": THIS.REQUEST.ID
    R.FOREX<FX.NOTES, 2>      = DATE.TIME: " ": OPERATOR

    API.ROUTINE = R.AM.PARAMETER<AM.PAR.FX.HEDGE.RTN>
    IF API.ROUTINE # '' THEN
        CALL CHECK.ROUTINE.EXIST(API.ROUTINE,COMPILED.OR.NOT,RETURN.INFO)
        IF COMPILED.OR.NOT THEN
            * Extend Subroutine sinature to include FOREX.VERSION to use
            CALL @API.ROUTINE(R.FOREX, R.AM.CCY.HEDGE.REQUEST, R.AM.CCY.HEDGE.DETAIL, FOREX.VERSION)
        END
    END

    CALL F.WRITE(FN.FOREX, FOREX.ID, R.FOREX)

    GOSUB CREATE.OFS.MESSAGE ; * Send OFS message to complete this FOREX entry

    FOREX.FWD.ID = FOREX.ID ; * Save this ID
    NARRATIVE  = 'ORDERED FOREX ': FOREX.ID: @VM
    
    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= CREATE.FOREX.SPOT.RECORD>
CREATE.FOREX.SPOT.RECORD:
*** <desc>Create a FOREX spot order</desc>

    GOSUB GET.UNIQUE.FOREX.ID

    FOREX.VERSION = 'FOREX,AM.CASH.MGMT'

    R.FOREX = ''

    R.FOREX<FX.DEAL.TYPE>        = 'SP'
    R.FOREX<FX.COUNTERPARTY>     = HEDGE.CUSTOMER
    R.FOREX<FX.CURRENCY.SOLD>    = EXPOSURE.CCY
    R.FOREX<FX.CURRENCY.BOUGHT>  = REF.CCY
    R.FOREX<FX.AMOUNT.SOLD>      = SPOT.BUY.AMT
    R.FOREX<FX.SPOT.RATE>        = ACT.SPOT.RATE
    R.FOREX<FX.DEAL.DATE>        = TRADED.DATE
    R.FOREX<FX.LINK.REFERENCE>   = FOREX.FWD.ID
    R.FOREX<FX.TRANSACTION.TYPE> = 'SP'
    R.FOREX<FX.PORTFOLIO.NUMBER> = PORTFOLIO.NO

    GOSUB SET.FOREX.AUDIT

    THIS.REQUEST.ID           = FIELD(THIS.ID, '*', 1)
    R.FOREX<FX.NOTES>         = "CCY_Hedge_": THIS.REQUEST.ID
    R.FOREX<FX.NOTES, 2>      = DATE.TIME: "_": OPERATOR

    API.ROUTINE = R.AM.PARAMETER<AM.PAR.FX.HEDGE.RTN>
    IF API.ROUTINE # '' THEN
        CALL CHECK.ROUTINE.EXIST(API.ROUTINE,COMPILED.OR.NOT,RETURN.INFO)
        IF COMPILED.OR.NOT THEN
            * Extend Subroutine sinature to include FOREX.VERSION to use
            CALL @API.ROUTINE(R.FOREX, R.AM.CCY.HEDGE.REQUEST, R.AM.CCY.HEDGE.DETAIL, FOREX.VERSION)
        END
    END

    CALL F.WRITE(FN.FOREX, FOREX.ID, R.FOREX)

    GOSUB CREATE.OFS.MESSAGE ; * Send OFS message to complete this FOREX entry
    NARRATIVE = 'ORDERED FOREX ': FOREX.ID: @VM

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.UNIQUE.FOREX.ID>
GET.UNIQUE.FOREX.ID:
*** <desc>Get and lock a unique new FOREX ID</desc>

    R.FOREX = ''
    FOREX.ID = ''

    CALL AM.GET.NEW.APPL.ID('FOREX', FOREX.ID)

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= CREATE.OFS.MESSAGE>
CREATE.OFS.MESSAGE:
*** <desc>Create an OFS message to activate the held FOREX record</desc>

    OFS.SOURCE.ID  = R.AM.PARAMETER<AM.PAR.OFS.SOURCE>

* Send OFS message here!
* Use FOREX.ID not ID.NEW when creating OFS messages.

    OFS.SEP         = ','
    OFS.OPERATION   = FOREX.VERSION
    OFS.OPTIONS     = '/I/'
    OFS.CREDENTIALS = '//'
    OFS.RECORD.ID   = FOREX.ID
    MSG.ID          = ''
    OPTNS           = ''

* Set up OFS message
    OFS.MESSAGE  = OFS.OPERATION
    OFS.MESSAGE := OFS.OPTIONS:     OFS.SEP
    OFS.MESSAGE := OFS.CREDENTIALS: OFS.SEP
    OFS.MESSAGE := OFS.RECORD.ID:   OFS.SEP
    OFS.MESSAGE := 'COUNTERPARTY=': HEDGE.CUSTOMER: OFS.SEP

* Post OFS message
    CALL OFS.POST.MESSAGE(OFS.MESSAGE, MSG.ID, OFS.SOURCE.ID, OPTNS)

* Start service
    SERVICE.NAME   = 'OFS.MESSAGE.SERVICE'
    SERVICE.ACTION = 'START'
    CALL SERVICE.CONTROL(SERVICE.NAME, SERVICE.ACTION, '')

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= UPDATE.DETAIL.RECORD.AS.ORDERED>
UPDATE.DETAIL.RECORD.AS.ORDERED:
*** <desc>Update the CCY.HEDGE.DETAIL record to show it has been ordered</desc>

    NARRATIVE = 'ORDERED': @VM
    NARRATIVE := R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.NARRATIVE>
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.NARRATIVE> = NARRATIVE
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.ORDERED>   = 'Yes'

    GOSUB POPULATE.AUDIT.FIELDS

    CALL F.WRITE(FN.AM.CCY.HEDGE.DETAIL, THIS.ID, R.AM.CCY.HEDGE.DETAIL)

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*
*** Common subroutines
*
*-----------------------------------------------------------------------------
*** <region name= CALCULATE.LCCY.AMOUNT>
CALCULATE.LCCY.AMOUNT:
*** <desc>Convert THIS.AMOUNT expressed in THIS.CCY to LCCY</desc>

    CCY.MKT       = 1
    BUY.CCY       = LCCY
    BUY.AMT       = ''
    SELL.CCY      = THIS.CCY
    SELL.AMT      = THIS.AMOUNT ; * In THIS.CCY
    BASE.CCY      = ''
    EXCHANGE.RATE = ''
    DIFFERENCE    = ''
    LCY.AMT       = ''
    RETURN.CODE   = ''

    CALL EXCHRATE(CCY.MKT, BUY.CCY, BUY.AMT, SELL.CCY, SELL.AMT, BASE.CCY, EXCHANGE.RATE, DIFFERENCE, LCY.AMT, RETURN.CODE)

    THIS.AMOUNT = BUY.AMT ; * In LCCY

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= CALCULATE.CCY.AMOUNT>
CALCULATE.CCY.AMOUNT:
*** <desc>Convert THIS.AMOUNT expressed in LCCY to THIS.CCY</desc>

    CCY.MKT       = 1
    BUY.CCY       = THIS.CCY
    BUY.AMT       = ''
    SELL.CCY      = LCCY
    SELL.AMT      = THIS.AMOUNT ; * In LCCY
    BASE.CCY      = ''
    EXCHANGE.RATE = ''
    DIFFERENCE    = ''
    LCY.AMT       = ''
    RETURN.CODE   = ''

    CALL EXCHRATE(CCY.MKT, BUY.CCY, BUY.AMT, SELL.CCY, SELL.AMT, BASE.CCY, EXCHANGE.RATE, DIFFERENCE, LCY.AMT, RETURN.CODE)

    THIS.AMOUNT = BUY.AMT ; * In THIS.CCY

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= CONVERT.AMOUNT>
CONVERT.AMOUNT:
*** <desc>Convert THIS.AMOUNT expressed in THIS.CCY1 to THIS.CCY2 using THIS.RATE</desc>

    CCY.MKT       = 1
    BUY.CCY       = THIS.CCY2
    BUY.AMT       = ''
    SELL.CCY      = THIS.CCY1
    SELL.AMT      = THIS.AMOUNT ; * In THIS.CCY1
    BASE.CCY      = ''
    EXCHANGE.RATE = THIS.RATE
    DIFFERENCE    = ''
    LCY.AMT       = ''
    RETURN.CODE   = ''

    CALL EXCHRATE(CCY.MKT, BUY.CCY, BUY.AMT, SELL.CCY, SELL.AMT, BASE.CCY, EXCHANGE.RATE, DIFFERENCE, LCY.AMT, RETURN.CODE)

    THIS.AMOUNT = BUY.AMT ; * In THIS.CCY2

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= POPULATE.AUDIT.FIELDS>
POPULATE.AUDIT.FIELDS:
*** <desc>Populates the audit fields</desc>

    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.RECORD.STATUS> = ''
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.CURR.NO>       = 1
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.INPUTTER>      = 'SY_':TNO:'_':OPERATOR

    TIME.STAMP = TIMEDATE()
    V$DATE = OCONV(ICONV(FIELD(TIME.STAMP,SPACE(1),2,3),'D'), 'D2/E')
    DATE.TIME = V$DATE[7,2]:V$DATE[4,2]:V$DATE[1,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]

    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.DATE.TIME>     = DATE.TIME
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.AUTHORISER>    = 'SY_':TNO:'_':OPERATOR
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.CO.CODE>       = ID.COMPANY
    R.AM.CCY.HEDGE.DETAIL<AM.HDG.DT.DEPT.CODE>     = R.USER<EB.USE.DEPARTMENT.CODE>

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.SPOT.RATE>
GET.SPOT.RATE:
*** <desc>Get the spot rate for the FOREX transactions</desc>
*
* NOTE : Only T24 rate to be returned / modification will be required to external rate
*        routine to allow it to deal with R.NEW in the correct format.
*
*   CON.RATE.RTN  = R.AM.PARAMETER<AM.PAR.CON.RATE.RTN>
*     IF CON.RATE.RTN THEN
*         GOSUB GET.EXTERNAL.SPOT.RATE ; * Get the rate from an external subroutine
*     END ELSE
    GOSUB GET.T24.SPOT.RATE ; * Get the rate from T24
*     END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.EXTERNAL.SPOT.RATE>
GET.EXTERNAL.SPOT.RATE:
*** <desc>Get the spot rate from an external subroutine</desc>
*
* NOTE : This code is currently not used, but may be required in future
*

*   EXT.BUY.SELL   = 'SELL' ; * Portfolio currency will always be sold when hedging
*   COUNTER.AMT    = ''
*   PROP.SPOT.RATE = ''
*   EX.BASE.RATE   = ''
*
*   MATPARSE R.NEW FROM R.AM.CCY.HEDGE.DETAIL ; * Set a common variable for the external routine
*   R.NEW(AM.HDG.DT.AUDIT.DATE.TIME + 10) = "HDG" ; * Inform external routine of data type
*   CALL @CON.RATE.RTN
*   MATBUILD R.AM.CCY.HEDGE.DETAIL FROM R.NEW ; * Restore values from the common variable
*   PROP.SPOT.RATE = R.NEW(AM.HDG.DT.PROP.SPOT.RATE) ; * Hold on to this rate for later
* Note only allow the rate to be returned

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.T24.SPOT.RATE>
GET.T24.SPOT.RATE:
*** <desc>Get the spot rate from T24</desc>
*
* NOTE : This code is currently not used, but may be required in future
*

    CCY.MKT       = 1
    BUY.CCY       = EXPOSURE.CCY
    BUY.AMT       = PROP.TRA.AMT
    SELL.CCY      = REF.CCY
    SELL.AMT      = ''
    BASE.CCY      = ''
    EXCHANGE.RATE = ''
    DIFFERENCE    = ''
    LCY.AMT       = ''
    RETURN.CODE   = ''

    CALL EXCHRATE(CCY.MKT, BUY.CCY, BUY.AMT, SELL.CCY, SELL.AMT, BASE.CCY, EXCHANGE.RATE, DIFFERENCE, LCY.AMT, RETURN.CODE)

    PROP.SPOT.RATE = EXCHANGE.RATE

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= SET.FOREX.AUDIT>
***
SET.FOREX.AUDIT:

    TIME.STAMP = TIMEDATE()
    V$DATE = OCONV(ICONV(FIELD(TIME.STAMP,SPACE(1),2,3),'D'), 'D2/E')
    DATE.TIME = V$DATE[7,2]:V$DATE[4,2]:V$DATE[1,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]

    R.FOREX<FX.RECORD.STATUS> = 'IHLD'
    R.FOREX<FX.CURR.NO>       = 1
    R.FOREX<FX.INPUTTER>      = TNO: '_': OPERATOR
    R.FOREX<FX.DATE.TIME>     = DATE.TIME
    R.FOREX<FX.AUTHORISER>    = ''
    R.FOREX<FX.CO.CODE>       = ID.COMPANY

    RETURN

*** </region>
*-----------------------------------------------------------------------------

    END
