[do]: https://github.com/mt1976/mwt-QM-dev/blob/master/.resources/themes/unicons-line-6563ff/play.svg "Logo Title Text 2"
[test]: https://github.com/mt1976/mwt-QM-dev/blob/master/.resources/themes/unicons-line-6563ff/cloud-question.svg "Logo Title Text 2"
[save]: https://github.com/mt1976/mwt-QM-dev/blob/master/.resources/themes/unicons-line-6563ff/save.svg "Logo Title Text 2"
[actions]: https://github.com/mt1976/mwt-QM-dev/blob/master/.resources/themes/unicons-line-6563ff/file-question-alt.svg "Logo Title Text 2"


# TODO

Demo webapp, single page, collapsible sections. 

## Confguration
Field | Value | Note | tag
--- | --- | --- | ---
Out|/mnt/sal-bnk6/sys-3/request/|*Where the webapp will drop request files*|N/A
Response|/mnt/sal-bnk6/sys-3/response/|*Where the webapp will monitor for reqposes from the wvt server*|N/A
Token|133ae0e051744715b9a70ee75e46c0a8|*An app token defined in the wvt server instance*|`appToken`
ID|bnk6abc|*A ID used to ensure all requests are unique*|`uniqueID`

test|save|connect
---|---|---
![test] [test connection] |![save] [save config] |![actions] [get actions] 

## Actions / Service Catalog 
Service|`requestAction`|`requestItem`|`requestParameters`|HelpText|Go
---|---|---|---|---|---
**Funds Check** 
  ACK]|SIENA.FUNDS.CHECK.ACK||NOPAGE|ACK&#39;s outstanding funds checks|![DO]
  NACK |SIENA.FUNDS.CHECK.NACK||NOPAGE|NACK&#39;s funds checks|![DO]
**Transaction Generation**
  Accounts |SIENA.GEN.TXNS|ACCOUNTS|NOPAGE||![DO]
  FX Spot|SIENA.GEN.TXNS|SPOT|NOPAGE||![DO]
  FX Forwards|SIENA.GEN.TXNS|FORWARD|NOPAGE||![DO]
  Bonds/UK Gilts|SIENA.GEN.TXNS|BOND|NOPAGE||![DO]
### Other Examples
Service|Execute|`requestAction`|`requestItem`|`requestParameters`|HelpText
---|---|---|---|---|---
 Spot Prices|![do]|SORT|SIENA.CACHE|WITH OBJECT LIKE FX.SP... BY OBJECT OBJECT VALUE ID-SUPP NOPAGE|
 FX Prices by CCYPAIR|![do]|SORT|SIENA.CACHE|WITH OBJECT LIKE FX...&lt;&lt;CCY PAIR&gt;&gt;... BY OBJECT OBJECT VALUE ID-SUPP NOPAGE|
## Response
+  Details response from server

