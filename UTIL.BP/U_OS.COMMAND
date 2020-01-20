SUBROUTINE U_OS.COMMAND(STMT, VERBOSE)
** INFORMATION ****************************************************************
* Routine Name   : U_OS.COMMAND
*         Type   : SUBROUTINE
*         Params : STMT, VERBOSE
*         Loc    : UTIL.BP
* -----------------------------------------------------------------------------
* Info Updated   : 20200120 at 16.53.17 in MWT-QM-DEV by sales
*                : on ldn-srv-ubnt01 (Linux)
* -----------------------------------------------------------------------------
*
$INCLUDE UTIL.BP I_UTIL.H
$INCLUDE UTIL.BP F_UTIL.LOG.EVENT.H

   IF VERBOSE THEN
      CALL U_CRT.INFO("OS.COMMAND", STMT)
   END ELSE
      HUSH ON
   END
   IF VERBOSE THEN
    OS.EXECUTE STMT CAPTURING OUTPUT
   END ELSE
    OS.EXECUTE STMT
   END
   IF VERBOSE THEN

      CALL U_CRT.INFO("OUTPUT","")
      CALL U_CRT.RECORD(OUTPUT)
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
