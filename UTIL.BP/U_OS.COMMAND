SUBROUTINE U_OS.COMMAND(STMT, VERBOSE, OUTPUT, SUPPRESS.LOG.EVENT)
** INFORMATION ****************************************************************
* Routine Name   : U_OS.COMMAND
*         Type   : SUBROUTINE
*         Params : STMT, VERBOSE, OUTPUT, SUPPRESS.LOG.EVENT
*         Loc    : UTIL.BP
** AUDIT **********************************************************************
* Info Updated   : 20200821 at 12.55.08 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H
$INCLUDE UTIL.BP F_UTIL.LOG.EVENT.H



   IF VERBOSE THEN
      CALL U_CRT.INFO("OS.COMMAND", STMT)
   END ELSE
      *    HUSH ON
   END

   OS.EXECUTE STMT CAPTURING OUTPUT



   IF VERBOSE THEN
      CALL U_CRT.INFO("OUTPUT", "")
      CALL U_CRT.RECORD(OUTPUT)
   END ELSE
      *  HUSH OFF
   END

   * CRT "STATEMENT ":STMT
   * CRT "OUTPUT ":OUTPUT

   R.EVENT = ""
   R.EVENT<U_LOG_EVENT> = "OS.COMMAND"
   R.EVENT<U_LOG_CMD> = STMT
   R.EVENT<U_LOG_MSG> = STMT
   R.EVENT<U_LOG_RETCD> = @SYSTEM.RETURN.CODE
   R.EVENT<U_LOG_SUBR> = "U_OS.COMMAND"
   IF SUPPRESS.LOG.EVENT THEN
   END ELSE
      CALL U_LOG.EVENT(STMT, R.EVENT)
   END
   RETURN
END
