PROGRAM UPDATE_USER.PHP
* save the data into WEBUSERS
*$Copyright (c) 2010 TO 2012 to 2008 mike.ryder@pwchest.com, All Rights Reserved
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.

$MODE UV.LOCATE
$CATALOG
$INCLUDE I_WEBCOMMON
$INCLUDE I_SCHEMA


* main *
     GOSUB PROCESS
     GOSUB FINALISE
     STOP
*************************
* end of main *
***************
* subroutines *
***************
PROCESS:
     APPLICATION = 'WEBUSERS'
     CALL LOADAPP
     IF FATAL$ERROR THEN RETURN

     I.APPLICATION = HTTPEXTRACT("id")
     READU R.RECORD FROM F.APPLICATION,I.APPLICATION ELSE
          FATAL$ERROR = WEBERROR("Record ":I.APPLICATION:" is missing from ":APPLICATION)
          RETURN
     END
     IF HTTPDATADO() THEN RETURN

     WRITE R.APPLICATION ON F.APPLICATION,I.APPLICATION ON ERROR FATAL$ERROR = WEBERROR('Write failure :':STATUS())

RETURN
******
FINALISE:
     PRINT "Content-Type: text/html"
     PRINT
     IF FATAL$ERROR THEN
          PRINT '{"msg":':DQUOTE(ERROR$VALUE<1>):'}'
     END ELSE
          PRINT '{"success":true}'
     END

RETURN
******
END
