*-----------------------------------------------------------------------------
* <Rating>-236</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE AM.CASH.SWEEP.PROCESS.DETAIL(THIS.ID, THIS.ACTION)
*-----------------------------------------------------------------------------
* Routine to handle the AM.SWEEP.DETAIL RCLC or ORDR operations
*-----------------------------------------------------------------------------
* Modifications:
* -------------
*
* 13/03/09 - BG_100022664
*            Created
*
* 19/03/09 - CI_10061440
*            Allow counter account to go short
*
* 30/10/09 - 6644
*            FX should not be generated for zero amount.
*
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
$INSERT I_F.AM.SWEEP.REQUEST
$INSERT I_F.AM.SWEEP.DETAIL
$INSERT I_F.AM.PARAMETER
$INSERT I_F.USER
$INSERT I_F.DATES
$INSERT I_F.FOREX

    FN.AM.SWEEP.REQUEST = 'F.AM.SWEEP.REQUEST'
    F.AM.SWEEP.REQUEST  = ''
    CALL OPF(FN.AM.SWEEP.REQUEST, F.AM.SWEEP.REQUEST)

    FN.AM.SWEEP.DETAIL = 'F.AM.SWEEP.DETAIL'
    F.AM.SWEEP.DETAIL  = ''
    CALL OPF(FN.AM.SWEEP.DETAIL, F.AM.SWEEP.DETAIL)

    FN.FOREX = 'F.FOREX$NAU'
    F.FOREX  = ''
    CALL OPF(FN.FOREX, F.FOREX)

    FN.AM.PARAMETER = 'F.AM.PARAMETER'
    F.AM.PARAMETER  = ''
    CALL OPF(FN.AM.PARAMETER,F.AM.PARAMETER)
    CALL CACHE.READ("F.AM.PARAMETER", ID.COMPANY, R.AM.PARAMETER, ER)

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc>Main process</desc>

    R.AM.SWEEP.DETAIL = ''
    YERR = ''
    CALL F.READ(FN.AM.SWEEP.DETAIL, THIS.ID, R.AM.SWEEP.DETAIL, F.AM.SWEEP.DETAIL, YERR)

    AM.SWEEP.REQUEST.ID = FIELD(THIS.ID,"*",1)
    R.AM.SWEEP.REQUEST = ''
    YERR = ''
    CALL F.READ(FN.AM.SWEEP.REQUEST, AM.SWEEP.REQUEST.ID, R.AM.SWEEP.REQUEST, F.AM.SWEEP.REQUEST, YERR)

    BEGIN CASE

        CASE THIS.ACTION EQ 'RCLC'
            GOSUB RECALCULATE.DETAIL.RECORDS

        CASE THIS.ACTION EQ 'ORDR'
            GOSUB CREATE.ORDERS

    END CASE

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= RECALCULATE.DETAIL.RECORDS>
RECALCULATE.DETAIL.RECORDS:
*** <desc>Recalculate detail records where Traded Amount has been changed</desc>


    MIN.CASH.AMT   = R.AM.SWEEP.DETAIL<AM.SWP.DT.MIN.CASH.AMT> + 0
    PROP.TRA.AMT   = R.AM.SWEEP.DETAIL<AM.SWP.DT.PROP.TRA.AMT> + 0
    PROP.TRA.RATE  = R.AM.SWEEP.DETAIL<AM.SWP.DT.PROP.TRA.RATE>
    ACT.MIN.AMT    = R.AM.SWEEP.DETAIL<AM.SWP.DT.ACT.MIN.AMT>  + 0
    ACT.TRA.AMT    = R.AM.SWEEP.DETAIL<AM.SWP.DT.ACT.TRA.AMT>  + 0
    TRA.ACCT.TOTAL = R.AM.SWEEP.DETAIL<AM.SWP.DT.TRA.ACCT.TOTAL>
    OPERATION.TYPE = R.AM.SWEEP.DETAIL<AM.SWP.DT.OPERATION.TYPE>
    TRADED.CCY     = R.AM.SWEEP.DETAIL<AM.SWP.DT.TRADED.CCY>
    COUNTER.CCY    = R.AM.SWEEP.DETAIL<AM.SWP.DT.COUNTER.CCY>
    CNT.ACCT.TOTAL = R.AM.SWEEP.DETAIL<AM.SWP.DT.CNT.ACCT.TOTAL>
    USE.CONVENTION = R.AM.SWEEP.DETAIL<AM.SWP.RQ.USE.CONVENTION>
    USER.AMENDED   = 'Yes'

    IF (ACT.TRA.AMT NE PROP.TRA.AMT) THEN
        * Only recalculate ACT.TRA.RATE if ACT.TRA.AMT has changed
        THIS.AMOUNT = ACT.TRA.AMT
        IF OPERATION.TYPE[1,1] EQ 'S' THEN
            * Recalculate Sell Rate
            GOSUB GET.SELL.RATE
        END ELSE
            * Recalculate Buy Rate
            GOSUB GET.BUY.RATE
        END
    END ELSE
        * Recalculate both ACT.TRA.AMT and ACT.TRA.RATE
        IF (ACT.MIN.AMT EQ MIN.CASH.AMT) THEN
            USER.AMENDED = 'No'
        END
        IF OPERATION.TYPE[1,1] EQ 'S' THEN
            * Recalculate Sell Details
            GOSUB RECALCULATE.SELL.DETAILS
        END ELSE
            * Recalculate Buy Detail Records
            GOSUB RECALCULATE.BUY.DETAILS
        END
    END

    R.AM.SWEEP.DETAIL<AM.SWP.DT.EXTERNAL.RATE>  = EXTERNAL.RATE
    R.AM.SWEEP.DETAIL<AM.SWP.DT.ACT.MIN.AMT>    = ACT.MIN.AMT
    R.AM.SWEEP.DETAIL<AM.SWP.DT.ACT.TRA.AMT>    = ACT.TRA.AMT
    R.AM.SWEEP.DETAIL<AM.SWP.DT.USER.AMENDED>   = USER.AMENDED
    R.AM.SWEEP.DETAIL<AM.SWP.DT.REQUIRE.RECALC> = 'No'

    GOSUB GET.EXTERNAL.SPOT.RATE ; * Get the rate from an external subroutine if required

    R.AM.SWEEP.DETAIL<AM.SWP.DT.PROP.TRA.RATE>  = PROP.TRA.RATE
    R.AM.SWEEP.DETAIL<AM.SWP.DT.ACT.TRA.RATE>   = PROP.TRA.RATE ; * Reset rate to proposed
    NARRATIVE  = 'Recalculated : ': OPERATION.TYPE: ' ': TRADED.CCY: ' ': ACT.TRA.AMT
    NARRATIVE := ' / ': COUNTER.CCY: ' @ ': PROP.TRA.RATE
    NARRATIVE := @VM: R.AM.SWEEP.DETAIL<AM.SWP.DT.NARRATIVE>

    R.AM.SWEEP.DETAIL<AM.SWP.DT.NARRATIVE>      = NARRATIVE

    GOSUB POPULATE.AUDIT.FIELDS

    CALL F.WRITE(FN.AM.SWEEP.DETAIL, THIS.ID, R.AM.SWEEP.DETAIL)


    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= RECALCULATE.SELL.DETAILS>
RECALCULATE.SELL.DETAILS:
*** <desc>Recalculate details for Sell type records</desc>

    IF ACT.MIN.AMT GE TRA.ACCT.TOTAL THEN
        * If proposed minimum is more than actual account value, set traded amount to 0
        ACT.TRA.AMT = 0
    END ELSE
        * Otherwise reduce traded amount accordingly
        THIS.AMOUNT = TRA.ACCT.TOTAL - ACT.MIN.AMT
        GOSUB CALCULATE.TRADED.CCY.AMOUNT; * Convert THIS.AMOUNT from LCCY to Traded CCY
        ACT.TRA.AMT = THIS.AMOUNT
    END

    GOSUB GET.SELL.RATE ; * Get the spot rate for this SELL

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= RECALCULATE.BUY.DETAILS>
RECALCULATE.BUY.DETAILS:
*** <desc>Recalculate details for Buy type records</desc>

    THIS.AMOUNT = ACT.MIN.AMT - TRA.ACCT.TOTAL ; * New difference

    BEGIN CASE

        CASE THIS.AMOUNT LE 0
            * Traded account is at or above amended minimum, no purchase necesary
            THIS.AMOUNT = 0

            *CASE THIS.AMOUNT GT CNT.ACCT.TOTAL
            *    * Only take as much from the counter currency account as is available
            *    THIS.AMOUNT = CNT.ACCT.TOTAL
            *    GOSUB CALCULATE.TRADED.CCY.AMOUNT; * Convert THIS.AMOUNT from LCCY to Traded CCY

        CASE OTHERWISE
            * Take the full amount from the counter currency account
            GOSUB CALCULATE.TRADED.CCY.AMOUNT; * Convert THIS.AMOUNT from LCCY to Traded CCY

    END CASE

    GOSUB GET.BUY.RATE ; * Get the spot rate for this BUY
    ACT.TRA.AMT  = THIS.AMOUNT

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.EXTERNAL.SPOT.RATE>
GET.EXTERNAL.SPOT.RATE:
*** <desc>Get the spot rate from an external routine</desc>

    IF USE.CONVENTION[1,1] EQ 'Y' THEN
        CON.RATE.RTN  = R.AM.PARAMETER<AM.PAR.CON.RATE.RTN>
        IF CON.RATE.RTN THEN

            EXT.BUY.SELL   = OPERATION.TYPE[1,1]
            COUNTER.AMT    = ''
            EXTERNAL.RATE  = ''
            EX.BASE.RATE   = ''

            MATPARSE R.NEW FROM R.AM.SWEEP.DETAIL ; * Set a common variable for the external routine
            CALL @CON.RATE.RTN
            MATBUILD R.AM.SWEEP.DETAIL FROM R.NEW ; * Restore values from the common variable

            PROP.TRA.RATE = R.NEW(AM.SWP.DT.PROP.TRA.RATE) ; * Hold on to this rate for later

        END
    END

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= CALCULATE.TRADED.CCY.AMOUNT>
CALCULATE.TRADED.CCY.AMOUNT:
*** <desc>Convert variable THIS.AMOUNT amount from LCCY to TRADED.CCY</desc>

    CCY.MKT       = 1
    BUY.CCY       = TRADED.CCY
    BUY.AMT       = ''
    SELL.CCY      = LCCY
    SELL.AMT      = THIS.AMOUNT ; * In LCCY
    BASE.CCY      = ''
    EXCHANGE.RATE = ''
    DIFFERENCE    = ''
    LCY.AMT       = ''
    RETURN.CODE   = ''

    CALL EXCHRATE(CCY.MKT, BUY.CCY, BUY.AMT, SELL.CCY, SELL.AMT, BASE.CCY, EXCHANGE.RATE, DIFFERENCE, LCY.AMT, RETURN.CODE)

    THIS.AMOUNT = BUY.AMT ; * In Traded CCY

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.BUY.RATE>
GET.BUY.RATE:
*** <desc>Get the rate for the FOREX buy transaction</desc>

    BUY.CCY  = TRADED.CCY
    SELL.CCY = COUNTER.CCY
    GOSUB GET.T24.SPOT.RATE ; * Get the rate from T24

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.SELL.RATE>
GET.SELL.RATE:
*** <desc>Get the rate for the FOREX sell transaction</desc>

    BUY.CCY  = COUNTER.CCY
    SELL.CCY = TRADED.CCY
    GOSUB GET.T24.SPOT.RATE ; * Get the rate from T24

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.T24.SPOT.RATE>
GET.T24.SPOT.RATE:
*** <desc>Get the spot rate from T24</desc>

    EXTERNAL.RATE = '' ; * Set to null will be changed later if appropriate

* Note this subroutine is only used to get the rate, not the actual amount

    CCY.MKT       = 1
    BUY.AMT       = THIS.AMOUNT ; * Traded CCY
    SELL.AMT      = ''
    BASE.CCY      = ''
    EXCHANGE.RATE = ''
    DIFFERENCE    = ''
    LCY.AMT       = ''
    RETURN.CODE   = ''

    CALL EXCHRATE(CCY.MKT, BUY.CCY, BUY.AMT, SELL.CCY, SELL.AMT, BASE.CCY, EXCHANGE.RATE, DIFFERENCE, LCY.AMT, RETURN.CODE)

    PROP.TRA.RATE  = EXCHANGE.RATE

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*
*** Order Creation Section
*
*-----------------------------------------------------------------------------
*** <region name= CREATE.ORDERS>
CREATE.ORDERS:
*** <desc>Create orders for this request</desc>

    ETEXT = ''
    CALL F.READ(FN.AM.SWEEP.DETAIL, THIS.ID, R.AM.SWEEP.DETAIL, F.AM.SWEEP.DETAIL, ETEXT)

    IF NOT(ETEXT) THEN
    
      ACT.TRA.AMT = R.AM.SWEEP.DETAIL<AM.SWP.DT.ACT.TRA.AMT>   ;* Do not create orders when ACT.TRA.AMT is Zero.
      IF ACT.TRA.AMT THEN
        SWEEP.CUSTOMER = R.AM.SWEEP.DETAIL<AM.SWP.DT.SWEEP.CUSTOMER>
        OPERATION.TYPE = R.AM.SWEEP.DETAIL<AM.SWP.DT.OPERATION.TYPE>
        TRADED.CCY     = R.AM.SWEEP.DETAIL<AM.SWP.DT.TRADED.CCY>
        COUNTER.CCY    = R.AM.SWEEP.DETAIL<AM.SWP.DT.COUNTER.CCY>
        ACT.TRA.AMT    = R.AM.SWEEP.DETAIL<AM.SWP.DT.ACT.TRA.AMT>
        ACT.TRA.RATE   = R.AM.SWEEP.DETAIL<AM.SWP.DT.ACT.TRA.RATE>
        TRA.ACCT.ID    = R.AM.SWEEP.DETAIL<AM.SWP.DT.TRA.ACCT.ID>
        COUNTER.ACCT   = R.AM.SWEEP.DETAIL<AM.SWP.DT.COUNTER.ACCT>
        PORTFOLIO.NO   = FIELD(R.AM.SWEEP.DETAIL<AM.SWP.DT.SWEEP.PORTFOLIO>,"-",2)

        GOSUB CREATE.FOREX.RECORD             ; * Create record with IHLD status
        GOSUB CREATE.OFS.MESSAGE              ; * Send OFS message to complete FOREX entry
        GOSUB UPDATE.DETAIL.RECORD.AS.ORDERED ; * Update the detail record to show ordered
      END
    END

    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= CREATE.FOREX.RECORD>
CREATE.FOREX.RECORD:
*** <desc>Create a FOREX order in HLD status</desc>

    GOSUB GET.UNIQUE.FOREX.ID

    FOREX.VERSION = 'FOREX,AM.CASH.MGMT'

    R.FOREX<FX.DEAL.TYPE>    = 'SP'
    R.FOREX<FX.COUNTERPARTY> = SWEEP.CUSTOMER
    R.FOREX<FX.SPOT.RATE>    = ACT.TRA.RATE

    IF OPERATION.TYPE[1,1] EQ 'S' THEN
        * Perform a FOREX sell trade
        R.FOREX<FX.CURRENCY.BOUGHT> = TRADED.CCY
        R.FOREX<FX.AMOUNT.BOUGHT>   = ACT.TRA.AMT
        R.FOREX<FX.CURRENCY.SOLD>   = COUNTER.CCY
        R.FOREX<FX.OUR.ACCOUNT.PAY> = COUNTER.ACCT
        R.FOREX<FX.OUR.ACCOUNT.REC> = TRA.ACCT.ID
    END ELSE
        * Perform a FOREX buy trade
        R.FOREX<FX.CURRENCY.BOUGHT> = COUNTER.CCY
        R.FOREX<FX.CURRENCY.SOLD>   = TRADED.CCY
        R.FOREX<FX.AMOUNT.SOLD>     = ACT.TRA.AMT
        R.FOREX<FX.OUR.ACCOUNT.PAY> = TRA.ACCT.ID
        R.FOREX<FX.OUR.ACCOUNT.REC> = COUNTER.ACCT
    END

    TIME.STAMP = TIMEDATE()
    V$DATE = OCONV(ICONV(FIELD(TIME.STAMP,SPACE(1),2,3),'D'), 'D2/E')
    DATE.TIME = V$DATE[7,2]:V$DATE[4,2]:V$DATE[1,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]

    THIS.REQUEST.ID           = FIELD(THIS.ID, '*', 1)
    R.FOREX<FX.PORTFOLIO.NUMBER> = PORTFOLIO.NO
    R.FOREX<FX.NOTES>         = "Cash_Sweep_": THIS.REQUEST.ID
    R.FOREX<FX.NOTES, 2>      = DATE.TIME: "_": OPERATOR
    R.FOREX<FX.CO.CODE>       = ID.COMPANY
    R.FOREX<FX.RECORD.STATUS> = 'IHLD'

    API.ROUTINE = R.AM.PARAMETER<AM.PAR.FX.CASH.MGMT.RTN>
    IF API.ROUTINE # '' THEN
        CALL CHECK.ROUTINE.EXIST(API.ROUTINE,COMPILED.OR.NOT,RETURN.INFO)
        IF COMPILED.OR.NOT THEN
            * Extend Subroutine sinature to include FOREX.VERSION to use
            CALL @API.ROUTINE(R.FOREX, R.AM.SWEEP.REQUEST, R.AM.SWEEP.DETAIL, FOREX.VERSION)
        END
    END

    CALL F.WRITE(FN.FOREX, FOREX.ID, R.FOREX)

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
    OFS.SEP         = ','
    OFS.OPERATION   = FOREX.VERSION
    OFS.OPTIONS     = '/I/'
    OFS.CREDENTIALS = '//'
    OFS.RECORD.ID   = FOREX.ID
    MSG.ID          = ''
    OPTNS           = ''

* Set up OFS header
    OFS.MESSAGE  = OFS.OPERATION
    OFS.MESSAGE := OFS.OPTIONS:     OFS.SEP
    OFS.MESSAGE := OFS.CREDENTIALS: OFS.SEP
    OFS.MESSAGE := OFS.RECORD.ID:   OFS.SEP

* Set up OFS body
    OFS.MESSAGE := 'DEAL.TYPE=SP':  OFS.SEP
    OFS.MESSAGE := 'COUNTERPARTY=': SWEEP.CUSTOMER: OFS.SEP
    OFS.MESSAGE := 'SPOT.RATE=':    ACT.TRA.RATE: OFS.SEP

    CALL OFS.POST.MESSAGE(OFS.MESSAGE, MSG.ID, OFS.SOURCE.ID, OPTNS)

    SERVICE.NAME   = 'OFS.MESSAGE.SERVICE'
    SERVICE.ACTION = 'START'
    CALL SERVICE.CONTROL(SERVICE.NAME, SERVICE.ACTION, '')

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= UPDATE.DETAIL.RECORD.AS.ORDERED>
UPDATE.DETAIL.RECORD.AS.ORDERED:
*** <desc>Update the AM.SWEEP.DETAIL record to show it has been ordered</desc>

    NARRATIVE  = 'ORDERED ': FOREX.ID: @VM
    NARRATIVE := R.AM.SWEEP.DETAIL<AM.SWP.DT.NARRATIVE>
    R.AM.SWEEP.DETAIL<AM.SWP.DT.NARRATIVE> = NARRATIVE
    R.AM.SWEEP.DETAIL<AM.SWP.DT.ORDERED>   = 'Yes'

    GOSUB POPULATE.AUDIT.FIELDS

    CALL F.WRITE(FN.AM.SWEEP.DETAIL, THIS.ID, R.AM.SWEEP.DETAIL)

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*
*** Common subroutines
*
*-----------------------------------------------------------------------------
*** <region name= POPULATE.AUDIT.FIELDS>
POPULATE.AUDIT.FIELDS:
*** <desc>Populates the audit fields</desc>

    R.AM.SWEEP.DETAIL<AM.SWP.DT.RECORD.STATUS> = ''
    R.AM.SWEEP.DETAIL<AM.SWP.DT.CURR.NO>       = 1
    R.AM.SWEEP.DETAIL<AM.SWP.DT.INPUTTER>      = 'SY_':TNO:'_':OPERATOR
    TIME.STAMP = TIMEDATE()
    V$DATE = OCONV(ICONV(FIELD(TIME.STAMP,SPACE(1),2,3),'D'), 'D2/E')
    DATE.TIME = V$DATE[7,2]:V$DATE[4,2]:V$DATE[1,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
    R.AM.SWEEP.DETAIL<AM.SWP.DT.DATE.TIME>     = DATE.TIME
    R.AM.SWEEP.DETAIL<AM.SWP.DT.AUTHORISER>    = 'SY_':TNO:'_':OPERATOR
    R.AM.SWEEP.DETAIL<AM.SWP.DT.CO.CODE>       = ID.COMPANY
    R.AM.SWEEP.DETAIL<AM.SWP.DT.DEPT.CODE>     = R.USER<EB.USE.DEPARTMENT.CODE>

    RETURN

*** </region>
*-----------------------------------------------------------------------------





    END
