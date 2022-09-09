@echo off
TITLE Environment Installation
echo Checking Internet Connection
set MyServer=www.google.com
%SystemRoot%\system32\ping.exe -n 1 %MyServer% >nul
if errorlevel 1 goto NoServer
echo %MyServer% is available.
Powershell.exe -File Files_download_installer/Script_Installer.ps1
cmd /c pip install -r requirements.txt
pause