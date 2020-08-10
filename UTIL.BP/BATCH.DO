PROGRAM U_BATCH.DO
** INFORMATION ****************************************************************
* Routine Name   : U_BATCH.DO
*         Type   : PROGRAM
*         Params :
*         Loc    : UTIL.BP
** AUDIT **********************************************************************
* Info Updated   : 20200810 at 16.04.03 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H
   CALL U_INITIALISE("U_BATCH.DO")
   PROCESS.NAME = ""
   CALL U_START(PROCESS.NAME)

   CALL U_HEADER("U_BATCH.DO")

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

   DO.BATCH = CMD.STRING<THIS.CMD>
   CALL U_CRT.INFO("BATCH", DO.BATCH)

   DO.SCRIPT = ""
   DO.PROCESSOR = ""
   DO.POSTPROCESS = ""
   DO.DELIVER = ""

   * CALL U_IO.GET.PROPERTY("jobs", DO.BATCH, DO.DATA)
   DO.DATA = ""
   NO.ITEMS = 0

   CALL U_IO.GET.LIST("jobs", DO.BATCH, DO.DATA, NO.ITEMS)

   * CALL U_CRT.INFO("DATA", DO.DATA)
   CALL U_CRT.INFO("ITEMS", NO.ITEMS)

   FOR THIS.JOB = 1 TO NO.ITEMS

      CALL U_CRT.INFO("EXEC", DO.DATA<THIS.JOB>)
      CALL U_JOB.DO.HELPER(DO.DATA<THIS.JOB>)
      CALL U_CRT.INFO("DONE", DO.DATA<THIS.JOB>)


   NEXT THIS.JOB


   CALL U_STOP(PROCESS.NAME)

END
