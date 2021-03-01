SUBROUTINE SIENA.DO(jobName)
** INFORMATION ****************************************************************
*   Routine Name : SIENA.DO
*           Type : SUBROUTINE
*         Params : jobName
*            Loc : BP
** AUDIT **********************************************************************
*   Info Updated : 20210301 at 15.20.48 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE BP I_UTIL.H

   IF jobName<>"" THEN
      processName = "SIENA.":jobName
      processHelper = processName:".HELPER"

      CALL U_INITIALISE(processName)
      CALL U_START(processName)
      CALL U_HEADER(processName)
      CALL @processHelper(jobName)
      CALL U_STOP(processName)

   END
   RETURN
