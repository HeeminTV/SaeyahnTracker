@ECHO OFF
CLS
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

:: PROGRAM INFORMATION (DO NOT EDIT THIS) ::
SET "SY_APPNAME=SaeyahnTracker"
SET "SY_VERSION=DEV VERSION"
SET "SY_EXT=.sy;.sytm"
SET "SY_APPCONFIGPATH=!APPDATA!\SaeyahnTracer-Rewritten"
SET /A "SY_MODULE_TRACKER_VER=0x0000"
SET /A "SY_MODULE_FORMAT_VER=0x0000"

:: REGISTER EXTENSIONS ::
FOR %%A IN (!SY_EXT!) DO (
	ASSOC %%A=SaeyahnTrackerModule%%A 2>NUL >NUL
	FTYPE SaeyahnTrackerModule%%A="%~0" "%%1" 2>NUL >NUL
)

:: UHH I DON'T KNOW WHAT EXACTLY THESE DO BUT IT IS REQUIRED
SET "WHILE=FOR /L %%Z IN (1 1 16) DO IF DEFINED DO.WHILE"
SET "WHILE=SET DO.WHILE=1&!WHILE! !WHILE! !WHILE! !WHILE! !WHILE! "
SET "BREAK=SET "DO.WHILE=""

:: LOAD / CREATE CONFIGURATION ::
REM -- COLOR, PATTERNS --
SET "SYCONFIG_COLOR_PATBG=24;34;51"
SET "SYCONFIG_COLOR_CHTBG=64;64;96"
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

REM -- OTHERS --
SET "SYCONFIG_TERMINAL-ISH_MODE=BREAK"

IF NOT EXIST "!SY_APPCONFIGPATH!\config.txt" (
	MKDIR "!SY_APPCONFIGPATH!" 2>NUL >NUL
	CALL :SAVE_CONFIG
)

FOR /F "USEBACKQ TOKENS=1,2 DELIMS==" %%A IN ("!SY_APPCONFIGPATH!\config.txt") DO SET "%%A=%%B"

:: CHECK DEPENDENCIES ::
RWIB.EXE 2>NUL >NUL
IF !ERRORLEVEL! EQU 9009 (
	CALL :MSGBOX "Couldn't find RWIB installed! Please download RWIB and put in the same directory with this tracker or in the one of the directories of PATH! Press OK to go to the download page." 16 1
	IF !TEMPVARI00! EQU 1 START https://github.com/HeeminTV/RWIB/releases
	EXIT /B 1
)

:: ARGUMENT HANDLER ::
SET "SY_CURRMODULE=%~1"
CALL :NEW_SONG
IF EXIST "!SY_CURRMODULE!" CALL :LOAD_MODULE

:: DRAW_TRACKER should be called when:
REM -- Loaded new song
REM -- Song playback has begun / stopped
REM -- Closed any kinds of dialogue
REM -- Rows / Pattern count has been changed in any ways (Appending / resize etc)
REM -- TRACKER_MODE got updated
:DRAW_TRACKER
CALL :UPDATE_PATTERN_COUNTER
ECHO [H[0m[48;2;!SYCONFIG_COLOR_MJTAB!m[38;2;!SYCONFIG_COLOR_MTTXT!m┌[7m[F7][27m─ Main Tab ──────────────────────────────────────────────────────────────────────────────────────────────────────┐ 
ECHO └──[7m[O][27m_Open──[7m[S][27m_Save──[7m[C][27m_Save as──[7m[T][27m_Configuration / About─────────────────────────────────────────────────────────┘ 
ECHO [3;0H[48;2;!SYCONFIG_COLOR_SITAB!m[38;2;!SYCONFIG_COLOR_SITXT!m┌[7m[F3][27m─ Song Information ──────────────────────────────────────────────────────────────────────────────────────────────┐[11;11HTracker Version !SY_VERSION![12;1H└──  You are in [5m!TRACKER_MODE![25m─────────────────────────────────────────────────────────────────────────────────────┘ 
FOR /L %%A IN (4,1,11) DO ECHO [%%A;1H│[%%A;119H│ 
ECHO [4;48H[7m[B][27m_BPM        : !SYMODULE_TEMPO![5;48H[7m[R][27m_Rows       : !SYMODULE_ROWS![6;48H[7m[H][27m_Highlight  : !SYMODULE_HIGHLIGHT![7;48H[7m[S][27m_Edit Step  : !EDITSTEP![4;72H[7m[S][27m_Song Title :[5;72H[7m[S][27m_Song Author:[4m[4;89H                             [5;89H                             [4;89H!SYMODULE_SONGTITLE![5;89H!SYMODULE_SONGAUTHOR![24m
CALL :DRAW_LOGO_IN 4 4
ECHO [13;1H[48;2;!SYCONFIG_COLOR_CHTBG!m[38;2;!SYCONFIG_COLOR_CTTXT!m┌[7m[F1][27m─ Tracker Section ─────────────────────────────────────────────────────────────────────────────────────────┐[14;1H├──[7m[A][27m_Samples──[7m[\][27m_Frames──────────┬─┬────────────────┬─┬────────────────┬─┬────────────────┬─┬────────────────┤
FOR /L %%A IN (1,1,6) DO (
	SET /A "TEMPVARI01=((%%A - 1) * 19) + 1"
	ECHO [15;!TEMPVARI01!H│ Channel %%A  ___ │:[16;!TEMPVARI01!H│----------------│-
)
!SYCONFIG_TERMINAL-ISH_MODE!

%WHILE% (
	
)

:: FUNCTIONS (CALL ONLY) ::
:NEW_SONG
SET "SYMODULE_TEMPO=150"
SET "SYMODULE_ROWS=64"
SET "SYMODULE_HIGHLIGHT=4"
SET "SYMODULE_SONGTITLE=New song"
SET "SYMODULE_SONGAUTHOR=Jack"
FOR /L %%A IN (0, 1, 255) DO SET "SYMODULE_PAT%%A="
CALL :RESET
CALL :CREATE_PATTERN 0
CALL :UPDATE_PATTERN_COUNTER
GOTO :EOF

:RESET
SET "EDITSTEP=1"
SET "CURSOR_X=0"
SET "CURSOR_ROWS=0"
SET "TRACKER_MODE=Tracker section  "
GOTO :EOF

REM PATTERN_COUNTER
:UPDATE_PATTERN_COUNTER
SET "PATTERN_COUNTER=0"
FOR /L %%A IN (0, 1, 255) DO IF DEFINED "SYMODULE_PAT%%A" SET /A "PATTERN_COUNTER+=1"
GOTO :EOF

:CREATE_PATTERN #
SET "SYMODULE_PAT%~1="
FOR /L %%A IN (0, 1, !SYMODULE_ROWS!) DO (
	FOR /L %%B IN (0, 1, 5) DO SET "SYMODULE_PAT%~1=!SYMODULE_PAT%~1!____________"
	SET "SYMODULE_PAT%~1=!SYMODULE_PAT%~1!;"
)
GOTO :EOF

REM 00
:DELETE_PATTERN #
IF NOT DEFINED SYMODULE_PAT%~1 GOTO :EOF
FOR /L %%A IN (1, 1, !PATTERN_COUNTER!) DO (
	SET /A "TEMPVARI00=%%A - 1"
	IF %%A GEQ %~1 SET "SYMODULE_PAT!TEMPVARI00!=!SYMODULE_PAT%%A!"
)
GOTO :EOF

REM 00 01
:SET_ROWS TARGET
IF %~1 EQU !SYMODULE_ROWS! GOTO :EOF
FOR /L %%A IN (0, 1, 255) DO IF DEFINED "SYMODULE_PAT%%A" (
	IF %~1 LSS !SYMODULE_ROWS! (
		SET "TEMPVARI00=0"
		SET "TEMPVARI01="
		FOR %%B IN (!SYMODULE_PAT%%A!) DO (
			IF !TEMPVARI00! LSS %~1 SET "TEMPVARI01=!TEMPVARI01!%%B;"
			SET /A "TEMPVARI00+=1"
		)
		SET "SYMODULE_PAT%%A=!TEMPVARI01"
	) ELSE (
		SET /A "TEMPVARI01=%~1 - SYMODULE_ROWS"
		FOR /L %%B IN (1, 1, !TEMPVARI01!) DO (
			FOR /L %%C IN (0, 1, 5) DO SET "SYMODULE_PAT%%A=!SYMODULE_PAT%%A!____________"
			SET "SYMODULE_PAT%%A=!SYMODULE_PAT%%A!;"
		)
	)
)
SET "SYMODULE_ROWS=%~1"
GOTO :EOF

REM 00 01 02 03 04 05
:DRAW_LOGO_IN X Y
FOR /F "TOKENS=1,2,3 DELIMS=;" %%A IN ("!SYCONFIG_COLOR_LBASE!") DO (
	SET /A "TEMPVARI00=%%A / 2,TEMPVARI01=%%B / 2,TEMPVARI02=%%C / 2"
	SET /A "TEMPVARI03=TEMPVARI00 / 6,TEMPVARI04=TEMPVARI01 / 6,TEMPVARI05=TEMPVARI02 / 6"
)
ECHO [%~2;%~1H[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m________________\[38;2;!SYCONFIG_COLOR_LGTXT!mSAEYAHN[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m/________________ 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [%~1G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m^|                \     /                ^| 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [%~1G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m^|____ _____ _____ \   / _____ _   _ _   ^| 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [%~1G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m    ^| ^|   ^| ^|      \ /  ^|   ^| ^|   ^| ^|\  ^| 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [%~1G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m    ^| ^|___^| ^|____   ^|   ^|___^| ^|___^| ^| \ ^| 
SET /A "TEMPVARI00+=TEMPVARI03,TEMPVARI01+=TEMPVARI04,TEMPVARI02+=TEMPVARI05"
ECHO [%~1G[38;2;!TEMPVARI00!;!TEMPVARI01!;!TEMPVARI02!m    │ │   │ │       │   │   │ │   │ │  \│ 
ECHO [%~1G[38;2;!SYCONFIG_COLOR_LBASE!m╙───┘ ┴   ┴ └────  ─┴─  ┴   ┴ ┴   ┴ ┴   ┴ 
GOTO :EOF

REM 00
:SAVE_CONFIG
ECHO ; SaeyahnTracker configuration file > "!SY_APPCONFIGPATH!\config.txt"
FOR /F "TOKENS=*" %%A IN ('SET') DO (
	SET "TEMPVARI00=%%A"
	IF "!TEMPVARI00:~0,8!"=="SYCONFIG" (ECHO %%A) >> "!SY_APPCONFIGPATH!\config.txt"
)
GOTO :EOF

REM 00 01
:MSGBOX CONTEXT TYPE BUTTON
SET "TEMPVARI01=!TEMP!\!RANDOM!.VBS"
ECHO WScript.Quit MsgBox("%~1",%~3+%~2,"!SY_APPNAME!") > "!TEMPVARI01!"
WSCRIPT "!TEMPVARI01!"
SET "TEMPVARI00=!ERRORLEVEL!"
DEL /Q "TEMPVARI01" 2>NUL >NUL
GOTO :EOF