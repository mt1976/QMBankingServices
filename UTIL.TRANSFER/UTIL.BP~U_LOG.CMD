SUBROUTINE U_LOG.CMD(LOG.DATA, R.CMD.EVENT)
** INFORMATION ****************************************************************
* Routine Name   : U_LOG.CMD
*         Type   : SUBROUTINE
*         Loc    : UTIL.BP
* -----------------------------------------------------------------------------
* Info Updated   : 20191218 at 15.43.50 in MWT-QM-DEV by sales
*                : on ldn-srv-ubnt01 (Linux)
* -----------------------------------------------------------------------------
*
*******************************************************************************
$INCLUDE UTIL.BP I_UTIL.H
$INCLUDE UTIL.BP I_UTIL.LOG.EVENT.H

   FN.UTIL.LOG.CMD = "UTIL.LOG.CMD" ; FV.UTIL.LOG.CMD = "" ; STOP.ON.ERROR = @TRUE ; ERROR.TEXT = ""
   CALL U_OPENFILE(FN.UTIL.LOG.CMD, FV.UTIL.LOG.CMD, STOP.ON.ERROR, ERROR.TEXT)
   FN.UTIL.LOG.EVENT = "UTIL.LOG.EVENT" ; FV.UTIL.LOG.EVENT = "" ; STOP.ON.ERROR = @TRUE ; ERROR.TEXT = ""
   CALL U_OPENFILE(FN.UTIL.LOG.EVENT, FV.UTIL.LOG.EVENT, STOP.ON.ERROR, ERROR.TEXT)

   ID.UTIL.LOG.CMD = ""
   CALL U_UNIQUE.ID(ID.UTIL.LOG.CMD)

   CALL U_WRITE(FV.UTIL.LOG.CMD, ID.UTIL.LOG.CMD, LOG.DATA, STOP.ON.ERROR, ERROR.TEXT)

   IF R.CMD.EVENT<U_LOG_EVENT> = "" THEN R.CMD.EVENT<U_LOG_EVENT> = "UNKOWN"
   R.CMD.EVENT<U_LOG_DATE> = OCONV(DATE(), "DX")
   R.CMD.EVENT<U_LOG_TIME> = OCONV(TIME(), "MTS.")
   R.CMD.EVENT<U_LOG_USER> = @USER
   R.CMD.EVENT<U_LOG_ID> = ID.UTIL.LOG.CMD
   R.CMD.EVENT<U_LOG_TTY> = @TTY
   R.CMD.EVENT<U_LOG_USERNO> = @USERNO
   R.CMD.EVENT<U_LOG_PATH> = @PATH
   R.CMD.EVENT<U_LOG_WHO> = @WHO
   R.CMD.EVENT<U_LOG_SENTENCE> = @SENTENCE
   R.CMD.EVENT<U_LOG_IP> = @IP.ADDR
   R.CMD.EVENT<U_LOG_HOST> = SYSTEM(1015)
   R.CMD.EVENT<U_LOG_PLATFORM> = SYSTEM(1010)

   CALL U_WRITE(FV.UTIL.LOG.EVENT, ID.UTIL.LOG.CMD, R.CMD.EVENT, STOP.ON.ERROR, ERROR.TEXT)

   RETURN
END
