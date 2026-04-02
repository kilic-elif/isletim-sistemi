@echo off
cd /d "%~dp0"
color 0B
echo ==============================================
echo [BILGI] Elif OS Native Edition Derleniyor...
echo ==============================================

:: Eger eski surum arkada gizlice acik kaldiysa onu zorla kapat (Overwrite hatasini onler)
taskkill /f /im os_kernel_elif.exe >nul 2>&1

:: C# Derleyicisini Bul
set CSC="%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
IF NOT EXIST %CSC% set CSC="%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe"

echo Adim 1: Modern Masaustu Bilesenleri Native EXE formatina cevriliyor...
%CSC% /nologo /target:winexe /out:os_kernel_elif.exe os_ui.cs

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ==============================================
    echo [HATA] KOD DERLENEMEDI! Lutfen ekran goruntusu alin.
    echo ==============================================
    pause
    exit
)

echo.
echo ==============================================
echo [BASARILI] Yeni Isletim Sistemi Baslatiliyor...
echo ==============================================
echo.
timeout /t 1 /nobreak > nul

start os_kernel_elif.exe
exit
