@echo off
REM Windows 12 Installation Batch Script
REM Run as Administrator

title Windows 12 Setup
color 0B

echo.
echo ========================================
echo    Windows 12 Installation & Customization
echo ========================================
echo.

REM Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Please run this script as Administrator!
    echo Right-click on the batch file and select "Run as Administrator"
    pause
    exit /b 1
)

echo [OK] Running with Administrator privileges
echo.

REM Create backup
echo [STEP 1/5] Creating Registry Backup...
reg export HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer backup.reg
echo [OK] Backup created: backup.reg
echo.

REM Move Taskbar to Top
echo [STEP 2/5] Moving Taskbar to Top...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSide /t REG_DWORD /d 1 /f
echo [OK] Taskbar position changed
echo.

REM Apply Dark Theme
echo [STEP 3/5] Applying Windows 12 Theme...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f
echo [OK] Theme applied
echo.

REM Disable Telemetry Services
echo [STEP 4/5] Disabling Telemetry...
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled
echo [OK] Telemetry services disabled
echo.

REM Check Chocolatey
echo [STEP 5/5] Checking Package Manager...
where choco >nul 2>&1
if %errorLevel% neq 0 (
    echo Installing Chocolatey...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    echo [OK] Chocolatey installed
) else (
    echo [OK] Chocolatey already installed
)
echo.

echo.
echo ========================================
echo    Windows 12 Setup Complete!
echo ========================================
echo.
echo RESTART REQUIRED: Your computer will now restart to apply changes
echo Press any key to restart...
pause
shutdown /r /t 0
