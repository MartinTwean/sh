rem Kodierung ANSI


@echo off
set path0=%~d0%~P0%
set title0=Backup
set pause0=

REM === HIER ANPASSEN: =============================================================
rem Quelle und Ziel
set "backup_ziel0=c:\_backup\"
set "backup_quelle0=e:\"
REM ================================================================================

REM Pfad zu 7zip
:PROCESSOR_ARCHITECTURE
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto 64bit
	set "Z=%path0%x86\7z.exe"
	goto PROCESSOR_ARCHITECTURE_END

:64bit
	set "Z=%path0%x64\7z.exe"

:PROCESSOR_ARCHITECTURE_END


chcp 437 >nul 2>&1
rem https://www.axel-hahn.de/startseite
rem https://stackoverflow.com/questions/41207496/color-single-lines-of-ascii-characters-with-batch-cmd
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
set "DEL=%%a"
)

echo [0m Hostname:[0m[93m %computername%[0m[98m 
echo [0m ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo [0m º  [93m          Run %title0% in SILENT MODE... shh!       [0m                º
echo [0m ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
chcp 1252 >nul 2>&1


if exist "!backup_ziel0!" goto weiter_1
	mkdir "!backup_ziel0!" >nul 2>&1

:weiter_1

set /a n=0
for /f "tokens=* delims=" %%v in ('dir /b "%backup_quelle0%"') do (
set /a n=n+1
set "file_name0=%%~NXv"
set "folder_name0=!backup_quelle0!"
set "backup_basis0=%backup_ziel0%%%v"
	
	rem set alternativ_pfad0=!alternativ_pfad0:."=!
	rem echo full path: %%~fi
    rem echo drive: %%~di
    rem echo path: %%~pi
    rem echo file name only: %%~ni
    rem echo extension only: %%~xi
    rem echo expanded path with short names: %%~si
    rem echo attributes: %%~ai
    rem echo date and time: %%~ti
    rem echo size: %%~zi
    rem echo drive + path: %%~dpi
    rem echo name.ext: %%~nxi
    rem echo full path + short name: %%~fsi)
    rem echo.
	echo ----------------------------
	echo file_name_!n!: !file_name0!
	echo folder_name_!n!: !folder_name0!
	echo backup_quelle_!n!: !backup_quelle0!
	echo backup_quelle_pfad_!n!: !folder_name0!!file_name0!
	echo backup_basis_!n!: !backup_basis0!
	echo ----------------------------
	echo.
	
	rem set "!backup_basis0!=!backup_basis0: .=.!"
	rem echo !backup_basis0!
	rem pause
	if exist "!backup_basis0!.7z" (
	echo Inkremintell
	echo backup_basis0: !backup_basis0!.7z
	%Z% u -t7z -m0=LZMA2 -mmt=on -mx=9 -md=2048m -mfb=273 -ms=on -ssw -aoa -up0q0r2x2y2z1w2 -ptest -mhe "!backup_basis0!.7z" "!folder_name0!!file_name0!"
	) else (
	echo Create
	echo backup_basis0: !backup_basis0!.7z
	%Z% a -t7z -m0=LZMA2 -mmt=on -mx=9 -md=2048m -mfb=273 -ms=on -ssw -aoa -ptest -mhe "!backup_basis0!.7z" "!folder_name0!!file_name0!"	
	)
)

%pause0%
exit

:get_localdatetime
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%-%MM%-%DD%" & set "timestamp=%HH%%Min%%Sec%" & set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"
goto start0