# Windows 12 Custom Installation Guide

## Overview
This package contains tools to transform Windows 11 into **Windows 12** with:
- ✅ Taskbar positioned at the top
- ✅ Modern dark theme
- ✅ Optimized performance
- ✅ Auto-installed development tools
- ✅ Custom startup configuration

---

## 📋 System Requirements
- Windows 11 (Pro, Home, or Enterprise)
- Administrator access
- 50GB free disk space
- Internet connection

---

## 🚀 Quick Start Guide

### Method 1: PowerShell Script (Recommended)

1. **Open PowerShell as Administrator:**
   - Right-click on PowerShell
   - Select "Run as Administrator"

2. **Navigate to the Windows 12 folder:**
   ```powershell
   cd "f:\Programing code\windows 12"
   ```

3. **Run the installation script:**
   ```powershell
   .\Install-Windows12.ps1 -InstallTools $true -CustomizeUI $true -MoveTaskbar $true
   ```

4. **Wait for installation to complete**

5. **Restart your computer:**
   ```powershell
   Restart-Computer -Force
   ```

---

### Method 2: Batch File (Simpler)

1. **Right-click on `Install-Windows12.bat`**

2. **Select "Run as Administrator"**

3. **Follow the on-screen prompts**

4. **Computer will restart automatically**

---

## 📦 Installation Breakdown

### Step 1: System Backup
- Automatically backs up your registry to `backup.reg`
- If something goes wrong, you can restore: 
  ```cmd
  reg import backup.reg
  ```

### Step 2: Taskbar Customization
- Moves taskbar from bottom to **top of screen**
- Changes Windows Explorer Advanced settings
- Registry Key: `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced`

### Step 3: Theme Application
- Sets **Dark Mode** for apps and system
- Enables **Transparency Effects** for modern look
- Applies modern Windows 11/12 aesthetic

### Step 4: System Optimization
- Disables telemetry services
- Optimizes startup time
- Reduces background processes

### Step 5: Tool Installation
- Installs Chocolatey package manager
- Auto-installs popular development tools

---

## 🛠️ Installed Tools

When you run the full installation, the following tools are automatically installed:

| Tool | Purpose |
|------|---------|
| **Visual Studio Code** | Code Editor |
| **Python** | Programming Language |
| **Node.js** | JavaScript Runtime |
| **Git** | Version Control |
| **7-Zip** | File Compression |
| **VLC Media Player** | Video Player |
| **Firefox** | Web Browser |
| **Google Chrome** | Web Browser |
| **Docker Desktop** | Container Platform |

To install only specific tools later, run:
```cmd
choco install <tool-name> -y
```

---

## 📁 File Structure

```
windows 12/
├── Install-Windows12.ps1          # Main PowerShell installation script
├── Install-Windows12.bat          # Batch file installation script
├── Install-Tools.bat              # Development tools installer
├── README.md                       # This file
├── registry-backup.reg            # Auto-created registry backup
└── config.json                     # Configuration settings
```

---

## ⚙️ Configuration Options

### PowerShell Script Parameters

```powershell
# Install everything
.\Install-Windows12.ps1 -InstallTools $true -CustomizeUI $true -MoveTaskbar $true

# Install only customization (no tools)
.\Install-Windows12.ps1 -InstallTools $false -CustomizeUI $true -MoveTaskbar $true

# Install only taskbar customization
.\Install-Windows12.ps1 -InstallTools $false -CustomizeUI $false -MoveTaskbar $true
```

---

## 🔧 Manual Customization

### Move Taskbar Back to Bottom
If you want to revert the taskbar to the bottom:

**PowerShell (Admin):**
```powershell
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $regPath -Name "TaskbarSide" -Value 0
```

**Command Prompt (Admin):**
```cmd
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSide /t REG_DWORD /d 0 /f
```

### Disable Dark Theme
**Command Prompt (Admin):**
```cmd
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f
```

---

## ❌ Troubleshooting

### Issue: "Access Denied" Error
- **Solution:** Run the script as Administrator
- Right-click and select "Run as Administrator"

### Issue: Taskbar Didn't Move
- **Solution:** Log out and log back in, or restart Windows
- Try running the batch file again

### Issue: Tools Not Installing
- **Solution:** Check your internet connection
- Run the tool installer separately: `Install-Tools.bat`

### Issue: Script Won't Run
- **Solution:** Enable PowerShell script execution:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### Restore Original Settings
- Double-click the auto-created `backup.reg` file
- Select "Yes" when prompted to merge with registry

---

## 📊 What Changes Are Made

| Change | Registry Path | Value |
|--------|-------------|-------|
| Taskbar Position | `HKCU\...\Explorer\Advanced` | TaskbarSide = 1 |
| Dark Theme | `HKCU\...\Themes\Personalize` | AppsUseLightTheme = 0 |
| Transparency | `HKCU\...\Themes\Personalize` | EnableTransparency = 1 |
| Telemetry | Service Config | DiagTrack = Disabled |

All changes are **reversible** and can be undone by importing the backup.reg file.

---

## 📝 Advanced Installation Options

### Create Custom Installation Disk
1. Use Windows Media Creation Tool
2. Insert the Windows 11 installation media
3. Copy the Windows12 folder to the installation media
4. After Windows installation, run the scripts

### Silent Installation (No Prompts)
**PowerShell:**
```powershell
.\Install-Windows12.ps1 -InstallTools $true -CustomizeUI $true -MoveTaskbar $true | Out-Null
```

### Schedule Automated Installation
Use Windows Task Scheduler to run scripts at startup automatically.

---

## 🔐 Security Notes

- ✅ All scripts are open-source and can be reviewed
- ✅ Only modifies Windows settings, doesn't install unknown software
- ✅ Automatic registry backup created before changes
- ✅ Safe to run on any Windows 11 system

---

## 📞 Support & Issues

If you encounter any issues:

1. **Check the backup.reg file** to restore previous settings
2. **Review the console output** for specific error messages
3. **Run scripts as Administrator** - most issues are permission-related
4. **Try the batch file version** if PowerShell has issues

---

## 🎯 Next Steps After Installation

1. **Restart your computer** - Changes take effect on restart
2. **Verify taskbar position** - Should be at the top
3. **Check installed tools** - Look in Start Menu
4. **Customize further** - Edit registry as needed
5. **Set up applications** - Configure VS Code, git, Python, etc.

---

## 📦 Distribution

To install this on another computer:

1. Copy the entire `windows 12` folder
2. Follow the Quick Start Guide on the new computer
3. All scripts are portable and self-contained

---

## ⭐ Features Summary

✅ Taskbar at top position
✅ Modern dark theme
✅ System optimization
✅ Automatic tool installation
✅ Registry backup & recovery
✅ Easy uninstall/revert
✅ No bloatware
✅ Fully customizable
✅ Works on Windows 11 Pro, Home, Enterprise
✅ Reversible changes

---

## 📄 License

This Windows 12 customization package is free to use and distribute.

---

**Version:** 1.0
**Last Updated:** 2026-06-15
**Compatible With:** Windows 11 (all versions)
