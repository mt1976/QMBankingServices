PROGRAM W_SERVICE.DO
** INFORMATION ****************************************************************
*   Routine Name : W_SERVICE.DO
*           Type : PROGRAM
*         Params :
*            Loc : UTIL.BP
** AUDIT **********************************************************************
*   Info Updated : 20210206 at 11.02.30 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H
$INCLUDE UTIL.BP F_UTIL.WCT.RECV.H
$INCLUDE UTIL.BP F_UTIL.WCT.RESP.H
$INCLUDE UTIL.BP F_UTIL.WCT.TEMPLATES.H

   PROCESS.NAME = "W_SERVICE.DO"

   STOP.ON.ERROR = @TRUE ; FV.RECEIVE="" ; FV.RESPONSE="" ; FV.TEMPLATES = ""

   CALL U_IO.OPENFILE(W$RECV.FILE.NAME, FV.RECEIVE, STOP.ON.ERROR, "")
   CALL U_IO.OPENFILE(W$RESP.FILE.NAME, FV.RESPONSE, STOP.ON.ERROR, "")
   CALL U_IO.OPENFILE(W$TEMPLATE.FILE.NAME, FV.TEMPLATES, STOP.ON.ERROR, "")

   responseType = "" ; CALL U_IO.GET.PROPERTY("connect", "responseType", responseType)


   responseTemplate = "" ; responseTemplateID = "response.":responseType
   CALL U_IO.READ(FV.TEMPLATES, responseTemplateID, responseTemplate, STOP.ON.ERROR, "")


   waitTime = 0 ; CALL U_IO.GET.PROPERTY("connect", "waitTime", waitTime)
   shutdownChar = 0 ; CALL U_IO.GET.PROPERTY("connect", "shutdownChar", shutdownChar)

   CALL U_INITIALISE(PROCESS.NAME)
   CALL U_START(PROCESS.NAME)
   CALL U_HEADER(PROCESS.NAME)

   CALL U_CRT.INFO("shutdownChar", shutdownChar:",":upcase(shutdownChar))

   breakLoop = @FALSE ; chkVar = ""
   LOOP
   UNTIL breakLoop

      GOSUB CHECK.QUEUE


      INPUT chkVar, 1:_ TIMEOUT waitTime
      IF chkVar = shutdownChar or chkVar = upcase(shutdownChar) THEN
         breakLoop=@TRUE
      END
   REPEAT
   CALL U_STOP(PROCESS.NAME)
   STOP


CHECK.QUEUE:
   STMT = "SELECT ":W$RECV.FILE.NAME:" WITH @ID UNLIKE ":DQUOTE(".keep")
   requestList = "" ; noRequests = 0
   CALL U_GET.LIST(STMT, requestList, noRequests)
   CALL U_CRT.INFO("REQUESTS", noRequests)
   IF noRequests>0 THEN
      FOR requestListItem = 1 TO noRequests
         requestID=requestList<requestListItem>
         GOSUB PROCESS.QUEUE.ITEM
      NEXT requestListItem
   END
   RETURN

PROCESS.QUEUE.ITEM:
   CALL U_CRT.INFO("REQUEST", requestID)
   responseID = "" ; CALL U_GET.UUID(responseID)
   CALL U_CRT.INFO("RESPONSE", responseID)
   request = "" ; response = ""
   CALL U_IO.READ(FV.RECEIVE, requestID, request, STOP.ON.ERROR, "")
   response = responseTemplate

   CALL U_XML.SUBSTITUTE("requestID", requestID, response)
   CALL U_XML.SUBSTITUTE("responseID", responseID, response)
   CALL U_XML.SUBSTITUTE("requestPayload", request, response)


   CALL U_IO.WRITE(FV.RESPONSE, responseID, response, STOP.ON.ERROR, ERROR.TEXT)
   CALL U_IO.DELETE(FV.RECEIVE, requestID, STOP.ON.ERROR, ERROR.TEXT)

   RETURN

END
