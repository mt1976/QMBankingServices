PROGRAM W_SERVICE.DO
** INFORMATION ****************************************************************
*   Routine Name : W_SERVICE.DO
*           Type : PROGRAM
*         Params :
*            Loc : UTIL.BP
** AUDIT **********************************************************************
*   Info Updated : 20210206 at 14.18.43 in DEV by root
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

   requestFilePath = "" ; CALL U_OS.FILE.PATH(FV.RECEIVE, requestFilePath)
   responseFilePath = "" ; CALL U_OS.FILE.PATH(FV.RESPONSE, responseFilePath)

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
* for debugging
      breakLoop=@TRUE

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
         requestFileName=requestList<requestListItem>
         GOSUB PROCESS.QUEUE.ITEM
      NEXT requestListItem
   END
   RETURN

PROCESS.QUEUE.ITEM:
   OK.TO.CONTINUE = @TRUE
   CALL U_CRT.INFO("REQUEST", requestFileName)
   responseID = "" ; CALL U_GET.UUID(responseID) ; responseFileName=responseID:".":responseType
   CALL U_CRT.INFO("RESPONSE", responseID)
   request = "" ; response = ""

   requestConsumed = "" ; CALL U_GET.EPOCH.DATE(requestConsumed)
   CALL U_IO.READ(FV.RECEIVE, requestFileName, request, STOP.ON.ERROR, "")
   response = responseTemplate

   requestFileType = "" ; requestFileType = CHANGE(requestFileName[4], ".", "")


   IF requestFileType <> "xml" AND requestFileType <> "json" THEN
      CALL U_CRT.INFO("ERROR", requestFileType:" cannot be procsessed skipping")
   END

   IF OK.TO.CONTINUE THEN
      GOSUB GET.REQUEST.ID

      requestAction = "" ; searchProperty = "requestAction" ; GOSUB GET.SEARCH.PROPERTY ; requestAction=searchResult
      requestItem = "" ; searchProperty = "requestItem" ; GOSUB GET.SEARCH.PROPERTY ; requestItem=searchResult
      requestParameters = "" ; searchProperty = "requestParameters" ; GOSUB GET.SEARCH.PROPERTY ; requestParameters=searchResult

      CALL U_XML.SUBSTITUTE("requestFileName", requestFileName, response)
      CALL U_XML.SUBSTITUTE("requestID", requestID, response)
      CALL U_XML.SUBSTITUTE("requestFilePath", requestFilePath, response)
      CALL U_XML.SUBSTITUTE("requestFileType", requestFileType, response)
      CALL U_XML.SUBSTITUTE("requestConsumed", requestConsumed, response)

      CALL U_XML.SUBSTITUTE("requestAction", requestAction, response)
      CALL U_XML.SUBSTITUTE("requestItem", requestItem, response)
      CALL U_XML.SUBSTITUTE("requestParameters", requestParameters, response)

      CALL U_XML.SUBSTITUTE("responseID", responseID, response)
      CALL U_XML.SUBSTITUTE("responseFileName", responseFileName, response)
      CALL U_XML.SUBSTITUTE("responseFilePath", responseFilePath, response)

      CALL U_XML.SUBSTITUTE("responseFileType", responseType, response)
      CALL U_XML.SUBSTITUTE("requestPayload", request, response)

      GOSUB PROCESS.ACTION

      responseEjected = "" ; CALL U_GET.EPOCH.DATE(responseEjected)
      CALL U_XML.SUBSTITUTE("responseEjected", responseEjected, response)
      CALL U_IO.WRITE(FV.RESPONSE, responseFileName, response, STOP.ON.ERROR, ERROR.TEXT)
   END
   CALL U_IO.DELETE(FV.RECEIVE, requestFileName, STOP.ON.ERROR, ERROR.TEXT)

   RETURN

PROCESS.ACTION:
   statement = ""
   commandLineAction = ""
   commandLineAction = "" ; CALL U_IO.GET.PROPERTY("connect", "requestAction$":UPCASE(requestAction), commandLineAction)
   IF commandLineAction <> "" THEN
      statement = commandLineAction
      IF requestItem <> "" THEN
         statement := SPACE(1):requestItem
         IF requestParameters <> "" THEN
            statement := SPACE(1):requestParameters
         END
      END
   END
   IF statement <> "" THEN
      CALL U_CRT.INFO("EXECUTE", statement)
      CALL U_OS.EXECUTE(statement, @TRUE)

   END



   RETURN

GET.REQUEST.ID:
   requestID = ""
* Interogate Inbound FILE

   searchProperty = "requestID"
   GOSUB GET.SEARCH.PROPERTY
   requestID=searchResult
   CALL U_CRT.INFO("SRCH_RESULT", requestID)

* If we can't find the request ID in the message use its file/record name.
   IF requestID = "" THEN
      requestID = requestFileName
   END

   RETURN

GET.SEARCH.PROPERTY:

   searchID = "" ; CALL U_IO.GET.PROPERTY("connect", searchProperty, searchID)
   searchResult = ""

   IF requestFileType = "json" THEN
      CALL U_JSON.FIND("wctRequest/":searchID, request, searchResult)
   END

   IF requestFileType = "xml" THEN
      CALL U_XML.FIND(searchID, request, searchResult)
   END

   RETURN

END
