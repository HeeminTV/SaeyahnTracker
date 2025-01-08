@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
SET "VERSIONINFO=DEV. VERSION"
TITLE SaeyahnTracker !VERSIONINFO!	
REM SETLOCAL ENABLEDELAYEDEXPANSION asmogus

echo '##::::::::'#######:::::'###::::'########::'####:'##::: ##::'######::::::::::::::::::
echo  ##:::::::'##.... ##:::'## ##::: ##.... ##:. ##:: ###:: ##:'##... ##:::::::::::::::::
echo  ##::::::: ##:::: ##::'##:. ##:: ##:::: ##:: ##:: ####: ##: ##:::..::::::::::::::::::
echo  ##::::::: ##:::: ##:'##:::. ##: ##:::: ##:: ##:: ## ## ##: ##::'####::::::::::::::::
echo  ##::::::: ##:::: ##: #########: ##:::: ##:: ##:: ##. ####: ##::: ##:::::::::::::::::
echo  ##::::::: ##:::: ##: ##.... ##: ##:::: ##:: ##:: ##:. ###: ##::: ##::'###:'###:'###:
echo  ########:. #######:: ##:::: ##: ########::'####: ##::. ##:. ######::: ###: ###: ###:
echo ........:::.......:::..:::::..::........:::....::..::::..:::......::::...::...::...::
:: banner3-D by Merlin Greywolf merlin@brahms.udel.edu
:: August 9, 1994

set "TEMPFILEPREFIX=!APPDATA!\SaeyahnTracker\SaeyahnTracker_"

IF NOT EXIST "!APPDATA!\SaeyahnTracker\" mkdir "!APPDATA!\SaeyahnTracker\"

echo ^<# : has been brought from https://stackoverflow.com/questions/41132764/detect-keystrokes-in-different-window-with-batch > "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo @echo off ^& setlocal >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo powershell -noprofile "iex (${%%~f0} | out-string)" >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo DEL /Q "!TEMPFILEPREFIX!%%~1.TMP" >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo goto :EOF >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo : end #^> >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo # import GetAsyncKeyState(^) >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo Add-Type user32_dll @' >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo     [DllImport("user32.dll"^)] >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo     public static extern short GetAsyncKeyState(int vKey); >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo '@ -namespace System >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo Add-Type -As System.Windows.Forms >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo function keyPressed($key^) { return [user32_dll]::GetAsyncKeyState([Windows.Forms.Keys]::$key) -band 32768 } >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo while ($true^) { >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo     $enterkey = keyPressed "Enter" >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo     if ($enterkey^) { break } >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo     start-sleep -milliseconds 30 >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo } >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"
echo $Host.UI.RawUI.FlushInputBuffer^(^) >> "!TEMPFILEPREFIX!ENTERDETECT.BAT"

echo WScript.Echo(new Date().getTime()); > "!TEMPFILEPREFIX!UNIXTIME.JS"

echo CreateObject("Wscript.Shell").Run "" ^& WScript.Arguments(0) ^& "", 0, False > "!TEMPFILEPREFIX!INVISIBLE.VBS"

call :RESET_VARIABLES

SET B1=[5m
set B2=[25m
chcp 65001 >nul
mode 120, 30 >nul
:REFRESHALL
FOR /L %%A IN (1, 1, !ROWS!) do IF %%A EQU !ROWS! ( SET "FRAME1=!FRAME1!____________:____________:____________:____________:____________:____________" ) ELSE SET "FRAME1=!FRAME1!____________:____________:____________:____________:____________:____________="
:DRAWLOGO 
SET I=1
:LOOP_FRAMECOUNT
IF DEFINED FRAME!I! (
	SET /A I+=1
	GOTO LOOP_FRAMECOUNT
)
SET /A FRAMES=I-1
REM ECHO !FRAMES!
REM PAUSE
IF !CURR_TAV! EQU 0 (
	SET "DISPLAYED_CURR_TAV=TRACKER  SECTION"
	SET "B1="
	SET "B2="
	SET "B3="
	SET "B4="
	SET "TRACKERDEFAULTCOLOUR=24;34;51"
	SET "TRACKERHIGHLIGHTCOLOUR1=54;64;81"
	SET "TRACKERHIGHLIGHTCOLOUR2=64;84;101"
	SET "TRACKERCURSORPREVIEWCOLOUR=64;64;192"
	SET "TRACKERCURSORRECORDCOLOUR=128;64;64"
	SET "TRACKERTABCOLOUR=64;64;96"
) ELSE (
	CALL :AVERAGEANSICOLOR TRACKERDEFAULTCOLOUR
	CALL :AVERAGEANSICOLOR TRACKERHIGHLIGHTCOLOUR1
	CALL :AVERAGEANSICOLOR TRACKERHIGHLIGHTCOLOUR2
	CALL :AVERAGEANSICOLOR TRACKERCURSORPREVIEWCOLOUR
	CALL :AVERAGEANSICOLOR TRACKERCURSORRECORDCOLOUR
	CALL :AVERAGEANSICOLOR TRACKERTABCOLOUR

	IF !CURR_TAV! EQU 1 ( 
		SET "DISPLAYED_CURR_TAV=SONG INFORMATION"
		SET B1=[5m
		set B2=[25m
		SET "B3="
		SET "B4="
	) ELSE IF !CURR_TAV! EQU 2 ( 
		SET "DISPLAYED_CURR_TAV=MAIN    TABULATE"
		SET "B1="
		SET "B2="
		SET B3=[5m
		SET B4=[25m
	)
)
CLS
CALL :STRLENFIT DISPLAYED_SONGAUTHOR 27 "!SONGAUTHOR!"
CALL :STRLENFIT DISPLAYED_SONGNAME 27 "!SONGNAME!"
echo [0m[48;2;0;0;61m┌[7m[F7][27m─ MAIN TAB ──────────────────────────────────────────────────────────────────────────────────────────────────────┐

ECHO └──[7m!B3![O]!B4![27m_OPEN──[7m!B3![S]!B4![27m_SAVE──[7m!B3![R]!B4![27m_RENDER──[7m!B3![T]!B4![27m_CONFIGURATION──────────────────────────────────────────────────────────────────┘[0m

echo ┌[7m[F3][27m─ SONG INFORMATION ──────────────────────────────────────────────────────────────────────────────────────────────┐

echo │  [90m________________\[93mSAEYAHN[90m/________________[0m	[7m!B1![B]!B2![27m_BPM		: !BPM!	│[7m!B1![T]!B2![27m_SONG TITLE	: [4m!DISPLAYED_SONGNAME![24m │

echo │  [90m^|                \     /                ^|[0m	[7m!B1![R]!B2![27m_ROWS	: !ROWS!	│[7m!B1![A]!B2![27m_AUTHOR	: [4m!DISPLAYED_SONGAUTHOR![24m │

echo │  ^|____ _____ _____ \   / _____ _   _ _   ^|	[7m!B1![H]!B2![27m_HIGHLIGHT	: !HIGHLIGHT!	│

echo │      ^| ^|   ^| ^|      \ /  ^|   ^| ^|   ^| ^|\  ^|	[7m!B1![S]!B2![27m_EDIT STEP^(S^): !EDITSTEPS!	│

echo │      ^| ^|___^| ^|____   ^|   ^|___^| ^|___^| ^| \ ^|

echo │      │ │   │ │       │   │   │ │   │ │  \│

echo │  [97m╙───┘ ┴   ┴ └────  ─┴─  ┴   ┴ ┴   ┴ ┴   ┴[0m

echo │  	Tracker Version !VERSIONINFO!

IF !SONG_PLAYING! EQU 0 (

	ECHO └──  YOU ARE IN [5m[3m!DISPLAYED_CURR_TAV![23m[25m  ───────────────────────────────────────────────────────────────────────────────────┘
			
) ELSE ECHO └──  [5m[3mPLAYING...[23m[25m  ────────────────────────────────────────────────────────────────────────────────────────────────────┘
REM PAUSE
:DRAWTRACKER
echo [12;0H
echo [48;2;!TRACKERTABCOLOUR!m┌[7m[F1][27m─ TRACKER SECTION ─────────────────────────────────────────────────────────────────────────────────────────┐

REM ECHO ├──────────────────────────────────────────────────────────────────────────────────────────────────────────────┤

echo ├──[7m[`][27m_SAMPLES──[7m[\][27m_FRAMES──────────┬─┬────────────────┬─┬────────────────┬─┬────────────────┬─┬────────────────┤

ECHO │ Channel 1  !CH7_STAT_CURRNOTE! │:│ Channel 2  !CH8_STAT_CURRNOTE! │:│ Channel 3  !CH9_STAT_CURRNOTE! │:│ Channel 4  !CH10_STAT_CURRNOTE! │:│ Channel 5  !CH11_STAT_CURRNOTE! │:│ Channel 6  !CH12_STAT_CURRNOTE! │

ECHO │----------------│-│----------------│-│----------------│-│----------------│-│----------------│-│----------------│[48;2;!TRACKERDEFAULTCOLOUR!m

IF !ROWS! LEQ 12 (
	SET SCROLL_MIN=0
) ELSE (
	IF !CURSOR_Y! GEQ 6 ( 
		SET /A SCROLL_MINTEMP=ROWS-6
		IF !CURSOR_Y! GEQ !SCROLL_MINTEMP! ( SET /A SCROLL_MIN=ROWS-13 ) ELSE SET /A SCROLL_MIN=CURSOR_Y-6
	) ELSE SET SCROLL_MIN=0
)
SET /A SCROLL_MAX=SCROLL_MIN+12
set I=0
for /f "tokens=* delims==" %%a in ("!FRAME1!") do for %%b in (%%a) do (
	SET "FRAMESHOWTEMP_ALL="
	IF !I! LSS !SCROLL_MIN! SET /A I+=1
	IF !I! GEQ !SCROLL_MIN! for /f "tokens=1,2,3,4,5,6 delims=:" %%1 in ("%%b") do (
		set "FRAMESHOWTEMP_7=%%1"
		set "FRAMESHOWTEMP_8=%%2"
		set "FRAMESHOWTEMP_9=%%3"
		set "FRAMESHOWTEMP_10=%%4"
		set "FRAMESHOWTEMP_11=%%5"
		set "FRAMESHOWTEMP_12=%%6"	
		FOR /L %%C IN (7, 1, 12) do (
			SET "CH%%C_STAT_CURRNOTE=!!FRAMESHOWTEMP_%%C:~0,3!"
			IF !SONG_PLAYING!!CURR_TAV! EQU 00 (
				IF %%C EQU !FRAMESHOWTEMP_CURSORCH! (
					IF !CURSOR_Y! EQU !i! (		
						REM SET "CH%%C_STAT_CURRNOTE=!!FRAMESHOWTEMP_%%C:~0,3!"
						IF !FRAMESHOWTEMP_CURSORINDEX! EQU 0 ( 
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL![7m!FRAMESHOWTEMP_%%C:~0,3![27m:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!│:│" 
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 1 ( 
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:[7m!FRAMESHOWTEMP_%%C:~3,1![27m!FRAMESHOWTEMP_%%C:~4,1!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!│:│" 
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 2 ( 
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,1![7m!FRAMESHOWTEMP_%%C:~4,1![27m:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!│:│"
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 3 ( 
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:[7m!FRAMESHOWTEMP_%%C:~5,1![27m:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!│:│"
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 4 ( 
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:[7m!FRAMESHOWTEMP_%%C:~6,1![27m!FRAMESHOWTEMP_%%C:~7,2!:!FRAMESHOWTEMP_%%C:~9,3!│:│" 
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 5 ( 
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~7,1![7m!FRAMESHOWTEMP_%%C:~8,1![27m!FRAMESHOWTEMP_%%C:~9,1!:!FRAMESHOWTEMP_%%C:~9,3!│:│" 
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 6 ( 
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,2![7m!FRAMESHOWTEMP_%%C:~8,1![27m:!FRAMESHOWTEMP_%%C:~9,3!│:│"
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 7 (
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:[7m!FRAMESHOWTEMP_%%C:~9,1![27m!FRAMESHOWTEMP_%%C:~10,2!│:│"
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 8 ( 
							SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,1![7m!FRAMESHOWTEMP_%%C:~10,1![27m!FRAMESHOWTEMP_%%C:~11,1!│:│"
						) ELSE IF !FRAMESHOWTEMP_CURSORINDEX! EQU 9 SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,2![7m!FRAMESHOWTEMP_%%C:~11,1![27m│:│"
					) else SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!│:│"
				) ELSE SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!│:│"
			) ELSE SET "FRAMESHOWTEMP_ALL=!FRAMESHOWTEMP_ALL!!FRAMESHOWTEMP_%%C:~0,3!:!FRAMESHOWTEMP_%%C:~3,2!:!FRAMESHOWTEMP_%%C:~5,1!:!FRAMESHOWTEMP_%%C:~6,3!:!FRAMESHOWTEMP_%%C:~9,3!│:│"
		)
		IF !I! GEQ !SCROLL_MIN! IF !I! LEQ !SCROLL_MAX! IF !CURSOR_Y! EQU !I! ( 
			IF !CURSOR_REC! EQU 0 ( 
				ECHO [48;2;!TRACKERCURSORPREVIEWCOLOUR!m│!FRAMESHOWTEMP_ALL:~0,-2! [48;2;!TRACKERDEFAULTCOLOUR!m !i! 
			) ELSE ECHO [48;2;!TRACKERCURSORRECORDCOLOUR!m│!FRAMESHOWTEMP_ALL:~0,-2! [48;2;!TRACKERDEFAULTCOLOUR!m !i! 
			
		) ELSE (
			set /a "FRAMESHOWTEMP_HIGHLIGHT1=!i! %% HIGHLIGHT"
			set /a "FRAMESHOWTEMP_HIGHLIGHT2=!i! %% (HIGHLIGHT*2)"
			IF !FRAMESHOWTEMP_HIGHLIGHT1! NEQ 0 (
				ECHO │!FRAMESHOWTEMP_ALL:~0,-2! [7m !i! [27m
			) ELSE (
				IF !FRAMESHOWTEMP_HIGHLIGHT2! NEQ 0 ( 
					ECHO [48;2;!TRACKERHIGHLIGHTCOLOUR1!m│!FRAMESHOWTEMP_ALL:~0,-2! [7m !i! [27m[48;2;!TRACKERDEFAULTCOLOUR!m 
				) ELSE ECHO [48;2;!TRACKERHIGHLIGHTCOLOUR2!m│!FRAMESHOWTEMP_ALL:~0,-2! [7m !i! [27m[48;2;!TRACKERDEFAULTCOLOUR!m 
			)
		)
		IF !I! GEQ !SCROLL_MAX! GOTO LOOPEXIT1 
	)
	:LOOPEXIT2
	set /a i+=1
) 
:LOOPEXIT1
IF !SONG_PLAYING! EQU 0 (
	powershell "exit($Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode)"
	if !errorlevel! GEQ 112 if !errorlevel! LEQ 121 (
		IF !ERRORLEVEL! EQU 112 SET CURR_TAV=0
		IF !ERRORLEVEL! EQU 114 SET CURR_TAV=1
		IF !ERRORLEVEL! EQU 118 SET CURR_TAV=2
		GOTO DRAWLOGO
	)
	IF !CURR_TAV! EQU 0 (
		if "!errorlevel!"=="40" set /a CURSOR_Y+=!EDITSTEPS!
		if "!errorlevel!"=="38" set /a CURSOR_Y-=!EDITSTEPS!
		IF "!ERRORLEVEL!"=="36" set CURSOR_Y=0
		IF "!ERRORLEVEL!"=="35" SET /A CURSOR_Y=ROWS-1
		if "!errorlevel!"=="34" set /a CURSOR_Y+=!EDITSTEPS! * 4
		if "!errorlevel!"=="33" set /a CURSOR_Y-=!EDITSTEPS! * 4

		if "!errorlevel!"=="39" set /a CURSOR_X+=1
		if "!errorlevel!"=="37" set /a CURSOR_X-=1
		IF "!ERRORLEVEL!"=="9" SET /A CURSOR_X+=10

		IF "!ERRORLEVEL!"=="32" IF !CURSOR_REC! EQU 0 ( SET CURSOR_REC=1 ) ELSE SET CURSOR_REC=0
		IF "!ERRORLEVEL!"=="13" ( 
			IF !SONG_PLAYING! EQU 0 ( 
				BREAK > "!TEMPFILEPREFIX!!UNIX!.TMP"
				SET SONG_PLAYING=1
				START WSCRIPT //NOLOGO "!TEMPFILEPREFIX!INVISIBLE.VBS" ""!TEMPFILEPREFIX!ENTERDETECT.BAT" !UNIX!"
			) ELSE SET SONG_PLAYING=0
			GOTO DRAWLOGO
		)
	) ELSE IF !CURR_TAV! EQU 1 (
		IF !ERRORLEVEL! EQU 66 CALL :SETTINGBOX "BPM" "BPM" 1 330
		IF !ERRORLEVEL! EQU 82 (
			SET TEMPVARI02=!ROWS!
			CALL :SETTINGBOX "number of rows" "TEMPVARI02" 1 100
			IF !TEMPVARI02! LSS !ROWS! (
				REM pause
				set "TEMPVARI03=!FRAME1!"
				SET /A TEMPVARI01=ROWS-TEMPVARI02
				set I=0
				:LOOP_ROWSCOUNT1
				if "!TEMPVARI03!"=="" goto LOOPEXIT3
				for /f "tokens=1* delims==" %%a in ("!TEMPVARI03!") do (
					set /a I+=1
					set "TEMPVARI03=%%b"
				)
				goto LOOP_ROWSCOUNT1

				:LOOPEXIT3
				set /a TEMPVARI05=I-TEMPVARI01
				set "TEMPVARI03=!FRAME1!"
				set "TEMPVARI04="
				for /l %%i in (1,1,!TEMPVARI05!) do for /f "tokens=1* delims==" %%a in ("!TEMPVARI03!") do (
						if "%%i"=="1" ( set "TEMPVARI04=%%a" ) else set "TEMPVARI04=!TEMPVARI04!=%%a"
						set "TEMPVARI03=%%b"
				)
				SET "FRAME1=!TEMPVARI04!"
			) 
			IF !TEMPVARI02! GTR !ROWS! (
				REM pause
				SET /A TEMPVARI01=TEMPVARI02-ROWS
				IF !TEMPVARI01! EQU 1 (
					SET "FRAME1=!FRAME1!=____________:____________:____________:____________:____________:____________"
				) ELSE FOR /L %%A IN (1, 1, !TEMPVARI01!) do (
					REM ECHO %%C
					IF %%A EQU !TEMPVARI01! ( 
						SET "FRAME1=!FRAME1!____________:____________:____________:____________:____________:____________" 
					) ELSE IF %%A EQU 1 (
						SET "FRAME1=!FRAME1!=____________:____________:____________:____________:____________:____________="
					) ELSE SET "FRAME1=!FRAME1!____________:____________:____________:____________:____________:____________="
				)
			)
			SET ROWS=!TEMPVARI02!
			IF !CURSOR_Y! GTR !ROWS! SET /A CURSOR_Y=ROWS-1
		)
		IF !ERRORLEVEL! EQU 83 CALL :SETTINGBOX "edit steps" "EDITSTEPS" 1 !ROWS!
		IF !ERRORLEVEL! EQU 72 CALL :SETTINGBOX "row highlight" "HIGHLIGHT" 1 64
		IF !ERRORLEVEL! EQU 84 CALL :SETTINGBOX "title of this project" "SONGNAME"
		IF !ERRORLEVEL! EQU 65 CALL :SETTINGBOX "author of this project" "SONGAUTHOR"
		goto drawlogo
	)
) ELSE (
	IF NOT EXIST "!TEMPFILEPREFIX!!UNIX!.TMP" (
		SET SONG_PLAYING=0
		REM SET /A CURSOR_Y-=1
		TIMEOUT 0 >NUL
		GOTO DRAWLOGO
	)
	SET /A CURSOR_Y+=1
)

IF !CURSOR_Y! LSS 0 SET /A CURSOR_Y+=ROWS
IF !CURSOR_Y! GEQ !ROWS! SET /A CURSOR_Y-=ROWS



IF !CURSOR_X! LSS 0 SET CURSOR_X=59
IF !CURSOR_X! GTR 59 SET /A CURSOR_X-=60
SET /A "FRAMESHOWTEMP_CURSORCH=(CURSOR_X - 0) / 10 + 7"
SET /A "FRAMESHOWTEMP_CURSORINDEX=CURSOR_X - ((FRAMESHOWTEMP_CURSORCH - 7) * 10)"

GOTO DRAWTRACKER

:RESET_VARIABLES
FOR /F %%A IN ('cscript //nologo "!TEMPFILEPREFIX!UNIXTIME.JS"') DO SET "UNIX=%%A"

SET BPM=165
SET HIGHLIGHT=4
SET ROWS=64
SET "SONGNAME=UNTITLED
SET "SONGAUTHOR=FUCK"
SET EDITSTEPS=1

SET CURR_TAV=0
SET CURR_FRAME=0
REM SET FRAMES=1

SET CURSOR_X=0
SET CURSOR_Y=0
SET CURSOR_REC=0
SET FRAMESHOWTEMP_CURSORCH=7
SET FRAMESHOWTEMP_CURSORINDEX=0

SET SONG_PLAYING=0

SET CH7_STAT_CURRNOTE=___
SET CH8_STAT_CURRNOTE=___
SET CH9_STAT_CURRNOTE=___
SET CH10_STAT_CURRNOTE=___
SET CH11_STAT_CURRNOTE=___
SET CH12_STAT_CURRNOTE=___
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

:AVERAGEANSICOLOR VARINAME
for /f "tokens=1,2,3 delims=;" %%a in ("!%~1!") do (
	:: CACULATES AVERAGE COLOUR
	SET /A "TEMPVARI01=(%%a + %%b + %%c) / 3"
	SET "%~1=!TEMPVARI01!;!TEMPVARI01!;!TEMPVARI01!"
)
GOTO :EOF

:SETTINGBOX
echo [15;30H[44m[93m╔══════════════════════════════════════════════════════════╗

echo [17;30H║  [40m                                                     [44m   ║
call :STRLENFIT TEMPVARI01 57 "Please set %~1..."    
echo [16;30H║ !TEMPVARI01!║

IF "%~4"=="" (
	echo [18;30H║                                                          ║
) ELSE (
	call :STRLENFIT TEMPVARI01 57 "Minimum: %~3, Maximum: %~4"    
	echo [18;30H║ !TEMPVARI01!║
)
echo [19;30H║ Press [7m[ENTER][27m if you're done typing.                     ║

echo [20;30H╚══════════════════════════════════════════════════════════╝
SET /P %~2=[17;33H[40m
IF "%~4" NEQ "" (
	echo !%~2!| findstr /r "^[1-9][0-9]*$">nul
	IF !ERRORLEVEL! NEQ 0 GOTO SETTINGBOX
	IF !%~2! LSS %~3 GOTO SETTINGBOX
	IF !%~2! GTR %~4 GOTO SETTINGBOX
)
GOTO :EOF