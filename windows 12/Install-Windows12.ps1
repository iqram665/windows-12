# Windows 12 Customization & Installation Script
# Run as Administrator

param(
    [bool]$InstallTools = $true,
    [bool]$CustomizeUI = $true,
    [bool]$MoveTaskbar = $true
)

# Set error action preference
$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Windows 12 Installation & Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Red
    exit 1
}

Write-Host "[✓] Running with Administrator privileges" -ForegroundColor Green
Write-Host ""

# ============================================
# Function: Move Taskbar to Top
# ============================================
function Move-TaskbarToTop {
    Write-Host "[→] Moving Taskbar to Top Position..." -ForegroundColor Yellow
    
    try {
        # Registry path for taskbar
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        
        # Create registry key if it doesn't exist
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        
        # Set taskbar position to Top (0=Bottom, 1=Top, 2=Left, 3=Right)
        Set-ItemProperty -Path $regPath -Name "TaskbarSide" -Value 1 -Force
        
        Write-Host "[✓] Taskbar moved to top" -ForegroundColor Green
    } catch {
        Write-Host "[✗] Failed to move taskbar: $_" -ForegroundColor Red
    }
}

# ============================================
# Function: Customize Theme
# ============================================
function Set-Windows12Theme {
    Write-Host "[→] Applying Windows 12 Theme..." -ForegroundColor Yellow
    
    try {
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        
        # Set to Dark Theme
        Set-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -Value 0 -Force
        Set-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -Value 0 -Force
        
        # Enable transparency effects
        Set-ItemProperty -Path $regPath -Name "EnableTransparency" -Value 1 -Force
        
        Write-Host "[✓] Theme applied" -ForegroundColor Green
    } catch {
        Write-Host "[✗] Failed to apply theme: $_" -ForegroundColor Red
    }
}

# ============================================
# Function: Disable Unnecessary Services
# ============================================
function Optimize-Windows {
    Write-Host "[→] Optimizing Windows Services..." -ForegroundColor Yellow
    
    $servicesToDisable = @(
        "DiagTrack",
        "dmwappushservice",
        "WMPNetworkSvc"
    )
    
    foreach ($service in $servicesToDisable) {
        try {
            Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "[✓] Disabled service: $service" -ForegroundColor Green
        } catch {
            # Service might not exist, skip
        }
    }
}

# ============================================
# Function: Install Development Tools
# ============================================
function Install-DevelopmentTools {
    Write-Host "[→] Installing Development Tools..." -ForegroundColor Yellow
    
    # Check if Chocolatey is installed
    if (-not (Test-Path "C:\ProgramData\chocolatey\choco.exe")) {
        Write-Host "[→] Installing Chocolatey..." -ForegroundColor Yellow
        
        try {
            Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            Write-Host "[✓] Chocolatey installed" -ForegroundColor Green
        } catch {
            Write-Host "[✗] Failed to install Chocolatey: $_" -ForegroundColor Red
            return
        }
    }
    
    # Tools to install
    $tools = @(
        "vscode",
        "python",
        "nodejs",
        "git",
        "7zip",
        "vlc",
        "firefox"
    )
    
    foreach ($tool in $tools) {
        Write-Host "[→] Installing $tool..." -ForegroundColor Cyan
        try {
            & choco install $tool -y
            Write-Host "[✓] $tool installed" -ForegroundColor Green
        } catch {
            Write-Host "[✗] Failed to install $tool: $_" -ForegroundColor Red
        }
    }
}

# ============================================
# Function: Create Startup Script
# ============================================
function Create-StartupScript {
    Write-Host "[→] Creating Startup Script..." -ForegroundColor Yellow
    
    try {
        $startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
        $scriptPath = "$startupFolder\Windows12-Startup.ps1"
        
        $scriptContent = @'
# Windows 12 Startup Script
# This script runs on every startup

Write-Host "Windows 12 Loading..." -ForegroundColor Cyan

# Refresh taskbar position
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $regPath -Name "TaskbarSide" -Value 1 -Force

# Show welcome message
Write-Host "Welcome to Windows 12!" -ForegroundColor Green
'@
        
        Set-Content -Path $scriptPath -Value $scriptContent -Force
        Write-Host "[✓] Startup script created" -ForegroundColor Green
    } catch {
        Write-Host "[✗] Failed to create startup script: $_" -ForegroundColor Red
    }
}

# ============================================
# Main Execution
# ============================================

Write-Host "Starting Windows 12 Setup Process..." -ForegroundColor Cyan
Write-Host ""

if ($MoveTaskbar) {
    Move-TaskbarToTop
}

if ($CustomizeUI) {
    Set-Windows12Theme
}

Optimize-Windows

if ($InstallTools) {
    Install-DevelopmentTools
}

Create-StartupScript

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer for changes to take effect"
Write-Host "2. The taskbar should now appear at the top"
Write-Host "3. Installed tools will be available in Start Menu"
Write-Host ""
Write-Host "To restart now, type: Restart-Computer -Force" -ForegroundColor Cyan
