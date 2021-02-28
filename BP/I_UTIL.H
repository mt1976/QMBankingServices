** INFORMATION ****************************************************************
*    Insert Name : I_UTIL.H - BP
*           Type : INSERT
*       Filename : n/a
*         Prefix : n/a
** AUDIT **********************************************************************
*   Info Created : YYYYMMDD at HH.MM.SS in DEV by MANUALLY
*                : MANUALLY CREATED
*******************************************************************************
* BP I_UTIL.H
* Common Block
COMMON /UTIL/
              U_INITIALISED,
              FN.UTIL.CONFIG, FV.UTIL.CONFIG,
              FN.UTIL.LOG.EVENT, FV.UTIL.LOG.EVENT,
              U_PROCESS.START.TIME, U_PROCESS.THREAD.ID,U_LOG.SEQ.NO

* Terminal
equate T$BOLD_ON              to    -58
equate T$BOLD_OFF             to    -59
equate T$BLINK_ON             to    -5
equate T$BLINK_OFF            to    -6
equate T$REVERSE_ON           to    -13
equate T$REVERSE_OFF          to    -14
equate T$UNDERLINE_ON         to    -15
equate T$UNDERLINE_OFF        to    -16
equate T$CLEARSCREEN          to    -1
equate T$CLEARLINE            to    -4
equate T$FOREGROUND           to    -37  ;* Set foreground colour
equate T$BACKGROUND           to    -38  ;* Set background colour
equate T$INPUT.PREFIX         to    "M "
* Colours
equate C$BLACK                to     0
equate C$BLUE                 to     1
equate C$GREEN                to     2
equate C$CYAN                 to     3
equate C$RED                  to     4
equate C$MAGENTA              to     5
equate C$BROWN                to     6
equate C$WHITE                to     7
equate C$GREY                 to     8
equate C$BRIGHT_BLUE          to     9
equate C$BRIGHT_GREEN         to    10
equate C$BRIGHT_CYAN          to    11
equate C$BRIGHT_RED           to    12
equate C$BRIGHT_MAGENTA       to    13
equate C$YELLOW               to    14
equate C$BRIGHT_WHITE         to    15
* General Static's
equate U$SEP                  to    "~"
equate U$SEP.ALT              to    "!"
equate U$SEP.ID               to    "."
equate U$SEP.CFG              to    "="
equate U$SEP.CFG.DATA         to    "|"
equate U$ID.MAXLEN            to    32
equate U$ID.SEP               to    "-"
* SQL - Used to 'escape' the = char when stored in a WCT properties file
equate SQL$EQUALS             to    "^"
* Logging
equate L$MODE.log4j           to    "log4j"
equate L$MODE.csv             to    "csv"
equate L$MODE.simple          to    "simple"
* Auto Generating Documentation
equate MD$BR                  to    "  "
equate MD$SUBR                to    "SUBROUTINE"
equate MD$HEADER              to    "INSERT"
equate MD$PRG                 to    "PROGRAM"
equate MD$H1                  to    "# "
equate MD$H2                  to    "## "
equate MD$H3                  to    "### "
equate MD$H4                  to    "#### "
equate MD$TC                  to    "|"
equate MD$TR                  to    " --- "
equate MD$COMMENT             to    "** "
equate MD$USAGE               to    "* USAGE "
equate MD$INCLUDE             to    "$INCLUDE "
equate MD$INSERT              to    "$INSERT "
equate MD$LIST                to    "* "
equate MD$CODE.START          to    "```javascript"
equate MD$CODE.END            to    "```"
equate MD$SUFFIX              to    ".md"
equate MD$CALL                to    "CALL"
* Wildcard Processing
equate WC$PREFIX              to    "{{"
equate WC$SUFFIX              to    "}}"
* WCT Static
equate W$SEP                  to    "|"
equate W$CRLF                 to    " & "
* PICK Standard's
equate T$AM                   to    "^"
equate T$VM                   to    "]"
equate T$SM                   to    "\"
