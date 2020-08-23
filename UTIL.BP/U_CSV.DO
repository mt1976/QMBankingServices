PROGRAM U_CSV.DO
** INFORMATION ****************************************************************
* Routine Name   : U_CSV.DO
*         Type   : PROGRAM
*         Params :
*         Loc    : UTIL.BP
** AUDIT **********************************************************************
* Info Updated   : 20200823 at 12.09.37 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H
   CALL U_INITIALISE("U_CSV.DO")
   PNM = "U_CSV.DO" ; STOP.ON.ERROR = @TRUE ; ERROR.TEXT = ""
   CALL U_START(PNM)
   CALL U_HEADER("(RE)BUILD FILE(S)")

   FN.UTIL.CSV.IN = "UTIL.CSV.IN" ; FV.UTIL.CSV.IN = ""
   CALL U_IO.OPENFILE(FN.UTIL.CSV.IN, FV.UTIL.CSV.IN, STOP.ON.ERROR, ERROR.TEXT)

   CMD.STRING = CONVERT(SPACE(1), @AM, @SENTENCE)
   IF CMD.STRING<2> = "" THEN
      CALL U_CRT.INFO("ERROR", "Parameters [ALL, or specific i.e. UTIL/SIENA]")
      CALL U_STOP(PNM)
      STOP
   END

   * remove the program name from the stack of cmds
   DEL CMD.STRING<1>
   * loop through the cmd strings
   NO.CMDS = DCOUNT(CMD.STRING, @AM)

*   CALL U_CRT.INFO("NO PROCESSES", NO.CMDS)
   FOR THIS.CMD = 1 TO NO.CMDS
      CSV.FILENAME = CMD.STRING<THIS.CMD>
*      CALL U_CRT.INFO("PROCESS", CSV.FILENAME)
      STMT = "SELECT ":FN.UTIL.CSV.IN:" LIKE ":DOWNCASE(CSV.FILENAME):".csv"
      IF CSV.FILENAME = "ALL" THEN
         STMT = "SELECT ":FN.UTIL.CSV.IN:" LIKE ...csv"
      END
      GOSUB PROCESS.IT
   NEXT THIS.CMD

   CALL U_STOP(PNM)

   STOP "DONE"

PROCESS.IT:
*CALL U_CRT.INFO('STMT',STMT)

   CALL U_OS.EXECUTE(STMT, @TRUE)

   PROCESS.LIST = ""
   LOOP
      READNEXT ID_CSV.FILE ELSE EXIT
      PROCESS.LIST<-1> = ID_CSV.FILE
      CALL U_CRT.INFO("PROCESS", ID_CSV.FILE)
      CALL U_CSV.DO.HELPER(ID_CSV.FILE)
   REPEAT

   RETURN
END
