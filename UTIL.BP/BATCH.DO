PROGRAM BATCH.DO
** INFORMATION ****************************************************************
* Routine Name   : BATCH.DO
*         Type   : PROGRAM
*         Params :
*         Loc    : UTIL.BP
** AUDIT **********************************************************************
* Info Updated   : 20200823 at 12.02.47 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H
   CALL U_INITIALISE("BATCH.DO")
   PROCESS.NAME = "BATCH.DO"
   CALL U_START(PROCESS.NAME)

   CALL U_HEADER("BATCH.DO")

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
   CALL U_INFO("BATCH-START", DO.BATCH)
   DO.SCRIPT = ""
   DO.PROCESSOR = ""
   DO.POSTPROCESS = ""
   DO.DELIVER = ""

   * CALL U_IO.GET.PROPERTY("jobs", DO.BATCH, DO.DATA)
   DO.DATA = ""
   NO.ITEMS = 0

   CALL U_IO.GET.LIST("jobs", DO.BATCH, DO.DATA, NO.ITEMS)


   CALL U_CRT.INFO("ITEMS", NO.ITEMS)
   CALL U_CRT.RECORD(DO.DATA)

   FOR THIS.JOB = 1 TO NO.ITEMS

      CALL U_CRT.INFO("EXEC", DO.DATA<THIS.JOB>)
      CALL U_HEADER(DO.DATA<THIS.JOB>)
      CALL U_INFO("JOB-START", DO.DATA<THIS.JOB>)
      CALL U_JOB.DO.HELPER(DO.DATA<THIS.JOB>)
      CALL U_INFO("JOB-END", DO.DATA<THIS.JOB>)
      CALL U_CRT.INFO("DONE", DO.DATA<THIS.JOB>)

   NEXT THIS.JOB

   CALL U_INFO("BATCH-END", DO.BATCH)

   CALL U_STOP(PROCESS.NAME)

END
