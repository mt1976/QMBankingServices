<img src="../.resources/themes/unicons-line-6563ff/corner-up-left-alt.svg" alt="BACK" width="25" />[BACK](../DOCS/UTIL.BP.md)  
# U_DOCUMENT.DO.HELPER  
|DATA|VALUE|
| --- | --- |
|TYPE|SUBROUTINE|
|SOURCE|<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="UTIL.BP" width="25" />[UTIL.BP](../DOCS/UTIL.BP.md)|
|ID|U_DOCUMENT.DO.HELPER|
|PARAMETERS|FN.ITEM, ID.ITEM, DO.TYPE, FV.ITEM, DOC.DETAIL|
    
## USAGE  
*  Used to build markdown help files.  
  
## REQUIRES  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="I_UTIL.H" width="25" />[I_UTIL.H](../DOCS.PAGE/I_UTIL.H.md)  
    
## HEADER INFORMATION  
```javascript
** INFORMATION ****************************************************************
*   Routine Name : U_DOCUMENT.DO.HELPER
*           Type : SUBROUTINE
*         Params : FN.ITEM, ID.ITEM, DO.TYPE, FV.ITEM, DOC.DETAIL
*            Loc : UTIL.BP
** AUDIT **********************************************************************
*   Info Updated : 20210226 at 12.15.14 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

```
## BODY  
### EXTERNAL CALLS  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.GET.PROPERTY" width="25" />[U_IO.GET.PROPERTY](../DOCS.PAGE/U_IO.GET.PROPERTY.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_TRANSLATE" width="25" />[U_TRANSLATE](../DOCS.PAGE/U_TRANSLATE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.OPENFILE" width="25" />[U_IO.OPENFILE](../DOCS.PAGE/U_IO.OPENFILE.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_CRT.INFO" width="25" />[U_CRT.INFO](../DOCS.PAGE/U_CRT.INFO.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.READ" width="25" />[U_IO.READ](../DOCS.PAGE/U_IO.READ.md)  
<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="U_IO.WRITE" width="25" />[U_IO.WRITE](../DOCS.PAGE/U_IO.WRITE.md)  
### INTERNAL CALLS  
#### PROCESS.INSERTS:  
  
 Process inserts, if line is prefixed $INSERT or $INCLUDE build output.    
  
#### PROCESS.INSERTS.ADD.MARKDOWN:  
  
 Adds link to header file.    
  
#### PROCESS.HEADER:  
  
#### PROCESS.BODY:  
  
#### PROCESS.BODY.CALLS:  
  
#### PROCESS.USAGE:  
  
  
