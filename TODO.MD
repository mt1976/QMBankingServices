[logo]: https://raw.githubusercontent.com/mt1976/mwt-QM-dev/07fd171af14e4fe91c8cd82980093cd571fed67e/.resources/themes/unicons-line-6563ff/comment-verify.svg?token=AHNDHX4TRIR5C7XKYGWQYETAEKGI2 "Logo Title Text 2"

# TODO

Demo webapp, single page, collapsible sections. 

## Confguration
Field | Value | Note | tag
--- | --- | --- | ---
Out|/mnt/sal-bnk6/sys-3/request/|*Where the webapp will drop request files*|N/A
Response|/mnt/sal-bnk6/sys-3/response/|*Where the webapp will monitor for reqposes from the wvt server*|N/A
Token|133ae0e051744715b9a70ee75e46c0a8|*An app token defined in the wvt server instance*|`appToken`
ID|bnk6abc|*A ID used to ensure all requests are unique*|`uniqueID`

[test connection] [save config] [get actions] 

## Actions / Service Catalog 
Service|Execute|`requestAction`|`requestItem`|`requestParameters`|HelpText
---|---|---|---|---|---
**Funds Check** 
  ACK|![alt text][logo]|SIENA.FUNDS.CHECK.ACK||NOPAGE|ACK&#39;s outstanding funds checks
  NACK | [DO]|SIENA.FUNDS.CHECK.NACK||NOPAGE|NACK&#39;s funds checks
**Transaction Generation**
  Accounts | [DO] |SIENA.GEN.TXNS|ACCOUNTS|NOPAGE|
  FX Spot| [DO] |SIENA.GEN.TXNS|SPOT|NOPAGE|
  FX Forwards| [DO]|SIENA.GEN.TXNS|FORWARD|NOPAGE|
  Bonds/UK Gilts| [DO]|SIENA.GEN.TXNS|BOND|NOPAGE|
### Other Examples
Service|Execute|`requestAction`|`requestItem`|`requestParameters`|HelpText
---|---|---|---|---|---
 Spot Prices|[do]|SORT|SIENA.CACHE|WITH OBJECT LIKE FX.SP... BY OBJECT OBJECT VALUE ID-SUPP NOPAGE|
 FX Prices by CCYPAIR|[do]|SORT|SIENA.CACHE|WITH OBJECT LIKE FX...&lt;&lt;CCY PAIR&gt;&gt;... BY OBJECT OBJECT VALUE ID-SUPP NOPAGE|
## Response
+  Details response from server

