<# ::
@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
CHCP 65001 >NUL
MODE 120, 30 >NUL
 
:: Copyright (C) 2025 HeeminTV

:: This program is free software; you can redistribute it and/or
:: modify it under the terms of the GNU General Public License
:: as published by the Free Software Foundation; either version 2
:: of the License, or (at your option) any later version.

:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.

:: You should have received a copy of the GNU General Public License
:: along with this program; if not, see <https://www.gnu.org/licenses/>.

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								PROGRAM INFORMATIONS

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

SET "SY_APPNAME=SaeyahnTracker"
SET "SY_VERSION=0.0.-1a"
SET "SY_EXT=.sy;.stm;.sytm"
SET "SY_APPCONFIGPATH=!APPDATA!\SaeyahnTracer-Rewritten"
SET /A "SY_MODULE_FORMAT_VER=0x0000"
SET "SY_APPID=!RANDOM!!RANDOM!"

FOR %%A IN (!SY_EXT!) DO (
	ASSOC %%A=SaeyahnTrackerModule%%A 2>NUL >NUL
	FTYPE SaeyahnTrackerModule%%A="%~0" "%%1" 2>NUL >NUL
)

RWIB.EXE 2>NUL >NUL
IF !ERRORLEVEL! EQU 9009 (
	CALL :R_MSGBOX "Couldn't find RWIB installed! Please download RWIB and put in the same directory with this tracker or in the one of the directories of PATH! Press OK to go to the download page." 16 1
	IF !TEMPVARI00! EQU 1 START https://github.com/HeeminTV/RWIB/releases
	EXIT /B 1
)

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								MACROS

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

SET "WHILE0=FOR /L %%Z IN (1 1 16) DO IF DEFINED DO.WHILE0"
SET "WHILE0=SET DO.WHILE0=1&!WHILE0! !WHILE0! !WHILE0! !WHILE0! !WHILE0! "
SET "BREAK0=SET "DO.WHILE0=""

SET "WHILE1=FOR /L %%Y IN (1 1 16) DO IF DEFINED DO.WHILE1"
SET "WHILE1=SET DO.WHILE1=1&!WHILE1! !WHILE1! !WHILE1! !WHILE1! !WHILE1! "
SET "BREAK1=SET "DO.WHILE1=""

SET "KEYINPUT=powershell "exit($Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode)""
SET "TIMESTAMP=((^!TIME:~0,2^! * 360000) + (((^!TIME:~3,1^! * 10) + ^!TIME:~4,1^!) * 6000) + (((^!TIME:~6,1^! * 10) + ^!TIME:~7,1^!) * 100) + (^!TIME:~9,1^! * 10) + ^!TIME:~10,1^!)"
:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								DEFAULT CONFIGURATION / LOAD CONFIGURATION

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

REM -- COLOR, PATTERNS --
SET "SYCONFIG_COLOR_CHTBG=64;64;96"
SET "SYCONFIG_COLOR_PATBG=24;34;51"
SET "SYCONFIG_COLOR_PATH1=54;64;81"
SET "SYCONFIG_COLOR_PATH2=64;84;101"
SET "SYCONFIG_COLOR_CURPV=64;64;192"
SET "SYCONFIG_COLOR_CURRC=128;64;64"

REM -- COLOR, CHARACTERS --
SET "SYCONFIG_COLOR_PDTXT=180;180;180"
SET "SYCONFIG_COLOR_P1TXT=192;192;192"
SET "SYCONFIG_COLOR_P2TXT=204;204;204"
SET "SYCONFIG_COLOR_CTTXT=204;204;204"
SET "SYCONFIG_COLOR_MTTXT=204;204;204"
SET "SYCONFIG_COLOR_SITXT=204;204;204"
SET "SYCONFIG_COLOR_LGTXT=204;204;204"

REM -- COLOR, OTHERS --
SET "SYCONFIG_COLOR_MJTAB=8;8;64"
SET "SYCONFIG_COLOR_SITAB=0;0;0"
SET "SYCONFIG_COLOR_LBASE=204;204;204"

IF NOT EXIST "!SY_APPCONFIGPATH!\config.txt" (
	MKDIR "!SY_APPCONFIGPATH!" 2>NUL >NUL
	CALL :SAVE_CONFIG
)

FOR /F "USEBACKQ TOKENS=1,2 DELIMS==" %%A IN ("!SY_APPCONFIGPATH!\config.txt") DO SET "%%A=%%B"

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								ARGUMENT HANDLER

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

SET "SY_CURRMODULE=%~1"
CALL :NEW_SONG
IF EXIST "!SY_CURRMODULE!" (
	CALL :LOAD_MODULE
) 
REM ELSE (
	REM CALL :R_MSGBOX "Couldn't load the file from the first argument!" 16 0
	REM EXIT /B 1
REM )
ECHO [2J[0m

:: Should be jumped to DRAW_ALL when one of these happens:
REM -- Song information has changed
REM -- New song loaded
:DRAW_ALL
CALL :MOVE_TO_FRAME "POINTER_UPDATE"

FOR /F "TOKENS=1,2,3 DELIMS=;" %%A IN ("!SYCONFIG_COLOR_LBASE!") DO (
	SET /A "TEMPVARI00=%%A / 2,TEMPVARI01=%%B / 2,TEMPVARI02=%%C / 2"
	SET /A "TEMPVARI03=TEMPVARI00 / 6,TEMPVARI04=TEMPVARI01 / 6,TEMPVARI05=TEMPVARI02 / 6"
)
ECHO [4;4H[0m[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m________________\[38;2;!SYCONFIG_COLOR_LGTXT!mSAEYAHN[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m/________________ 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [4G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m^|                \     /                ^| 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [4G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m^|____ _____ _____ \   / _____ _   _ _   ^| 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [4G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m    ^| ^|   ^| ^|      \ /  ^|   ^| ^|   ^| ^|\  ^| 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [4G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m    ^| ^|___^| ^|____   ^|   ^|___^| ^|___^| ^| \ ^| 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [4G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m    │ │   │ │       │   │   │ │   │ │  \│[10;4H[38;2;!SYCONFIG_COLOR_LBASE!m╙───┘ ┴   ┴ └────  ─┴─  ┴   ┴ ┴   ┴ ┴   ┴[11;11HTracker Version !SY_VERSION!^
[H[0m[48;2;!SYCONFIG_COLOR_MJTAB!m[38;2;!SYCONFIG_COLOR_MTTXT!m┌[7m[F7][27m─ Main Tab ──────────────────────────────────────────────────────────────────────────────────────────────────────┐^
[2;1H└──[7m[N][27m_New──[7m[O][27m_Open──[7m[S][27m_Save──[7m[C][27m_Save as──[7m[R][27m_Render──[7m[M][27m_Export as .xm──[7m[T][27m_Configuration / About─────────────────┘ 

:: Should be jumped to DRAW_TRACKER when one of these happens:
REM -- Closed any kinds of dialogue
REM -- Rows / Pattern count has been changed in any ways (Appending / resize etc)
REM -- TRACKER_MODE got updated
:DRAW_TRACKER
IF !TRACKER_MODE! EQU 2 (
	SET "TEMPVARI00=Samples Selector  [25m"
	SET "TEMPVARI01=Samples  "
	SET "TEMPVARI02=Frames  ─"
) ELSE (
	IF !TRACKER_MODE! EQU 0 SET "TEMPVARI00=Pattern Editor  [25m──"
	IF !TRACKER_MODE! EQU 1 SET "TEMPVARI00=Frame Editor  [25m────"
	IF !TRACKER_MODE! EQU 3 SET "TEMPVARI00=Song Information  [25m"
	IF !TRACKER_MODE! EQU 4 SET "TEMPVARI00=Main Tab  [25m────────"
	SET "TEMPVARI01=Frames  ─"
	SET "TEMPVARI02=Samples  "
)
ECHO [3;1H[48;2;!SYCONFIG_COLOR_SITAB!m[38;2;!SYCONFIG_COLOR_SITXT!m┌[7m[F3][27m─ Song Information ──────────────────────────────────────────────────────────────────────────────────────────────┐^
[12;1H└──  You are in [5m!TEMPVARI00!──────────────────────────────────[4;48H[7m[B][27m_BPM        : !SYMODULE_TEMPO![5;48H[7m[R][27m_Rows       : !SYMODULE_ROWS![6;48H[7m[H][27m_Highlight  : !SYMODULE_HIGHLIGHT![7;48H[7m[S][27m_Edit Step  : !EDITSTEP![4;72H[7m[S][27m_Song Title :[5;72H[7m[S][27m_Song Author:[4m[4;89H                             [5;89H                             [4;89H!SYMODULE_SONGTITLE![5;89H!SYMODULE_SONGAUTHOR![24m[10;1H│[11;1H│ 

FOR /L %%A IN (4,1,9) DO ECHO [%%A;1H│[%%A;119H│ 
FOR /F "TOKENS=1,2,3 DELIMS=;" %%A IN ("!SYCONFIG_COLOR_CHTBG!;!SYCONFIG_COLOR_CTTXT!") DO (
	SET /A "TEMPVARI00=%%A / 2"
	SET /A "TEMPVARI03=%%B / 2"
	SET /A "TEMPVARI04=%%C / 2"
)
ECHO [13;1H[48;2;!SYCONFIG_COLOR_CHTBG!m[38;2;!SYCONFIG_COLOR_CTTXT!m┌[7m[F1][27m─ Tracker Section ─────────────────────────────────────────────┴───────────────────────────────────────────┬─────┤[14;1H├──[7m[\][27m_Patterns / Frames / Samples──┬─┬────────────────┬─┬────────────────┬─┬────────────────┬─┬────────────────┤ PAT │^
[8;78H[48;2;!TEMPVARI00!;!TEMPVARI03!;!TEMPVARI04!m[2m┌─  !TEMPVARI02!────────────────────────────┤[9;69H[48;2;!SYCONFIG_COLOR_CHTBG!m[22m┌─  !TEMPVARI01!─────────────────────────────────────┤[16;115H----│

FOR /L %%A IN (1,1,6) DO (
    SET /A "TEMPVARI01=((%%A - 1) * 19) + 1"
    ECHO [15;!TEMPVARI01!H│ Channel %%A      │:[16;!TEMPVARI01!H│----------------│-
)

SET "EDIT_MACRO=BREAK"
GOTO EDIT

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								EDITING PATTERNS / UPDATE PATTERN

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:EDIT_MODIFIED_PATTERN
SET "TEMPVARI05="
SET "EDIT_MACRO=IF ^!ROWCURR^! EQU ^!CURSOR_ROWS^! ( SET "TEMPVARI05=^!TEMPVARI05^!^!EDIT_BUFFER^!;" ) ELSE ( SET "TEMPVARI05=^!TEMPVARI05^!%%A;" )"

:EDIT
SET /A "TEMPVARI01=SYMODULE_ROWS - 6,TEMPVARI00=FRAME_COUNTER - 1,OCTAVE&=7"
ECHO [48;2;!SYCONFIG_COLOR_CHTBG!m[38;2;!SYCONFIG_COLOR_CTTXT!m[15;116H   │[15;114H!CURSOR_FRAME!/!TEMPVARI00!^
[15;14H___[15;33H___[15;52H___[15;71H___[15;90H___[15;109H___[16;1H

IF !CURSOR_ROWS! LSS 6 (
	SET "DISPLAY_START=0"
) ELSE IF !CURSOR_ROWS! GEQ !TEMPVARI01! (
	SET /A "DISPLAY_START=SYMODULE_ROWS - 13"
) ELSE (
	SET /A "DISPLAY_START=CURSOR_ROWS - 6"
)
SET /A "DISPLAY_END=DISPLAY_START + 12,ROWCURR=-1"
FOR %%A IN (!SYMODULE_PAT%CURSOR_POINTED_FRAME%!) DO SET /A "ROWCURR+=1" & %EDIT_MACRO% & IF !ROWCURR! GEQ !DISPLAY_START! IF !ROWCURR! LEQ !DISPLAY_END! IF !ROWCURR! LSS !SYMODULE_ROWS! (
	SET "ROWCONTEXT=%%A"
	SET /A "TEMPVARI01=^!(ROWCURR %% SYMODULE_HIGHLIGHT) + ^!(ROWCURR %% (SYMODULE_HIGHLIGHT << 1)),TEMPVARI02=((CURSOR_X / 7) * 12) + ((1 - ^!(ROWCURR - CURSOR_ROWS)) * 100),TEMPVARI03=CURSOR_X - ((CURSOR_X / 7) * 7)"
	IF !ROWCURR! EQU !CURSOR_ROWS! (
		IF DEFINED TEMPVARI05 SET "ROWCONTEXT=!EDIT_BUFFER!"
		IF !CURSOR_MODE! EQU 1 (
			SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_CURRC!m[38;2;!SYCONFIG_COLOR_PDTXT!m"
		) ELSE (
			SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_CURPV!m[38;2;!SYCONFIG_COLOR_PDTXT!m"
		)
	) ELSE (
		IF !TEMPVARI01! EQU 2 (
			SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_PATH2!m[38;2;!SYCONFIG_COLOR_P2TXT!m"
		) ELSE IF !TEMPVARI01! EQU 1 (
			SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_PATH1!m[38;2;!SYCONFIG_COLOR_P1TXT!m"
		) ELSE (
			SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_PATBG!m[38;2;!SYCONFIG_COLOR_PDTXT!m"
		)
	)
	
	SET "ROWLINE=!ROWCOLOR!│"
	FOR /L %%B IN (0, 12, 71) DO (
		SET "TEMPVARI00=!ROWCONTEXT:~%%B,12!"
		IF %%B0 EQU !TEMPVARI02!!TRACKER_MODE! (
			IF !TEMPVARI03! EQU 0 (
				SET "ROWLINE=!ROWLINE![7m!TEMPVARI00:~0,3![27m:!TEMPVARI00:~3,2!:!TEMPVARI00:~5,1!:!TEMPVARI00:~6,3!:!TEMPVARI00:~9,3!│:│"
			) ELSE IF !TEMPVARI03! EQU 1 (
				SET "ROWLINE=!ROWLINE!!TEMPVARI00:~0,3!:[7m!TEMPVARI00:~3,2![27m:!TEMPVARI00:~5,1!:!TEMPVARI00:~6,3!:!TEMPVARI00:~9,3!│:│"
			REM ) ELSE IF !TEMPVARI03! EQU 2 (
				REM SET "ROWLINE=!ROWLINE!!TEMPVARI00:~0,3!:!TEMPVARI00:~3,1![7m!TEMPVARI00:~4,1![27m:!TEMPVARI00:~5,1!:!TEMPVARI00:~6,3!:!TEMPVARI00:~9,3!│:│"
			) ELSE IF !TEMPVARI03! EQU 2 (
				SET "ROWLINE=!ROWLINE!!TEMPVARI00:~0,3!:!TEMPVARI00:~3,2!:[7m!TEMPVARI00:~5,1![27m:!TEMPVARI00:~6,3!:!TEMPVARI00:~9,3!│:│"
			) ELSE IF !TEMPVARI03! EQU 3 (
				SET "ROWLINE=!ROWLINE!!TEMPVARI00:~0,3!:!TEMPVARI00:~3,2!:!TEMPVARI00:~5,1!:[7m!TEMPVARI00:~6,1![27m!TEMPVARI00:~7,2!:!TEMPVARI00:~9,3!│:│"
			) ELSE IF !TEMPVARI03! EQU 4 (
				SET "ROWLINE=!ROWLINE!!TEMPVARI00:~0,3!:!TEMPVARI00:~3,2!:!TEMPVARI00:~5,1!:!TEMPVARI00:~6,1![7m!TEMPVARI00:~7,2![27m:!TEMPVARI00:~9,3!│:│"
			) ELSE IF !TEMPVARI03! EQU 5 (
				SET "ROWLINE=!ROWLINE!!TEMPVARI00:~0,3!:!TEMPVARI00:~3,2!:!TEMPVARI00:~5,1!:!TEMPVARI00:~6,3!:[7m!TEMPVARI00:~9,1![27m!TEMPVARI00:~10,2!│:│"
			) ELSE IF !TEMPVARI03! EQU 6 (
				SET "ROWLINE=!ROWLINE!!TEMPVARI00:~0,3!:!TEMPVARI00:~3,2!:!TEMPVARI00:~5,1!:!TEMPVARI00:~6,3!:!TEMPVARI00:~9,1![7m!TEMPVARI00:~10,2![27m│:│"
			)
		) ELSE (
			SET "ROWLINE=!ROWLINE!!TEMPVARI00:~0,3!:!TEMPVARI00:~3,2!:!TEMPVARI00:~5,1!:!TEMPVARI00:~6,3!:!TEMPVARI00:~9,3!│:│"
		)
	)
	IF !TRACKER_MODE! NEQ 0 SET "ROWLINE=[2m!ROWLINE!"
	ECHO !ROWLINE![114G [7m !ROWCURR!  [27m[119G│[0m
)

IF DEFINED TEMPVARI05 (
	SET "SYMODULE_PAT!CURSOR_POINTED_FRAME!=!TEMPVARI05!"
	SET "TEMPVARI05="
	SET "EDIT_MACRO=BREAK"
)

%KEYINPUT%
REM -- GLOBAL
IF !ERRORLEVEL! GEQ 112 IF !ERRORLEVEL! LEQ 118 (
	IF !ERRORLEVEL! EQU 112 SET "TRACKER_MODE=0"
	IF !ERRORLEVEL! EQU 114 SET "TRACKER_MODE=3"
	IF !ERRORLEVEL! EQU 118 SET "TRACKER_MODE=4"
	GOTO DRAW_TRACKER
)
REM -- PATTERN EDITOR
IF !TRACKER_MODE! EQU 0 (
	IF !ERRORLEVEL! EQU 38 SET /A "CURSOR_ROWS-=EDITSTEP"
	IF !ERRORLEVEL! EQU 40 SET /A "CURSOR_ROWS+=EDITSTEP"
	IF !ERRORLEVEL! EQU 36 SET "CURSOR_ROWS=0"
	IF !ERRORLEVEL! EQU 35 SET /A "CURSOR_ROWS=SYMODULE_ROWS - 1"
	IF !ERRORLEVEL! EQU 33 SET /A "CURSOR_ROWS-=SYMODULE_HIGHLIGHT"
	IF !ERRORLEVEL! EQU 34 SET /A "CURSOR_ROWS+=SYMODULE_HIGHLIGHT"

	IF !ERRORLEVEL! EQU 39 SET /A "CURSOR_X+=1"
	IF !ERRORLEVEL! EQU 37 SET /A "CURSOR_X-=1"
	IF !ERRORLEVEL! EQU 9 SET /A "CURSOR_X=((CURSOR_X + 7) / 7) * 7"

	IF !CURSOR_ROWS! LSS 0 (
		SET /A "CURSOR_ROWS+=SYMODULE_ROWS"
		CALL :MOVE_TO_FRAME "PREV"
	)
	IF !CURSOR_ROWS! GEQ !SYMODULE_ROWS! (
		SET /A "CURSOR_ROWS-=SYMODULE_ROWS"
		CALL :MOVE_TO_FRAME "NEXT"
	)
	IF !CURSOR_ROWS! LSS 0 SET "CURSOR_ROWS=0"
	IF !CURSOR_ROWS! GEQ !SYMODULE_ROWS! SET /A "CURSOR_ROWS=SYMODULE_ROWS - 1"

	IF !CURSOR_X! LSS 0 SET /A "CURSOR_X+=42"
	IF !CURSOR_X! GEQ 42 SET /A "CURSOR_X-=42"

	IF !ERRORLEVEL! EQU 32 SET /A "CURSOR_MODE=^!CURSOR_MODE"
	IF !ERRORLEVEL! EQU 13 CALL :PLAY "%~0"

	IF !ERRORLEVEL! EQU 220 (
		SET "CURSOR_FRTAB=0"
		SET "TRACKER_MODE=1"
		GOTO DRAW_TRACKER
	)
	
	REM -- Notes
	IF !TEMPVARI03! EQU 0 (
		IF !ERRORLEVEL! EQU 90 SET "EDIT_BUFFER=3C-0"
		IF !ERRORLEVEL! EQU 83 SET "EDIT_BUFFER=3C#0"
		IF !ERRORLEVEL! EQU 88 SET "EDIT_BUFFER=3D-0"
		IF !ERRORLEVEL! EQU 68 SET "EDIT_BUFFER=3D#0"
		IF !ERRORLEVEL! EQU 67 SET "EDIT_BUFFER=3E-0"
		IF !ERRORLEVEL! EQU 86 SET "EDIT_BUFFER=3F-0"
		IF !ERRORLEVEL! EQU 71 SET "EDIT_BUFFER=3F#0"
		IF !ERRORLEVEL! EQU 66 SET "EDIT_BUFFER=3G-0"
		IF !ERRORLEVEL! EQU 72 SET "EDIT_BUFFER=3G#0"
		IF !ERRORLEVEL! EQU 78 SET "EDIT_BUFFER=3A-0"
		IF !ERRORLEVEL! EQU 74 SET "EDIT_BUFFER=3A#0"
		IF !ERRORLEVEL! EQU 77 SET "EDIT_BUFFER=3B-0"
		
		IF !ERRORLEVEL! EQU 81 SET "EDIT_BUFFER=3C-1"
		IF !ERRORLEVEL! EQU 188 SET "EDIT_BUFFER=3C-1"
		IF !ERRORLEVEL! EQU 50 SET "EDIT_BUFFER=3C#1"
		IF !ERRORLEVEL! EQU 76 SET "EDIT_BUFFER=3C#1"
		IF !ERRORLEVEL! EQU 87 SET "EDIT_BUFFER=3D-1"
		IF !ERRORLEVEL! EQU 190 SET "EDIT_BUFFER=3D-1"
		IF !ERRORLEVEL! EQU 51 SET "EDIT_BUFFER=3D#1"
		IF !ERRORLEVEL! EQU 186 SET "EDIT_BUFFER=3D#1"
		IF !ERRORLEVEL! EQU 69 SET "EDIT_BUFFER=3E-1"
		IF !ERRORLEVEL! EQU 191 SET "EDIT_BUFFER=3E-1"
		IF !ERRORLEVEL! EQU 82 SET "EDIT_BUFFER=3F-1"
		IF !ERRORLEVEL! EQU 53 SET "EDIT_BUFFER=3F#1"
		IF !ERRORLEVEL! EQU 84 SET "EDIT_BUFFER=3G-1"
		IF !ERRORLEVEL! EQU 54 SET "EDIT_BUFFER=3G#1"
		IF !ERRORLEVEL! EQU 89 SET "EDIT_BUFFER=3A-1"
		IF !ERRORLEVEL! EQU 55 SET "EDIT_BUFFER=3A#1"
		IF !ERRORLEVEL! EQU 85 SET "EDIT_BUFFER=3B-1"
		
		IF !ERRORLEVEL! EQU 73 SET "EDIT_BUFFER=3C-2"
		IF !ERRORLEVEL! EQU 57 SET "EDIT_BUFFER=3C#2"
		IF !ERRORLEVEL! EQU 79 SET "EDIT_BUFFER=3D-2"
		IF !ERRORLEVEL! EQU 48 SET "EDIT_BUFFER=3D#2"
		IF !ERRORLEVEL! EQU 80 SET "EDIT_BUFFER=3E-2"
		IF !ERRORLEVEL! EQU 219 SET "EDIT_BUFFER=3F-2"
		IF !ERRORLEVEL! EQU 221 SET "EDIT_BUFFER=3G-2"
		
		IF !SAMPLE_COUNTER! NEQ 0 IF !CURSOR_SAMPLE! LSS 10 ( SET "EDIT_BUFFER=5!EDIT_BUFFER:~1,3!0!CURSOR_SAMPLE!" ) ELSE ( SET "EDIT_BUFFER=5!EDIT_BUFFER:~1,3!!CURSOR_SAMPLE!" )
		
		CALL :EDIT_PATTERN
	)
	
	REM IF NOT "!EDIT_BUFFER!"=="" (
		REM SET "TEMPVARI00=0"
		REM SET "TEMPVARI02="
		REM SET /A "TEMPVARI03=((CURSOR_X >> 3) * 12)"
		REM FOR %%A IN (!SYMODULE_PAT%CURSOR_POINTED_FRAME%!) DO (
			REM IF !TEMPVARI00! EQU !CURSOR_ROWS! (
				REM SET "TEMPVARI01=%%A"
				REM FOR /L %%B IN (0, 12, 71) DO (
					REM SET "TEMPVARI04=!TEMPVARI01:~%%B,12!"
					REM IF %%B EQU !TEMPVARI03! (
						REM IF "!EDIT_BUFFER:~0,1!"=="0" SET "TEMPVARI02=!TEMPVARI02!!EDIT_BUFFER:~1,3!!TEMPVARI04:~3,9!"
					REM ) ELSE (
						REM IF "!EDIT_BUFFER:~0,1!"=="0" SET "TEMPVARI02=!TEMPVARI02!!TEMPVARI04!"
					REM )
				REM )
				REM SET "TEMPVARI02=!TEMPVARI02!;"
			REM ) ELSE (
				REM SET "TEMPVARI02=!TEMPVARI02!%%A;"
			REM )
			REM SET /A "TEMPVARI00+=1"
		REM )
		REM SET "EDIT_BUFFER="
		REM SET "SYMODULE_PAT!CURSOR_ROWS!=!TEMPVARI02!"
	REM )

REM -- FRAME EDITOR
) ELSE IF !TRACKER_MODE! EQU 1 (
	IF !ERRORLEVEL! EQU 220 (
		SET "CURSOR_FRTAB=0"
		SET "TRACKER_MODE=2"
		GOTO DRAW_TRACKER
	)

	IF !CURSOR_FRTAB! EQU 0 (
		IF !ERRORLEVEL! EQU 39 SET /A "CURSOR_FRAME+=1"
		IF !ERRORLEVEL! EQU 37 SET /A "CURSOR_FRAME-=1"
		IF !ERRORLEVEL! EQU 38 SET /A "CURSOR_FRAME+=16"
		IF !ERRORLEVEL! EQU 40 SET /A "CURSOR_FRAME-=16"

		IF !CURSOR_FRAME! LSS 0 SET /A "CURSOR_FRAME+=FRAME_COUNTER"
		IF !CURSOR_FRAME! GEQ !FRAME_COUNTER! SET /A "CURSOR_FRAME-=FRAME_COUNTER"		
		IF !CURSOR_FRAME! LSS 0 SET "CURSOR_FRAME=0"
		IF !CURSOR_FRTAB! GEQ !FRAME_COUNTER! SET /A "CURSOR_FRAME=FRAME_COUNTER - 1"
		
		IF !ERRORLEVEL! EQU 13 SET "CURSOR_FRTAB=1"
	) ELSE (
		IF !ERRORLEVEL! EQU 37 SET /A "CURSOR_FRTAB-=1"
		IF !ERRORLEVEL! EQU 39 SET /A "CURSOR_FRTAB+=1"
		
		IF !CURSOR_FRTAB! LSS 1 SET "CURSOR_FRTAB=6"
		IF !CURSOR_FRTAB! GTR 6 SET "CURSOR_FRTAB=1"
		
		IF !ERRORLEVEL! EQU 13 (
			REM -- INS
			IF !CURSOR_FRTAB! EQU 1 (
				CALL :INSERT_FRAME !CURSOR_FRAME!
				SET /A "CURSOR_FRAME+=1"
			REM -- SET
			) ELSE IF !CURSOR_FRTAB! EQU 2 (
				CALL :DRAW_FRAME_EDITOR
				CALL :R_INSERT_NUMBER !TEMPVARI00! !TEMPVARI01! !CURSOR_POINTED_FRAME!
				IF NOT DEFINED SYMODULE_PAT!TEMPVARI00! CALL :MAKE_BLANK_PATTERN !TEMPVARI00!
				CALL :MODIFY_FRAME !CURSOR_FRAME! !TEMPVARI00!
				CALL :DELETE_UNUSED_PATTERN
			REM -- SRW
			) ELSE IF !CURSOR_FRTAB! EQU 3 (
				%WHILE0% (
					CALL :MOVE_TO_FRAME "POINTER_UPDATE"
					CALL :R_INSERT_NUMBER !TEMPVARI00! !TEMPVARI01! !CURSOR_POINTED_FRAME!
					IF !ERRORLEVEL! EQU 0 (
						IF NOT DEFINED SYMODULE_PAT!TEMPVARI00! CALL :MAKE_BLANK_PATTERN !TEMPVARI00!
						CALL :MODIFY_FRAME !CURSOR_FRAME! !TEMPVARI00!
						CALL :INSERT_FRAME !CURSOR_FRAME!
						SET /A "CURSOR_FRAME+=1"
					) ELSE (
						%BREAK0%
					)
				)
				CALL :DELETE_UNUSED_PATTERN
			REM -- DUP
			) ELSE IF !CURSOR_FRTAB! EQU 4 (
				CALL :INSERT_FRAME !CURSOR_FRAME!
				SET "SYMODULE_PAT!TEMPVARI00!=!SYMODULE_PAT%CURSOR_POINTED_FRAME%!"
			REM -- REM
			) ELSE IF !CURSOR_FRTAB! EQU 5 (
				IF !FRAME_COUNTER! NEQ 1 CALL :DELETE_FRAME !CURSOR_FRAME!
				CALL :DELETE_UNUSED_PATTERN
			REM -- X
			) ELSE IF !CURSOR_FRTAB! EQU 6 (
				SET "CURSOR_FRTAB=0"
			)
		)
	)

	CALL :MOVE_TO_FRAME "POINTER_UPDATE"
	
REM -- SAMPLE EDITOR
) ELSE IF !TRACKER_MODE! EQU 2 (
	IF !ERRORLEVEL! EQU 220 (
		SET "TRACKER_MODE=0"
		GOTO DRAW_TRACKER
	)
)
GOTO EDIT

:: FUNCTIONS (CALL ONLY) ::
:NEW_SONG
CALL :RESET
SET "SYMODULE_TEMPO=150"
SET "SYMODULE_HIGHLIGHT=4"
SET "SYMODULE_FRAME=0;"
SET "SYMODULE_SONGTITLE=New song"
SET "SYMODULE_SONGAUTHOR=Jack"

SET "SAMPLE_COUNTER=0"
SET "FRAME_COUNTER=0"
CALL :SET_ROWS 64
FOR /L %%A IN (0, 1, 99) DO SET "SYMODULE_PAT%%A="

CALL :MAKE_BLANK_PATTERN 0
CALL :UPDATE_FRAME_COUNTER
GOTO :EOF

:RESET
SET "EDITSTEP=1"
SET "OCTAVE=3"
SET "CURSOR_FRAME=0"
SET "CURSOR_X=0"
SET "CURSOR_ROWS=0"
SET "CURSOR_MODE=0"
SET "CURSOR_SAMPLE=-1"
SET "TRACKER_MODE=0"

REM 0 = FRAMES
REM 1 = INS
REM 2 = MOV
REM 3 = SET
REM 4 = DUP
REM 5 = REM
REM 6 = X
SET "CURSOR_FRTAB=0"
SET "CURSOR_SPTAB=-1"
GOTO :EOF

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								SONG PLAYBACK

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:PLAY PATH_OF_THIS_SCRIPT
SET "CURSOR_ROWS=0"
SET /A "BPMMS=1500 / SYMODULE_TEMPO"
ECHO !SY_APPID! > "!SY_APPCONFIGPATH!\!SY_APPID!.stat"
START /MIN powershell -c "iex ((Get-Content '%~1') -join [Environment]::Newline); iex 'main \"!SY_APPCONFIGPATH!\!SY_APPID!.stat\"'"
TIMEOUT 0 >NUL
SET /A "PREVDELAY=%TIMESTAMP%"
%WHILE1% (
	SET /A "TEMPVARI01=SYMODULE_ROWS - 6,TEMPVARI00=FRAME_COUNTER - 1"
	ECHO [48;2;!SYCONFIG_COLOR_CHTBG!m[38;2;!SYCONFIG_COLOR_CTTXT!m[15;116H   │[15;114H!CURSOR_FRAME!/!TEMPVARI00![16;1H
	IF !CURSOR_ROWS! LSS 6 (
		SET "DISPLAY_START=0"
	) ELSE IF !CURSOR_ROWS! GEQ !TEMPVARI01! (
		SET /A "DISPLAY_START=SYMODULE_ROWS - 13"
	) ELSE (
		SET /A "DISPLAY_START=CURSOR_ROWS - 6"
	)
	SET /A "DISPLAY_END=DISPLAY_START + 12,ROWCURR=-1"
	FOR /F "TOKENS=*" %%A IN ("!CURSOR_POINTED_FRAME!") DO FOR %%B IN (!SYMODULE_PAT%%A!) DO SET /A "ROWCURR+=1" & IF !ROWCURR! GEQ !DISPLAY_START! IF !ROWCURR! LEQ !DISPLAY_END! IF !ROWCURR! LSS !SYMODULE_ROWS! (
		SET "ROWCONTEXT=%%B"
		SET /A "TEMPVARI01=^!(ROWCURR %% SYMODULE_HIGHLIGHT) + ^!(ROWCURR %% (SYMODULE_HIGHLIGHT << 1))"
		IF !ROWCURR! EQU !CURSOR_ROWS! (
			SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_CURPV!m[38;2;!SYCONFIG_COLOR_PDTXT!m"
		) ELSE (
			IF !TEMPVARI01! EQU 2 (
				SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_PATH2!m[38;2;!SYCONFIG_COLOR_P2TXT!m"
			) ELSE IF !TEMPVARI01! EQU 1 (
				SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_PATH1!m[38;2;!SYCONFIG_COLOR_P1TXT!m"
			) ELSE (
				SET "ROWCOLOR=[48;2;!SYCONFIG_COLOR_PATBG!m[38;2;!SYCONFIG_COLOR_PDTXT!m"
			)
		)
		
		ECHO !ROWCOLOR!│!ROWCONTEXT:~0,3!:!ROWCONTEXT:~3,2!:!ROWCONTEXT:~5,1!:!ROWCONTEXT:~6,3!:!ROWCONTEXT:~9,3!│:│^
!ROWCONTEXT:~12,3!:!ROWCONTEXT:~15,2!:!ROWCONTEXT:~17,1!:!ROWCONTEXT:~18,3!:!ROWCONTEXT:~21,3!│:│^
!ROWCONTEXT:~24,3!:!ROWCONTEXT:~27,2!:!ROWCONTEXT:~29,1!:!ROWCONTEXT:~30,3!:!ROWCONTEXT:~33,3!│:│^
!ROWCONTEXT:~36,3!:!ROWCONTEXT:~39,2!:!ROWCONTEXT:~41,1!:!ROWCONTEXT:~42,3!:!ROWCONTEXT:~45,3!│:│^
!ROWCONTEXT:~48,3!:!ROWCONTEXT:~51,2!:!ROWCONTEXT:~53,1!:!ROWCONTEXT:~54,3!:!ROWCONTEXT:~57,3!│:│^
!ROWCONTEXT:~60,3!:!ROWCONTEXT:~63,2!:!ROWCONTEXT:~65,1!:!ROWCONTEXT:~66,3!:!ROWCONTEXT:~69,3!│ [7m !ROWCURR!  [27m[119G│
	)
	SET /A "TEMPVARI00=%TIMESTAMP% - PREVDELAY"
	IF !TEMPVARI00! GEQ 1500 (
		BREAK
	) ELSE IF !TEMPVARI00! GEQ !BPMMS! (
		IF NOT EXIST "!SY_APPCONFIGPATH!\!SY_APPID!.stat" %BREAK1%
		SET /A "CURSOR_ROWS+=TEMPVARI00 / BPMMS,PREVDELAY=%TIMESTAMP%"
		IF !CURSOR_ROWS! GEQ !SYMODULE_ROWS! (
			SET /A "CURSOR_ROWS-=SYMODULE_ROWS"
			CALL :MOVE_TO_FRAME "NEXT"
		)
	) ELSE (
		BREAK
	)
)
TIMEOUT 1 >NUL
GOTO :EOF

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								FRAME MANAGEMENT

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

REM 00 01 02
:INSERT_FRAME #
SET "TEMPVARI00=-1"
FOR /L %%A IN (99, -1, 0) DO IF NOT DEFINED SYMODULE_PAT%%A SET "TEMPVARI00=%%A"
CALL :MAKE_BLANK_PATTERN !TEMPVARI00!
SET "TEMPVARI01="
SET "TEMPVARI02=0"
FOR %%A IN (!SYMODULE_FRAME!) DO (
	IF !TEMPVARI02! EQU %~1 (
		SET "TEMPVARI01=!TEMPVARI01!%%A;!TEMPVARI00!;"
	) ELSE (
		SET "TEMPVARI01=!TEMPVARI01!%%A;"
	)
	SET /A "TEMPVARI02+=1"
)
SET "SYMODULE_FRAME=!TEMPVARI01!"
CALL :UPDATE_FRAME_COUNTER
GOTO :EOF

REM 00 01
:DELETE_FRAME #
SET "TEMPVARI00=0"
SET "TEMPVARI01="
FOR %%A IN (!SYMODULE_FRAME!) DO (
	IF !TEMPVARI00! NEQ %~1 SET "TEMPVARI01=!TEMPVARI01!%%A;"
	SET /A "TEMPVARI00+=1"
)
SET "SYMODULE_FRAME=!TEMPVARI01!"
CALL :UPDATE_FRAME_COUNTER
IF !CURSOR_FRAME! GEQ !FRAME_COUNTER! CALL :MOVE_TO_FRAME "PREV"
GOTO :EOF

REM 00 01
:MODIFY_FRAME # TO
SET "TEMPVARI00=0"
SET "TEMPVARI01="
FOR %%A IN (!SYMODULE_FRAME!) DO (
	IF !TEMPVARI00! EQU %~1 (
		SET "TEMPVARI01=!TEMPVARI01!%~2;"
	) ELSE (
		SET "TEMPVARI01=!TEMPVARI01!%%A;"
	)
	SET /A "TEMPVARI00+=1"
)
SET "SYMODULE_FRAME=!TEMPVARI01!"
GOTO :EOF

REM 00
:MOVE_TO_FRAME PREV/NEXT/POINTER_UPDATE/#
IF "%~1"=="PREV" (
	IF !CURSOR_FRAME! EQU 0 (
		SET /A "TEMPVARI00=FRAME_COUNTER - 1"
	) ELSE (
		SET /A "TEMPVARI00=CURSOR_FRAME - 1"
	)
) ELSE IF "%~1"=="NEXT" (
	SET /A "TEMPVARI00=FRAME_COUNTER - 1"
	IF !CURSOR_FRAME! EQU !TEMPVARI00! (
		SET "TEMPVARI00=0"
	) ELSE (
		SET /A "TEMPVARI00=CURSOR_FRAME + 1"
	)
) ELSE IF "%~1"=="POINTER_UPDATE" (
	SET "TEMPVARI00=!CURSOR_FRAME!"
	BREAK
) ELSE (
	SET "TEMPVARI00=%~1"
)
SET "CURSOR_FRAME=!TEMPVARI00!"
SET "TEMPVARI00=-1"
FOR %%A IN (!SYMODULE_FRAME!) DO SET /A "TEMPVARI00+=1" & IF !TEMPVARI00! EQU !CURSOR_FRAME! SET "CURSOR_POINTED_FRAME=%%A"
CALL :DRAW_FRAME_EDITOR
GOTO :EOF

REM FRAME_COUNTER
:UPDATE_FRAME_COUNTER
SET "FRAME_COUNTER=0"
FOR %%A IN (!SYMODULE_FRAME!) DO SET /A "FRAME_COUNTER+=1"
GOTO :EOF

REM 00 01 02 03 04 05
:DRAW_FRAME_EDITOR
IF !CURSOR_FRTAB! EQU 1 (
	SET "TEMPVARI00=[7m<INS>[27m  <SET>  <SRW>  <DUP>  <REM>  <X>"
) ELSE IF !CURSOR_FRTAB! EQU 2 (
	SET "TEMPVARI00=<INS>  [7m<SET>[27m  <SRW>  <DUP>  <REM>  <X>"
) ELSE IF !CURSOR_FRTAB! EQU 3 (
	SET "TEMPVARI00=<INS>  <SET>  [7m<SRW>[27m  <DUP>  <REM>  <X>"
) ELSE IF !CURSOR_FRTAB! EQU 4 (
	SET "TEMPVARI00=<INS>  <SET>  <SRW>  [7m<DUP>[27m  <REM>  <X>"
) ELSE IF !CURSOR_FRTAB! EQU 5 (
	SET "TEMPVARI00=<INS>  <SET>  <SRW>  <DUP>  [7m<REM>[27m  <X>"
) ELSE IF !CURSOR_FRTAB! EQU 6 (
	SET "TEMPVARI00=<INS>  <SET>  <SRW>  <DUP>  <REM>  [7m<X>[27m"
) ELSE (
	SET "TEMPVARI00=<INS>  <SET>  <SRW>  <DUP>  <REM>  <X>"
)
ECHO [48;2;!SYCONFIG_COLOR_CHTBG!m[38;2;!SYCONFIG_COLOR_CTTXT!m[10;69H│                                                 │[11;69H│                                                 │[12;69H┤  !TEMPVARI00!         │[0m
SET "TEMPVARI03=0"
SET "TEMPVARI04=0"
FOR %%A IN (!SYMODULE_FRAME!) DO (
	SET /A "TEMPVARI02=((CURSOR_FRAME >> 4) * ^!(FRAME_COUNTER >> 5)) * 16,TEMPVARI00=((TEMPVARI04 & 15) * 3) + 71"
	IF %%A LSS 10 (
		SET "TEMPVARI05=0%%A"
	) ELSE (
		SET "TEMPVARI05=%%A"
	)
	IF %%A GEQ !TEMPVARI02! IF !TEMPVARI03! LSS 32 (
		IF !TEMPVARI03! LSS 16 (
			SET "TEMPVARI01=10"
		) ELSE (
			SET "TEMPVARI01=11"
		)
		IF !TEMPVARI04! EQU !CURSOR_FRAME! SET "TEMPVARI05=[7m!TEMPVARI05!"
		ECHO [!TEMPVARI01!;!TEMPVARI00!H[48;2;!SYCONFIG_COLOR_CHTBG!m[38;2;!SYCONFIG_COLOR_CTTXT!m!TEMPVARI05![0m
		SET /A "TEMPVARI03+=1"
	)
	
	SET /A "TEMPVARI04+=1"
)
GOTO :EOF

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								PATTERN MANAGEMENT

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

REM 00
:DELETE_UNUSED_PATTERN
FOR /L %%A IN (0, 1, 99) DO IF "!SYMODULE_PAT%%A!"=="!BLANKTABLE!" (
	SET "TEMPVARI00=0"
	FOR %%B IN (!SYMODULE_FRAME!) DO IF %%B EQU %%A SET "TEMPVARI00=1"
	IF !TEMPVARI00! EQU 0 SET "SYMODULE_PAT%%A="
)
GOTO :EOF

:MAKE_BLANK_PATTERN #
SET "SYMODULE_PAT%~1="
FOR /L %%A IN (0, 1, !SYMODULE_ROWS!) DO (
	FOR /L %%B IN (0, 1, 5) DO SET "SYMODULE_PAT%~1=!SYMODULE_PAT%~1!____________"
	SET "SYMODULE_PAT%~1=!SYMODULE_PAT%~1!;"
)
GOTO :EOF

REM 00 01 02
:SET_ROWS TARGET
SET "TEMPVARI02=!SYMODULE_ROWS!"
SET "SYMODULE_ROWS=%~1"
IF "%~1"=="!TEMPVARI02!" GOTO :EOF
CALL :MAKE_BLANK_PATTERN 128
SET "BLANKTABLE=!SYMODULE_PAT128!"
SET "SYMODULE_PAT128="
FOR /L %%A IN (0, 1, 99) DO IF DEFINED "SYMODULE_PAT%%A" (
	IF %~1 LSS !TEMPVARI02! (
		SET "TEMPVARI00=0"
		SET "TEMPVARI01="
		FOR %%B IN (!SYMODULE_PAT%%A!) DO (
			IF !TEMPVARI00! LSS %~1 SET "TEMPVARI01=!TEMPVARI01!%%B;"
			SET /A "TEMPVARI00+=1"
		)
		SET "SYMODULE_PAT%%A=!TEMPVARI01!"
	) ELSE (
		SET /A "TEMPVARI01=%~1 - TEMPVARI02"
		FOR /L %%B IN (1, 1, !TEMPVARI01!) DO (
			FOR /L %%C IN (0, 1, 5) DO SET "SYMODULE_PAT%%A=!SYMODULE_PAT%%A!____________"
			SET "SYMODULE_PAT%%A=!SYMODULE_PAT%%A!;"
		)
	)
)
GOTO :EOF

REM 00 01 02
:EDIT_PATTERN
SET /A "TEMPVARI00=CURSOR_ROWS * 73,TEMPVARI01=CURSOR_X - ((CURSOR_X / 7) * 7)"
IF !TEMPVARI01! EQU 0 (
	SET /A "TEMPVARI02=0 + ((CURSOR_X / 7) * 12)"
) ELSE !TEMPVARI01! EQU 1 (
	SET /A "TEMPVARI02=3 + ((CURSOR_X / 7) * 12)"
) ELSE !TEMPVARI01! EQU 2 (
	SET /A "TEMPVARI02=5 + ((CURSOR_X / 7) * 12)"
) ELSE !TEMPVARI01! EQU 3 (
	SET /A "TEMPVARI02=6 + ((CURSOR_X / 7) * 12)"
) ELSE !TEMPVARI01! EQU 4 (
	SET /A "TEMPVARI02=7 + ((CURSOR_X / 7) * 12)"
) ELSE !TEMPVARI01! EQU 5 (
	SET /A "TEMPVARI02=9 + ((CURSOR_X / 7) * 12)"
) ELSE !TEMPVARI01! EQU 6 (
	SET /A "TEMPVARI02=10 + ((CURSOR_X / 7) * 12)"
)
REM SET /A "TEMPVARI02=(CURSOR_ROWS * 73) - TEMPVARI02 - 1"
SET /A "TEMPVARI03=TEMPVARI00 + (TEMPVARI02 + !EDIT_BUFFER:~0,1!)"
SET "EDIT_BUFFER=!SYMODULE_PAT%CURSOR_POINTED_FRAME%:~%TEMPVARI00%,%TEMPVARI02%!!EDIT_BUFFER:~1!!SYMODULE_PAT%CURSOR_POINTED_FRAME%:~%TEMPVARI00%,%TEMPVARI02%!!SYMODULE_PAT%CURSOR_POINTED_FRAME%:~%TEMPVARI03%!"
GOTO :EOF

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								FILE SYSTEM

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

REM 00 01 02
:SAVE_MODULE PATH
REM -- HEADERS --
DEL /Q "%~1" 2>NUL >NUL
FOR /L %%A IN (0, 1, 396) DO IF NOT "!SYMODULE_FRAME:~%%A,1!"=="" SET "TEMPVARI02=%%A"
SET /A "TEMPVARI00=(SY_MODULE_FORMAT_VER >> 8) & 0xFF,TEMPVARI01=SY_MODULE_FORMAT_VER & 0xFF,TEMPVARI02=(TEMPVARI02 << 7) | SYMODULE_HIGHLIGHT"
RWIB "%~1" WRITE DEC 83 89 84 77 !TEMPVARI00! !TEMPVARI01! !SYMODULE_ROWS! !SYMODULE_TEMPO! !TEMPVARI02! !SAMPLE_COUNTER! 0 0 0 0 0
SET "TEMPVARI00="
SET "TEMPVARI01="
FOR /L %%A IN (0, 1, 31) DO (
	IF "!SYMODULE_SONGTITLE:~%%A,1!"=="" ( SET "TEMPVARI00=!TEMPVARI00! " ) ELSE ( SET "TEMPVARI00=!SYMODULE_SONGTITLE:~%%A,1!" )
	IF "!SYMODULE_SONGAUTHOR:~%%A,1!"=="" ( SET "TEMPVARI01=!TEMPVARI01! " ) ELSE ( SET "TEMPVARI01=!SYMODULE_SONGAUTHOR:~%%A,1!" )
)
RWIB "%~1" WRITE ASCII "!TEMPVARI00!!TEMPVARI01!!SYMODULE_FRAME!"

REM -- PATTERNS --
IF !SYMODULE_ROWS! LEQ 100 (
	FOR /L %%A IN (0, 1, 99) DO IF DEFINED SYMODULE_PAT%%A (
		RWIB "%~1" WRITE DEC %%A
		RWIB "%~1" WRITE ASCII "!SYMODULE_PAT%%A!"
	)
) ELSE (
	FOR /L %%A IN (0, 1, 99) DO IF DEFINED SYMODULE_PAT%%A (
		RWIB "%~1" WRITE DEC %%A
		RWIB "%~1" WRITE ASCII "!SYMODULE_PAT%%A:~0,4096!"
		RWIB "%~1" WRITE ASCII "!SYMODULE_PAT%%A:~4096,4096!"
	)
)
GOTO :EOF

:SAVE_CONFIG
ECHO ; SaeyahnTracker configuration file > "!SY_APPCONFIGPATH!\config.txt"
FOR /F "TOKENS=*" %%A IN ('SET SYCONFIG') DO (ECHO %%A) >>"!SY_APPCONFIGPATH!\config.txt"
GOTO :EOF

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

:: 								USER INPUT INTERFACE

:: --------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------

REM 00 01
:R_MSGBOX CONTEXT TYPE BUTTON
SET "TEMPVARI01=!TEMP!\!RANDOM!.VBS"
ECHO WScript.Quit MsgBox("%~1",%~3 + %~2,"!SY_APPNAME!") > "!TEMPVARI01!"
CSCRIPT //NOLOGO "!TEMPVARI01!"
SET "TEMPVARI00=!ERRORLEVEL!"
DEL /Q "!TEMPVARI01!" 2>NUL >NUL
GOTO :EOF

REM 00 01 02 03 04 05
:R_INSERT_NUMBER X Y DEAFULT
SET "TEMPVARI01=0"
IF %~3 LSS 10 (
	SET "TEMPVARI03=0%~3"
) ELSE (
	SET "TEMPVARI03=%~3"
)
%WHILE1% (
	ECHO [0m[%~2;%~1H[5m[7m!TEMPVARI03![0m
	%KEYINPUT%
	SET "TEMPVARI05=!ERRORLEVEL!"
	IF !TEMPVARI05! LEQ 57 (
		IF !TEMPVARI05! GEQ 48 (
			IF !TEMPVARI01! EQU 0 (
				SET /A "TEMPVARI02=!ERRORLEVEL! - 48"
				SET "TEMPVARI03=0!TEMPVARI02!"
			) ELSE IF !TEMPVARI01! EQU 1 (
				SET /A "TEMPVARI02=!ERRORLEVEL! - 48"
				SET "TEMPVARI03=!TEMPVARI03:~1,1!!TEMPVARI02!"
			)
			SET /A "TEMPVARI01+=1"
			SET "TEMPVARI05=0"
		) ELSE SET "TEMPVARI01=2"
	) ELSE SET "TEMPVARI01=2"
			REM SET /A "TEMPVARI01+=1"
		REM ) ELSE IF !TEMPVARI05! EQU 13 (
			REM SET "TEMPVARI01=2"
		REM ) ELSE IF !TEMPVARI05! EQU 27 (
			REM SET "TEMPVARI01=2"
		REM ) ELSE IF !TEMPVARI05! EQU 37 (
			REM SET "TEMPVARI01=2"
		REM ) ELSE IF !TEMPVARI05! EQU 39 (
			REM SET "TEMPVARI01=2"
		REM )
	REM ) ELSE IF !TEMPVARI05! EQU 220 (
		REM SET "TEMPVARI01=2"
	REM ) ELSE IF !TEMPVARI05! EQU 112 (
		REM SET "TEMPVARI01=2"
	REM ) ELSE IF !TEMPVARI05! EQU 114 (
		REM SET "TEMPVARI01=2"
	REM ) ELSE IF !TEMPVARI05
	
	IF !TEMPVARI01! EQU 2 (
		IF "!TEMPVARI03:~0,1!"=="0" (
			SET "TEMPVARI00=!TEMPVARI03:~1,1!"
		) ELSE (
			SET "TEMPVARI00=!TEMPVARI03!"
		)
		%BREAK1%
	)
)
EXIT /B !TEMPVARI05!

:FILE_DIALOG Load/Save FILTERS
FOR /F "DELIMS=" %%A in ('powershell -command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $f = New-Object System.Windows.Forms.%~1FileDialog; $f.Filter = '%~2'; $f.Multiselect = $false; if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { Write-Host $f.FileName } else { Write-Host 'NONE' }"') DO SET "TEMPVARI00=%%A"
GOTO :EOF

REM 00
REM :MOVE_FRAME_INTERFACE
REM IF !FRAME_COUNTER! EQU 1 GOTO :EOF
REM SET "TEMPVARI00=!CURSOR_FRAME!"
REM %WHILE0% (
	REM FOR /L %%A IN (70, 3, 118) DO ECHO [48;2;!SYCONFIG_COLOR_CHTBG!m[38;2;!SYCONFIG_COLOR_CTTXT!m[10;%%AH [11;%%AH 
REM )
REM GOTO :EOF

#>
# POWERSHELL SECTION
function main
{
param([string] $FilePath)
Add-Type -TypeDefinition @'
	using System;
	using System.Runtime.InteropServices;
	public class User32 {
		[DllImport("user32.dll")]
		public static extern short GetAsyncKeyState(int vKey);
	}
'@
while($true){if([User32]::GetAsyncKeyState(0x0D) -band 0x8000){ Remove-Item -Path $FilePath -Force; break }}
}