@echo off
REM Windows 12 Launcher - Main Menu
REM This script provides an easy interface to run installation options

setlocal enabledelayedexpansion

title Windows 12 Installation Launcher
color 0B

:menu
cls
echo.
echo ========================================
echo     WINDOWS 12 INSTALLATION LAUNCHER
echo ========================================
echo.
echo Select an option:
echo.
echo [1] Full Installation (Recommended)
echo      - Move taskbar to top
echo      - Apply Windows 12 theme
echo      - Install development tools
echo      - Optimize system
echo.
echo [2] Quick Setup (Theme Only)
echo      - Move taskbar to top
echo      - Apply theme
echo      - Optimize system
echo      - No tool installation
echo.
echo [3] Install Development Tools
echo      - Visual Studio Code
echo      - Python, Node.js, Git
echo      - VLC, Firefox, Chrome, Docker
echo.
echo [4] Apply Taskbar Only
echo      - Only move taskbar to top
echo.
echo [5] Apply Theme Only
echo      - Only apply dark theme
echo.
echo [6] View Configuration
echo      - Show current settings
echo.
echo [7] Revert Changes
echo      - Restore original settings from backup
echo.
echo [0] Exit
echo.
echo ========================================
echo.
set /p choice="Enter your choice (0-7): "

if "%choice%"=="1" goto fullinstall
if "%choice%"=="2" goto quicksetup
if "%choice%"=="3" goto installtools
if "%choice%"=="4" goto taskbaronly
if "%choice%"=="5" goto themeonly
if "%choice%"=="6" goto viewconfig
if "%choice%"=="7" goto revert
if "%choice%"=="0" goto exit
echo Invalid choice. Please try again.
timeout /t 2 >nul
goto menu

:fullinstall
cls
echo.
echo ========================================
echo     STARTING FULL INSTALLATION
echo ========================================
echo.
echo This will:
echo  1. Move taskbar to TOP
echo  2. Apply Windows 12 theme
echo  3. Install Chocolatey
echo  4. Install development tools
echo  5. Optimize system
echo  6. Restart computer
echo.
echo NOTE: Administrator privileges required
echo.
set /p confirm="Continue? (Y/N): "
if /i "%confirm%"=="Y" (
    call Install-Windows12.bat
    timeout /t 3 >nul
) else (
    echo Installation cancelled.
    timeout /t 2 >nul
)
goto menu

:quicksetup
cls
echo.
echo ========================================
echo     STARTING QUICK SETUP
echo ========================================
echo.
echo This will:
echo  1. Move taskbar to TOP
echo  2. Apply Windows 12 theme
echo  3. Optimize system
echo  4. Restart computer
echo.
echo NOTE: No tools will be installed
echo.
set /p confirm="Continue? (Y/N): "
if /i "%confirm%"=="Y" (
    title Quick Setup Running...
    REM Create backup
    reg export HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer backup.reg
    
    REM Move taskbar
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSide /t REG_DWORD /d 1 /f
    
    REM Apply theme
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
    
    echo Quick setup complete. Restarting...
    timeout /t 3 >nul
    shutdown /r /t 0
) else (
    echo Setup cancelled.
    timeout /t 2 >nul
)
goto menu

:installtools
cls
echo.
echo ========================================
echo     INSTALLING DEVELOPMENT TOOLS
echo ========================================
echo.
if exist Install-Tools.bat (
    call Install-Tools.bat
) else (
    echo ERROR: Install-Tools.bat not found!
)
timeout /t 3 >nul
goto menu

:taskbaronly
cls
echo.
echo ========================================
echo     MOVING TASKBAR TO TOP
echo ========================================
echo.
echo Moving taskbar to top position...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSide /t REG_DWORD /d 1 /f
echo.
echo Done! Please restart Windows for changes to take effect.
echo.
set /p restart="Restart now? (Y/N): "
if /i "%restart%"=="Y" (
    shutdown /r /t 0
) else (
    echo Please restart manually for changes to apply.
    timeout /t 3 >nul
)
goto menu

:themeonly
cls
echo.
echo ========================================
echo     APPLYING WINDOWS 12 THEME
echo ========================================
echo.
echo Applying dark theme and transparency...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f
echo.
echo Done! Theme changes applied immediately.
echo.
timeout /t 3 >nul
goto menu

:viewconfig
cls
echo.
echo ========================================
echo     CURRENT CONFIGURATION
echo ========================================
echo.
echo Checking system configuration...
echo.

REM Check taskbar position
for /f "tokens=3" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSide 2^>nul') do set taskbar_pos=%%i
if "%taskbar_pos%"=="0x1" (
    echo [✓] Taskbar Position: TOP
) else if "%taskbar_pos%"=="0x0" (
    echo [✓] Taskbar Position: BOTTOM
) else (
    echo [?] Taskbar Position: Default
)

REM Check theme
for /f "tokens=3" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme 2^>nul') do set theme=%%i
if "%theme%"=="0x0" (
    echo [✓] Theme: DARK MODE
) else if "%theme%"=="0x1" (
    echo [✓] Theme: LIGHT MODE
) else (
    echo [?] Theme: Default
)

REM Check Chocolatey
where choco >nul 2>&1
if %errorLevel% equ 0 (
    echo [✓] Chocolatey: INSTALLED
) else (
    echo [✗] Chocolatey: NOT INSTALLED
)

echo.
echo Press any key to return to menu...
pause >nul
goto menu

:revert
cls
echo.
echo ========================================
echo     REVERTING CHANGES
echo ========================================
echo.

if exist backup.reg (
    echo Found backup file. Reverting all changes...
    echo.
    set /p confirm="Are you sure? (Y/N): "
    if /i "%confirm%"=="Y" (
        echo Importing backup...
        reg import backup.reg
        echo.
        echo Changes reverted! Please restart Windows.
        echo.
        set /p restart="Restart now? (Y/N): "
        if /i "%restart%"=="Y" (
            shutdown /r /t 0
        )
    ) else (
        echo Revert cancelled.
        timeout /t 2 >nul
    )
) else (
    echo ERROR: backup.reg file not found!
    echo Could not revert changes.
    timeout /t 3 >nul
)
goto menu

:exit
cls
echo.
echo Thank you for using Windows 12 Launcher!
echo.
pause
exit /b 0
