PROGRAM W_SERVICE.DO
** INFORMATION ****************************************************************
*   Routine Name : W_SERVICE.DO
*           Type : PROGRAM
*         Params :
*            Loc : UTIL.BP
** AUDIT **********************************************************************
*   Info Updated : 20210214 at 22.52.15 in DEV by root
*                : on mercury.local (Mac)
*******************************************************************************

$INCLUDE UTIL.BP I_UTIL.H
$INCLUDE UTIL.BP F_UTIL.WCT.RECV.H
$INCLUDE UTIL.BP F_UTIL.WCT.RESP.H
$INCLUDE UTIL.BP F_UTIL.WCT.TEMPLATES.H
$INCLUDE UTIL.BP F_UTIL.WORKFILE.H
$INCLUDE UTIL.BP F_UTIL.WCT.TOKENS.H
$INCLUDE UTIL.BP F_UTIL.LOG.EVENT.H

   PROCESS.NAME = "W_SERVICE.DO"
   wct_Properties = "wct_connect"

   STOP.ON.ERROR = @TRUE ; FV.RECEIVE="" ; FV.RESPONSE="" ; FV.TEMPLATES = "" ; FV.REPORTS = ""

   CALL U_IO.OPENFILE(W$RECV.FILE.NAME, FV.RECEIVE, STOP.ON.ERROR, "")
   CALL U_IO.OPENFILE(W$RESP.FILE.NAME, FV.RESPONSE, STOP.ON.ERROR, "")
   CALL U_IO.OPENFILE(W$TEMPLATE.FILE.NAME, FV.TEMPLATES, STOP.ON.ERROR, "")
   CALL U_IO.OPENFILE(U$WRK.FILE.NAME, FV.REPORTS, STOP.ON.ERROR, "")

   requestFilePath = "" ; CALL U_OS.FILE.PATH(FV.RECEIVE, requestFilePath)
   responseFilePath = "" ; CALL U_OS.FILE.PATH(FV.RESPONSE, responseFilePath)
   activePath = "" ; CALL U_IO.GET.PROPERTY("util", "path", activePath)

   defaultResponseType = "" ; CALL U_IO.GET.PROPERTY(wct_Properties, "responseType", defaultResponseType)
   defaultResponseTemplate = "" ; defaultResponseTemplateID = "response.":defaultResponseType

   CALL U_IO.READ(FV.TEMPLATES, defaultResponseTemplateID, defaultResponseTemplate, STOP.ON.ERROR, "")

   waitTime = 0 ; CALL U_IO.GET.PROPERTY(wct_Properties, "waitTime", waitTime)
   shutdownChar = 0 ; CALL U_IO.GET.PROPERTY(wct_Properties, "shutdownChar", shutdownChar)

   CALL U_INITIALISE(PROCESS.NAME)
   CALL U_START(PROCESS.NAME)
   CALL U_HEADER(PROCESS.NAME)

   CALL U_CRT.INFO("QUIT CHAR", shutdownChar:",":upcase(shutdownChar))

   breakLoop = @FALSE ; chkVar = ""
   LOOP
   UNTIL breakLoop

      GOSUB CHECK.QUEUE

      INPUT chkVar, 1:_ TIMEOUT waitTime
      IF chkVar = shutdownChar or chkVar = upcase(shutdownChar) THEN
         breakLoop=@TRUE
      END
* for debugging
*      breakLoop=@TRUE

   REPEAT
   CALL U_STOP(PROCESS.NAME)
   STOP


CHECK.QUEUE:

   STMT = "SELECT ":W$RECV.FILE.NAME:" WITH @ID UNLIKE ":DQUOTE(".keep")
   requestList = "" ; noRequests = 0
   CALL U_GET.LIST(STMT, requestList, noRequests)
   * CALL U_CRT.INFO("REQUESTS", noRequests)
   IF noRequests>0 THEN
      FOR requestListItem = 1 TO noRequests
         requestFileName=requestList<requestListItem>
         GOSUB PROCESS.QUEUE.ITEM
      NEXT requestListItem
   END

   RETURN

PROCESS.QUEUE.ITEM:
   OK.TO.CONTINUE = @TRUE
*   CALL U_CRT.INFO("REQUEST", requestFileName)
   responseID = "" ; CALL U_GET.UUID(responseID)
*   CALL U_CRT.INFO("RESPONSE", responseID)
   request = "" ; response = ""

   requestConsumed = "" ; CALL U_GET.EPOCH.DATE(requestConsumed)
   CALL U_IO.READ(FV.RECEIVE, requestFileName, request, STOP.ON.ERROR, "")

   requestFileType = "" ; requestFileType = CHANGE(requestFileName[4], ".", "")


   IF requestFileType <> "xml" AND requestFileType <> "json" THEN
      CALL U_CRT.INFO("ERROR", requestFileType:" cannot be processed skipping")
   END


   IF OK.TO.CONTINUE THEN
      GOSUB GET.REQUEST.ID
      responseID = requestID

      requestResponseFormat = "" ; searchProperty = "requestResponseFormat" ; GOSUB GET.SEARCH.PROPERTY ; requestResponseFormat=searchResult

      requestAction = "" ; searchProperty = "requestAction" ; GOSUB GET.SEARCH.PROPERTY ; requestAction=searchResult



      IF requestResponseFormat <> defaultResponseType THEN
         requestResponseTemplateID = "response.":requestResponseFormat
         CALL U_IO.READ(FV.TEMPLATES, requestResponseTemplateID, response, STOP.ON.ERROR, "")
         responseFileName=requestID:".":requestResponseFormat
         responseType = requestResponseFormat
      END ELSE
         response = defaultResponseTemplate
         responseFileName=requestID:".":defaultResponseType
         responseType = defaultResponseType
      END

      requestAction = "" ; searchProperty = "requestAction" ; GOSUB GET.SEARCH.PROPERTY ; requestAction=searchResult
      requestItem = "" ; searchProperty = "requestItem" ; GOSUB GET.SEARCH.PROPERTY ; requestItem=searchResult
      requestParameters = "" ; searchProperty = "requestParameters" ; GOSUB GET.SEARCH.PROPERTY ; requestParameters=searchResult
      sessionToken = "" ; searchProperty = "sessionToken" ; GOSUB GET.SEARCH.PROPERTY ; sessionToken=searchResult
      applicationToken = "" ; searchProperty = "appToken" ; GOSUB GET.SEARCH.PROPERTY ; applicationToken=searchResult
      uniqueID = "" ; searchProperty = "uniqueID" ; GOSUB GET.SEARCH.PROPERTY ; uniqueID=searchResult
      userPassword = "" ; searchProperty = "userPassword" ; GOSUB GET.SEARCH.PROPERTY ; userPassword=searchResult


      responseStatus = ""
      responseContent = ""

      CALL U_WILDCARD.SUBSTITUTE("requestFileName", requestFileName, response)
      CALL U_WILDCARD.SUBSTITUTE("requestID", requestID, response)
      CALL U_WILDCARD.SUBSTITUTE("requestFilePath", requestFilePath, response)
      CALL U_WILDCARD.SUBSTITUTE("requestFileType", requestFileType, response)
      CALL U_WILDCARD.SUBSTITUTE("requestConsumed", requestConsumed, response)

      CALL U_WILDCARD.SUBSTITUTE("requestAction", requestAction, response)
      CALL U_WILDCARD.SUBSTITUTE("requestItem", requestItem, response)
      CALL U_WILDCARD.SUBSTITUTE("requestParameters", requestParameters, response)

      CALL U_WILDCARD.SUBSTITUTE("responseID", responseID, response)
      CALL U_WILDCARD.SUBSTITUTE("responseFileName", responseFileName, response)
      CALL U_WILDCARD.SUBSTITUTE("responseFilePath", responseFilePath, response)

      CALL U_WILDCARD.SUBSTITUTE("responseFileType", responseType, response)

      GOSUB GET.REQUEST.DATA

      CALL U_WILDCARD.SUBSTITUTE("requestPayloadCount", requestPayloadCount, response)
      CALL U_WILDCARD.SUBSTITUTE("requestPayload", requestPayload, response)

      GOSUB PROCESS.ACTION

      responseEjected = "" ; CALL U_GET.EPOCH.DATE(responseEjected)
      CALL U_WILDCARD.SUBSTITUTE("responseEjected", responseEjected, response)

      CALL U_WILDCARD.SUBSTITUTE("responseContentCount", responseContentCount, response)
      CALL U_WILDCARD.SUBSTITUTE("responseContent", responseContent, response)
      CALL U_WILDCARD.SUBSTITUTE("responseStatus", responseStatus, response)

      GOSUB PROCESS.REQUEST.LOG.EVENT

      CALL U_IO.WRITE(FV.RESPONSE, responseFileName, response, STOP.ON.ERROR, ERROR.TEXT)
   END
   CALL U_IO.DELETE(FV.RECEIVE, requestFileName, STOP.ON.ERROR, ERROR.TEXT)

   RETURN

PROCESS.REQUEST.LOG.EVENT:
   LOG.DATA = response
   R.EVENT = ""
   R.EVENT<U_LOG_EVENT> = "WCT_REQUEST"
   R.EVENT<U_LOG_CMD> = requestAction
   R.EVENT<U_LOG_MSG> = requestItem:" ":requestParameters
   R.EVENT<U_LOG_SUBR> = "W_SERVICE.DO"
   CALL U_LOG.EVENT(LOG.DATA, R.EVENT)
   RETURN

PROCESS.ACTION:
* SUBRS MUST RETURN responseContent
   responseContent = ""

   CALL U_CRT.INFO("requestAction", requestAction)
   CALL U_CRT.INFO("ra(last)", requestAction[1, 1])
   CALL U_CRT.INFO("requestItem", requestItem)



   BEGIN CASE

      CASE UPCASE(requestAction)[1, 1] = "@"
         GOSUB PROCESS.CALLOUT
      CASE UPCASE(requestAction)[1, 1] = "!"
         GOSUB PROCESS.DIRECT.CLI.COMMAND
      CASE UPCASE(requestAction) = "LOGIN"
         responseCode = "" ; responseMessage = ""
         CALL W_SERVICE.LOGIN(applicationToken, uniqueID, "", sessionToken, responseCode, responseMessage)
         responseStatus = responseCode
         responseContent = responseMessage
      CASE UPCASE(requestAction) = "TEST"
         responseCode = "" ; responseMessage = ""
         CALL W_SERVICE.TEST(requestItem, requestParameters, responseCode, responseMessage)
         responseStatus = responseCode
         responseContent = responseMessage
      CASE UPCASE(requestAction) = "LOGOUT"
         * TODO
      CASE UPCASE(requestAction) = "SERVICES"
         CALL W_SERVICE.SERVICES(responseStatus, responseContent)

      CASE 1
         GOSUB PROCESS.CLI.COMMAND

   END CASE

   GOSUB PROCESS.RESPONSE.CONTENT



   RETURN

PROCESS.CALLOUT:
   CALLOUT.ROUTINE = "W_SERVICE.":CHANGE(requestAction, "@", "")
   CALL U_CRT.INFO("EXTERNAL", CALLOUT.ROUTINE)

   fsResult = ""
   CALL !FINDPROG(fsResult, CALLOUT.ROUTINE)
   CALL U_CRT.INFO("FINGPROG", fsResult)
   IF fsResult <> "" THEN
      CALL @CALLOUT.ROUTINE(requestItem, requestParameters, responseContent, responseStatus)
   END ELSE
      responseStatus = "500"
      responseContent = DQUOTE(CALLOUT.ROUTINE):" cannot be found"
   END


   RETURN

PROCESS.CLI.COMMAND:
   statement = ""
   commandLineAction = ""
   commandLineAction = "" ; CALL U_IO.GET.PROPERTY(wct_Properties, "requestAction$":UPCASE(requestAction), commandLineAction)
   IF commandLineAction <> "" THEN
      statement = commandLineAction
      IF requestItem <> "" THEN
         statement := SPACE(1):requestItem
         IF requestParameters <> "" THEN
            statement := SPACE(1):ICONV(requestParameters,"HD")
         END
      END
   END
   IF statement <> "" THEN
      CALL U_CRT.INFO("EXECUTE", statement)

      processExtn = "wct"
      outputFileName = responseID:U_TRUNC:DOWNCASE(requestAction):".":processExtn

      CMD = ""
      CMD<1> = "STORE"
      CMD<2> = activePath:"/":U$WRK.FILE.NAME:"/"
      CMD<3> = outputFileName

      CALL U_OS.EXECUTE(statement, CMD)

      * GET response Data
      GOSUB GET.RESPONSE.DATA

   END
   RETURN

PROCESS.DIRECT.CLI.COMMAND:
   statement = ""
   commandLineAction = ""
   commandLineAction = CHANGE(UPCASE(requestAction), "!", "")
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

      processExtn = "wct"
      outputFileName = responseID:U_TRUNC:DOWNCASE(requestAction):".":processExtn

      CMD = ""
      CMD<1> = "STORE"
      CMD<2> = activePath:"/":U$WRK.FILE.NAME:"/"
      CMD<3> = outputFileName

      CALL U_OS.EXECUTE(statement, CMD)

      * GET response Data
      GOSUB GET.RESPONSE.DATA

   END
   RETURN

GET.RESPONSE.DATA:

   temp_responseContent = "" ; responseContent = ""
   CALL U_IO.READ(FV.REPORTS, outputFileName, responseContent, @FALSE, "")
   CALL U_CLEAN.TEXT(responseContent)
   responseStatus = "200"

   RETURN

PROCESS.RESPONSE.CONTENT:
   responseContentCount = 100
   responseContentCount = DCOUNT(responseContent, @AM)
   temp_responseContent = responseContent ; responseContent = ""
   FOR I = 1 TO responseContentCount
      IF responseType = "xml" THEN
         CALL U_BUILD.XML.FIELD(responseContent, "responseContentRow", "", temp_responseContent<I>)
      END
      IF responseType = "json" THEN
         CALL U_BUILD.JSON.FIELD.REPEATING(responseContent, temp_responseContent<I>)
      END
   NEXT I
   RETURN


GET.REQUEST.DATA:
   requestPayload = ""
   tmpRequest = request ; CALL U_CLEAN.TEXT(tmpRequest)
   requestPayloadCount = DCOUNT(tmpRequest, @AM)

   FOR I = 1 TO requestPayloadCount
      IF responseType = "xml" THEN
         CALL U_BUILD.XML.FIELD(requestPayload, "requestPayloadRow", "", tmpRequest<I>)
      END
      IF responseType = "json" THEN
         CALL U_BUILD.JSON.FIELD.REPEATING(requestPayload, tmpRequest<I>)
      END
   NEXT I

   RETURN

GET.REQUEST.ID:
   requestID = ""
* Interogate Inbound FILE

   searchProperty = "requestID"
   GOSUB GET.SEARCH.PROPERTY
   requestID=searchResult
   * CALL U_CRT.INFO("SRCH_RESULT", requestID)

* If we can't find the request ID in the message use its file/record name.
   IF requestID = "" THEN
      requestID = requestFileName
   END

   requestID = CHANGE(CHANGE(requestID, ".xml", ""), ".json", "")

   RETURN

GET.SEARCH.PROPERTY:

   searchID = "" ; CALL U_IO.GET.PROPERTY(wct_Properties, "tag_":searchProperty, searchID)
   searchResult = ""

   IF requestFileType = "json" THEN
      CALL U_JSON.FIND("wctRequest/":searchID, request, searchResult)
   END

   IF requestFileType = "xml" THEN
      CALL U_XML.FIND(searchID, request, searchResult)
   END

   RETURN

END
