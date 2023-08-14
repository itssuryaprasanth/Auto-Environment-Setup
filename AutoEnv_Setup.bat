@setlocal enableextensions
@cd /d "%~dp0"
@echo off
TITLE Environment Installation
rmdir /Q /S C:\Users\%USERNAME%\Downloads\AutoEnv_Installers
del /f Validation.bat
echo ************************************************
echo Checking Internet Connection
set MyServer=www.google.com
%SystemRoot%\system32\ping.exe -n 1 %MyServer% >nul
echo %MyServer% is available
echo ************************************************
Powershell.exe -ExecutionPolicy Bypass -File AutoEnv_Shell_Script.ps1
echo *************************************************
echo Validation.bat file is created, please close this session by press enter button
echo **************************************************
echo Validation will start after restart
shutdown -r
pause
exit /B