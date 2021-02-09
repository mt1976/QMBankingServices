<img src="../.resources/themes/unicons-line-6563ff/corner-up-left-alt.svg" alt="BACK" width="25" />[BACK](../DOCS/SIENA.BP.md)  
# SIENA.GILTS.HELPER  
|DATA|VALUE|
| --- | --- |
|TYPE|SUBROUTINE|
|SOURCE|<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="SIENA.BP" width="25" />[SIENA.BP](../DOCS/SIENA.BP.md)|
|ID|SIENA.GILTS.HELPER|
|PARAMETERS|PROCESS.NAME|
    
## USAGE  
  
## REQUIRES  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="I_UTIL.H" width="25" />[I_UTIL.H](../DOCS.PAGE/I_UTIL.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="I_UKTREASURY.H" width="25" />[I_UKTREASURY.H](../DOCS.PAGE/I_UKTREASURY.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.TRANSLATE.H" width="25" />[F_UTIL.TRANSLATE.H](../DOCS.PAGE/F_UTIL.TRANSLATE.H.md)  
    
## HEADER INFORMATION  
```javascript
** INFORMATION ****************************************************************
*   Routine Name : SIENA.GILTS.HELPER
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
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.OPENFILEPATH" width="25" />[U_IO.OPENFILEPATH](../DOCS.PAGE/U_IO.OPENFILEPATH.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_HEADER" width="25" />[U_HEADER](../DOCS.PAGE/U_HEADER.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.GET.PROPERTY" width="25" />[U_IO.GET.PROPERTY](../DOCS.PAGE/U_IO.GET.PROPERTY.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_OS.CURL" width="25" />[U_OS.CURL](../DOCS.PAGE/U_OS.CURL.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="SIENA.XML.HEADER" width="25" />[SIENA.XML.HEADER](../DOCS.PAGE/SIENA.XML.HEADER.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="SIENA.XML.FOOTER" width="25" />[SIENA.XML.FOOTER](../DOCS.PAGE/SIENA.XML.FOOTER.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.WRITE" width="25" />[U_IO.WRITE](../DOCS.PAGE/U_IO.WRITE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_STOP" width="25" />[U_STOP](../DOCS.PAGE/U_STOP.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_TRANSLATE" width="25" />[U_TRANSLATE](../DOCS.PAGE/U_TRANSLATE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="SIENA.NI.NAME" width="25" />[SIENA.NI.NAME](../DOCS.PAGE/SIENA.NI.NAME.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_BUILD.XML.FIELD" width="25" />[U_BUILD.XML.FIELD](../DOCS.PAGE/U_BUILD.XML.FIELD.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_OS.CURL" width="25" />[U_OS.CURL](../DOCS.PAGE/U_OS.CURL.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="SIENA.CACHE.CLEAR" width="25" />[SIENA.CACHE.CLEAR](../DOCS.PAGE/SIENA.CACHE.CLEAR.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="SIENA.CACHE.UPDATE" width="25" />[SIENA.CACHE.UPDATE](../DOCS.PAGE/SIENA.CACHE.UPDATE.md)  
### INTERNAL CALLS  
#### DO.PROCESS.ROW:  
  
#### DO.CONTRACT.DEFINITION:  
  
#### DO.PRICE.INFO:  
  
  
