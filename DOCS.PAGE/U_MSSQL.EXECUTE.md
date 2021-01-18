<img src="../.resources/themes/unicons-line-6563ff/corner-up-left-alt.svg" alt="BACK" width="25" />[BACK](../DOCS/UTIL.BP.md)  
# U_MSSQL.EXECUTE  
|DATA|VALUE|
| --- | --- |
|TYPE|SUBROUTINE|
|SOURCE|<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="UTIL.BP" width="25" />[UTIL.BP](../DOCS/UTIL.BP.md)|
|ID|U_MSSQL.EXECUTE|
|PARAMETERS|SQL.STATEMENT, SQL.ADDRESS, SQL.DATABASE, VERBOSE, ID_UTIL.SQL.RESPONSE|
    
## USAGE  
  
## REQUIRES  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="I_UTIL.H" width="25" />[I_UTIL.H](../DOCS.PAGE/I_UTIL.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.LOG.EVENT.H" width="25" />[F_UTIL.LOG.EVENT.H](../DOCS.PAGE/F_UTIL.LOG.EVENT.H.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="F_UTIL.SQL.CMD.H" width="25" />[F_UTIL.SQL.CMD.H](../DOCS.PAGE/F_UTIL.SQL.CMD.H.md)  
    
## HEADER INFORMATION  
```javascript
** INFORMATION ****************************************************************
*   Routine Name : U_MSSQL.EXECUTE
*           Type : SUBROUTINE
*         Params : SQL.STATEMENT, SQL.ADDRESS, SQL.DATABASE, VERBOSE, ID_UTIL.SQL.RESPONSE
*            Loc : UTIL.BP
** AUDIT **********************************************************************
*   Info Updated : 20200922 at 16.34.08 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

```
## BODY  
### EXTERNAL CALLS  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.OPENFILE" width="25" />[U_IO.OPENFILE](../DOCS.PAGE/U_IO.OPENFILE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_OS.FILE.PATH" width="25" />[U_OS.FILE.PATH](../DOCS.PAGE/U_OS.FILE.PATH.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.OPENFILE" width="25" />[U_IO.OPENFILE](../DOCS.PAGE/U_IO.OPENFILE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_OS.FILE.PATH" width="25" />[U_OS.FILE.PATH](../DOCS.PAGE/U_OS.FILE.PATH.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.GET.PROPERTY" width="25" />[U_IO.GET.PROPERTY](../DOCS.PAGE/U_IO.GET.PROPERTY.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_GET.UUID" width="25" />[U_GET.UUID](../DOCS.PAGE/U_GET.UUID.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.WRITE" width="25" />[U_IO.WRITE](../DOCS.PAGE/U_IO.WRITE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_LOG.EVENT" width="25" />[U_LOG.EVENT](../DOCS.PAGE/U_LOG.EVENT.md)  
### INTERNAL CALLS  
  
