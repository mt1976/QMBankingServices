SELECT        NameFirm, NameCentre, BICCode, ContactIndicator, CoverTrade, CustomerCategory, FSCSInclusive, FeeFactor, InactiveStatus, Indemnity, KnowYourCustomerStatus, LERLimitCarveOut, LastAmended, LastLogin,
                         LossGivenDefault, MIC, ProtectedDepositor, RPTCurrency, RateTimeout, RateValidation, Registered, RegulatoryCategory, SecuredSettlement, SettlementLimitCarveOut, SortCode, Training, TrainingCode, TrainingReceived,
                         Unencumbered, LEIExpiryDate, MIFIDReviewDate, GDPRReviewDate, DelegatedReporting, BOReconcile, MIFIDReportableDealsAllowed, SignedInvestmentAgreement, AppropriatenessAssessment, FinancialCounterparty,
                         Collateralisation, PortfolioCode, ReconciliationLetterFrequency, DirectDealing
FROM            {{SQL.SOURCE}}.CounterpartyExtensions
WHERE        (InternalDeleted IS NULL)
