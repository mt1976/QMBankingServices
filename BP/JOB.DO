PROGRAM JOB.DO
** INFORMATION ****************************************************************
*   Routine Name : JOB.DO
*           Type : PROGRAM
*         Params :
*            Loc : BP
** AUDIT **********************************************************************
*   Info Updated : 20210301 at 15.20.48 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE BP I_UTIL.H
   CALL U_INITIALISE("JOB.DO")
   PROCESS.NAME = "JOB.DO"
   CALL U_START(PROCESS.NAME)

   CALL U_HEADER("JOB.DO")

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
