PROGRAM GET_USERS.PHP
* get json data for CRUD
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

     APPLICATION = "WEBUSERS"
     CALL LOADAPP
     CALL JSON.FORMAT
     PRINT "Content-Type: text/html"
     PRINT
     IF FATAL$ERROR THEN
          PRINT = '{"msg":':DQUOTE(ERROR$VALUE<1>):'}'
          CALL WEB4LOG(ERROR$VALUE<1>)
     END ELSE
          PRINT COMI
     END
     FATAL$ERROR = WEBERROR('CLEAR')
END
