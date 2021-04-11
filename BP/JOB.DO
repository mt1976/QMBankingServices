PROGRAM JOB.DO
** INFORMATION ****************************************************************
*   Routine Name : JOB.DO
*           Type : PROGRAM
*         Params : 
*            Loc : BP
** AUDIT **********************************************************************
*   Info Updated : 20210411 at 16.25.52 in MWT-QM-DEV by matttownsend
*                : on silicon.local (Mac)
*******************************************************************************

$INCLUDE BP I_UTIL.H
   PROCESS.NAME = SYSTEM(45)
   CALL U_INITIALISE(PROCESS.NAME)

   CALL U_START(PROCESS.NAME)

   CALL U_HEADER(PROCESS.NAME)

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
