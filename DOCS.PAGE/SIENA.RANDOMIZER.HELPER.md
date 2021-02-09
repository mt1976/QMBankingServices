<img src="../.resources/themes/unicons-line-6563ff/corner-up-left-alt.svg" alt="BACK" width="25" />[BACK](../DOCS/SIENA.BP.md)  
# SIENA.RANDOMIZER.HELPER  
|DATA|VALUE|
| --- | --- |
|TYPE|SUBROUTINE|
|SOURCE|<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="SIENA.BP" width="25" />[SIENA.BP](../DOCS/SIENA.BP.md)|
|ID|SIENA.RANDOMIZER.HELPER|
|PARAMETERS|PROCESS.NAME|
    
## USAGE  
  
## REQUIRES  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="I_UTIL.H" width="25" />[I_UTIL.H](../DOCS.PAGE/I_UTIL.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.LOG.EVENT.H" width="25" />[F_UTIL.LOG.EVENT.H](../DOCS.PAGE/F_UTIL.LOG.EVENT.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_SIENA.TXN.TEMPLATES.H" width="25" />[F_SIENA.TXN.TEMPLATES.H](../DOCS.PAGE/F_SIENA.TXN.TEMPLATES.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_SIENA.TXN.OUT.H" width="25" />[F_SIENA.TXN.OUT.H](../DOCS.PAGE/F_SIENA.TXN.OUT.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_SIENA.CACHE.H" width="25" />[F_SIENA.CACHE.H](../DOCS.PAGE/F_SIENA.CACHE.H.md)  
    
## HEADER INFORMATION  
```javascript
** INFORMATION ****************************************************************
*   Routine Name : SIENA.RANDOMIZER.HELPER
*           Type : SUBROUTINE
*         Params : PROCESS.NAME
*            Loc : SIENA.BP
** AUDIT **********************************************************************
*   Info Updated : 20210209 at 11.19.11 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

```
## BODY  
### EXTERNAL CALLS  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_START" width="25" />[U_START](../DOCS.PAGE/U_START.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.OPENFILE" width="25" />[U_IO.OPENFILE](../DOCS.PAGE/U_IO.OPENFILE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.GET.PROPERTY" width="25" />[U_IO.GET.PROPERTY](../DOCS.PAGE/U_IO.GET.PROPERTY.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_GET.LIST" width="25" />[U_GET.LIST](../DOCS.PAGE/U_GET.LIST.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.RECORD" width="25" />[U_CRT.RECORD](../DOCS.PAGE/U_CRT.RECORD.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_GET.LIST" width="25" />[U_GET.LIST](../DOCS.PAGE/U_GET.LIST.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_GET.UUID" width="25" />[U_GET.UUID](../DOCS.PAGE/U_GET.UUID.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.READ" width="25" />[U_IO.READ](../DOCS.PAGE/U_IO.READ.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_GET.NEXT.WORKING.DAY" width="25" />[U_GET.NEXT.WORKING.DAY](../DOCS.PAGE/U_GET.NEXT.WORKING.DAY.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_RND.BETWEEN" width="25" />[U_RND.BETWEEN](../DOCS.PAGE/U_RND.BETWEEN.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="SIENA.CACHE.FETCH" width="25" />[SIENA.CACHE.FETCH](../DOCS.PAGE/SIENA.CACHE.FETCH.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_GET.UUID" width="25" />[U_GET.UUID](../DOCS.PAGE/U_GET.UUID.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.WRITE" width="25" />[U_IO.WRITE](../DOCS.PAGE/U_IO.WRITE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_STOP" width="25" />[U_STOP](../DOCS.PAGE/U_STOP.md)  
### INTERNAL CALLS  
 INITIALISE    
  
 Open Files    
  
 Setup static    
  
 Get Soft Translation Variables    
  
#### REPLACE.IT:  
  
  
