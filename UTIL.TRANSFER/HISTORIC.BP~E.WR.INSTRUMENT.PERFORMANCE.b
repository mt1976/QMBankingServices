* Version n dd/mm/yy  GLOBUS Release No. G13.2.00 26/06/02
*-----------------------------------------------------------------------------
* <Rating>-291</Rating>

    SUBROUTINE E.WR.INSTRUMENT.PERFORMANCE(OUT.ARRAY)
**********************************************************
*
*This  routine is attached to the Enquiry WR.INSTRUMENT.PERFORMANCE.
*This routine returns the performance for a monthly period.
*
* Modification History:
*-----------------------
*
* Modification History:
*-----------------------
*
* 23/04/10 - EN_10004546/43441
*            Period start date always return day 01 irrespective of it is a working day or not
************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AM.INST.PERF.DETAIL
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AM.PARAMETER
    $INSERT I_F.AM.PERF.PARAMETER
    $INSERT I_F.SC.PERF.DETAIL
    $INSERT I_F.SEC.ACC.MASTER
    $INSERT I_F.SUB.ASSET.TYPE
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AM.INST.VEH
    $INSERT I_F.AM.BENCHMARK
    $INSERT I_F.SC.POS.ASSET
    $INSERT I_DAS.SEC.ACC.MASTER
    $INSERT I_DAS.COMMON
    $INSERT I_F.COMPANY
*************************************************************************

    GOSUB INITIALISE

    GOSUB GET.PORTFOLIO.IDS

    LOOP
        REMOVE PORTFOLIO.ID FROM PORTFOLIO.LIST SETTING EXISTS
    WHILE PORTFOLIO.ID : EXISTS DO

        GOSUB GET.PORTFOLIO.DETAILS

        GOSUB CALC.PERF

        GOSUB RESET.VARIABLES

    REPEAT

    RETURN

************************************************************************

*----------
INITIALISE:
*----------

    REGION = ''
    OPEN.DATE = ''
    CLOSE.DATE = ''
    OUT.ARRAY = ''

    FN.SC.PERF.DETAIL = 'F.SC.PERF.DETAIL'
    F.SC.PERF.DETAIL = ''
    CALL OPF(FN.SC.PERF.DETAIL,F.SC.PERF.DETAIL)

    FN.SEC.ACC.MASTER = 'F.SEC.ACC.MASTER'
    F.SEC.ACC.MASTER = ''
    CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.SUB.ASSET.TYPE = 'F.SUB.ASSET.TYPE'
    F.SUB.ASSET.TYPE = ''
    CALL OPF(FN.SUB.ASSET.TYPE,F.SUB.ASSET.TYPE)

    FN.SC.POS.ASSET = 'F.SC.POS.ASSET'
    F.SC.POS.ASSET = ''
    CALL OPF(FN.SC.POS.ASSET,F.SC.POS.ASSET)

    FN.AM.BENCHMARK = 'F.AM.BENCHMARK'
    F.AM.BENCHMARK = ''
    CALL OPF(FN.AM.BENCHMARK,F.AM.BENCHMARK)

    RETURN


*-------------
CALC.PERF:
*-------------
    B.DATE = START.DATE
    S.DATE = END.DATE
    PORTID = PORTFOLIO.ID

    CALL CALC.DAILY.DEITZ.INST.PERF(PORTID,B.DATE,S.DATE,CALC.METHOD,REC.STORE.PERF.VAL,INST.ID.ARR,INST.BEGIN.DATE,INST.END.DATE,CCY.SET,FACTOR,"","","")

    NO.OF.INST = DCOUNT(INST.ID.ARR,FM)
    PREV.DATE = ''
    FOR CNT1 = 1 TO NO.OF.INST
        GOSUB PROCESS.INSTRUMENT
    NEXT CNT1
    RETURN


ASSIGN.REF.CCY.FLDS:
**********************
    INFLOW.FLD = AM.INST.PERF.DET.MV.RC.INFLOW
    OUTFLOW.FLD = AM.INST.PERF.DET.MV.RC.OUTFLOW
    INDEX.FLD = AM.INST.PERF.DET.TOT.INDEX
    SOD.VAL.FLD = AM.INST.PERF.DET.MV.RC.SOD
    EOD.VAL.FLD = AM.INST.PERF.DET.MV.RC.EOD


    RETURN

*------------------*
GET.NAME.INSTR.CCY:
*------------------*
*
    FN.AM.INST.VEH.MM = 'F.AM.INST.VEH'
    F.AM.INST.VEH.MM = ''
    SEC.NAME = ''
    SEC.CCY = ''
    IF SEC.E.DATE[1,6] EQ TODAY[1,6] THEN
        CALL OPF(FN.AM.INST.VEH.MM,F.AM.INST.VEH.MM)
    END ELSE
        CALL AM.OPEN.VEH(FN.AM.INST.VEH.MM, SEC.E.DATE, F.AM.INST.VEH.MM, '')
        IF F.AM.INST.VEH.MM EQ '' THEN
            FN.AM.INST.VEH.MM = ''
        END
    END

    IF FN.AM.INST.VEH.MM THEN
        AIV.ID = PORT.ID:'.':INST.ID:'.':SEC.E.DATE
        CALL F.READ(FN.AM.INST.VEH.MM,AIV.ID,R.AIV,F.AM.INST.VEH.MM,AIV.MM.ERR)
        IF NOT(AIV.MM.ERR) THEN
            SEC.NAME = R.AIV<AM.INST.VEH.SHORT.DESCR>
            SEC.CCY = R.AIV<AM.INST.VEH.INSTR.CCY>
            END.PRICE = R.AIV<AM.INST.VEH.MARKET.PRICE,1>
        END
    END
    RETURN

*-----------------------------------------------------------------------------

*** <region name= RESET.VARIABLES>
RESET.VARIABLES:
*** <desc> </desc>
    Y.SAM.NO = ''
    OUTFLOW.FLD =''
    INFLOW.FLD = ''
    SOD.VAL.FLD = ''
    EOD.VAL.FLD = ''
    INDEX.FLD= ''
    REF.CCY = ''
    CCY.SET = ''
    PORTFOLIO.ID = ''
    FIRST.TIMES = "Y"
    FIRST.TIME = 'Y'
    FST.TIME = "Y"
    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.PORTFOLIO>
GET.PORTFOLIO:
*** <desc> </desc>

    CALL F.READ(FN.SEC.ACC.MASTER,PORTFOLIO.ID,R.SEC.ACC.MASTER,F.SEC.ACC.MASTER,ER)

    IF ER THEN
        ENQ.ERROR = "INVALID PORTFOLIO ":PORTFOLIO.ID:",":FN.SEC.ACC.MASTER
        E = "EB-REC.NOT.FOUND.ON":VM:DQUOTE(PORTFOLIO.ID):",":DQUOTE(FN.SEC.ACC.MASTER)
    END
    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.END.DATE>
GET.END.DATE:
*** <desc> </desc>
    END.DATE = ''
    LOCATE 'END.DATE' IN D.FIELDS<1> SETTING POS THEN
        END.DATE = D.RANGE.AND.VALUE<POS>
    END
    IF END.DATE = '' OR END.DATE GT TODAY THEN
        END.DATE = TODAY
    END
    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.START.DATE>
GET.START.DATE:
*** <desc> </desc>
    START.DATE = END.DATE[1,6]:'01'

    YREGION = R.COMPANY(EB.COM.LOCAL.COUNTRY):'00'   ;*43441
    CALL CDT(YREGION,START.DATE,'-1W+1W')

    SAM.START.DATE = R.SEC.ACC.MASTER<SC.SAM.START.DATE>
*... Start Date must always be the beginning of the reporting period
*... This means that we will not report on portfolios created this month.
*    IF START.DATE LT SAM.START.DATE THEN
*        START.DATE = SAM.START.DATE
*    END
    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.BEGIN.VAL>
GET.BEGIN.VAL:
*** <desc> </desc>

    DETAIL.ID = PORTFOLIO.ID:'.':START.DATE[1,6]
    R.SC.PERF.DETAIL = ''
    PERF.ER = ''
    CALL F.READ(FN.SC.PERF.DETAIL,DETAIL.ID,R.SC.PERF.DETAIL,F.SC.PERF.DETAIL,PERF.ER)
    BEGIN.VAL1=R.SC.PERF.DETAIL<SC.PERF.BEGIN.VALUE>
    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.END.VAL>
GET.END.VAL:
*** <desc> </desc>
    DT.ID=PORTFOLIO.ID:'.':CLOSE.DATE[1,6]
    CALL F.READ(FN.SC.PERF.DETAIL,DT.ID,R.SC.DETAIL,F.SC.PERF.DETAIL,ERR)
    SUBVAL = DCOUNT(R.SC.DETAIL<SC.PERF.PERF.DATE>,@VM)
    LOCATE CLOSE.DATE IN R.SC.DETAIL<SC.PERF.PERF.DATE,1> SETTING POS THEN
        END.VAL1=R.SC.DETAIL<SC.PERF.VALUE.END.DAY,POS>
    END ELSE
        CALL CDT(REGION,CLOSE.DATE,'+1W-1W')
        LOCATE CLOSE.DATE IN R.SC.DETAIL<SC.PERF.PERF.DATE,1> SETTING POS1 THEN
            END.VAL1 = R.SC.DETAIL<SC.PERF.VALUE.END.DAY,POS1>
        END ELSE
            END.VAL1 = R.SC.DETAIL<SC.PERF.VALUE.END.DAY,SUBVAL>
        END
    END
    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.EXCHANGE.RATE>
GET.EXCHANGE.RATE:
*** <desc> </desc>
    CCY.MKT = ''

    IF EXCH.DATE NE '' THEN
        BUY.CCY<1,2> = EXCH.DATE
    END

    CCY.MKT = 1
    BUY.AMT = ''
    BASE.CCY = ''
    EXCHANGE.RATE = ''
    DIFFERENCE = ''
    LCY.AMT = ''
    RETURN.CODE = ''

    CALL EXCHRATE(CCY.MKT,BUY.CCY,BUY.AMT,SELL.CCY,SELL.AMT,BASE.CCY,EXCHANGE.RATE,DIFFERENCE,LCY.AMT,RETURN.CODE)

    IF BUY.CCY EQ SELL.CCY THEN
        EXCHANGE.RATE = 1
    END

    EXCH.DATE = ''
    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.SECURITY.RECORD>
GET.SECURITY.RECORD:
*** <desc> </desc>
    SECURITY.MASTER.ID = INST.ID
    R.SECURITY.MASTER = ''
    YERR = ''
    CALL F.READ(FN.SECURITY.MASTER,SECURITY.MASTER.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,YERR)
    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.SUB.ASSET.TYPE>
GET.SUB.ASSET.TYPE:
*** <desc> </desc>
*... only done for securities at the moment, should be expanded to work with DX and other products
    SUB.ASSET.TYPE = ''
    SECURITY.MASTER.ID = INST.ID
    R.SECURITY.MASTER = ''
    YERR = ''
    CALL F.READ(FN.SECURITY.MASTER,SECURITY.MASTER.ID,R.SECURITY.MASTER,F.SECURITY.MASTER,YERR)
    IF YERR EQ '' THEN
        SUB.ASSET.TYPE = R.SECURITY.MASTER<SC.SCM.SUB.ASSET.TYPE>
    END

    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.ASSET.TYPE>
GET.ASSET.TYPE:
*** <desc> </desc>
    ASSET.TYPE = ''
    IF SUB.ASSET.TYPE NE '' THEN
        SUB.ASSET.TYPE.ID = SUB.ASSET.TYPE
        R.SUB.ASSET.TYPE = ''
        YERR = ''
        CALL F.READ(FN.SUB.ASSET.TYPE,SUB.ASSET.TYPE.ID,R.SUB.ASSET.TYPE,F.SUB.ASSET.TYPE,YERR)
        IF YERR EQ '' THEN
            ASSET.TYPE = R.SUB.ASSET.TYPE<SC.CSG.ASSET.TYPE.CODE>
        END
    END
    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.SC.POS.ASSET>
GET.SC.POS.ASSET:
*** <desc> </desc>
    R.SC.POS.ASSET = ''
    IF ASSET.TYPE NE '' THEN
        SC.POS.ASSET.ID = PORTFOLIO.ID:'.':SUB.ASSET.TYPE:'.':ASSET.TYPE
        R.SC.POS.ASSET = ''
        YERR = ''
        CALL F.READ(FN.SC.POS.ASSET,SC.POS.ASSET.ID,R.SC.POS.ASSET,F.SC.POS.ASSET,YERR)
    END

    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= GET.BENCHMARK>
GET.BENCHMARK:
*** <desc> </desc>
    BENCHMARK.DESC = ''
    INSTRUMENT.BENCHMARK.PERF = ''
    IF BENCHMARK.ID NE '' THEN
        AM.BENCHMARK.ID = BENCHMARK.ID
        R.AM.BENCHMARK = ''
        YERR = ''
        CALL F.READ(FN.AM.BENCHMARK,AM.BENCHMARK.ID,R.AM.BENCHMARK,F.AM.BENCHMARK,YERR)
        IF YERR EQ '' THEN
            BENCHMARK.DESC = R.AM.BENCHMARK<AM.BM.SHORT.NAME>
            GOSUB CALCULATE.BENCHMARK
        END

    END
    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= CHANGE.REF.AMT.TO.INST.AMT>
CHANGE.REF.AMT.TO.INST.AMT:
*** <desc> </desc>
    IF REF.CCY.AMT EQ 0 OR REF.CCY.AMT EQ '' THEN
        INST.CCY.AMT = 0
    END ELSE
        IF REF.CCY EQ INST.CCY THEN
            INST.CCY.AMT = REF.CCY.AMT
        END ELSE
            SELL.CCY = REF.CCY
            BUY.CCY = INST.CCY
            EXCH.DATE = ''
            SELL.AMT = REF.CCY.AMT
            GOSUB GET.EXCHANGE.RATE
            INST.CCY.AMT = BUY.AMT
        END
    END

    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= CHANGE.REF.AMT.TO.VAL.AMT>
CHANGE.REF.AMT.TO.VAL.AMT:
*** <desc> </desc>

    IF REF.CCY.AMT EQ 0 OR REF.CCY.AMT EQ '' THEN
        VAL.CCY.AMT = 0
    END ELSE
        IF REF.CCY EQ VAL.CCY THEN
            VAL.CCY.AMT = REF.CCY.AMT
        END ELSE
            SELL.CCY = REF.CCY
            BUY.CCY = VAL.CCY
            EXCH.DATE = ''
            SELL.AMT = REF.CCY.AMT
            GOSUB GET.EXCHANGE.RATE
            VAL.CCY.AMT = BUY.AMT
        END
    END
    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.PORTFOLIO.DETAILS>
GET.PORTFOLIO.DETAILS:
*** <desc> </desc>
    FACTOR = 100

*... Provided in the selection criteria
    GOSUB GET.PORTFOLIO

*... This is provided in the selection criteria and will be the end of the month.
*... It defaults to today.
    GOSUB GET.END.DATE

*... Set start date to beginning of this month or portfolio start date
    GOSUB GET.START.DATE

    BENCHMARK.ID = R.SEC.ACC.MASTER<SC.SAM.BENCHMARK,1>
*... The call is here because we are currently using the portfolio benchmark
*... as we do not hold a benchmark against an instrument.
*... If we do enhance this to have an instrument vbenchmark then we will need
*... to get teh benchmark for each instrument and modify GET.BENCHMARK and
*... move this calls to PROCESS.INSTRUMENT.
    GOSUB GET.BENCHMARK

    CALC.METHOD = ""
    CALC.METHOD.1CHAR = ""
    METHOD.ENRI       = ""
    R.AM.PERF.PARAMETER = ""
    CALL AM.VAL.CALC.METHOD(CALC.METHOD,R.AM.PERF.PARAMETER,CALC.METHOD.1CHAR,METHOD.ENRI,"","")

    REF.CCY = R.SEC.ACC.MASTER<SC.SAM.REFERENCE.CURRENCY>
    CCY.SET = REF.CCY

    VAL.CCY = R.SEC.ACC.MASTER<SC.SAM.VALUATION.CURRENCY>

    GOSUB ASSIGN.REF.CCY.FLDS

    SIN.LAST = R.SEC.ACC.MASTER<SC.SAM.CLOSURE.DATE>

    GOSUB GET.BEGIN.VAL

    GOSUB GET.END.VAL
    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.PORTFOLIO.IDS>
GET.PORTFOLIO.IDS:
*** <desc> </desc>
* Work out if we need to select SEC.ACC.MASTER file or not

    PORTFOLIO.LIST = ''
    LOCATE 'SAM.NO' IN D.FIELDS<1> SETTING SAM.NO.POS THEN
        PORTFOLIO.LIST = D.RANGE.AND.VALUE<SAM.NO.POS>
    END ELSE
        D.FIELDS<SAM.NO.POS> = 'SAM.NO'
    END

    IF PORTFOLIO.LIST EQ '' THEN
        GOSUB CALL.DAS.FOR.SEC.ACC.MASTER
    END ELSE
        * Allow for a space delimited list of portfolios.
        *... this doesn't work with the current system so we don't do it.
        *       CONVERT " " TO VM IN PORTFOLIO.LIST
    END

    RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= CALL.DAS.FOR.SEC.ACC.MASTER>
*** <desc>Call Data Access Service for SEC.ACC.MASTER to return list of portfolios to process. </desc>

CALL.DAS.FOR.SEC.ACC.MASTER:


    DAS.FILE.NAME = 'SEC.ACC.MASTER'
    DAS.FILE.SUFFIX = ''
*    DAS.LIST = dasSecAccMasterDynSelect
    DAS.LIST = dasAllIds
    DAS.ARGS = ''

*    INCLUDE.SAM = ''
*    LOCATE 'WR.REPORTING' IN D.FIELDS<1> SETTING WR.REPORTING.POS THEN
*        INCLUDE.SAM = D.RANGE.AND.VALUE<WR.REPORTING.POS> EQ 'Y'
*    END
*
*    IF INCLUDE.SAM THEN
*        DAS.ARGS<1> = 'WR.REPORTING'
*        DAS.ARGS<2> = 'EQ'
*        DAS.ARGS<3> = 'Y'
*    END

    CALL DAS(DAS.FILE.NAME,DAS.LIST,DAS.ARGS,DAS.FILE.SUFFIX)
    PORTFOLIO.LIST = DAS.LIST

    RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= PROCESS.INSTRUMENT>
PROCESS.INSTRUMENT:
*** <desc> </desc>
    INST.ID = FIELD(INST.ID.ARR<CNT1>,'#',1)

    AIC = FIELD(INST.ID.ARR<CNT1>,'#',2)
    B.DATE = INST.BEGIN.DATE<CNT1>
    E.DATE = INST.END.DATE<CNT1>
    SEC.CODE = INST.ID
    SEC.E.DATE = E.DATE
    PORT.ID = PORTFOLIO.ID
    GOSUB GET.NAME.INSTR.CCY
    INST.NAME = SEC.NAME
    INST.CCY = SEC.CCY

    B.VAL = REC.STORE.PERF.VAL<SOD.VAL.FLD,CNT1>
    IF B.VAL EQ '' THEN
        B.VAL = 0
    END
    E.VAL = REC.STORE.PERF.VAL<EOD.VAL.FLD,CNT1>
    IF E.VAL EQ '' THEN
        E.VAL = 0
    END
    SALES = REC.STORE.PERF.VAL<OUTFLOW.FLD,CNT1>
    IF SALES EQ '' THEN
        SALES = 0
    END
    PURCHASES = REC.STORE.PERF.VAL<INFLOW.FLD,CNT1>
    IF PURCHASES EQ '' THEN
        PURCHASES = 0
    END

    AIC.VAL = AIC

    CASH.FLOW = SALES + PURCHASES

*... problem with divide by zero craig  winter to clarify
    DIVISOR =(B.VAL + 0.5 * CASH.FLOW)
    IF DIVISOR NE 0 THEN
        DIETZ = ((E.VAL - B.VAL - CASH.FLOW) / DIVISOR  ) * 100
    END ELSE
        DIETZ = 0
    END

    IF CALC.METHOD[1,1] # 'M' THEN
        PERF = REC.STORE.PERF.VAL<INDEX.FLD,CNT1,1>
    END ELSE
        * Daily
        PERF = REC.STORE.PERF.VAL<INDEX.FLD,CNT1,1>
    END

    MODIFIED.DIETZ = PERF

    IF CCY.SET[1,1] EQ 'S' THEN
        CCY.FLD = INST.CCY
    END ELSE
        CCY.FLD = REF.CCY
    END

    IF CNT1 = '1' THEN
        E.DATES = END.DATE
    END ELSE
        E.DATES = ''
    END

    SELL.AMT = 1
    SELL.CCY = INST.CCY
    BUY.CCY = REF.CCY
    EXCH.DATE = END.DATE
    GOSUB GET.EXCHANGE.RATE
    END.EXCHANGE.RATE = EXCHANGE.RATE

    SELL.AMT = 1
    SELL.CCY = INST.CCY
    BUY.CCY = REF.CCY
    EXCH.DATE = B.DATE
    GOSUB GET.EXCHANGE.RATE
    START.EXCHANGE.RATE = EXCHANGE.RATE

    GOSUB GET.SUB.ASSET.TYPE

    GOSUB GET.ASSET.TYPE

    GOSUB GET.SC.POS.ASSET

*... For orchestrate instrument ccy is local ccy, go figure.
    REF.CCY.AMT = PURCHASES
    GOSUB CHANGE.REF.AMT.TO.INST.AMT
    PURCHASES.INST.CCY = INST.CCY.AMT

*... For orchestrate instrument ccy is local ccy, go figure.
    REF.CCY.AMT = SALES
    GOSUB CHANGE.REF.AMT.TO.INST.AMT
    SALES.INST.CCY = INST.CCY.AMT

*... For orchestrate instrument ccy is local ccy, go figure.
    REF.CCY.AMT = B.VAL
    GOSUB CHANGE.REF.AMT.TO.INST.AMT
    START.VAL.INST.CCY = INST.CCY.AMT

    REF.CCY.AMT = PURCHASES
    GOSUB CHANGE.REF.AMT.TO.VAL.AMT
    VALUATION.VALUE.OF.BUYS = VAL.CCY.AMT

    REF.CCY.AMT = SALES
    GOSUB CHANGE.REF.AMT.TO.VAL.AMT
    VALUATION.VALUE.OF.SELLS = VAL.CCY.AMT

    INCEPTION.DATE = R.SC.POS.ASSET<SC.PAS.HELD.SINCE>
    IF INCEPTION.DATE EQ '' THEN
        INCEPTION.DATE = SAM.START.DATE
    END

    THIS.LINE = ''
*... Lines Commented out are not used yet. Just placeholders
*... Many of these items have Orchistrate names that we do not know how to translate yet.
*       THIS.LINE<1,1> = ACCOUNT.ID                             ; * sub asset type?
*       THIS.LINE<1,2> = ACCOUNT.NAME                           ; * sub asset type short desc?
*       THIS.LINE<1,3> = ASSET.NAME                                     ; * security master short desc?
*       THIS.LINE<1,4> = ASSET.TYPE
*       THIS.LINE<1,5> = CASH.CHANGES.LOCAL
*       THIS.LINE<1,6> = CASH.CHANGES.VALUATION
*       THIS.LINE<1,7> = COUPON.IN.PERIOD
    THIS.LINE<1,8> = DIETZ
*       THIS.LINE<1,9> = DIVIDENDS
    THIS.LINE<1,10> = E.VAL
    THIS.LINE<1,11> = END.DATE
    THIS.LINE<1,12> = END.EXCHANGE.RATE
    THIS.LINE<1,13> = END.PRICE
    THIS.LINE<1,14> = E.VAL
    THIS.LINE<1,15> = INCEPTION.DATE
    THIS.LINE<1,16> = BENCHMARK.ID
    THIS.LINE<1,17> = BENCHMARK.DESC
    THIS.LINE<1,18> = INSTRUMENT.BENCHMARK.PERF
    THIS.LINE<1,19> = INST.ID
******        THIS.LINE<1,20> = INTEREST.PAID
******        THIS.LINE<1,21> = INTEREST.PAYMENTS

    THIS.LINE<1,22> = PURCHASES.INST.CCY
    THIS.LINE<1,23> = SALES.INST.CCY
    THIS.LINE<1,24> = MODIFIED.DIETZ
    THIS.LINE<1,25> = PORTFOLIO.ID
    THIS.LINE<1,26> = R.SEC.ACC.MASTER<SC.SAM.ACCOUNT.NAME>
    THIS.LINE<1,27> = R.SEC.ACC.MASTER<SC.SAM.REFERENCE.CURRENCY>
******        THIS.LINE<1,28> = REALISED.CCY.PL
******        THIS.LINE<1,29> = REALISED.PRICE.REF.CCY
******        THIS.LINE<1,30> = REALISED.PROFIT.LCY
******        THIS.LINE<1,31> = REALISED.PROFIT.VAL.CCY
    THIS.LINE<1,32> = BEGIN.VAL1
    THIS.LINE<1,33> = START.DATE
    THIS.LINE<1,34> = START.EXCHANGE.RATE
    THIS.LINE<1,35> = START.VAL.INST.CCY
*        THIS.LINE<1,36> = START.PRICE.VAL.CCY
    THIS.LINE<1,37> = B.VAL
*        THIS.LINE<1,38> = TAX.PAID.VAL.CCY
*        THIS.LINE<1,39> = BOUGHT.NOMINAL
*        THIS.LINE<1,40> = TOTAL.COUPONS
*        THIS.LINE<1,41> = TOTAL.INT.RECIEVED
*        THIS.LINE<1,42> = TOTAL.SELLS
******        THIS.LINE<1,43> = UNREALISED.CCY.PL
******        THIS.LINE<1,44> = UNREALISED.INT
******        THIS.LINE<1,45> = UNREALISED.PRICE
******        THIS.LINE<1,46> = UNREALISED.PROFIT.VALUATION
    THIS.LINE<1,47> = VALUATION.VALUE.OF.BUYS
    THIS.LINE<1,48> = VALUATION.VALUE.OF.SELLS

* DONT DO THIS!!!!!!!!!!!!!!!!!!! ARGHHH!!!
*                            1          2         3        4           5               6             7        8          9            10              11             12          13              14          15          16          17            18            19            20                  21          22
*        OUT.ARRAY<-1> = END.DATE:"*":B.VAL:"*":E.VAL:"*":PERF:"*":CALC.METHOD:"*":PORTFOLIO.ID:"*":AIC:"*":SALES:"*":PURCHASES:"*":OPEN.DATE:"*":CLOSE.DATE:"*":INST.CCY:"*":BEGIN.VAL1:"*":END.VAL1:"*":INST.NAME:"*":B.DATE:"*":E.DATE:"*":CALC.METHOD:"*":INST.ID:"*":PERIOD.CALCULATED:"*":CCY.SET:"*":E.DATES ;*CI10018706 -S/E
    CHANGE VM TO '*' IN THIS.LINE
    OUT.ARRAY<-1> = THIS.LINE
    RETURN
*** </region>


*------------------------------------------------------------------------

*** <desc>Calculate the benchmark performance figures </desc>
CALCULATE.BENCHMARK:

* Calculate perfomance for the month to date
    CALL CALC.BENCHMARK.PERF(BENCHMARK.ID,START.DATE,END.DATE,INSTRUMENT.BENCHMARK.PERF)

    RETURN

    END
