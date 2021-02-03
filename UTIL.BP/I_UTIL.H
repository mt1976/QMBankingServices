* UTIL.BP I_UTIL.H
* Common Block
COMMON /UTIL/
              U_INITIALISED,
              FN.UTIL.CONFIG, FV.UTIL.CONFIG,
              FN.UTIL.LOG.EVENT, FV.UTIL.LOG.EVENT,
              U_PROCESS.START.TIME, U_PROCESS.THREAD.ID,U_LOG.SEQ.NO

* Terminal
equate U_BOLD_ON              to    -58
equate U_BOLD_OFF             to    -59
equate U_BLINK_ON             to    -5
equate U_BLINK_OFF            to    -6
equate U_REVERSE_ON           to    -13
equate U_REVERSE_OFF          to    -14
equate U_UNDERLINE_ON         to    -15
equate U_UNDERLINE_OFF        to    -16
equate U_CLEAR_SCREEN         to    -1
equate U_CLEAR_LINE           to    -4
equate U_SET_FG_COLOUR        to    -37  ;* Set foreground colour
equate U_SET_BG_COLOUR        to    -38  ;* Set background colour
* Colours
equate U_COL_BLACK            to     0
equate U_COL_BLUE             to     1
equate U_COL_GREEN            to     2
equate U_COL_CYAN             to     3
equate U_COL_RED              to     4
equate U_COL_MAGENTA          to     5
equate U_COL_BROWN            to     6
equate U_COL_WHITE            to     7
equate U_COL_GREY             to     8
equate U_COL_BRIGHT_BLUE      to     9
equate U_COL_BRIGHT_GREEN     to    10
equate U_COL_BRIGHT_CYAN      to    11
equate U_COL_BRIGHT_RED       to    12
equate U_COL_BRIGHT_MAGENTA   to    13
equate U_COL_YELLOW           to    14
equate U_COL_BRIGHT_WHITE     to    15
* Static's
equate U_SEP                  to    "~"
equate U_SEP_ALT              to    "!"
equate U_TRUNC                to    "-"
equate U_PROP_SEP             to    "="
equate U_PROP_SEP_ALT         to    "|"
equate U_PREF                 to    "M "
equate U_LOGMODE_log4j        to    "log4j"
equate U_LOGMODE_csv          to    "csv"
equate U_LOGMODE_simple       to    "simple"
equate U_MAXIDLEN             to    32
equate U_PREF_SQL_EQ          to    "^"
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
equate DOC_COMMENT            to    "** "
equate DOC_USAGE              to    "* USAGE "
equate DOC_INCLUDE            to    "$INCLUDE "
equate DOC_INSERT             to    "$INSERT "
equate MD$LIST                to    "* "
equate MD$CODE.START          to    "```javascript"
equate MD$CODE.END            to    "```"
equate MD$SUFFIX              to    ".md"
equate MD$CALL                to    "CALL"
equate SUB$PREFIX             to    "{{"
equate SUB$SUFFIX             to    "}}"
* PICK Standard's
equate U_CRT_AM               to    "^"
equate U_CRT_VM               to    "]"
equate U_CRT_SM               to    "\"
equate U_SEP_ID               to    "."
