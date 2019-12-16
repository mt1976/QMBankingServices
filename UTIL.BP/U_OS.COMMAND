SUBROUTINE U_OS.COMMAND(STMT, VERBOSE)
** INFORMATION ****************************************************************
* Routine Name   : U_OS.COMMAND
*         Type   : SUBROUTINE
*         Loc    : UTIL.BP
* ------------------------
* Info Updated   : 20191216 at 14.54.41 in MWT-QM-DEV by sales
                 : on ldn-srv-ubnt01 (Linux)
*******************************************************************************
$COPYRIGHT = "Copyright (C) 2019 Matt Townsend mt76@gmx.com"
*******************************************************************************
$INCLUDE UTIL.BP UTIL.H
$INCLUDE UTIL.BP I_UTIL.CMD.EVENT.H

   IF VERBOSE THEN
      CALL U_CRT.ACTION("OS.COMMAND", STMT)
   END ELSE
      HUSH ON
   END

   OS.EXECUTE STMT

   IF VERBOSE THEN

      * CALL U_CRT.ACTION("OUTPUT","")
      * CALL U_CRT.RECORD(OUTPUT)
   END ELSE
      HUSH OFF
   END

   R.EVENT = ""
   R.EVENT<U_LOG_EVENT> = "OS.COMMAND"
   R.EVENT<U_LOG_CMD> = STMT
   R.EVENT<U_LOG_RETCD> = @SYSTEM.RETURN.CODE
   R.EVENT<U_LOG_SUBR> = "U_OS.COMMAND"

   CALL U_LOG.CMD(STMT, R.EVENT)

   RETURN
END
