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
SET "SY_VER=DEV VERSION"
SET "SY_EXT=.sy;.sytm"
SET "SY_APPCONFIGPATH=!APPDATA!\SaeyahnTracer-Rewritten"

TITLE !SY_APPNAME! - !SY_VER!

:: REGISTER EXTENSIONS ::
FOR %%A IN (!SY_EXT!) DO (
	ASSOC %%A=SaeyahnTrackerModule%%A 2>NUL >NUL
	FTYPE SaeyahnTrackerModule%%A="%~0" "%%1" 2>NUL >NUL
)

:: LOAD / CREATE CONFIGUATION ::
REM -- COLOR, PATTERNS --
SET "SYCONFIG_COLOR_PATBG=24;34;51"
SET "SYCONFIG_COLOR_PATH1=54;64;81"
SET "SYCONFIG_COLOR_PATH2=64;84;101"
SET "SYCONFIG_COLOR_CURPV=64;64;192"
SET "SYCONFIG_COLOR_CURRC=128;64;64"
SET "SYCONFIG_COLOR_CHTAB=64;64;96"

REM -- COLOR, CHARACTERS --
SET "SYCONFIG_COLOR_PTTXT=204;204;204"
SET "SYCONFIG_COLOR_CTTXT=204;204;204"
SET "SYCONFIG_COLOR_MTTXT=204;204;204"

REM -- COLOR, OTHERS --
SET "SY_CONFIG_COLOR_MJTAB=8;8;64"

IF NOT EXIST "!SY_APPCONFIGPATH!\config.txt" (
	MKDIR "!SY_APPCONFIGPATH!" 2>NUL >NUL
	CALL :SAVE_CONFIG
)

FOR /F "USEBACKQ TOKENS=1,2 DELIMS==" %%A IN ("!SY_APPCONFIGPATH!\config.txt") DO SET "%%A=%%B"

CALL :DRAW_LOGO_IN 2 0
EXIT /B

:: FUNCTIONS (CALL ONLY) ::
:DRAW_LOGO_IN X Y
ECHO [%~2;%~1H[90m________________\[93mSAEYAHN[90m/________________[0m 
ECHO [%~1G[90m^|                \     /                ^|[0m 
ECHO [%~1G^|____ _____ _____ \   / _____ _   _ _   ^| 
ECHO [%~1G    ^| ^|   ^| ^|      \ /  ^|   ^| ^|   ^| ^|\  ^| 
ECHO [%~1G    ^| ^|___^| ^|____   ^|   ^|___^| ^|___^| ^| \ ^| 
ECHO [%~1G    │ │   │ │       │   │   │ │   │ │  \│ 
ECHO [%~1G[97m╙───┘ ┴   ┴ └────  ─┴─  ┴   ┴ ┴   ┴ ┴   ┴[0m 
GOTO :EOF

REM 00
:SAVE_CONFIG
ECHO ; SaeyahnTracker configuation file > "!SY_APPCONFIGPATH!\config.txt"
FOR /F "TOKENS=*" %%A IN ('SET') DO (
	SET "TEMPVARI00=%%A"
	IF "!TEMPVARI00:~0,8!"=="SYCONFIG" ECHO %%A >> "!SY_APPCONFIGPATH!\config.txt"
)

REM 00 01
:MSGBOX CONTEXT TYPE BUTTON
SET "TEMPVARI01=!TEMP!\!RANDOM!.VBS"
ECHO WScript.Quit MsgBox("%~1",%~3+%~2,"!SY_APPNAME!") > "!TEMPVARI01!"
WSCRIPT "!TEMPVARI01!"
SET "TEMPVARI00=!ERRORLEVEL!"
DEL /Q "TEMPVARI01" 2>NUL >NUL
GOTO :EOF