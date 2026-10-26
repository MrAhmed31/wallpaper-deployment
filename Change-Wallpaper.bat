
@echo off
title Online Wallpaper Changer
echo.
echo Downloading and applying wallpaper...
echo.

set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"

if not exist "%PS%" (
    echo ERROR: PowerShell was not found.
    pause
    exit /b 1
)

"%PS%" -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; try { $folder=Join-Path $env:USERPROFILE 'Pictures'; New-Item -ItemType Directory -Path $folder -Force | Out-Null; $file=Join-Path $folder 'OnlineWallpaper.jpg'; $url='https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1920&q=90'; Invoke-WebRequest -Uri $url -OutFile $file; if ((Get-Item $file).Length -lt 10000) { throw 'Downloaded image is too small.' }; Add-Type 'using System.Runtime.InteropServices; public class WallAPI { [DllImport(\"user32.dll\", CharSet=CharSet.Auto)] public static extern int SystemParametersInfo(int a,int b,string c,int d); }'; if ([WallAPI]::SystemParametersInfo(20,0,$file,3) -eq 0) { throw 'Windows could not apply the wallpaper.' }; Write-Host 'Wallpaper changed successfully!' -ForegroundColor Green } catch { Write-Host ('ERROR: '+$_.Exception.Message) -ForegroundColor Red; exit 1 }"

echo.
pause
