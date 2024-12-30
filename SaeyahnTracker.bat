@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
call :RESET_VARIABLES
TITLE SaeyahnTracker Version !VERSIONINFO!
chcp 65001 >nul
mode 120, 30
COLOR 87
REM set /a TEMP_COLOR_R=0x!COLOR_MAINBG:~0,2!
REM set /a TEMP_COLOR_G=0x!COLOR_MAINBG:~2,2!
REM set /a TEMP_COLOR_B=0x!COLOR_MAINBG:~4,2!
REM ECHO [48;2;!TEMP_COLOR_R!;!TEMP_COLOR_G!;!TEMP_COLOR_B!m
REM set /a TEMP_COLOR_R=0x!COLOR_MAINTEXT:~0,2!
REM set /a TEMP_COLOR_G=0x!COLOR_MAINTEXT:~2,2!
REM set /a TEMP_COLOR_B=0x!COLOR_MAINTEXT:~4,2!
REM ECHO [38;2;!TEMP_COLOR_R!;!TEMP_COLOR_G!;!TEMP_COLOR_B!m

echo ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
echo ^|  #################       #################	[7m[B][27m_BPM		: !BPM!	^|
echo ^|  #                #     #                #	[7m[H][27m_HIGHLIGHT	: !HIGHLIGHT!	^|
echo ^|  ##### ##### ##### #   # ##### #   # #   #
echo ^|      # #   # #      # #  #   # #   # ##  #
echo ^|      # ##### #####   #   ##### ##### # # #
echo ^|      # #   # #       #   #   # #   # #  ##
echo ^|  ##### #   # #####   #   #   # #   # #   #
echo ^|  Tracker Version !VERSIONINFO!
ECHO ^|
ECHO └─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
pause

:RESET_VARIABLES
REM SET "COLOR_MENU=87"
SET "VERSIONINFO=ALPHA VERSION"
SET BPM=165
SET HIGHLIGHT=4
GOTO :eOF