PROGRAM SIENA.DO
** INFORMATION ****************************************************************
* Routine Name   : SIENA.DO
*         Type   : PROGRAM
*         Params :
*         Loc    : SIENA.BP
** AUDIT **********************************************************************
* Info Updated   : 20200810 at 16.07.52 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H
   CALL U_INITIALISE("SIENA.DO")
   PROCESS.NAME = ""
   CALL U_START(PROCESS.NAME)

   CALL U_HEADER("SIENA.DO")

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
   CALL U_CRT.INFO("PROCESS", DO.ITEM)

   DO.SCRIPT = ""
   DO.PROCESSOR = ""
   DO.POSTPROCESS = ""
   DO.DELIVER = ""

   CALL U_JOB.DO.HELPER(DO.ITEM)

   CALL U_STOP(PROCESS.NAME)

END
