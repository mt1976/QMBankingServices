PROGRAM REPORT.DO
** INFORMATION ****************************************************************
*   Routine Name : REPORT.DO
*           Type : PROGRAM
*         Params :
*            Loc : BP
** AUDIT **********************************************************************
*   Info Updated : 20210302 at 21.53.22 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE BP I_UTIL.H

   PROCESS.NAME = SYSTEM(45)
   CALL U_INITIALISE(PROCESS.NAME)
   CALL U_START(PROCESS.NAME)
   * CALL U_HEADER(PROCESS.NAME)

   CMD.STRING = CONVERT(SPACE(1), @AM, @SENTENCE)
   IF CMD.STRING<2> = "" THEN
      CALL U_CRT.INFO("ERROR", "Parameters [A specific type i.e. RVMARKET]")
      CALL U_STOP(PROCESS.NAME)
      STOP
   END
* remove the program name from the stack of cmds
   DEL CMD.STRING<1>
* loop through the cmd strings
   THIS.CMD = 1

   DO.ITEM = CMD.STRING<THIS.CMD>
   * CALL U_CRT.INFO("PROCESS", DO.ITEM)

   CALL U_REPORT.DO.HELPER(DO.ITEM)
   HUSH ON
   CALL U_STOP(PROCESS.NAME)
   HUSH OFF
END
