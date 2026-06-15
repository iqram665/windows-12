@echo off
REM Auto-Install Development Tools for Windows 12
REM Requires Chocolatey to be installed first

title Windows 12 - Installing Development Tools
color 0B

echo.
echo ========================================
echo    Installing Development Tools
echo ========================================
echo.

REM Check for Chocolatey
where choco >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Chocolatey is not installed!
    echo Please run Install-Windows12.bat first
    pause
    exit /b 1
)

REM List of tools to install
echo [INFO] This will install the following tools:
echo  - Visual Studio Code
echo  - Python 3.x
echo  - Node.js
echo  - Git
echo  - 7-Zip
echo  - VLC Media Player
echo  - Firefox
echo  - Google Chrome
echo.
echo Press any key to start installation...
pause

REM Install tools
echo [1/9] Installing Visual Studio Code...
choco install vscode -y
echo [OK] Visual Studio Code installed

echo.
echo [2/9] Installing Python...
choco install python -y
echo [OK] Python installed

echo.
echo [3/9] Installing Node.js...
choco install nodejs -y
echo [OK] Node.js installed

echo.
echo [4/9] Installing Git...
choco install git -y
echo [OK] Git installed

echo.
echo [5/9] Installing 7-Zip...
choco install 7zip -y
echo [OK] 7-Zip installed

echo.
echo [6/9] Installing VLC Media Player...
choco install vlc -y
echo [OK] VLC installed

echo.
echo [7/9] Installing Firefox...
choco install firefox -y
echo [OK] Firefox installed

echo.
echo [8/9] Installing Google Chrome...
choco install googlechrome -y
echo [OK] Google Chrome installed

echo.
echo [9/9] Installing Docker...
choco install docker-desktop -y
echo [OK] Docker Desktop installed

echo.
echo ========================================
echo    Installation Complete!
echo ========================================
echo.
echo All development tools have been installed successfully!
echo.
pause
