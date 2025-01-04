@ECHO OFF
if false==true (
	SET SAEYAHN_CONHOST=1
	CALL CONHOST %0
	EXIT /B
)
SETLOCAL ENABLEDELAYEDEXPANSION
call :RESET_VARIABLES
TITLE SaeyahnTracker Version !VERSIONINFO!
chcp 65001 >nul
mode 120, 30 >nul
REM COLOR 8F

:DRAWLOGO 
SET /A DISPLAYED_MODEY=ROWS+20
REM MODE 120, !DISPLAYED_MODEY!
REM echo [0m
CLS
CALL :STRLENFIT DISPLAYED_SONGAUTHOR 27 "!SONGAUTHOR!"
CALL :STRLENFIT DISPLAYED_SONGNAME 27 "!SONGNAME!"
echo [48;2;0;0;61m┌[7m[F9][27m─ MAIN TAB ──────────────────────────────────────────────────────────────────────────────────────────────────────┐

ECHO └──[7m[O][27m_OPEN──[7m[S][27m_SAVE──[7m[R][27m_RENDER──[7m[C][27m_CHANGE SOUND DRIVER────────────────────────────────────────────────────────────┘[0m
echo ┌[7m[F3][27m─ SONG INFORMATION ──────────────────────────────────────────────────────────────────────────────────────────────┐
echo ^|  ________________\       /________________	[7m[B][27m_BPM		: !BPM!	^|[7m[T][27m_SONG TITLE	: [4m!DISPLAYED_SONGNAME![24m ^|
echo ^|  ^|                \     /                ^|	[7m[R][27m_ROWS	: !ROWS!	^|[7m[A][27m_AUTHOR	: [4m!DISPLAYED_SONGAUTHOR![24m ^|
echo ^|  ^|____ _____ _____ \   / _____ _   _ _   ^|	[7m[H][27m_HIGHLIGHT	: !HIGHLIGHT!	^|
echo ^|      ^| ^|   ^| ^|      \ /  ^|   ^| ^|   ^| ^|\  ^|	[7m[S][27m_EDIT STEP^(S^): !EDITSTEPS!	^|
echo ^|      ^| ^|___^| ^|____   ^|   ^|___^| ^|___^| ^| \ ^|
echo ^|      ^| ^|   ^| ^|       ^|   ^|   ^| ^|   ^| ^|  \^|
echo ^|  ____^| ^|   ^| ^|____   ^|   ^|   ^| ^|   ^| ^|   ^|
echo ^|  	Tracker Version !VERSIONINFO!
ECHO └─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘

:DRAWTRACKER
echo [12;0H
echo [48;2;64;64;96m┌[7m[F1][27m_TRACKER SECTION ──────────────────────────────────────────────────────────────────────────────────────────┐
ECHO ^|   Channel 1    ^|:^|   Channel 2    ^|:^|   Channel 3    ^|:^|   Channel 4    ^|:^|   Channel 5    ^|:^|   Channel 6    ^|
ECHO ^|  Playing !CH1_STAT_CURRNOTE!   ^|:^|  Playing !CH2_STAT_CURRNOTE!   ^|:^|  Playing !CH3_STAT_CURRNOTE!   ^|:^|  Playing !CH4_STAT_CURRNOTE!   ^|:^|  Playing !CH5_STAT_CURRNOTE!   ^|:^|  Playing !CH6_STAT_CURRNOTE!   ^|
ECHO ^|----------------^|:^|----------------^|:^|----------------^|:^|----------------^|:^|----------------^|:^|----------------^|[!TRACKERDEFAULTCOLOUR!
IF !ROWS! LEQ 12 (
	SET SCROLL_MIN=0
) ELSE (
	IF !CURSOR_Y! GEQ 6 ( 
		SET /A SCROLL_MINTEMP=ROWS-6
		IF !CURSOR_Y! GEQ !SCROLL_MINTEMP! ( SET /A SCROLL_MIN=ROWS-13 ) ELSE SET /A SCROLL_MIN=CURSOR_Y-6
	) ELSE SET SCROLL_MIN=0
)
SET /A SCROLL_MAX=SCROLL_MIN+12
set i=0
for /f "tokens=* delims==" %%a in ("!FRAME1!") do for %%b in (%%a) do (
	REM set /a i+=1
	SET "FRAMESHOWTEMP_ALL="
	REM echo %%b !i!
	for /f "tokens=1,2,3,4,5,6 delims=:" %%1 in ("%%b") do (
		
		set "FRAMESHOWTEMP_7=%%1"
		set "FRAMESHOWTEMP_8=%%2"
		set "FRAMESHOWTEMP_9=%%3"
		set "FRAMESHOWTEMP_10=%%4"
		set "FRAMESHOWTEMP_11=%%5"
		set "FRAMESHOWTEMP_12=%%6"
		FOR /L %%C IN (7, 1, 12) do (
			SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|"
		)
		IF !I! GEQ !SCROLL_MIN! IF !I! LEQ !SCROLL_MAX! IF !CURSOR_Y! EQU !I! ( 
			IF !CURSOR_REC! EQU 0 ( 
				ECHO [48;2;64;64;192m^|!FRAMESHOWTEMP_ALL:~0,-2! [!TRACKERDEFAULTCOLOUR! !i! 
			) ELSE ECHO [48;2;127;64;64m^|!FRAMESHOWTEMP_ALL:~0,-2! [!TRACKERDEFAULTCOLOUR! !i! 
			
		) ELSE (
			set /a "FRAMESHOWTEMP_HIGHLIGHT1=!i! %% HIGHLIGHT"
			set /a "FRAMESHOWTEMP_HIGHLIGHT2=!i! %% (HIGHLIGHT*2)"
			IF !FRAMESHOWTEMP_HIGHLIGHT1! NEQ 0 (
				ECHO ^|!FRAMESHOWTEMP_ALL:~0,-2! [7m !i! [27m
			) ELSE (
				IF !FRAMESHOWTEMP_HIGHLIGHT2! NEQ 0 ( 
					ECHO [!TRACKERHIGHLIGHTCOLOUR1!^|!FRAMESHOWTEMP_ALL:~0,-2! [7m !i! [27m[!TRACKERDEFAULTCOLOUR! 
				) ELSE ECHO [!TRACKERHIGHLIGHTCOLOUR2!^|!FRAMESHOWTEMP_ALL:~0,-2! [7m !i! [27m[!TRACKERDEFAULTCOLOUR! 
			)
		)
		IF !I! GEQ !SCROLL_MAX! GOTO LOOPEXIT1 
	)
	set /a i+=1
) 
:LOOPEXIT1
powershell "exit($Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode)"
if "!errorlevel!"=="40" set /a CURSOR_Y+=!EDITSTEPS!
if "!errorlevel!"=="38" set /a CURSOR_Y-=!EDITSTEPS!
IF "!ERRORLEVEL!"=="36" set CURSOR_Y=0
IF "!ERRORLEVEL!"=="35" SET /A CURSOR_Y=ROWS-1
if "!errorlevel!"=="34" set /a CURSOR_Y+=!EDITSTEPS! * 4
if "!errorlevel!"=="33" set /a CURSOR_Y-=!EDITSTEPS! * 4
IF !CURSOR_Y! LSS 0 SET /A CURSOR_Y=ROWS-1
IF !CURSOR_Y! GEQ !ROWS! SET /A CURSOR_Y=0
IF "!ERRORLEVEL!"=="32" IF !CURSOR_REC! EQU 0 ( SET CURSOR_REC=1 ) ELSE SET CURSOR_REC=0
REM ECHO !CURSOR_Y!
REM PAUSE
GOTO DRAWTRACKER

:RESET_VARIABLES
REM SET "COLOR_MENU=87"
SET "FRAME1=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________=____________:____________:____________:____________:____________:____________"
SET "VERSIONINFO=ALPHA VERSION"
SET "TRACKERDEFAULTCOLOUR=48;2;24;34;51m"
SET "TRACKERHIGHLIGHTCOLOUR1=48;2;54;64;81m"
SET "TRACKERHIGHLIGHTCOLOUR2=48;2;64;84;101m"

SET BPM=165
SET HIGHLIGHT=4
SET ROWS=64
SET "SONGNAME=UNTITLED
SET "SONGAUTHOR=FUCK"
SET EDITSTEPS=1
REM SET "

SET CURR_TAV=1
SET CURR_FRAME=0
SET FRAMES=1

SET CURSOR_X=0
SET CURSOR_Y=0
SET CURSOR_REC=0
SET CH1_STAT_CURRNOTE=___
SET CH2_STAT_CURRNOTE=C#3
SET CH3_STAT_CURRNOTE=F#4
SET CH4_STAT_CURRNOTE=C#1
SET CH5_STAT_CURRNOTE=___
SET CH6_STAT_CURRNOTE=___
GOTO :eOF

:STRLENFIT
set "STRLENFIT_TEMPVAR1=%1"
set "STRLENFIT_TEMPVAR2=%2"
shift
shift

set "STRLENFIT_TEMPVAR3="
:STRLENFIT_combineArgs
if "%~1"=="" goto :STRLENFIT_processString
set "STRLENFIT_TEMPVAR3=!STRLENFIT_TEMPVAR3!%~1 "
shift
goto :STRLENFIT_combineArgs

:STRLENFIT_processString
set "STRLENFIT_TEMPVAR3=!STRLENFIT_TEMPVAR3:~0,-1!"
for /l %%a in (0,1,64) do if not "!STRLENFIT_TEMPVAR3:~%%a,1!" == "" set /a STRLENFIT_TEMPVAR4+=1

if !STRLENFIT_TEMPVAR4! gtr !STRLENFIT_TEMPVAR2! (
	set "!STRLENFIT_TEMPVAR1!=!STRLENFIT_TEMPVAR3!
) else (
	set "!STRLENFIT_TEMPVAR1!=!STRLENFIT_TEMPVAR3!"
    set /a STRLENFIT_TEMPVAR5=STRLENFIT_TEMPVAR2 - STRLENFIT_TEMPVAR4
    for /l %%i in (1,1,!STRLENFIT_TEMPVAR5!) do set "!STRLENFIT_TEMPVAR1!=!%STRLENFIT_TEMPVAR1%! "
)
set "STRLENFIT_TEMPVAR1="
set "STRLENFIT_TEMPVAR2="
set "STRLENFIT_TEMPVAR3="
set "STRLENFIT_TEMPVAR4="
set "STRLENFIT_TEMPVAR5="
goto :eof
