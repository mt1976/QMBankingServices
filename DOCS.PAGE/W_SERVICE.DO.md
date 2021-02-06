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
    
## HEADER INFORMATION  
```javascript
** INFORMATION ****************************************************************
*   Routine Name : W_SERVICE.DO
*           Type : PROGRAM
*         Params :
*            Loc : UTIL.BP
** AUDIT **********************************************************************
*   Info Updated : 20210206 at 14.18.43 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

```
## BODY  
### EXTERNAL CALLS  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.OPENFILE" width="25" />[U_IO.OPENFILE](../DOCS.PAGE/U_IO.OPENFILE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.READ" width="25" />[U_IO.READ](../DOCS.PAGE/U_IO.READ.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_INITIALISE" width="25" />[U_INITIALISE](../DOCS.PAGE/U_INITIALISE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_START" width="25" />[U_START](../DOCS.PAGE/U_START.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_HEADER" width="25" />[U_HEADER](../DOCS.PAGE/U_HEADER.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_STOP" width="25" />[U_STOP](../DOCS.PAGE/U_STOP.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_GET.LIST" width="25" />[U_GET.LIST](../DOCS.PAGE/U_GET.LIST.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.READ" width="25" />[U_IO.READ](../DOCS.PAGE/U_IO.READ.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_XML.SUBSTITUTE" width="25" />[U_XML.SUBSTITUTE](../DOCS.PAGE/U_XML.SUBSTITUTE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.WRITE" width="25" />[U_IO.WRITE](../DOCS.PAGE/U_IO.WRITE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.DELETE" width="25" />[U_IO.DELETE](../DOCS.PAGE/U_IO.DELETE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_OS.EXECUTE" width="25" />[U_OS.EXECUTE](../DOCS.PAGE/U_OS.EXECUTE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_JSON.FIND" width="25" />[U_JSON.FIND](../DOCS.PAGE/U_JSON.FIND.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_XML.FIND" width="25" />[U_XML.FIND](../DOCS.PAGE/U_XML.FIND.md)  
### INTERNAL CALLS  
#### CHECK.QUEUE:  
  
#### PROCESS.QUEUE.ITEM:  
  
#### PROCESS.ACTION:  
  
#### GET.REQUEST.ID:  
  
#### GET.SEARCH.PROPERTY:  
  
  
