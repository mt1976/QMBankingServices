<img src="../.resources/themes/unicons-line-6563ff/corner-up-left-alt.svg" alt="BACK" width="25" />[BACK](../DOCS/UTIL.BP.md)  
# W_SERVICE.DO  
|DATA|VALUE|
| --- | --- |
|TYPE|PROGRAM|
|SOURCE|<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="UTIL.BP" width="25" />[UTIL.BP](../DOCS/UTIL.BP.md)|
|ID|W_SERVICE.DO|
    
## USAGE  
  
## REQUIRES  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="I_UTIL.H" width="25" />[I_UTIL.H](../DOCS.PAGE/I_UTIL.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.WCT.RECV.H" width="25" />[F_UTIL.WCT.RECV.H](../DOCS.PAGE/F_UTIL.WCT.RECV.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.WCT.RESP.H" width="25" />[F_UTIL.WCT.RESP.H](../DOCS.PAGE/F_UTIL.WCT.RESP.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.WCT.TEMPLATES.H" width="25" />[F_UTIL.WCT.TEMPLATES.H](../DOCS.PAGE/F_UTIL.WCT.TEMPLATES.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.WORKFILE.H" width="25" />[F_UTIL.WORKFILE.H](../DOCS.PAGE/F_UTIL.WORKFILE.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.WCT.TOKENS.H" width="25" />[F_UTIL.WCT.TOKENS.H](../DOCS.PAGE/F_UTIL.WCT.TOKENS.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.LOG.EVENT.H" width="25" />[F_UTIL.LOG.EVENT.H](../DOCS.PAGE/F_UTIL.LOG.EVENT.H.md)  
    
## HEADER INFORMATION  
```javascript
** INFORMATION ****************************************************************
*   Routine Name : W_SERVICE.DO
*           Type : PROGRAM
*         Params :
*            Loc : UTIL.BP
** AUDIT **********************************************************************
*   Info Updated : 20210227 at 22.42.00 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

```
## BODY  
### EXTERNAL CALLS  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_INITIALISE" width="25" />[U_INITIALISE](../DOCS.PAGE/U_INITIALISE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_START" width="25" />[U_START](../DOCS.PAGE/U_START.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_HEADER" width="25" />[U_HEADER](../DOCS.PAGE/U_HEADER.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.OPENFILE" width="25" />[U_IO.OPENFILE](../DOCS.PAGE/U_IO.OPENFILE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.READ" width="25" />[U_IO.READ](../DOCS.PAGE/U_IO.READ.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_STOP" width="25" />[U_STOP](../DOCS.PAGE/U_STOP.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_GET.LIST.SILENT" width="25" />[U_GET.LIST.SILENT](../DOCS.PAGE/U_GET.LIST.SILENT.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_WILDCARD.SUBSTITUTE" width="25" />[U_WILDCARD.SUBSTITUTE](../DOCS.PAGE/U_WILDCARD.SUBSTITUTE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.WRITE" width="25" />[U_IO.WRITE](../DOCS.PAGE/U_IO.WRITE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.DELETE" width="25" />[U_IO.DELETE](../DOCS.PAGE/U_IO.DELETE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_LOG.EVENT" width="25" />[U_LOG.EVENT](../DOCS.PAGE/U_LOG.EVENT.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="W_SERVICE.LOGIN" width="25" />[W_SERVICE.LOGIN](../DOCS.PAGE/W_SERVICE.LOGIN.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="W_SERVICE.TEST" width="25" />[W_SERVICE.TEST](../DOCS.PAGE/W_SERVICE.TEST.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="W_SERVICE.SERVICES" width="25" />[W_SERVICE.SERVICES](../DOCS.PAGE/W_SERVICE.SERVICES.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="!FINDPROG" width="25" />[!FINDPROG](../DOCS.PAGE/!FINDPROG.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="@CALLOUT.ROUTINE" width="25" />[@CALLOUT.ROUTINE](../DOCS.PAGE/@CALLOUT.ROUTINE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_OS.EXECUTE" width="25" />[U_OS.EXECUTE](../DOCS.PAGE/U_OS.EXECUTE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.READ" width="25" />[U_IO.READ](../DOCS.PAGE/U_IO.READ.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CLEAN.TEXT" width="25" />[U_CLEAN.TEXT](../DOCS.PAGE/U_CLEAN.TEXT.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_BUILD.XML.FIELD" width="25" />[U_BUILD.XML.FIELD](../DOCS.PAGE/U_BUILD.XML.FIELD.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_BUILD.JSON.FIELD.REPEATING" width="25" />[U_BUILD.JSON.FIELD.REPEATING](../DOCS.PAGE/U_BUILD.JSON.FIELD.REPEATING.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_BUILD.XML.FIELD" width="25" />[U_BUILD.XML.FIELD](../DOCS.PAGE/U_BUILD.XML.FIELD.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_JSON.FIND" width="25" />[U_JSON.FIND](../DOCS.PAGE/U_JSON.FIND.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_XML.FIND" width="25" />[U_XML.FIND](../DOCS.PAGE/U_XML.FIND.md)  
### INTERNAL CALLS  
#### CHECK.QUEUE:  
  
#### PROCESS.QUEUE.ITEM:  
  
#### PROCESS.REQUEST.LOG.EVENT:  
  
#### PROCESS.ACTION:  
  
#### PROCESS.CALLOUT:  
  
#### PROCESS.CLI.COMMAND:  
  
#### PROCESS.DIRECT.CLI.COMMAND:  
  
#### GET.RESPONSE.DATA:  
  
#### PROCESS.RESPONSE.CONTENT:  
  
#### GET.REQUEST.DATA:  
  
#### GET.REQUEST.ID:  
  
#### GET.SEARCH.PROPERTY:  
  
  
