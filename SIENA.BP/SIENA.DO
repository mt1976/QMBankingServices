SUBROUTINE SIENA.DO(jobName)
** INFORMATION ****************************************************************
*   Routine Name : SIENA.DO
*           Type : SUBROUTINE
*         Params : jobName
*            Loc : SIENA.BP
** AUDIT **********************************************************************
*   Info Updated : 20210209 at 11.19.11 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H

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
