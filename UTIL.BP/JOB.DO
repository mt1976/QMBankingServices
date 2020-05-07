PROGRAM JOB.DO
** INFORMATION ****************************************************************
* Routine Name   : JOB.DO
*         Type   : PROGRAM
*         Params :
*         Loc    : UTIL.BP
** AUDIT **********************************************************************
* Info Updated   : 20200507 at 08.01.44 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H
   CALL U_INITIALISE("JOB.DO")
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

   CALL U_IO.GET.PROPERTY("siena", DO.ITEM, DO.DATA)

   DO.DATA = CONVERT(U_PROP_SEP_ALT, @AM, DO.DATA)

   DO.SCRIPT = DO.DATA<1>
   DO.PROCESSOR = DO.DATA<2>
   DO.POSTPROCESS = DO.DATA<3>
   DO.DELIVER = DO.DATA<4>

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
   IF DO.POSTPROCESS <> "" THEN
      PP.SUB.NAME = "SIENA.":DO.PROCESSOR:".POST"
      DO.SUBN = SUB.NAME
      CALL U_CRT.INFO("DO POST", DO.SUBN)
      CALL @PP.SUB.NAME(PP.SUB.NAME)
      CALL U_CRT.INFO("DO DONE", DO.SUBN)
   END
   IF DO.DELIVER <> "" THEN
      CALL U_CRT.INFO("DO DELIVER", DO.DELIVER)
      CALL SIENA.DELIVER.HELPER(SUB.NAME, DO.DELIVER)
      CALL U_CRT.INFO("DO DONE", DO.DELIVER)
   END

   CALL U_STOP(PROCESS.NAME)

END
