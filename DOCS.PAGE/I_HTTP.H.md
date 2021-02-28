<img src="../.resources/themes/unicons-line-6563ff/corner-up-left-alt.svg" alt="BACK" width="25" />[BACK](../DOCS/BP.md)  
# I_HTTP.H  
|DATA|VALUE|
| --- | --- |
|TYPE|INSERT|
|SOURCE|<img src="../.resources/themes/unicons-line-6563ff/link.svg" alt="BP" width="25" />[BP](../DOCS/BP.md)|
|ID|I_HTTP.H|
    
    
## HEADER INFORMATION  
```javascript
** INFORMATION ****************************************************************
*    Insert Name : I_HTTP.H - BP
*           Type : INSERT
*       Filename : n/a
*         Prefix : n/a
** AUDIT **********************************************************************
*   Info Created : 20210228 at 11.52.00 in DEV by MANUALLY
*                : MANUALLY CREATED
*******************************************************************************
```
## BODY  
```javascript
*******************************************************************************
** HTTP Response Codes
equate RC$CONTINUE                              to 100
equate RC$SWITCHING.PROTOCOLS                   to 101
equate RC$PROCESSING                            to 102
equate RC$EARLY.HINTS                           to 103
equate RC$OK                                    to 200
equate RC$CREATED                               to 201
equate RC$ACCEPTED                              to 202
equate RC$NON.AUTHORITATIVE.INFORMATION         to 203
equate RC$NO.CONTENT                            to 204
equate RC$RESET.CONTENT                         to 205
equate RC$PARTIAL.CONTENT                       to 206
equate RC$MULTI.STATUS                          to 207
equate RC$ALREADY.REPORTED                      to 208
equate RC$IM.USED                               to 226
equate RC$MULTIPLE.CHOICES                      to 300
equate RC$MOVED.PERMANENTLY                     to 301
equate RC$FOUND                                 to 302
equate RC$SEE.OTHER                             to 303
equate RC$NOT.MODIFIED                          to 304
equate RC$USE.PROXY                             to 305
equate RC$TEMPORARY.REDIRECT                    to 307
equate RC$PERMANENT.REDIRECT                    to 308
equate RC$BAD.REQUEST                           to 400
equate RC$UNAUTHORIZED                          to 401
equate RC$PAYMENT.REQUIRED                      to 402
equate RC$FORBIDDEN                             to 403
equate RC$NOT.FOUND                             to 404
equate RC$METHOD.NOT.ALLOWED                    to 405
equate RC$NOT.ACCEPTABLE                        to 406
equate RC$PROXY.AUTHENTICATION.REQUIRED         to 407
equate RC$REQUEST.TIMEOUT                       to 408
equate RC$CONFLICT                              to 409
equate RC$GONE                                  to 410
equate RC$LENGTH.REQUIRED                       to 411
equate RC$PRECONDITION.FAILED                   to 412
equate RC$PAYLOAD.TOO.LARGE                     to 413
equate RC$URI.TOO.LONG                          to 414
equate RC$UNSUPPORTED.MEDIA.TYPE                to 415
equate RC$RANGE.NOT.SATISFIABLE                 to 416
equate RC$EXPECTATION.FAILED                    to 417
equate RC$MISDIRECTED.REQUEST                   to 421
equate RC$UNPROCESSABLE.ENTITY                  to 422
equate RC$LOCKED                                to 423
equate RC$FAILED.DEPENDENCY                     to 424
equate RC$TOO.EARLY                             to 425
equate RC$UPGRADE.REQUIRED                      to 426
equate RC$PRECONDITION.REQUIRED                 to 428
equate RC$TOO.MANY.REQUESTS                     to 429
equate RC$REQUEST.HEADER.FIELDS.TOO.LARGE       to 431
equate RC$UNAVAILABLE.FOR.LEGAL.REASONS         to 451
equate RC$INTERNAL.SERVER.ERROR                 to 500
equate RC$NOT.IMPLEMENTED                       to 501
equate RC$BAD.GATEWAY                           to 502
equate RC$SERVICE.UNAVAILABLE                   to 503
equate RC$GATEWAY.TIMEOUT                       to 504
equate RC$HTTP.VERSION.NOT.SUPPORTED            to 505
equate RC$VARIANT.ALSO.NEGOTIATES               to 506
equate RC$INSUFFICIENT.STORAGE                  to 507
equate RC$LOOP.DETECTED                         to 508
equate RC$NOT.EXTENDED                          to 510
equate RC$NETWORK.AUTHENTICATION.REQUIRED       to 511
** 512 Onward Manually Added
equate RC$SECURITY.VIOLATION                    to 512
equate RC$NO.DATA                               to 513
** UTIL.TRANSLATE lookup prefix
equate RC$LOOKUP to "http"
```
