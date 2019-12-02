* Version 3 02/06/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-142</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.WR.GET.CUST.DETAILS(OUT.ARRAY)
*-----------------------------------------------------------------------------
* This routine is used to fetch the Customer Details
* with the Local Reference Field related to the Customer Application
* and its Corresponding Values from the Customer Record.
*-----------------------------------------------------------------------------
* Modification History :
*
* 06/11/09 - RTC7151 - aleggett@temenos.com
*            7151: Convert enquiry WR.KYCINFO NOFILE enquiry into file-based enquiry.
*
* 18/12/09 - RTC10020 - aleggett@temenos.com
*            10020: KYC Info cvs ouput
*            Add extra fields and output most data in same columns as
*            the local ref fields.
*
* 23/12/09 - RTC10222
*            Add attributes for report start and end dates.
*
*
* 23/04/10 - EN_10004546/19078
*            Period start date always return day 01 irrespective of it is a working day or not
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.LOCAL.REF.TABLE
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_DAS.SEC.ACC.MASTER
    $INSERT I_DAS.COMMON
    $INSERT I_F.WR.PARAMETER
    $INSERT I_F.SEC.ACC.MASTER
    $INSERT I_F.AM.BENCHMARK
    $INSERT I_F.AM.PERF.PARAMETER
    $INSERT I_F.CURRENCY
    $INSERT I_F.INVESTMENT.PROGRAM
    $INSERT I_F.COMPANY
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB MAIN.PROCESS        ;* get the Client Information

    RETURN

*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
INITIALISE:
*** <desc> to initialise the variable</desc>

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.LOCAL.REF.TABLE = 'F.LOCAL.REF.TABLE'
    F.LOCAL.REF.TABLE = ''
    CALL OPF(FN.LOCAL.REF.TABLE,F.LOCAL.REF.TABLE)

    FN.LOCAL.TABLE = 'F.LOCAL.TABLE'
    F.LOCAL.TABLE = ''
    CALL OPF(FN.LOCAL.TABLE,F.LOCAL.TABLE)

    FN.SEC.ACC.MASTER = 'F.SEC.ACC.MASTER'
    F.SEC.ACC.MASTER = ''
    CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)

    FN.SEC.ACC.CUST = 'F.SEC.ACC.CUST'
    F.SEC.ACC.CUST = ''
    CALL OPF(FN.SEC.ACC.CUST,F.SEC.ACC.CUST)

    FN.AM.BENCHMARK = 'F.AM.BENCHMARK'
    F.AM.BENCHMARK = ''
    CALL OPF(FN.AM.BENCHMARK,F.AM.BENCHMARK)

    FN.INVESTMENT.PROGRAM = 'F.INVESTMENT.PROGRAM'
    F.INVESTMENT.PROGRAM = ''
    CALL OPF(FN.INVESTMENT.PROGRAM,F.INVESTMENT.PROGRAM)

    FN.CURRENCY = 'F.CURRENCY'
*   Currency table is opened already and F.CURRENCY is common

    CUST.ID = ''
    ATTRIBUTE.NAME = ''
    ATTRIBUTE.DESCR = ''
    ATTRIBUTE.VALUE = ''

    FN.WR.PARAMETER = 'F.WR.PARAMETER'
    F.WR.PARAMETER = ''
    CALL OPF(FN.WR.PARAMETER,F.WR.PARAMETER)

* Read the company-level WR.PARAMETER record

    R.WR.PARAMETER = ''
    YERR = ''
    CALL EB.READ.PARAMETER(FN.WR.PARAMETER,'N','',R.WR.PARAMETER,ID.COMPANY,F.WR.PARAMETER,YERR)

    IF YERR THEN

        * Read the system-wide WR.PARAMETER record

        R.WR.PARAMETER = ''
        YERR = ''
        CALL EB.READ.PARAMETER(FN.WR.PARAMETER,'N','',R.WR.PARAMETER,'SYSTEM',F.WR.PARAMETER,YERR)

    END

* Get the AM.PERF.PARAMETER record

    R.AM.PERF.PARAMETER = ""
    ID.AM.PERF.PARAMETER = ID.COMPANY
    CALL AM.GET.ENQ.PARAMS(ID.AM.PERF.PARAMETER,"","","","","",R.AM.PERF.PARAMETER,"","","")
    perfMethod = R.AM.PERF.PARAMETER<AM.SSP.PERF.METHOD>
    perfStartDate = ''


    RETURN

***</region>
*-----------------------------------------------------------------------------
*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc> to get the Client Information </desc>

*** Get the List of Customers from the Selection Criteria

    CUST.ID.LIST = ''

    LOCATE "CUSTOMER.NO" IN D.FIELDS<1> SETTING POS THEN
        CUST.LIST = D.RANGE.AND.VALUE<POS>
        GOSUB getCustPortList
    END

    IF CUST.ID.LIST = '' THEN
        GOSUB getWrReportingCustomers
    END

*** Read the Local Ref Table to get the list of local table id's

    CALL F.READ(FN.LOCAL.REF.TABLE,'CUSTOMER',R.LOCAL.REF,F.LOCAL.REF.TABLE,ERR)

    LOCAL.FLD.LIST = R.LOCAL.REF<EB.LRT.LOCAL.TABLE.NO>
    NO.OF.LOCAL.REFS = DCOUNT(LOCAL.FLD.LIST, VM)

    LOOP
        REMOVE CUST.ID FROM CUST.ID.LIST SETTING POS
    WHILE CUST.ID:POS

        GOSUB processCustomer

    REPEAT

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= getCustPortList>
getCustPortList:
*** <desc>Get list of customer/portfolio combinations for this company </desc>

* make CUST.ID.LIST so it contains list of portfolios for each customer entered.
* as CUSTOMER.ID*PORTFOLIO.ID^CUSTOMER.ID*PORTFOLIO.ID....

    CONVERT ' ' TO FM IN CUST.LIST

    LOOP
        REMOVE SEC.ACC.CUST.ID FROM CUST.LIST SETTING EXISTS
    WHILE SEC.ACC.CUST.ID:EXISTS DO


        * READ SEC.ACC.CUST to get list of portfolios for this customer

        R.SEC.ACC.CUST = ''
        YERR = ''
        CALL F.READ(FN.SEC.ACC.CUST,SEC.ACC.CUST.ID,R.SEC.ACC.CUST,F.SEC.ACC.CUST,YERR)

        portList = R.SEC.ACC.CUST

        * CALL SC.CHECK.PORTFOLIO.COMPANY to exclude any portfolios not for this company

        LOOP
            REMOVE SAM.NO FROM portList SETTING MORE
        WHILE MORE:SAM.NO DO
            R.SAM = ''
            ERR.MSG = ''
            CALL SC.CHECK.PORTFOLIO.COMPANY(SAM.NO,R.SAM,ERR.MSG)
            IF NOT(ERR.MSG) THEN
                CUST.ID.LIST<-1> = SEC.ACC.CUST.ID:"*":SAM.NO
            END
        REPEAT

    REPEAT

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= getWrReportingCustomers>
*** <desc>Get customers for whom WR.REPORTING has been selected (in terms of one of their portfolios) </desc>
getWrReportingCustomers:

    dasFileName = 'SEC.ACC.MASTER'
    dasFileSuffix = ''
    dasList = dasSecAccMasterDynSelect

    dasArgs = ''
    dasArgs<1> = 'WR.REPORTING'
    dasArgs<2> = 'EQ'
    dasArgs<3> = 'Y'

    CALL DAS(dasFileName,dasList,dasArgs,dasFileSuffix)

    portfolioList = dasList

    CUST.ID.LIST = ''

    LOOP
        REMOVE portfolioId FROM portfolioList SETTING exists
    WHILE portfolioId:exists DO
        customerId = FIELD(portfolioId,'-',1)
        CUST.ID.LIST<-1> = customerId : '*' : portfolioId
    REPEAT

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= processCustomer>
processCustomer:
*** <desc>Process for the current customer </desc>
*** For the Given customer's get data to be reported and the list of Local Ref Fields and its value.

    portfolioId = FIELD(CUST.ID,'*',2)
    CUST.ID = FIELD(CUST.ID,'*',1)

    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,ERR)

    CUST.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>

    runDate = ''
    CALL WR.LBD.DATE(runDate)
    PERIOD.END.DATE = runDate

    PERIOD.START.DATE = PERIOD.END.DATE[1,6]:'01'
    YREGION = R.COMPANY(EB.COM.LOCAL.COUNTRY):'00'   ;*19078
    CALL CDT(YREGION,PERIOD.START.DATE,'-1W+1W') 

    AREA.NAME = ''

    SEC.ACC.MASTER.ID = portfolioId
    R.SEC.ACC.MASTER = ''
    YERR = ''
    CALL F.READ(FN.SEC.ACC.MASTER,SEC.ACC.MASTER.ID,R.SEC.ACC.MASTER,F.SEC.ACC.MASTER,YERR)

    benchmarkId = R.SEC.ACC.MASTER<SecAccMaster_Benchmark,1> ; * Take first in list
    R.AM.BENCHMARK = ''
    YERR = ''
    CALL F.READ(FN.AM.BENCHMARK,benchmarkId,R.AM.BENCHMARK,F.AM.BENCHMARK,YERR)
    benchmarkName = R.AM.BENCHMARK<AM.BM.SHORT.NAME>

    portfolioName = R.SEC.ACC.MASTER<SecAccMaster_AccountName>
    perfStartDate = MINIMUM(R.SEC.ACC.MASTER<SecAccMaster_PerformDate>)

    groupCashByCcy = ""

    includeCash = "1" ; * We're just hard-coding this for now.

    currencyID = R.SEC.ACC.MASTER<SecAccMaster_ReferenceCurrency>
    currencyISOCode = currencyID

    R.CURRENCY = ''
    YERR = ''
    CALL F.READ(FN.CURRENCY,currencyID,R.CURRENCY,F.CURRENCY,YERR)

    currencyName = R.CURRENCY<EB.CUR.CCY.NAME>

    reportTemplate = R.CUSTOMER<Customer_ReportTemplate>
    holdingsPivot = R.CUSTOMER<Customer_HoldingsPivot>

    GOSUB addFixedDataToAttributes

    GOSUB processLocalRefs

    GOSUB appendDataToOutArray

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= addFixedDataToAttributes>
addFixedDataToAttributes:
*** <desc>Add fixed data to attribute name, descr, value list </desc>

    ATTRIBUTE.NAME<1,1> = "BENCHMARK.ID"
    ATTRIBUTE.DESCR<1,1> = "BenchmarkID"
    ATTRIBUTE.VALUE<1,1> = benchmarkId

    ATTRIBUTE.NAME<1,2> = "BENCHMARK.NAME"
    ATTRIBUTE.DESCR<1,2> = "BenchmarkName"
    ATTRIBUTE.VALUE<1,2> = benchmarkName

    ATTRIBUTE.NAME<1,3> = "PERFORM.DATE"
    ATTRIBUTE.DESCR<1,3> = "PerformanceStartDate"
    ATTRIBUTE.VALUE<1,3> = perfStartDate

    ATTRIBUTE.NAME<1,4> = "GROUP.CASH.BY.CCY"
    ATTRIBUTE.DESCR<1,4> = "GroupCashByCurrency"
    ATTRIBUTE.VALUE<1,4> = groupCashByCcy

    ATTRIBUTE.NAME<1,5> = "INCLUDE.CASH"
    ATTRIBUTE.DESCR<1,5> = "IncludeCash"
    ATTRIBUTE.VALUE<1,5> = includeCash

    ATTRIBUTE.NAME<1,6> = "PERF.METHOD"
    ATTRIBUTE.DESCR<1,6> = "PerformanceMethod"
    ATTRIBUTE.VALUE<1,6> = perfMethod

    ATTRIBUTE.NAME<1,7> = "CURRENCY.ID"
    ATTRIBUTE.DESCR<1,7> = "CurrencyID"
    ATTRIBUTE.VALUE<1,7> = currencyID

    ATTRIBUTE.NAME<1,8> = "CURRENCY.ISO.CODE"
    ATTRIBUTE.DESCR<1,8> = "CurrencyISOCode"
    ATTRIBUTE.VALUE<1,8> = currencyISOCode

    ATTRIBUTE.NAME<1,9> = "CURRENCY.NAME"
    ATTRIBUTE.DESCR<1,9> = "CurrencyName"
    ATTRIBUTE.VALUE<1,9> = currencyName

    ATTRIBUTE.NAME<1,10> = "REPORT.TEMPLATE"
    ATTRIBUTE.DESCR<1,10> = "ReportTemplate"
    ATTRIBUTE.VALUE<1,10> = reportTemplate

    ATTRIBUTE.NAME<1,11> = "HOLDINGS.PIVOT.1"
    ATTRIBUTE.DESCR<1,11> = "HoldingsPivot.1"
    ATTRIBUTE.VALUE<1,11> = holdingsPivot<1,1>

    ATTRIBUTE.NAME<1,12> = "HOLDINGS.PIVOT.2"
    ATTRIBUTE.DESCR<1,12> = "HoldingsPivot.2"
    ATTRIBUTE.VALUE<1,12> = holdingsPivot<1,2>

    ATTRIBUTE.NAME<1,13> = "REPORT.START.DATE"
    ATTRIBUTE.DESCR<1,13> = "ReportStartDate"
    ATTRIBUTE.VALUE<1,13> = PERIOD.START.DATE

    ATTRIBUTE.NAME<1,14> = "REPORT.END.DATE"
    ATTRIBUTE.DESCR<1,14> = "ReportEndDate"
    ATTRIBUTE.VALUE<1,14> = PERIOD.END.DATE


    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= processLocalRefs>
processLocalRefs:
*** <desc>Process the local reference fields </desc>

    OFFSET = DCOUNT(ATTRIBUTE.NAME<1>,VM)

    LOCAL.REF.VALUES = R.CUSTOMER<EB.CUS.LOCAL.REF>
    FOR REF.FIELD = 1 TO NO.OF.LOCAL.REFS
        LOCAL.FLD = LOCAL.FLD.LIST<1,REF.FIELD>
        CALL F.READ(FN.LOCAL.TABLE,LOCAL.FLD,R.LOCAL.FLD,F.LOCAL.TABLE,ERR)

        ATTRIBUTE.NAME<1,REF.FIELD+OFFSET> = R.LOCAL.FLD<EB.LTA.SHORT.NAME>
        ATTRIBUTE.DESCR<1,REF.FIELD+OFFSET> = R.LOCAL.FLD<EB.LTA.DESCRIPTION>

*** to list the respective Local Reference Value

        ATTRIBUTE.VALUE<1,REF.FIELD+OFFSET> = LOCAL.REF.VALUES<1,REF.FIELD>

    NEXT REF.FIELD

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= appendDataToOutArray>
appendDataToOutArray:
*** <desc>Append data to the outgoing array </desc>

    outLineArr = ''
    outLineArr<1> = CUST.ID
    outLineArr<2> = CUST.NAME
    outLineArr<3> = portfolioId
    outLineArr<4> = portfolioName
    outLineArr<5> = PERIOD.START.DATE
    outLineArr<6> = PERIOD.END.DATE
    outLineArr<7> = AREA.NAME

    outLineArr<8> = '' ; * attribute name - will be iterated
    outLineArr<9> = '' ; * attribute description - will be iterated
    outLineArr<10> = '' ; * attribute value - will be iterated
    outLineArr<11> = '' ; * attribute value - will be iterated

* SELECTION CRITERIA

* Repeating Sections

    numRepeatingFlds = DCOUNT(ATTRIBUTE.NAME<1>,VM)
    FOR repeatingFld = 1 TO numRepeatingFlds

        outLineArr<8> = ATTRIBUTE.NAME<1,repeatingFld>
        outLineArr<9> = ATTRIBUTE.DESCR<1,repeatingFld>
        outLineArr<10> = ATTRIBUTE.VALUE<1,repeatingFld>
        outLineArr<11> = ATTRIBUTE.VALUE<1,repeatingFld>

        outLine = outLineArr

        CONVERT FM TO '*' IN outLine
        CONVERT VM TO '~' IN outLine

        OUT.ARRAY<-1> = outLine

    NEXT repeatingFld

    ATTRIBUTE.NAME = ''
    ATTRIBUTE.DESCR = ''
    ATTRIBUTE.VALUE = ''

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= DAS.INTERFACE>
DAS.INTERFACE:
*** <desc> </desc>

    CALL DAS(DAS.FILE.NAME,DAS.LIST,DAS.ARGS,DAS.FILE.SUFFIX)

    RETURN

*** </region>
*-----------------------------------------------------------------------------

    END
