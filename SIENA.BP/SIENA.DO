PROGRAM SIENA.DELIVER
** INFORMATION ****************************************************************
* Routine Name   : SIENA.DO
*         Type   : PROGRAM
*         Loc    : SIENA.BP
* -----------------------------------------------------------------------------
* Info Updated   : 20191217 at 11.08.31 in MWT-QM-DEV by sales
*                : on ldn-srv-ubnt01 (Linux)
* -----------------------------------------------------------------------------
*
*******************************************************************************
$INCLUDE UTIL.BP I_UTIL.H

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
   DO.DELIVER = ""

   CALL U_OS.GET.PROPERTY("SIENA.CONFIG", "siena", DO.ITEM, DO.DATA)

   DO.DATA = CONVERT(U_SEP, @AM, DO.DATA)

   DO.SCRIPT = DO.DATA<1>
   DO.PROCESSOR = DO.DATA<2>
   DO.DELIVER = DO.DATA<3>

   IF DO.SCRIPT <> "" THEN
      CALL U_CRT.INFO("DO SCRIPT", DO.SCRIPT)
      CALL SIENA.SCRIPT.HELPER(DO.SCRIPT)
      CALL U_CRT.INFO("DO DONE", DO.SCRIPT)
   END
   IF DO.PROCESSOR <> "" THEN
      SUB.NAME = "SIENA.":DO.PROCESSOR:".HELPER"
      DO.SUBN = SUB.NAME
      CALL U_CRT.INFO("DO SUB", DO.SUBN)
      CALL @SUB.NAME(SUB.NAME)
      CALL U_CRT.INFO("DO DONE", DO.SUBN)
   END
   IF DO.DELIVER <> "" THEN
      CALL U_CRT.INFO("DO DELIVER", DO.DELIVER)
      CALL SIENA.DELIVER.HELPER(SUB.NAME, DO.DELIVER)
      CALL U_CRT.INFO("DO DONE", DO.DELIVER)
   END

   CALL U_STOP(PROCESS.NAME)

END
