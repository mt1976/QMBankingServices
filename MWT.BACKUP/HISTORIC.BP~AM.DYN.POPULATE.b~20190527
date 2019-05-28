* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>-118</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE AM.DYN.POPULATE(AM.MODEL.PORT.REBUILD.ID)
*-----------------------------------------------------------------------------
* This will take a valid AM.MODEL.PORT.REBUILD id from AM.DYN.POPULATE.WRK
* and create a SEC.OPEN.ORDER or a SECURITY.TRANSFER depending on parameter settings.
*-----------------------------------------------------------------------------
* Modification History:
*
* 31/07/2005 EN_10003489
*             Created.
*
* 27/09/2007 EN_10003513
*            Modified to create trades or orders based on parameter settings.
*            Modified to use price specified on model.
*            Modified to allow backvalued orders and trades.
*
* 05/10/2007 EN_10003513
*            Add ability to create SECURITY.TRANSFERS based on AM.PARAMETER settings.
*            Orders and Trade value and trade date to be VALIDITY.DATE
*            The BROKER and DEPOSITORY on the trade to be VIRTUAL
*            CUST.PRICE is now got from the AM.DYNAMIC.MODEL.
* 30/10/2007 BG_100015612
*            The exchange rate needs to be added to the transfer
*            The rate, which on ADM is Ptfo Ref CCY -> Security CCY
*            needs to be
*            Ptfo Ref CCY -> Local CCY
*
* 12/03/09 - BG_100022635 - aleggett@temenos.com
*            DBSA Performance improvement for Virtual Portfolio processing
*            Use parameterised transaction types and delivery type
*            Ref: TTS0906420
*
* 10/08/09 - CI_10065292
*            Make sure that the nominal is rounded to 6 decimal places.
* 17/05/10 - Add a dummy CASH asset type for a Pre-Sales Demo
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AM.DYN.POPULATE.COMMON
    $INSERT I_F.AM.MODEL.PORT.REBUILD
    $INSERT I_F.SEC.OPEN.ORDER
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SC.STD.SEC.TRADE
    $INSERT I_F.SC.TRANS.TYPE
    $INSERT I_F.AM.PARAMETER
    $INSERT I_F.COMPANY
    $INSERT I_F.DATES
    $INSERT I_F.USER
    $INSERT I_F.SEC.TRADE
    $INSERT I_AM.DYNAMIC.MODEL.COMMON
    $INSERT I_F.AM.DYNAMIC.MODEL
    $INSERT I_F.SECURITY.TRANSFER
    $INSERT I_F.SEC.ACC.MASTER
    $INSERT I_F.CURRENCY.PARAM
    $INSERT I_F.SUB.ASSET.TYPE
*-----------------------------------------------------------------------------
* Perform the transaction/contract processing in this routine. All files & standard
* variables should be setup in AM.DYN.POPULATE.LOAD and passed using the
* named COMMON I_AM.DYN.POPULATE.COMMON


    GOSUB INITIALISE

    IF NOMINAL.AMT GT 0 THEN
        GOSUB CREATE.TRADE
        IF isStock THEN GOSUB CREATE.OFS.MSG.TO.INPUT.RECORD
        GOSUB WRITE.AM.MODEL.PORT.REBUILD
        GOSUB DELETE.WORK.FILE.KEY
    END

    RETURN

*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
***
    R.SECURITY.TRANSFER = ''

    JUL.PROCESSDATE = R.DATES(EB.DAT.JULIAN.DATE)[3,5]

    R.AM.MODEL.PORT.REBUILD = ''
    YERR = ''
    CALL F.READ(FN.AM.MODEL.PORT.REBUILD,AM.MODEL.PORT.REBUILD.ID,R.AM.MODEL.PORT.REBUILD,F.AM.MODEL.PORT.REBUILD,YERR)

    CHILD.NODE.NAME = R.AM.MODEL.PORT.REBUILD<AM.MPR.CHILD.NODE.ID>
    SECURITY.NO = R.AM.MODEL.PORT.REBUILD<AM.MPR.SECURITY.NO>
    NOMINAL.AMT = DROUND(R.AM.MODEL.PORT.REBUILD<AM.MPR.AMEND.PROP.NOM>, 6)
    BUY.SELL = UPCASE(R.AM.MODEL.PORT.REBUILD<AM.MPR.AMEND.ACTION>)
    VALIDITY.DATE = R.AM.MODEL.PORT.REBUILD<AM.MPR.VALIDITY.DATE>
    DEPOSITORY = R.AM.PARAMETER<AM.PAR.VIRTUAL.DEPOSITORY>
    BROKER = R.AM.PARAMETER<AM.PAR.VIRTUAL.BROKER>
    PORTFOLIO = R.AM.MODEL.PORT.REBUILD<AM.MPR.SECURITY.ACCOUNT>
    CUSTOMER = FIELD(PORTFOLIO, '-', 1)

* Set up virtual transaction codes and delivery instructions to populate the SECURITY.TRANSFER with.

    vrtTransType = R.AM.PARAMETER<AM.PAR.VRT.TRANS.TYPE>
    vrtDelivInstr = R.AM.PARAMETER<AM.PAR.VRT.DELIV.INSTR>

    IF vrtTransType = '' THEN
        vrtTransType = 'TRA' ; * Hard code this if nothing else has been specified
    END

    SC.TRANS.TYPE.ID = vrtTransType
    R.SC.TRANS.TYPE = ''
    YERR = ''
    CALL CACHE.READ("F.SC.TRANS.TYPE",SC.TRANS.TYPE.ID,R.SC.TRANS.TYPE,YERR)
    vrtTransCr = R.SC.TRANS.TYPE<SC.TRN.SECURITY.CR.CODE>
    vrtTransDr = R.SC.TRANS.TYPE<SC.TRN.SECURITY.DR.CODE>
    IF vrtTransCr = '' THEN
        vrtTransCr = 'TRI' ; * Hard code this if nothing else has been specified
    END
    IF vrtTransDr = '' THEN
        vrtTransDr = 'TRO' ; * Hard code this if nothing else has been specified
    END

    IF vrtDelivInstr = '' THEN
        vrtDelivInstr = 'FOP' ; * Hard code this if nothing else has been specified
    END

*... Defaults to creating a trade.
    SEC.APPLICATION.NAME = 'SECURITY.TRANSFER'

    FN.SECURITY.TRANSFER = 'F.SECURITY.TRANSFER'
    F.SECURITY.TRANSFER = ''
    CALL OPF(FN.SECURITY.TRANSFER,F.SECURITY.TRANSFER)

    FN.SECURITY.TRANSFER$NAU = 'F.SECURITY.TRANSFER$NAU'
    F.SECURITY.TRANSFER$NAU = ''
    CALL OPF(FN.SECURITY.TRANSFER$NAU,F.SECURITY.TRANSFER$NAU)


    FN.SEC.ACC.MASTER = 'F.SEC.ACC.MASTER'
    F.SEC.ACC.MASTER = ''
    CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)

    FN.CURRENCY.PARAM = 'F.CURRENCY.PARAM'
    F.CURRENCY.PARAM = ''
    CALL OPF(FN.CURRENCY.PARAM,F.CURRENCY.PARAM)

    FN.SUB.ASSET.TYPE = 'F.SUB.ASSET.TYPE'
    F.SUB.ASSET.TYPE = ''
    CALL OPF(FN.SUB.ASSET.TYPE,F.SUB.ASSET.TYPE)

    isStock = @TRUE


    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.NEXT.KEY>
GET.NEXT.KEY:
*** <desc>Get a new SEC.OPEN.ORDER key generated by auto id system</desc>
    IF isStock THEN
        CALL SC.GET.NEXT.APPL.ID( SEC.APPLICATION.NAME, SEC.APPLICATION.ID)
    END ELSE
        SEC.APPLICATION.ID = "CASH"
    END

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= DELETE.WORK.FILE.KEY>
DELETE.WORK.FILE.KEY:
***
    AM.DYN.POPULATE.WRK.ID = AM.MODEL.PORT.REBUILD.ID
    CALL F.DELETE(FN.AM.DYN.POPULATE.WRK,AM.DYN.POPULATE.WRK.ID)

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= WRITE.AM.MODEL.PORT.REBUILD>
WRITE.AM.MODEL.PORT.REBUILD:
***

*... Add the trade id to the source record to enable us to trace trades.
    R.AM.MODEL.PORT.REBUILD<AM.MPR.SEC.TXFR.ID, -1> = SECURITY.TRANSFER.ID
    CALL F.WRITE(FN.AM.MODEL.PORT.REBUILD,AM.MODEL.PORT.REBUILD.ID,R.AM.MODEL.PORT.REBUILD)

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= CREATE.OFS.MSG.TO.INPUT.RECORD>
CREATE.OFS.MSG.TO.INPUT.RECORD:

* DEBUG

***
*... Which version of SECURITY.TRANSFER should we use?
    parameterVersion = R.AM.PARAMETER<AM.PAR.SEC.TXF.VERSION>
    parameterFieldNo = AM.PAR.SEC.TXF.VERSION
    IF FIELD(parameterVersion,",",1) EQ 'SECURITY.TRANSFER' THEN
        APP.VERSION = parameterVersion
    END ELSE
        APP.VERSION = 'SECURITY.TRANSFER,'
    END

*... What OFS.SOURCE should we use
    OFS.SOURCE.ID = R.AM.PARAMETER<AM.PAR.OFS.SOURCE>

*... create message to input the record.
    OFS.MSG = APP.VERSION:'/I/PROCESS,//': ID.COMPANY :','
    OFS.MSG := SEC.APPLICATION.ID:',SECURITY.NO:1:1=':SECURITY.NO
    MSG.ID = ''
    OPTNS = ''
    CALL OFS.POST.MESSAGE(OFS.MSG, MSG.ID, OFS.SOURCE.ID, OPTNS)

*... Start the OFS message service
    SERVICE.NAME = 'OFS.MESSAGE.SERVICE'
    SERVICE.ACTION = 'START'
    CALL SERVICE.CONTROL(SERVICE.NAME,SERVICE.ACTION,'')

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.DATE.TIME>
GET.DATE.TIME:
***
    THIS.DATE = OCONV(DATE(),'D-')
    TIME.STAMP = TIMEDATE()
    DATE.TIME = THIS.DATE[9,2]:THIS.DATE[1,2]:THIS.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= CREATE.TRADE>
CREATE.TRADE:
***
    GOSUB GET.SECURITY.MASTER

	IF isStock THEN
    	GOSUB GET.TRADE.PRICE
    	GOSUB CREATE.NEW.TRADE
    END
    
    GOSUB GET.NEXT.KEY

    GOSUB WRITE.SECURITY.TRANSFER

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= CREATE.NEW.TRADE>
CREATE.NEW.TRADE:
***

*... transaction type
    IF BUY.SELL = "BUY" THEN
        R.SECURITY.TRANSFER<SC.STR.TRANSACTION.TYPE> = vrtTransCr
    END ELSE
        R.SECURITY.TRANSFER<SC.STR.TRANSACTION.TYPE> = vrtTransDr
    END

    R.SECURITY.TRANSFER<SC.STR.SECURITY.NO> = SECURITY.NO

    R.SECURITY.TRANSFER<SC.STR.DEPOSITORY> = DEPOSITORY ; * Virtual Depo

    R.SECURITY.TRANSFER<SC.STR.TRADE.DATE> = VALIDITY.DATE
    R.SECURITY.TRANSFER<SC.STR.VALUE.DATE> = VALIDITY.DATE

* Customer Details
    R.SECURITY.TRANSFER<SC.STR.CUSTOMER.NO> = CUSTOMER
    R.SECURITY.TRANSFER<SC.STR.SECURITY.ACC> = PORTFOLIO

    R.SECURITY.TRANSFER<SC.STR.NO.NOMINAL> = NOMINAL.AMT

    R.SECURITY.TRANSFER<SC.STR.PRICE> = TRADE.PRICE
* Add in the rate

    refToSecCcyExchangeRate = R.AM.MODEL.PORT.REBUILD<AM.MPR.AMEND.RATE>
    GOSUB exchangeRateManipulation ; * Swaps Exch Rate from Ref->Sec CCY to Ref -> Local CCY
    R.SECURITY.TRANSFER<SC.STR.REF.EXCH.RATE> = refToLccyExchangeRate

    R.SECURITY.TRANSFER<SC.STR.BROKER.NO> = BROKER
* Transfer must be free of payment
    R.SECURITY.TRANSFER<SC.STR.DELIVERY.INSTR> = vrtDelivInstr



* Stop any delivery etc....
    R.SECURITY.TRANSFER<SC.STR.VAULT.UPDATE> = "NO"
    R.SECURITY.TRANSFER<SC.STR.PAYMENT.REQD> = "NO"
    R.SECURITY.TRANSFER<SC.STR.BROKER.ADVICE.REQD> = "NO"
    R.SECURITY.TRANSFER<SC.STR.DEPOT.ADVICE.REQD> = "NO"
    R.SECURITY.TRANSFER<SC.STR.CASH.HOLD.SETTLE> = "NO"
    R.SECURITY.TRANSFER<SC.STR.SEC.HOLD.SETTLE> = "NO"
    R.SECURITY.TRANSFER<SC.STR.SUPPR.DELIVERY> = "Yes"

**... narrative
*      R.SECURITY.TRANSFER<SC.STR.CU.NARRATIVE,1> = 'Created from model build record id ':AM.MODEL.PORT.REBUILD.ID
*      R.SECURITY.TRANSFER<SC.STR.BR.NARRATIVE,1> = 'Created from model build record id ':AM.MODEL.PORT.REBUILD.ID

*... current version number
    R.SECURITY.TRANSFER<SC.STR.CURR.NO> = '1'

*... inputter
    R.SECURITY.TRANSFER<SC.STR.INPUTTER> = TNO:'_':OPERATOR

*... date time
    GOSUB GET.DATE.TIME
    R.SECURITY.TRANSFER<SC.STR.DATE.TIME> = DATE.TIME

*... company
    R.SECURITY.TRANSFER<SC.STR.CO.CODE> = ID.COMPANY

*... users department
    R.SECURITY.TRANSFER<SC.STR.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>

*... status to held
    R.SECURITY.TRANSFER<SC.STR.RECORD.STATUS> = 'IHLD'

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.SECURITY.MASTER>
GET.SECURITY.MASTER:
***
    R.SECURITY.MASTER = ''
    YERR = ''
    CALL F.READ(FN.SECURITY.MASTER, SECURITY.NO, R.SECURITY.MASTER,F.SECURITY.MASTER,YERR)


    SUB.ASSET.TYPE.ID =  R.SECURITY.MASTER<SC.SCM.SUB.ASSET.TYPE>

    R.SUB.ASSET.TYPE = ''
    YERR = ''
    CALL F.READ(FN.SUB.ASSET.TYPE,SUB.ASSET.TYPE.ID,R.SUB.ASSET.TYPE,F.SUB.ASSET.TYPE,YERR)

* IF R.SUB.ASSET.TYPE<SC.CSG.ASSET.TYPE.CODE> = "57" THEN <<-- the 57 value should be taken from a parameter file really.

    IF R.SUB.ASSET.TYPE<SC.CSG.ASSET.TYPE.CODE> = "57" THEN
        * This is a dummy cash asset type.
        isStock = @FALSE
    END

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= WRITE.SECURITY.TRANSFER>
WRITE.SECURITY.TRANSFER:
***
    SECURITY.TRANSFER.ID = SEC.APPLICATION.ID
    IF isStock THEN
        CALL F.WRITE(FN.SECURITY.TRANSFER$NAU,SECURITY.TRANSFER.ID,R.SECURITY.TRANSFER)
    END
    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.TRADE.PRICE>
GET.TRADE.PRICE:
***
    AM.DYNAMIC.MODEL.ID = CHILD.NODE.NAME:'*':VALIDITY.DATE
    R.AM.DYNAMIC.MODEL = ''
    YERR = ''
    CALL F.READ(FN.AM.DYNAMIC.MODEL,AM.DYNAMIC.MODEL.ID,R.AM.DYNAMIC.MODEL,F.AM.DYNAMIC.MODEL,YERR)
    SECURITY.NO.LIST = R.AM.DYNAMIC.MODEL<AM.DYN.SECURITY>
    CONVERT @SM TO @VM IN SECURITY.NO.LIST
    TRADE.PRICE = ''
    LOCATE SECURITY.NO IN SECURITY.NO.LIST<1,1> SETTING POS THEN
        AMEND.PRICE.LIST = R.AM.DYNAMIC.MODEL<AM.DYN.AMEND.PRICE>
        CONVERT @SM TO @VM IN AMEND.PRICE.LIST
        TRADE.PRICE = AMEND.PRICE.LIST<1,POS>
        IF TRADE.PRICE EQ '' THEN
            REF.PRICE.LIST = R.AM.DYNAMIC.MODEL<AM.DYN.REF.PRICE>
            CONVERT @SM TO @VM IN REF.PRICE.LIST
            TRADE.PRICE = REF.PRICE.LIST<1,POS>
        END

    END
*... get the price from the security master record
    IF TRADE.PRICE EQ '' THEN
        TRADE.PRICE = R.SECURITY.MASTER<SC.SCM.LAST.PRICE>
    END

    RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= exchangeRateManipulation>
exchangeRateManipulation:
*** <desc>Swaps Exch Rate from Ref->Sec CCY to Ref -> Local CCY</desc>
* uses refToSecCcyExchangeRate = R.AM.MODEL.PORT.REBUILD<AM.MPR.AMEND.RATE>
* returns refToLccyExchangeRate
    IF refToSecCcyExchangeRate = "" THEN
        * DO NOTHING
        refToLccyExchangeRate = ""
    END ELSE

        refToLccyExchangeRate = ""
        securityCCY = R.AM.MODEL.PORT.REBUILD<AM.MPR.SECURITY.CCY>
        ID.SEC.ACC.MASTER = R.AM.MODEL.PORT.REBUILD<AM.MPR.SECURITY.ACCOUNT>
        GOSUB getPortfolioRecord ; * Retrieve the portfolio record.
        referenceCCY = R.SEC.ACC.MASTER<SC.SAM.REFERENCE.CURRENCY>

        CCY.BUY = securityCCY
        BUY.AMT = ""
        CCY.SELL= referenceCCY
        SELL.AMT= "1000"
        BASE.CCY= ""
        EXCHANGE.RATE= refToSecCcyExchangeRate
        DIFFERENCE= ""
        LCY.AMT= ""
        RETURN.CODE= ""
        GOSUB processEx ; *

        GOSUB getCurrencyRankings ; *

        IF referenceRank < localRank THEN
            AMT = LCY.AMT / SELL.AMT
        END ELSE
            AMT = SELL.AMT / LCY.AMT
        END

        refToLccyExchangeRate = AMT

    END
    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= getPortfolioRecord>
getPortfolioRecord:
*** <desc>Retrieve the portfolio record.</desc>
    R.SEC.ACC.MASTER = ''
    YERR = ''
    CALL F.READ(FN.SEC.ACC.MASTER,ID.SEC.ACC.MASTER,R.SEC.ACC.MASTER,F.SEC.ACC.MASTER,YERR)

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= processEx>
processEx:
***
    CALL EXCHRATE("1",CCY.BUY,BUY.AMT,CCY.SELL,SELL.AMT,BASE.CCY,EXCHANGE.RATE,DIFFERENCE,LCY.AMT,RETURN.CODE)

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= getCurrencyRankings>
getCurrencyRankings:
***

    testCCY = securityCCY
    GOSUB getRank ; *
    securityRank = testRank

    testCCY = referenceCCY
    GOSUB getRank ; *
    referenceRank = testRank

    testCCY = LCCY
    GOSUB getRank ; *
    localRank = testRank

    RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= getRank>
getRank:
***

    ID.CURRENCY.PARAM = testCCY
    testRank = ""

    R.CURRENCY.PARAM = ''
    YERR = ''
    CALL F.READ(FN.CURRENCY.PARAM,ID.CURRENCY.PARAM,R.CURRENCY.PARAM,F.CURRENCY.PARAM,YERR)
    testRank = R.CURRENCY.PARAM<EB.CUP.BASE.CCY.RANK>
    IF testRank = "" THEN testRank = 999999999999

    RETURN
*** </region>
    END
