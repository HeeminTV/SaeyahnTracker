@ECHO OFF
REM if NOT "%~1"=="FIRSTWINDOW" (
	REM SET SAEYAHN_CONHOST=1
	REM START CONHOST %0 FIRSTWINDOW
	
REM )
SETLOCAL ENABLEDELAYEDEXPANSION
call :RESET_VARIABLES
TITLE SaeyahnTracker Version !VERSIONINFO!
SET B1=[5m
set B2=[25m
chcp 65001 >nul
mode 120, 30 >nul
REM COLOR 8F
SET /A ROWS=0
:DRAWLOGO 
for /f "tokens=* delims==" %%a in ("!FRAME1!") do for %%b in (%%a) DO SET /A ROWS+=1
IF !CURR_TAV! EQU 0 (
	SET "DISPLAYED_CURR_TAV=TRACKER  SECTION"
	SET "B1="
	SET "B2="
	SET "B3="
	SET "B4="
) ELSE IF !CURR_TAV! EQU 1 ( 
	SET "DISPLAYED_CURR_TAV=SONG INFORMATION"
	SET B1=[5m
	set B2=[25m
	SET "B3="
	SET "B4="
) ELSE IF !CURR_TAV! EQU 2 ( 
	SET "DISPLAYED_CURR_TAV=MAIN    TABULATE"
	SET B3=[5m
	set B4=[25m
	SET "B1="
	SET "B2="
)
CLS
CALL :STRLENFIT DISPLAYED_SONGAUTHOR 27 "!SONGAUTHOR!"
CALL :STRLENFIT DISPLAYED_SONGNAME 27 "!SONGNAME!"
echo [48;2;0;0;61m┌[7m[F9][27m─ MAIN TAB ──────────────────────────────────────────────────────────────────────────────────────────────────────┐

ECHO └──[7m!B3![O]!B4![27m_OPEN──[7m!B3![S]!B4![27m_SAVE──[7m!B3![R]!B4![27m_RENDER──[7m!B3![C]!B4![27m_CHANGE SOUND DRIVER────────────────────────────────────────────────────────────┘[0m
echo ┌[7m[F3][27m─ SONG INFORMATION ──────────────────────────────────────────────────────────────────────────────────────────────┐
echo ^|  ________________\       /________________	[7m!B1![B]!B2![27m_BPM		: !BPM!	^|[7m!B1![T]!B2![27m_SONG TITLE	: [4m!DISPLAYED_SONGNAME![24m ^|
echo ^|  ^|                \     /                ^|	[7m!B1![R]!B2![27m_ROWS	: !ROWS!	^|[7m!B1![A]!B2![27m_AUTHOR	: [4m!DISPLAYED_SONGAUTHOR![24m ^|
echo ^|  ^|____ _____ _____ \   / _____ _   _ _   ^|	[7m!B1![H]!B2![27m_HIGHLIGHT	: !HIGHLIGHT!	^|
echo ^|      ^| ^|   ^| ^|      \ /  ^|   ^| ^|   ^| ^|\  ^|	[7m!B1![S]!B2![27m_EDIT STEP^(S^): !EDITSTEPS!	^|
echo ^|      ^| ^|___^| ^|____   ^|   ^|___^| ^|___^| ^| \ ^|
echo ^|      ^| ^|   ^| ^|       ^|   ^|   ^| ^|   ^| ^|  \^|
echo ^|  ____^| ^|   ^| ^|____   ^|   ^|   ^| ^|   ^| ^|   ^|
echo ^|  	Tracker Version !VERSIONINFO!
ECHO └──YOU ARE IN [5m[3m!DISPLAYED_CURR_TAV![23m[25m────────────────────────────────────────────────────────────────────────────────────────┘

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
	SET "FRAMESHOWTEMP_ALL="
	for /f "tokens=1,2,3,4,5,6 delims=:" %%1 in ("%%b") do (
		
		set "FRAMESHOWTEMP_7=%%1"
		set "FRAMESHOWTEMP_8=%%2"
		set "FRAMESHOWTEMP_9=%%3"
		set "FRAMESHOWTEMP_10=%%4"
		set "FRAMESHOWTEMP_11=%%5"
		set "FRAMESHOWTEMP_12=%%6"
		
		IF !I! LSS !SCROLL_MIN! SET /A i+=1
		REM pause >nul
		FOR /L %%C IN (7, 1, 12) do (
			IF %%C EQU !FRAMESHOWTEMP_CURSORCH! (
				IF !CURSOR_Y! EQU !i! (
					IF !FRAMESHOWTEMP_CURSORINDEX! EQU 0 ( 
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL![7m!FRAMESHOWTEMP_%%C:~0,3![27m:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|" 
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 1 ( 
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:[7m!FRAMESHOWTEMP_%%C:~3,1![27m!FRAMESHOWTEMP_%%C:~4,1!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|" 
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 2 ( 
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,1![7m!FRAMESHOWTEMP_%%C:~4,1![27m:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|"
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 3 ( 
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:[7m!FRAMESHOWTEMP_%%C:~5,1![27m:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|"
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 4 ( 
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:[7m!FRAMESHOWTEMP_%%C:~6,1![27m!FRAMESHOWTEMP_%%C:~7,2!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|" 
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 5 ( 
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~7,1![7m!FRAMESHOWTEMP_%%C:~8,1![27m!FRAMESHOWTEMP_%%C:~9,1!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|" 
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 6 ( 
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,2![7m!FRAMESHOWTEMP_%%C:~8,1![27m:!FRAMESHOWTEMP_%%C:~9,3!^|:^|"
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 7 (
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:[7m!FRAMESHOWTEMP_%%C:~9,1![27m!FRAMESHOWTEMP_%%C:~10,2!^|:^|"
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 8 ( 
						SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,1![7m!FRAMESHOWTEMP_%%C:~10,1![27m!FRAMESHOWTEMP_%%C:~11,1!^|:^|"
					) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 9 SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,2![7m!FRAMESHOWTEMP_%%C:~11,1![27m^|:^|"
					REM SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|"
				) else SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|"
			) ELSE ( 
				SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!^|:^|"
			)
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
REM set /a CURSOR_Y+=!EDITSTEPS!
if !errorlevel! GEQ 112 if !errorlevel! LEQ 121 (
	ECHO [0m
	IF !ERRORLEVEL! EQU 112 SET CURR_TAV=0
	IF !ERRORLEVEL! EQU 114 SET CURR_TAV=1
	IF !ERRORLEVEL! EQU 120 SET CURR_TAV=2
	GOTO DRAWLOGO
)
REM ) else 
if "!errorlevel!"=="38" set /a CURSOR_Y-=!EDITSTEPS!
IF "!ERRORLEVEL!"=="36" set CURSOR_Y=0
IF "!ERRORLEVEL!"=="35" SET /A CURSOR_Y=ROWS-1
if "!errorlevel!"=="34" set /a CURSOR_Y+=!EDITSTEPS! * 4
if "!errorlevel!"=="33" set /a CURSOR_Y-=!EDITSTEPS! * 4

IF !CURSOR_Y! LSS 0 SET /A CURSOR_Y+=ROWS
IF !CURSOR_Y! GEQ !ROWS! SET /A CURSOR_Y-=ROWS

if "!errorlevel!"=="39" set /a CURSOR_X+=1
if "!errorlevel!"=="37" set /a CURSOR_X-=1
IF "!ERRORLEVEL!"=="9" SET /A CURSOR_X+=10

IF !CURSOR_X! LSS 0 SET CURSOR_X=59
IF !CURSOR_X! GTR 59 SET /A CURSOR_X-=60
IF "!ERRORLEVEL!"=="32" IF !CURSOR_REC! EQU 0 ( SET CURSOR_REC=1 ) ELSE SET CURSOR_REC=0
IF "!ERRORLEVEL!"=="13" IF !SONG_PLAYING! EQU 0 ( SET SONG_PLAYING=1 ) ELSE SET SONG_PLAYING=0
SET /A "FRAMESHOWTEMP_CURSORCH=(CURSOR_X - 0) / 10 + 7"
SET /A "FRAMESHOWTEMP_CURSORINDEX=CURSOR_X - ((FRAMESHOWTEMP_CURSORCH - 7) * 10)"
REM )
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
REM SET ROWS=64
SET "SONGNAME=UNTITLED
SET "SONGAUTHOR=FUCK"
SET EDITSTEPS=1
REM SET "

SET CURR_TAV=0
SET CURR_FRAME=0
SET FRAMES=1

SET CURSOR_X=0
SET CURSOR_Y=0
SET CURSOR_REC=0
SET FRAMESHOWTEMP_CURSORCH=7
SET FRAMESHOWTEMP_CURSORINDEX=0

SET SONG_PLAYING=0

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
