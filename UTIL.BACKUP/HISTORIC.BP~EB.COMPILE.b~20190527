* Version 13 03/09/01  GLOBUS Release No. G15.0.02 28/09/04
*-----------------------------------------------------------------------------
* <Rating>-817</Rating>
*-----------------------------------------------------------------------------
    PROGRAM EB.COMPILE
*-----------------------------------------------------------------------------
* Compiles and catalogs basic programs to the correct library.
*     o Performs standards compliance checks.
*     o Builds the release, and allows a restart if fails
*     o Produces a compliance report for each item
*     o Produces an xml usage document (c.f. old xref files)
*     o Is jBASE only. This version will NOT work with Universe.
*-----------------------------------------------------------------------------
* Examines the command line to determine behaviour:
* Without an active SELECT list:
*
* EB.COMPILE file prog [-args]
*    file  = name of the directory
*    prog  = name of program
*    -args = the arguments
*
* With an active SELECT list:
*
* EB.COMPILE file -args
*    file  = name of the directory
*    -args = the arguments
*
*-----------------------------------------------------------------------------
* Arguments
* c - compile
* t - catalog
* x - do standards check (JBASE.TEXT.SCAN)
* j - do java compliance check (J24.COMPILE)
* s - score the item (EB.CODE.REVIEW)
* v - verbose
* r - restartable
* R - restart from previous
* p - produce score report
* d - produce xml documentation
* y - do not do como off
* i - do NOT use -I option on BASIC command
* D - Bypass DEBUG checking. Allow Compile for DEBUGGING purposes.

*************************************************************************
*** <region name='Modification History'>
* 19/02/97 - GB9700192
*            Check that the BP object file exists
*
* 23/06/97 - GB9700742
*            Amend program due to the fact that BP1 and BP2 have been
*            replaced by T24.BP
*
* 06/07/00 - GB0001563
*            Changed to work in jBASE also.  If running in UV and
*            if jBASE is installed then it compiles the program in jBASE
*            It scans for CHAR and SEQ, CHARS and SEQS
*
* 31/07/00 - GB0001961
*            The following changes are done.
*            1. EXECUTE 'ENV' should be used only when running in UV and
*               when jbase is installed.
*            2. COMO is stored as PGM.COMPILE. Modify this to include @USERNO
*
* 11/08/00 - GB0002059
*            in jBASE, if the program is formated, then
*            EB.COMPILE is not able to copy the inserts from
*            T24.BP. The reason, FORMAT inserts space before
*            '$INSERT'. Hence EB.COMPILE cannot detect the
*            inserts. Use TRIM() to remove the space.
*
* 17/10/00 - GB0002069
*            In some instances the source code will not compile due to syntactical
*            differences. It has been decided that such programs will be maintained
*            in two forms. The original name will still be the UniVerse equivalent
*            and the program name with a '.JBASE' will be its jBASE counterpart.
*            The EB.COMPILE program will have hard-coded names defined to it that
*            it will ignore for compilation on either side. For jBASE releases the
*            program BUILD.GLOBUS.C.SOURCE will ensure that the jBASE equivalent
*            source code is released.
*
* 18/10/00 - GB0002660
*            Make LOGOUT a jBASE specific program
*
* 18/10/00 - GB0002666
*            Make SH a jBASE specific program
*
* 19/04/01 - GB0101116
*            Ignore any program ending in .JBASE such that we will not
*            attempt the Universe compile - in addition to the hardcoded list
*
* 01/08/01 - GB0101990
*            EB.COMPILE does not compile the jGLOBUS program SH
*            Fix it to allow EB.COMPILE to compile SH in jBASE
*            only
*
* 06/09/01 - GB0102128
*            Enable program to be run from DIM.SOFTWARE.HANDOVER, to build
*            TEMP.RELEASE.  If program is being run to build the release,
*            programs should only be compiled, not cataloged, and inserts
*            should not be copied as they should all exist
*
* 12/10/01 - GLOBUS_EN_10000249
*            Amend program so that if it is being run in jBASE, the bin
*            & libs are set according to the BP name (this will be done
*            in new program - SET.LIBRARIES.JBASE; can't be done in this
*            program otherwise it won't compile in UV).
*            Also for jBASE, write out a VOC entry to say where the
*            program has been compiled/cataloged from.
*
* 16/11/01 - GLOBUS_BG_100000236
*            Remove references to PRD.BP1 (no longer required; could also
*            be dangerous as out of date inserts would be copied)
*
* 21/03/02 - GLOBUS_BG_100000762
*            Changes made so that the program DOS gets compiled
*            only in jGLOBUS
*
* 21/03/02 - GLOBUS_BG_100001413
*            Change made so that if the name in which routine is
*            saved is different from the declared name then
*            the routine should not be compiled and error has to be shown
*
* 03/10/02 - GLOBUS_BG_100002217
*            Disallow program compile if an $INSERT is used more than once
*
* 18/02/03 - GLOBUS_BG_100003496
*            Disallow program compile / catalog, if a routine name
*            contains '$'.
*
* 30/04/03 - GLOBUS_BG_10004133
*            Amendment to allow JBASE.TEXT.SCAN to use an application to dictate
*            what is checked rather than hardcoded strings. Disallow _ in routine
*            name. Disallow routines ending in .B
*
* 08/10/03 - GLOBUS_BG_100005345
*            Do CATALOG using a list to prevent multiple rebuilds of the same library.
*            Use the -I option in the BASIC command, this makes the insert copy redundant.
*            Remove open of .O file, this no longer exists in jBASE.
*
* 14/10/03 - GLOBUS_BG_10005402
*            Make sure CATALOG is only done where required!
*
* 05/11/03 - GLOBUS_BG_100005610
*            When compiling temp.release don't use the -IGLOBUS.BP as GLOBUS.BP doesn't
*            exist.
*
* 30/01/04 - GLOBUS_BG_100006126
*            Don't use FORMLIST followed by CATALOG to catalog the programs as
*            jBASE 4.1 ends up with an active select list after the EXECUTE.
*
* 01/07/04 - CI_10021033
*            Changes done so that code is compatible with AS400
*
* 13/09/04 - BG_100007221
*            In jBase 4.1 was listing non-existant slect list when compiling JOURNAL.UPDATE.JBASE
*
* 25/05/06 - EN_10002946
*            Rewrite as now jbase only. Also, enable:
*              o Restartable processing when running from a list
*              o Run j24 and scoring
*              o Produce a report for warnings, errors and score
*
* 21/06/06 - BG_100011521
*            When compiling a select list the Warnings produced from jBASE are not being
*            cleared so subsequent compilations inherit other programs warnings! This
*            has been fixed.
*            Also removed the call to DO.J24.CHECK as this is not needed at the moment and
*            the CALLJ in J24.COMPILE has caused the following errors:
*                 - CLASSPATH doesn't exist! set to :
*                   java.lang.NoClassDefFoundError: com/temenos/j24/compiler/EbCompile
*                 - JVMDG217: Dump Handler is Processing a Signal - Please Wait.
*                 - jBASE: Segmentation violation. Aborting
*
* 24/07/06 - BG_100011738
*            Imporved command line arg processing. If file name is not specified then
*            the default of 'BP' will be used.
*            Example:
*                       1.  EB.COMPILE REPO -> Should compile the REPO program in BP
*                       2.  GET-LIST MY.LIST
*                           EB.COMPILE   -> Should compile all items IN the list MY.LIST IN BP
*                       3.  EB.COMPILE   -> WITH no active SELECT list OR PROGRAM name should DO nothing
*
* 26/07/06 - BG_100011760
*            Removed unesscessary file open to F.PGM.DATA.CONTROL
*
* 29/11/06 - BG_100012494
*            Introduce a check to stop compile when we find a DEBUG statement
*            in the code to be compiled.
*
* 05/04/07 - BG_100013554
*            Enabled the J24.COMPILE and improved the error reporting i.e. any
*            problems encounted during the J24 compile will be show as <warnings>.
*
* 10/04/07 - BG_100013579
*            Uninitialised Var PROBLEMS.FROM.J24.COMPILE fixed.
*
* 19/11/07 - BG_100015924
*            Add better error handling into J24.COMPILE to gracefully show an error
*            when the J24 compiler cannot be found but only for Development
*            (i.e. no errors for clients)
*
* 29/02/08 - GLOBUS_BG_100017403 - dgearing@temenos.com
*            add j24 compile errors to output
*            correct spelling mistakes
*
* 12/06/08- BG_100018739
*           Display the catalog output along with the compile output.
*           TTS Ref : TTS0705832
*
* 25/06/08 - CI_10056300
*            Warnings and error messages not displayed using options
*            in EB.COMPILE.
*            Ref:TTS0801325
*
* 24/10/08 - EN_10003897
*            Compilation and Catalogging done based on COMPONENT attribute
*
* 12/03/09 - BG_100022646
*            Decatalog the old component lib/bin if they have changed component
*
* 22/09/09 - EN_10004355
*            Replace Globus.BP with T24.BP in T24 Server Code
*
* 25/11/2009 - BG_100025913
*            Soft code the folder named T24.BP
*
****************************************************************************
* </region>
*-----------------------------------------------------------------------------
*** <region name='inserts'>
    $INSERT I_EB.COMPILE.COMMON         ;* BG_100004133
    $INSERT I_COMMON
* </region>
*-----------------------------------------------------------------------------
*** <region name='main section'>
*-----------------------------------------------------------------------------
    GOSUB INITIALISE          ;* Initialise variables and open required files. ; * GB0001563

    GOSUB GET.PARAMETERS      ;* Get parameters passed through on the command line

    PROG.LIST = PROG.LIST     ;* reset the remove pointer
    PROGRESS.COUNT = 0
    LOOP
        REMOVE PROG.NAME FROM PROG.LIST SETTING YD
    WHILE PROG.NAME
        GOSUB PROCESS.ITEM
        PROGRESS.COUNT +=1
        IF ACTIVE.LIST THEN   ;* When we are processing many items, show the compile output as we go
            GOSUB SHOW.COMPILE.OUTPUT   ;* Print the output of the jBASE compiler
            GOSUB FINALISE.DISPLAY
        END
    REPEAT

    GOSUB DO.CATALOG          ;* Now do the cataloging

    IF NOT(ACTIVE.LIST) THEN
        GOSUB SHOW.COMPILE.OUTPUT       ;* Show the whole output (including catalog) at the end.
        GOSUB FINALISE.DISPLAY
    END
*
    IF DO.COMOS THEN
        EXECUTE "COMO OFF"
    END
    CRT
*
    STOP
*** </region>
*-----------------------------------------------------------------------------
*** <region name='Get Parameters'>
GET.PARAMETERS:
    GOSUB SET.DEFAULT.OPTIONS ;* Set the default behaviour
*
* Determine if we have an active select list. If we do, this basically gives us
* the list of items to process
*
    ARGS = ''
    READLIST PROG.LIST THEN
        ACTIVE.LIST = 1
    END ELSE
        PROG.LIST = ''
        ACTIVE.LIST = 0
    END
*
* Get parameters passed through on the command line
*
    CMD.LINE = TRIM(@SENTENCE)[' ',2,99]          ;* Get rid of the EB.COMPILE part
    PARAMETER.COUNT = DCOUNT(CMD.LINE," ")        ;* How many arguments are supplied

    IF ACTIVE.LIST = 0 THEN
        IF PARAMETER.COUNT = 0 THEN
            GOSUB SHOW.HELP
            STOP
        END
    END

    CONVERT ' ' TO @FM IN CMD.LINE      ;* Turn it into an array for easier processing

    NO.ITEMS = DCOUNT(CMD.LINE,@FM)

* BG_100012494

    IF ACTIVE.LIST = 1 THEN
* There is an active select list, no really.
        BEGIN CASE
        CASE NO.ITEMS = 0
* No additional parameters
            PROG.FILE = "BP"
        CASE NO.ITEMS = 1
            IF CMD.LINE[1,1] # "-" THEN
                PROG.FILE = CMD.LINE
            END ELSE
                PROG.FILE = "BP"
                ARGS = CMD.LINE
            END
        CASE 1
            PROG.FILE = CMD.LINE<1>
            ARGS = FIELD(CMD.LINE, @FM, 2, 99)
        END CASE
    END ELSE
* Regular use
        IF NO.ITEMS = 1 THEN
* Assume they have just specifed a program name
* so default the File to BP.
            PROG.FILE = 'BP'
            PROG.LIST = CMD.LINE
        END ELSE
* More items but what are they? Lets find out shall we...
            IF CMD.LINE<2>[1,1] = "-" THEN
* Anything from 2 onwards are arguments
                PROG.FILE = "BP"
                PROG.LIST = CMD.LINE<1>
                ARGS = FIELD(CMD.LINE, @FM, 2, 99)
            END ELSE
* Anything from 3 onwards are arguments
                PROG.FILE = CMD.LINE<1>
                PROG.LIST = CMD.LINE<2>
                ARGS = FIELD(CMD.LINE, @FM, 3, 99)
            END
        END
    END

    OPEN PROG.FILE TO BP ELSE
        FATAL.MSG =  'Cannot open ': PROG.FILE
        STOP
    END

    GOSUB PROCESS.ARGUMENTS   ;* Work out how the passed arguments affect processing.

    IF DO.COMOS THEN
        EXECUTE "COMO ON COMPILE.PGM.":@USER.NO   ;* GB0001961
    END

    RETURN
* </region>
*-----------------------------------------------------------------------------
*** <region name= Initialisation>
*** <desc>Initialise, create and open required files</desc>
INITIALISE:
* Initialise variables and open required files.
    STDS.WARNINGS.COUNT=0
    J24.WARNINGS.COUNT = 0
    TIME.START = TIME()
    EB.COMPILE.VERSION = '6.0'
    INSERT.LOCATION = T24$BP       ;* Find the inserts in T24.BP
    COMPILE.OPTIONS = "-I":INSERT.LOCATION
    SHOW.MSGS = 1   ;* Allows running in silent
    OBSOLETE.PRODUCTS = 'OB DG GI LA BA XX GB KW CH BD GT'  ;* list of obsolete products!
    THIS.MSG = ''
    GOSUB OPEN.FILES          ;* Opens or creates files
    R.EB.COMPILE.TEXT.COPY = R.EB.COMPILE.TEXT    ;* If this is blank, it is flagged in PRODUCE.REPORT
    CATALOG.LIST = ''         ;* BG_100005345
    WARNINGS.FROM.JBASE.COMPILER = ''   ;* Variables undefined, etc.
    PROBLEMS.FROM.J24.COMPILE = ''      ;* BG_100013579
    WARNINGS.FROM.J24.COMPILER = ''     ;* Things the java compiler doesn't like
    GOSUB DEFINE.XML.TAGS     ;* Set the tags that we will use for the XML output
    GOSUB DEFINE.PRODUCT.GROUPS         ;* Set which products belong to which product groups
*
* Save the original bin and lib settings...
*
    SAVED.BIN = ''
    SAVED.LIB = ''
    SAVED.OUTPUTDIR = ''
*
* XML doc operations...
*
    OPERS = 'READ WRITE DELETE OPEN CALL OTHER'
    CONVERT ' ' TO @FM IN OPERS
    NO.OF.OPERS = DCOUNT(OPERS,@FM)

    DO.DEBUG.CHECK = @TRUE

    COMPONENT.LIST = ''       ;* will hold the list of components for which we are

    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= Do standards checking>
*** <desc>Ensure that the coding standards are followed</desc>
DO.STANDARDS.CHECK:
    IF DO.CHECKS THEN
        R.EB.COMPILE.TEXT = R.EB.COMPILE.TEXT.COPY
    END ELSE
        R.EB.COMPILE.TEXT = ''
    END
* Check for errors and produce warnings based on the parameter record EB.COMPILE.TEXT>SYSTEM
    ERROR.FLAG = ''
    THE.DISPLAY = ''
    THE.DOC = ''
    THIS.PROG.NAME = PROG.NAME
    C$DEBUG.CHECK = DO.DEBUG.CHECK
    CALL JBASE.TEXT.SCAN('',PROG.FILE,THIS.PROG.NAME,ERROR.FLAG,THE.DISPLAY,THE.DOC)
    STDS.WARNINGS.COUNT = COUNT(THE.DISPLAY,'<warning>') + COUNT(THE.DISPLAY,'<standard>')
    RETURN

*** </region>
*-----------------------------------------------------------------------------
*** <region name= PROCESS.ITEM>
***
PROCESS.ITEM:
    ITEM.MSG = ''
    CODE.SCORE = ''
    COMPILE.OUTPUT = ''       ;* Just from the jbase compile part
    THE.DISPLAY = ''          ;* The whole nine yards
    BEGIN CASE
    CASE PROG.NAME[1,2] = 'I_'
        ITEM.MSG = 'is an insert.'      ;* Ignore inserts
    CASE PROG.NAME[1,1] = '$' OR PROG.NAME[1,1] = '!'
        ITEM.MSG = 'is object code.'    ;* Ignore object code
    CASE PROG.NAME MATCHES '...$...' OR PROG.NAME MATCHES '..._...'   ;* BG_100004133 s
        ITEM.MSG = 'has banned character "_" or "$" in name.'         ;* Ignore '$' '_' routines
    CASE PROG.NAME[2] = '.B'
        ITEM.MSG = 'has banned suffix .B'         ;* .B extensions forbidden, reserved in C++
    CASE PROG.NAME[1,4] = 'CON.'
        ITEM.MSG = 'has banned prefix CON.'       ;* Windows exec
    CASE 1
        READ R.ITEM FROM BP, PROG.NAME ELSE R.ITEM = ''     ;* Shouldnt happen really!
        IF R.ITEM = '' THEN
            ITEM.MSG =  'cannot be read from ':PROG.FILE : '.'
        END
    END CASE
    IF ITEM.MSG THEN
        THIS.MSG = PROG.NAME : ' ' : ITEM.MSG : ' Ignoring.'
        GOSUB SHOW.MSG
    END ELSE
        GOSUB DETERMINE.PRODUCT.GROUP   ;* Work out the product and product group
        GOSUB SHOW.SUMMARY    ;* Show a summary of what we are going to do
        ERROR.FLAG = 0
        GOSUB DO.SCORE        ;* EB.CODE.REVIEW
        GOSUB DO.J24.CHECK    ;* J24 compliance check
        GOSUB DO.STANDARDS.CHECK        ;* Check for CHAR-SEQ usage
        IF ERROR.FLAG EQ 1 THEN
            ERROR.LIST<-1> = PROG.NAME
        END ELSE
            GOSUB DO.COMPILE  ;* Invoke jBASE compiler
        END
        GOSUB ADD.TO.CATALOG.LIST       ;* Add the item to the catalog list in the correct product group
        GOSUB PRODUCE.REPORT
    END

    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Set catalog library>
SET.LIBRARIES:
    ERROR.MSG = ''
    CALL SET.LIBRARIES.JBASE('SET',SAVE.PROG.FILE,SAVED.BIN,SAVED.LIB,SAVED.OUTPUTDIR,ERROR.MSG,'1')          ;* CI_10021033 E
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Process jBASE compiler warnings>
*** <desc>Loop through and add any warnings from the jBASE compiler to the xml output</desc>
PROCESS.JBASE.WARNINGS:

    WARNINGS.FROM.JBASE.COMPILER = ''
    WARNING.TEXT = ''
    WARNING.POINTER = 1

    LOOP
    WHILE INDEX(COMPILE.OUTPUT,'Warning: ',WARNING.POINTER)
        WARNING.START.POS = INDEX(COMPILE.OUTPUT,'Warning: ',WARNING.POINTER) + LEN('Warning: ')
        WARNING.TEXT = COMPILE.OUTPUT[WARNING.START.POS,9999]
        WARNING.TEXT = WARNING.TEXT<1>
        WARNINGS.FROM.JBASE.COMPILER := WARNING.TAG : WARNING.TEXT : WARNING.TAG.C
        WARNING.POINTER +=1
    REPEAT

    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Perform the J24 compliance checks>
*** <desc>Add warnings if the code breaks java conversion rules</desc>
DO.J24.CHECK:
    J24.WARNINGS.COUNT = 0
    J24.PROBLEMS = ''
    IF DO.J24 THEN
        IF NOT(ACTIVE.LIST) THEN
            CRT 'Checks ':
        END
        J24.ARG=""
* Need to get the full path from the file pointer...
        FULL.PATH = ''
        STATUS FILE.INFO FROM BP ELSE
            FATAL.MSG =  'Could not get file path from file pointer'  ;* Shouldnt happen!
            GOSUB FATAL.ERROR
        END
        FULL.PATH = FILE.INFO<20>
        J24.ARG<1>=FULL.PATH  ;* The full path
        J24.ARG<2>=PROG.NAME  ;* Program name
        GOSUB DO.J24.COMPILE
    END
    J24.WARNINGS.COUNT = COUNT(J24.PROBLEMS,'<standard>')

    RETURN
*-----------------------------------------------------------------------------
DO.J24.COMPILE:

* BG_100013554 s
    PROBLEMS.FROM.J24.COMPILE = ''
    J24.COMPILE.MESSAGE = ''
*
    CALL J24.COMPILE(J24.ARG,J24.PROBLEMS)

    IF NOT(INDEX(SYSTEM(1021), 'TEMENOS',1)) THEN ;* if not Temenos environment
        J24.PROBLEMS = ''     ;* do not throw the error for the client's
    END

*
* If there was a problem invoking the java compiler, the result will be numeric!
*
    IF J24.PROBLEMS NE '' THEN
        IF NUM(J24.PROBLEMS) THEN
            J24.COMPILE.MESSAGE = 'Java Standards was not checked! Code ' : J24.PROBLEMS : ' was returned.'
            J24.COMPILE.MESSAGE.TYPE = 'Ensure your T24 java environment is configured correctly.'

* Construct the tags needed for a warning message
            WARN.TAG.O = '<': C$WARN.ITEM.TAG :'>'
            WARN.TAG.C = '</': C$WARN.ITEM.TAG :'>'
            MSG.TAG.O = '<': C$MSG.TAG :'>'
            MSG.TAG.C = '</': C$MSG.TAG :'>'
            LINE.TAG.O = '<': C$LINE.NO.TAG :'>'
            LINE.TAG.C = '</': C$LINE.NO.TAG :'>'
            TYPE.TAG.O = '<': C$WARN.TYPE.TAG :'>'
            TYPE.TAG.C = '</': C$WARN.TYPE.TAG :'>'

* Construct the Warning Message
            PROBLEMS.FROM.J24.COMPILE = WARN.TAG.O
            PROBLEMS.FROM.J24.COMPILE := MSG.TAG.O : J24.COMPILE.MESSAGE : MSG.TAG.C
            PROBLEMS.FROM.J24.COMPILE := LINE.TAG.O : LINE.TAG.C
            PROBLEMS.FROM.J24.COMPILE := TYPE.TAG.O : J24.COMPILE.MESSAGE.TYPE : TYPE.TAG.C
            PROBLEMS.FROM.J24.COMPILE := WARN.TAG.C
        END ELSE    ;* BG_100017403
            PROBLEMS.FROM.J24.COMPILE = J24.PROBLEMS        ;* BG_100017403
        END
    END
* BG_100013554 e

    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Perform the code scoring>
*** <desc>Invoke EB.CODE.REVIEW to get the score of the item</desc>
DO.SCORE:

    CODE.SCORE = ''
    THE.RATING = ''
    R.ITEM.ORI = ''
    IF DO.SCORE THEN
        IF NOT(ACTIVE.LIST) THEN
            CRT 'Score ':
        END
        CODE.SCORE = 'DETAIL' ;* Don't display, but return the whole string as an argument
        R.ITEM.ORI = R.ITEM
        CALL EB.CODE.REVIEW(R.ITEM,CODE.SCORE)    ;* perform the code review on the item

        IF R.ITEM.ORI <> R.ITEM THEN
* Code has been stamped with the new rating
* so write this to disk!
            WRITE R.ITEM ON BP, PROG.NAME
        END
*
* The new overall rating of the item is held in the <rating> tag
*
        RATING.START = INDEX(CODE.SCORE, '<Rating>',1)+LEN('<Rating>')
        RATING.END = INDEX(CODE.SCORE, '</Rating>',1)
        THE.RATING = CODE.SCORE[RATING.START, RATING.END-RATING.START]

    END


    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name='produce the output from all the steps'>
FINALISE.DISPLAY:
*
* If JBASE.TEXT.SCAN didnt find any problems, it will still have placeholder tags!
*
    STANDARDS.START.POS = INDEX(THE.DISPLAY,STANDARDS.TAG,1)
    WARNINGS.START.POS = INDEX(THE.DISPLAY,WARNINGS.TAG,1)

* BG_100013554 add the J24 Compile problems to the warnings
    THE.DISPLAY = THE.DISPLAY[1,WARNINGS.START.POS+LEN('<warnings>')-1] : PROBLEMS.FROM.J24.COMPILE : WARNINGS.FROM.JBASE.COMPILER : THE.DISPLAY[WARNINGS.START.POS+LEN('<warnings>'),9999]

    OUTPUT.START.POS = INDEX(THE.DISPLAY, OUTPUT.TAG.C,1)   ;* Should be one, but to be sure...
    THE.DISPLAY = THE.DISPLAY[1,OUTPUT.START.POS-1] :CODE.SCORE : OUTPUT.TAG.C
* And finally spit it out!
    IF DO.DISPLAY THEN
        CRT THE.DISPLAY
    END

    RETURN
*</region>
*-----------------------------------------------------------------------------
*** <region name= DO.CATALOG>
DO.CATALOG:
*** <desc>Now do the cataloging</desc>
* do this by creating an active select list then execute the CATALOG command
*
    SAVE.PROG.FILE = PROG.FILE
    NO.OF.COMPONENTS = DCOUNT(COMPONENT.LIST,@FM) ;* number of components
    FULL.CATALOG.LIST  = CATALOG.LIST

    FOR COMPT.NO = 1 TO NO.OF.COMPONENTS          ;* loop through each component for catalogging component wise

        COMPONENT = COMPONENT.LIST<COMPT.NO>      ;* get the component
        CATALOG.LIST = RAISE(FULL.CATALOG.LIST<COMPT.NO>)

        CATALOG.OUTPUT = ''   ;*initialise
        JSHOW.PATH = ''     ;* Hold the current t24bin/t24lib path
        LIB.TYPE = ''          ;* Hold the Subroutine/Executable
        IF CATALOG AND CATALOG.LIST THEN
            CRT 'Catalog '
            SAVE.PROG.FILE <2> = COMPONENT        ;* assign the component to pass it to set libraries
            GOSUB SET.LIBRARIES         ;* Set the libraries according to BP name
            CALL EB.DECATALOG.OLD.LIB("GET",CATALOG.LIST,JSHOW.PATH,LIB.TYPE)    ;*  Get the old library path
            EXECUTE 'CATALOG ':PROG.FILE: PASSLIST CATALOG.LIST CAPTURING CATALOG.OUTPUT

            CALL EB.DECATALOG.OLD.LIB("DECATALOG",CATALOG.LIST,JSHOW.PATH,LIB.TYPE) ;* Decatalog the old library if they have changed component
* Restore original library settings
            ERROR.MSG = ''
            CALL SET.LIBRARIES.JBASE('RESET','',SAVED.BIN,SAVED.LIB,SAVED.OUTPUTDIR,ERROR.MSG,'1')  ;* CI_10021033
        END

    NEXT COMPT.NO

    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= SET.DEFAULT.OPTIONS>
SET.DEFAULT.OPTIONS:
*** <desc>Set the default behaviour</desc>

    COMPILE = 1     ;* The defaults
    CATALOG = 1     ;* The defaults
    DO.CHECKS = 1   ;* J24.COMPILE, JBASE.TEXT.SCAN
    DO.SCORE = 1    ;*  EB.CODE.REVIEW
    RESTARTABLE = 0 ;* can we restart
    DEFAULT.DIR = 'BP'
    DO.COMOS = 1    ;* Put a como around the whole thing
    DO.REPORT = 0   ;* Don't produce the report by default
    DO.DISPLAY = 1  ;* Show output by default
    SHOW.MSGS = 1
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= PROCESS.ARGUMENTS>
***
PROCESS.ARGUMENTS:
*
* Turn it all off by default if there are any arguments
*
    COMPILE = 0
    CATALOG = 0
    DO.CHECKS = 0
    DO.J24 = 0
    DO.SCORE = 0
* dont turn off DO.DISPLAY variable needed for displaying error and warning messages
    SHOW.MSGS = 0
    DO.REPORT = 0
    DO.DOC = 0
    DO.DEBUG.CHECK = 0
    TURN.COMO.OFF = 1
    NO.OF.ARGS = LEN(ARGS)

    BAD.ARGS = 0
    IF ARGS[1,1] <> '-' THEN
        BAD.ARGS = 1
    END ELSE
        FOR I = 2 TO NO.OF.ARGS
            THIS.ARG = ARGS[I,1]
            GOSUB PROCESS.ARGUMENT      ;* Work out watch each argument means
        NEXT I
    END
*
* ...but turn it all on if there are no arguments!
*
    IF NO.OF.ARGS =0 THEN
        GOSUB SET.ALL.CHECKS  ;* Set all the checks to process.
    END
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Show summary>
* Tell the used what it is that we are going to do!
SHOW.SUMMARY:
*** <desc>Show a summary of what we are going to do</desc>
    IF PROGRESS.COUNT = 0 THEN          ;* Only show the summary for the first item....
        CRT 'Source directory : ':PROG.FILE:
        IF ACTIVE.LIST THEN
            TOTAL.ITEMS = COUNT(PROG.LIST, @FM) + 1
            CRT ' Active list with ' : TOTAL.ITEMS : ' items.'
        END ELSE
            CRT ' Single item : ':PROG.LIST
        END
        IF DO.SCORE THEN
            CRT 'Score ':
        END
        IF DO.CHECKS THEN
            CRT 'Checks ':
        END
        IF COMPILE THEN
            CRT 'Compile ':
        END
        IF CATALOG THEN
            CRT 'Catalog ':
        END
        IF RESTARTABLE THEN
            CRT 'Restart ':
        END
        IF NOT(DO.DEBUG.CHECK) THEN
            CRT 'Compilation with DEBUG'
        END
        CRT
    END
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Restart>
***
CREATE.RESTART.DIR:
*
* Create a directory to copy items into so that we can delete items out of it as we process
* Allowing us to restart...
*
    RESTART.DIR = 'EB.COMPILE.RESTART'
    OPEN RESTART.DIR TO F.RESTART.DIR ELSE
        MY.CMD = 'CREATE.FILE DATA ' : RESTART.DIR : ' TYPE=UD'
        EXECUTE MY.CMD CAPTURING THE.OUTPUT
        OPEN RESTART.DIR TO F.RESTART.DIR ELSE
            CRT 'Cannot open or create ' :RESTART.DIR
            STOP
        END
    END
*
* Also copy the items into a directory that reflects the item that we are creating,
* so that when a jshow -c is run you can see where the code came from!
*
    CRT 'Supply Project Build (YYYYNN), GA release (RXX) or Service pack (RXX.NNN)':
    INPUT DIR.TO.CREATE
    DIR.TO.CREATE := '.BP'

    OPEN DIR.TO.CREATE TO F.TEMP THEN
        CRT 'Clearing....':DIR.TO.CREATE
        MY.CMD = 'CLEAR.FILE ' : DIR.TO.CREATE
    END ELSE
        CRT 'Creating....':DIR.TO.CREATE
        MY.CMD = 'CREATE.FILE DATA ' : DIR.TO.CREATE : ' TYPE=UD'
    END
    CRT
    CRT 'Continue? (Y)':
    INPUT GO.OR.NOT
    IF UPCASE(GO.OR.NOT) <> 'Y' THEN
        STOP
    END
    CRT MY.CMD
    EXECUTE MY.CMD CAPTURING THE.OUTPUT
*
* Need to check that the file is now there, and empty
* !!!
    OPEN DIR.TO.CREATE TO BP ELSE
        FATAL.MSG = 'CANT OPEN or create restart directory' : DIR.TO.CREATE
        GOSUB FATAL.ERROR
    END
*
* Now copy all the items over from the source directory
*
    MY.CMD = 'COPY FROM ': PROG.FILE : ' TO ' : DIR.TO.CREATE : ' ALL'
    CRT MY.CMD
    EXECUTE MY.CMD CAPTURING THE.OUTPUT
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Display help and messages>
*** <desc>Displays the help page</desc>
SHOW.HELP:

    CRT '<ebcompile>'
    CRT 'Version ' : EB.COMPILE.VERSION
    CRT 'May be called with an active SELECT list:'
    CRT 'EB.COMPILE directory prog [-args]'
    CRT 'or without:'
    CRT 'EB.COMPILE directory [-args]'
    CRT 'where:'
    CRT 'directory = name of source directory'
    CRT 'prog = the item to be processed'
    CRT '</ebcompile>'
    RETURN

*-----------------------------------------------------------------------------
SHOW.MSG:
    IF SHOW.MSGS THEN
        CRT THIS.MSG
    END
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= PRODUCE.REPORT>
*** <desc>Produce a report of the compilation and standards check</desc>
PRODUCE.REPORT:
* TODO: Need to handle the error list here
* Update the report record for the program
    IF DO.REPORT THEN
        READ R.REPORT FROM F.EB.COMPILE.REPORT, PROG.NAME ELSE R.REPORT = ''

        THIS.GROUP = 'GROUP N/A'
        THIS.PRODUCT = 'PRODUCT N/A'

        R.REPORT<1> = THIS.GROUP
        R.REPORT<2> = THIS.PRODUCT
        IF R.EB.COMPILE.TEXT.COPY = '' THEN       ;* If we couldnt do any checks, let people know
            STDS.WARNINGS.COUNT = 'No standards checks took place'
        END
        INS THE.RATING BEFORE R.REPORT<3,1>       ;* Put this new score at the top
        INS STDS.WARNINGS.COUNT BEFORE R.REPORT<4,1>
        INS J24.WARNINGS.COUNT BEFORE R.REPORT<5,1>
        DEL R.REPORT<3,11>    ;* Only keep the last 10 scores
        DEL R.REPORT<4,11>    ;* Only keep the last 10 scores
        DEL R.REPORT<5,11>    ;* Only keep the last 10 scores
        WRITE R.REPORT ON F.EB.COMPILE.REPORT, PROG.NAME
    END
    IF DO.DOC THEN
        GOSUB CREATE.DOC      ;* Create / update the XML usage docs
    END
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= SHOW.COMPILE.OUTPUT>
SHOW.COMPILE.OUTPUT:
*** <desc>Print the output of the jBASE compiler</desc>

    IF DO.DISPLAY THEN
        FMC = DCOUNT(COMPILE.OUTPUT,@FM)
        FOR I = 1 TO FMC
            CRT COMPILE.OUTPUT<I>
        NEXT I
        IF NOT(ACTIVE.LIST) THEN        ;* If only a single item
            FMC1=DCOUNT(CATALOG.OUTPUT,@FM)       ;* No. of items in catalog output
            FOR I = 1 TO FMC1
                CRT CATALOG.OUTPUT<I>   ;* Print the catalog output
            NEXT I
        END
    END ELSE
        IF PROGRESS.COUNT[2]='00' THEN
            TIME.PASSED = TIME() - TIME.START
            ITEMS.PER.SECOND = PROGRESS.COUNT / TIME.PASSED
            TIME.LEFT = (TOTAL.ITEMS - PROGRESS.COUNT) / ITEMS.PER.SECOND
            CRT PROGRESS.COUNT : ' ' : PROG.NAME : '. ' : TIME.LEFT : ' seconds remaining.'
        END
    END
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= DO.COMPILE>
DO.COMPILE:
*** <desc>Invoke jBASE compiler and do stds checking</desc>
    COMPILE.OUTPUT = ''
    IF COMPILE THEN
        IF NOT(ACTIVE.LIST) THEN
            CRT 'Compile ':
        END
        COMPILE.COMMAND = "BASIC ":COMPILE.OPTIONS:" ":PROG.FILE:" ":PROG.NAME  ;* BG_100005345/BG_100005610
        EXECUTE COMPILE.COMMAND CAPTURING COMPILE.OUTPUT

        WARNINGS.FROM.JBASE.COMPILER = ''         ;* GB_100011521
        IF INDEX(COMPILE.OUTPUT, 'Warning',1) THEN          ;* Add any warnings from jBASE
            GOSUB PROCESS.JBASE.WARNINGS
        END
    END
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= PROCESS.ARGUMENT>
PROCESS.ARGUMENT:
*** <desc>Work out watch each argument means</desc>
* Use the arguments to only turn on some of the functionality.
* The options are:
* c - compile
* t - catalog
* x - do standards check (JBASE.TEXT.SCAN)
* j - do java compliance check (J24.COMPILE)
* s - score the item (EB.CODE.REVIEW)
* v - verbose
* r - restartable
* R - restart from previous
* p - produce score report
* d - produce xml documentation
* D - Bypass DEBUG checking. Allow Compile for DEBUGGING purposes.

    BEGIN CASE
    CASE THIS.ARG = 'R'
* !!! TO DO - restart processing
    CASE THIS.ARG = 'p'
        DO.REPORT = 1
    CASE THIS.ARG = 'd'
        DO.DOC = 1
        DO.CHECKS = 1         ;* Needs to call JBASE.TEXT.SCAN for this to work

    CASE THIS.ARG = 'r'
        GOSUB CREATE.RESTART.DIR
    CASE THIS.ARG = 'c'       ;* compile
        COMPILE = 1
    CASE THIS.ARG = 't'       ;* catalog
        CATALOG=1
    CASE THIS.ARG = 'x'       ;* checks
        DO.CHECKS = 1
    CASE THIS.ARG = 's'       ;* score
        DO.SCORE = 1
    CASE THIS.ARG = 'y'
        TURN.COMO.OFF = 0     ;* !!! TO DO
    CASE THIS.ARG = 'i'
        NO.MINUSI = 1         ;* !!! TO DO
    CASE THIS.ARG = 'D'
* DO everything apart from the DEBUG test.
        GOSUB SET.ALL.CHECKS
        DO.DEBUG.CHECK = 0
    CASE 1
        CRT 'Invalid argument "':THIS.ARG:'" supplied. Ignoring.'
    END CASE
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= define xml tags>
DEFINE.XML.TAGS:
*** <desc>Set the tags that we will use for the XML output</desc>
*
* List the tags that we will wrap around the code review results from EB.CODE.REVIEW
*
    CODE.REVIEW.TAGS = ''
    CODE.REVIEW.TAGS<-1> = 'totalsize'
    CODE.REVIEW.TAGS<-1> = 'paragraphsize'
    CODE.REVIEW.TAGS<-1> = 'nestedconditions'
    CODE.REVIEW.TAGS<-1> = 'conditionsize'
    CODE.REVIEW.TAGS<-1> = 'gotocount'
    CODE.REVIEW.TAGS<-1> = 'nonstandard'
    CODE.REVIEW.TAGS<-1> = 'labelcount'
    CODE.REVIEW.TAGS<-1> = 'commentcount'
    CODE.REVIEW.TAGS<-1> = 'rating'

    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= ADD.TO.CATALOG.LIST>
ADD.TO.CATALOG.LIST:
*** <desc>Add the item to the catalog list</desc>

* If the compile was ok, add to the catalog list of the COMPONENT
    COMPONENT = ''
    READ R.PGM.DATA.CONTROL FROM F.PGM.DATA.CONTROL,'BP>':PROG.NAME THEN
        COMPONENT = TRIM(R.PGM.DATA.CONTROL<5>)   ;* get the component specified in PGM.DATA.CONTROL
    END
    COMPONENT = DOWNCASE(COMPONENT)     ;* change the component to lower case
    IF  COMPONENT = '' THEN   ;* no component is specified in PGM.DATA.CONTROL
        COMPONENT = 'general' ;* then treat the routine as "general" category by default
    END

    LOCATE COMPONENT IN COMPONENT.LIST<1> SETTING COMPT.POS ELSE
        COMPONENT.LIST<COMPT.POS> = COMPONENT
    END
    CATALOG.LIST<COMPT.POS,-1> = PROG.NAME


* IF CATALOG.LIST = '' THEN ;* BG_100005345 s
*   CATALOG.LIST = PROG.NAME
*END ELSE
*  CATALOG.LIST := @FM:PROG.NAME
*END   ;* BG_100005345 e
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name=FATAL.ERROR>
FATAL.ERROR:
    CRT FATAL.MSG
    STOP
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= OPEN.FILES>
OPEN.FILES:
*** <desc>Opens or creates files</desc>
*
* Open or create the report file
*
    FN.EB.COMPILE.REPORT = 'F.EB.COMPILE.REPORT'
    F.EB.COMPILE.REPORT = ''
    OPEN FN.EB.COMPILE.REPORT TO F.EB.COMPILE.REPORT ELSE
        MY.CMD = 'CREATE.FILE DATA ': FN.EB.COMPILE.REPORT : ' 183'   ;* Create the file with a decent modulo!
        EXECUTE MY.CMD CAPTURING CREATE.OUTPUT
        OPEN FN.EB.COMPILE.REPORT TO F.EB.COMPILE.REPORT ELSE
            FATAL.MSG =  'Cannot open or create ' : FN.EB.COMPILE.REPORT : ' ' : CREATE.OUTPUT
            GOSUB FATAL.ERROR
        END
    END
*
* Open or create the doc directory
*
    FN.DOC = 'doc'
    F.DOC = ''
    OPEN FN.DOC TO F.DOC ELSE
        MY.CMD = 'CREATE.FILE DATA ': FN.DOC : ' TYPE=UD'
        EXECUTE MY.CMD CAPTURING CREATE.OUTPUT
        OPEN FN.DOC TO F.DOC ELSE
            FATAL.MSG =  'Cannot open or create ' : FN.DOC : ' ' : CREATE.OUTPUT
            GOSUB FATAL.ERROR
        END
    END
*
* Open PGM.FILE and FILE.CONTROL. We use this to determine the type of the item that we are dealing with
* i.e. template, batch, etc. which is used to update the doc. If we can't open these, then we don't care
* but it means that the doc will not be complete
*
    PGM.FILE.OK = 1
    FILE.CONTROL.OK = 1

    FN.PGM.FILE = 'F.PGM.FILE'
    F.PGM.FILE = ''
    OPEN FN.PGM.FILE TO F.PGM.FILE ELSE
        PGM.FILE.OK = 0
    END

    FN.FILE.CONTROL = 'F.FILE.CONTROL'
    F.FILE.CONTROL = ''
    OPEN FN.FILE.CONTROL TO F.FILE.CONTROL ELSE
        FILE.CONTROL.OK = 0
    END


    FN.PGM.DATA.CONTROL = 'F.PGM.DATA.CONTROL'
    F.PGM.DATA.CONTROL = ''
    OPEN FN.PGM.DATA.CONTROL TO F.PGM.DATA.CONTROL ELSE
        FATAL.MSG =  'Cannot open F.PGM.DATA.CONTROL'       ;* what do we do here?!
        GOSUB FATAL.ERROR
    END


    ERROR.LIST = '' ;* Set up list to save names of any programs which fail compilation
* Get the text to be checked in JBASE.TEXT.SCAN
    R.EB.COMPILE.TEXT = ''    ;* BG_100004133 s
    OPEN 'F.EB.COMPILE.TEXT' TO F.EB.COMPILE.TEXT THEN
        READ R.EB.COMPILE.TEXT FROM F.EB.COMPILE.TEXT,"SYSTEM" ELSE
            R.EB.COMPILE.TEXT = ""
        END
    END
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= DEFINE.PRODUCT.GROUPS>
DEFINE.PRODUCT.GROUPS:
*************************************************************************
* THIS CODE HAS BEEN COMMENTED OUT AS IT IS NOT NEED AT THE MOMENT      *
* THIS MAYBE NEEDED IN THE FUTURE                                       *
*************************************************************************
*
*      PRODUCT.GROUP.NAMES = ''
*      PRODUCT.GROUP.NAMES<-1> = 'accounting'
*      PRODUCT.GROUP.NAMES<-1> = 'amdx'
*      PRODUCT.GROUP.NAMES<-1> = 'financial'
*      PRODUCT.GROUP.NAMES<-1> = 'infrastructure'
*      PRODUCT.GROUP.NAMES<-1> = 'lending'
*      PRODUCT.GROUP.NAMES<-1> = 'retail'
*      PRODUCT.GROUP.NAMES<-1> = 'securities'
*      PRODUCT.GROUP.NAMES<-1> = 'treasury'
*      PRODUCT.GROUP.NAMES<-1> = 'emerge'
*      PRODUCT.GROUP.NAMES<-1> = 'upgrade'
*      PRODUCT.GROUP.NAMES<-1> = 'other'
*
*      PRODUCT.GROUPS = ''
*      PRODUCT.GROUPS<-1> = 'AC AT CO EU IA IC LI MB MC MI PC PM RE ST TX'
*      PRODUCT.GROUPS<-1> = 'AM AMF AMM AMP AMV DX'
*      PRODUCT.GROUPS<-1> = 'CM DC DD DE FT LC MD NR'
*      PRODUCT.GROUPS<-1> = 'AR BA BC CI DM EB DT GA GB IB IM OF OO PW TS TK'
*      PRODUCT.GROUPS<-1> = 'DL EM FA FD LD LA MG PD SA SL'
*      PRODUCT.GROUPS<-1> = 'ATM AA AZ BL CC TT'
*      PRODUCT.GROUPS<-1> = 'CF CH ET MF RP RT SC'
*      PRODUCT.GROUPS<-1> = 'FR FX FXAT MM ND SW TR LM'
*      PRODUCT.GROUPS<-1> = 'EM'
*      PRODUCT.GROUPS<-1> = 'upgrade'
*      PRODUCT.GROUPS<-1> = 'NEW'
*      CONVERT ' ' TO @VM IN PRODUCT.GROUPS
*      NO.OF.PRODUCT.GROUPS = DCOUNT(PRODUCT.GROUP.NAMES,@FM)
    RETURN
***</region>
*-----------------------------------------------------------------------------
*** <region name= CREATE.DOC>
CREATE.DOC:
*************************************************************************
* THIS CODE HAS BEEN COMMENTED OUT AS IT IS NOT NEEDED AT THE MOMENT    *
* THIS MAYBE NEEDED IN THE FUTURE                                       *
*************************************************************************

**** <desc>Create / update the XML usage docs</desc>
*
**
** For the doc production loop through the items that are being used
** and produce the XML report for this program.
**
** We also need to update the table records for those tables that we are performing
** operations on, and the program items for those that we are calling so that we have a two way link
**
*      R.DOC = ''
*
*      FOR I = 1 TO NO.OF.OPERS ; * Loop through each of the operations that are being performed
*         R.DOC<I> = '<' : DOWNCASE(OPERS<I>) : '>' ; * produce the tag : READ -> <read>
*         R.DOC<I> :='<item>' : THE.DOC<I> ; * add in the items  to the doc
*
**
** Now we need to go through the items that we are using, and update the "other" record, so that
** we have a two way link, i.e. the calling program has a list of items that it calls, and the
** subroutines that are being called have a list of the programs that are calling it.
**
*         TEMP.DOC = THE.DOC<I>
*         LOOP
*            REMOVE THIS.ITEM FROM TEMP.DOC SETTING THIS.MARK
*         WHILE THIS.ITEM:THIS.MARK
*            IF THIS.ITEM THEN
*               DOC.KEY = THIS.ITEM ; * The table or routine in question
*               IS.TABLE = 0
*               IF OPERS<I> <> 'CALL' THEN ; * if it is an IO operation then we change the item to refer to the table
*                  DOC.KEY = THIS.ITEM : '_TABLE'
*                  IS.TABLE = 1
*               END
*               DOC.KEY :='.xml'
*               READ R.OTHER.DOC FROM F.DOC, DOC.KEY ELSE
*                  R.OTHER.DOC = "<?xml-stylesheet type='text/xsl' href='../xsl/doc.xsl'?><report><id>" : THIS.ITEM : '</id>'
*                  IF IS.TABLE THEN
*                  R.OTHER.DOC:= '<type>Table</type>'
*                  END
*                  R.OTHER.DOC:= '</report>' ; * create a new "empty" record
*               END
**
** Change the tag so that we have the two way link, i.e. readby, writeby, etc. and add the item in
**
*TO.ADD = '<' : DOWNCASE(OPERS<I>) : 'by>' : PROG.NAME:'</' : DOWNCASE(OPERS<I>) : 'by>' :
**
** Now check whether the item is in the record already (don't want duplicates) and if not insert it
** into the xml
**
*      IF NOT(INDEX(R.OTHER.DOC,TO.ADD,1)) THEN
*         INSERT.POS = INDEX(R.OTHER.DOC,'</id>',1)+4
*         R.OTHER.DOC = R.OTHER.DOC[1,INSERT.POS] : TO.ADD : R.OTHER.DOC[INSERT.POS+1,99999]
**
** And then write it out
**
*         WRITE R.OTHER.DOC ON F.DOC, DOC.KEY
*      END
*   END
*   REPEAT
*   CHANGE @VM TO '</item><item>' IN R.DOC<I>
*   R.DOC<I> :='</item>'
*   R.DOC<I> := '</' : DOWNCASE(OPERS<I>) : '>'
*   NEXT I
**
** Now produce the report for the item that we are actually processing!
** Read in the xml as it may have been populated by the xref processing..
**
*READ R.OLD.DOC FROM F.DOC, PROG.NAME : '.xml' THEN
*END.OF.ID = INDEX(R.OLD.DOC,'</id>',1)+4
*R.OLD.DOC = R.OLD.DOC[END.OF.ID,9999999]
*END ELSE
*R.OLD.DOC = '</report>'
*END
*   R.DOC.OUT = "<?xml-stylesheet type='text/xsl' href='../xsl/doc.xsl'?><report><id>":PROG.NAME:'</id>'
*   IF PGM.FILE.OK AND FILE.CONTROL.OK THEN
*      READ R.PGM.FILE FROM F.PGM.FILE, PROG.NAME ELSE R.PGM.FILE = ''
*      READ R.FILE.CONTROL FROM F.FILE.CONTROL, PROG.NAME ELSE R.FILE.CONTROL = ''
*      THE.PARENT = ''
*      THE.TYPE = ''
*      BEGIN CASE
*         CASE R.FILE.CONTROL
*            THE.TYPE = 'Application'
*            THE.PARENT = 'T24.template'
*         CASE R.PGM.FILE<1> = 'B'
*            THE.TYPE = 'CoB'
*            THE.PARENT = 'T24.cob'
*
*         CASE 1
*            THE.TYPE = 'Subroutine'
*            THE.PARENT = 'T24'
*      END CASE
*      R.DOC.OUT := '<type>':THE.TYPE:'</type><inherits>':THE.PARENT:'</inherits>'
*   END
*   *
*   * !!! TODO find the argument list and add the arguments to the doc
*   *
*   R.DOC.OUT :='<product>':THIS.PRODUCT:'</product><group>':THIS.GROUP:'</group>'
*   R.DOC.OUT:= CODE.SCORE:R.DOC:R.OLD.DOC
*   CHANGE '<item></item>' TO '' IN R.DOC.OUT ; * Get rid of any blank tags.
*   WRITE R.DOC.OUT ON F.DOC, PROG.NAME : '.xml'
    RETURN
***</region>
*-----------------------------------------------------------------------------
*** <region name= DETERMINE.PRODUCT.GROUP>
DETERMINE.PRODUCT.GROUP:
*************************************************************************
* THIS CODE HAS BEEN COMMENTED OUT AS IT IS NOT NEEDED AT THE MOMENT    *
* THIS MAYBE NEEDED IN THE FUTURE                                       *
*************************************************************************
** For each item, read the PGM.DATA.CONTROL record and determine what we are dealing with
*      PGM.DATA.CONTROL.ID = 'BP>':PROG.NAME
*      READ R.PGM.DATA.CONTROL FROM F.PGM.DATA.CONTROL, PGM.DATA.CONTROL.ID ELSE R.PGM.DATA.CONTROL = ''
*
*      THIS.PRODUCT = R.PGM.DATA.CONTROL<1>
*      IF R.PGM.DATA.CONTROL = '' THEN
*         THIS.PRODUCT = 'NEW'   ;* Assume it is a new progam
*      END
*      THIS.GROUP = ''
*      BEGIN CASE
*         CASE THIS.PRODUCT MATCHES(OBSOLETE.PRODUCTS)  ;* Obsolete
*            THIS.GROUP = ''
*         CASE PROG.NAME[1,5] = 'CONV.'         ;* Conversion
*            THIS.GROUP = 'upgrade'
*         CASE PROG.NAME[1,5] = 'CORR.'         ;* Correction
*            THIS.GROUP = 'upgrade'
*         CASE 1          ;* It's a real boy - need to find the product in the group.
*            GROUP.NO = 0
*            FOUND.GROUP = 0
*            LOOP
*
*            UNTIL GROUP.NO >= NO.OF.PRODUCT.GROUPS OR FOUND.GROUP
*               GROUP.NO +=1
*               LOCATE THIS.PRODUCT IN PRODUCT.GROUPS<GROUP.NO,1> SETTING GROUP.POS THEN
*                  THIS.GROUP = PRODUCT.GROUP.NAMES<GROUP.NO>
*                  FOUND.GROUP = 1
*               END
*
*            REPEAT
*      END CASE
*      IF THIS.GROUP = '' THEN
*         THIS.MSG =  'No product group found. Item is obsolete'
*         GOSUB SHOW.MSG
*         GROUP.NO = ''
*      END ELSE
*
*         LOCATE THIS.GROUP IN PRODUCT.GROUP.NAMES<1> SETTING GROUP.NO ELSE GROUP.NO = 11 ; * For items that are not done in the scan
*         THIS.MSG =  'Product group : ' : THIS.GROUP
*         GOSUB SHOW.MSG
*
*      END
    RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= SET.ALL.CHECKS>
SET.ALL.CHECKS:
*** <desc>Set all the checks to process.</desc>
    COMPILE = 1
    CATALOG = 1
    DO.CHECKS = 1
    DO.J24 = 1
    DO.SCORE = 1
    DO.DISPLAY = 1
    SHOW.MSGS = 1
    DO.REPORT = 1
    DO.DOC = 1
    TURN.COMO.OFF = 1
    DO.DEBUG.CHECK = 1
    RETURN
*** </region>
