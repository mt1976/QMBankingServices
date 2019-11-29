PROGRAM REMOVE_USER.PHP
* remove a user from webpages
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
     GOSUB INITIALISE
     GOSUB PROCESS
     GOSUB FINALISE
     STOP
*************************
* end of main *
***************
* subroutines *
***************
INITIALISE:

     APPLICATION = 'WEBUSERS'
     CALL LOADAPP

RETURN
******
PROCESS:
     IF FATAL$ERROR THEN RETURN
     I.RECORD = HTTPEXTRACT("id")
     IF NOT(I.RECORD) THEN
          FATAL$ERROR = WEBERROR("No record key provided")
          RETURN
     END

     READU R.RECORD FROM F.APPLICATION,I.RECORD THEN
          DELETE F.APPLICATION,I.RECORD
     END ELSE
          FATAL$ERROR = WEBERROR("Record for ":I.RECORD:" not in table")
     END

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
