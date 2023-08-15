$current_project_location= Get-Location
. $current_project_location\Installers\Download_Softwares.ps1
. $current_project_location\Installers\Validate_Softwares.ps1
. $current_project_location\Installers\Install_Softwares.ps1
. $current_project_location\Installers\Uninstall_Softwares.ps1
. $current_project_location\Helper\Configuration.ps1
. $current_project_location\Helper\Requirements.ps1
. $current_project_location\Helper\Validate_Services.ps1
. $current_project_location\Utilites\Logger.ps1

$Download_object = [Download_Softwares]::new()
$Install_object = [Install_Softwares]::new()
$Validate_object = [Validating_Softwares]::new()
$Requirement_object =[Requirements]::new()
$Uninstall_object =[Uninstall_Softwares]::new()
$Services_object =[Validate_Services]::new()

[string]$username = [System.Environment]::UserName
[string]$destination = "C:\Users\{0}\Downloads\AutoEnv_Installers"
$destination = $destination.Replace('{0}',$username)



$Download_object.Create_Folder()
$Requirement_object.Create_Requirement_txt()

WriteLog("Environment Installation Starts")

$user_choice_valdation =0

# Validation Bat File Creation

New-Item Validation.bat
Set-Content Validation.bat '@setlocal enableextensions
@cd /d "%~dp0"
@echo off
TITLE Environment Validation
echo **************************************************
set PATH=%PATH%;C:\Python
set JAVA_HOME "C:\Program Files\Java\jdk-11.0.15\bin"
Powershell.exe -ExecutionPolicy Bypass -File Helper/Validation_after_installation.ps1
echo **************************************************
echo Installing python packages
cmd /c pip install -r requirements.txt
echo **************************************************
echo Validating installed python packages
cd Helper
cmd /c python Validate_Libraries.py
echo Validation Process Completed
echo ***************************************************
echo "Check logs and softwares handy in this location \Downloads\AutoEnv_Installers"
echo ***************************************************
pause
exit /B'

Copy-Item -Path 'Config.xml' -Destination $destination
echo 'Enabling Developer Mode'
WriteLog("Adding registries to run alienware center after restart")
WriteLog("Adding registries to run envrionment validation after restart")
cmd.exe /C "REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1""
WriteLog("Adding registries to HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319 to avoid breakages between connections")
cmd.exe /C "REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319" /t REG_DWORD /v "SchUseStrongCrypto" /d "1" /f"
# Pre Conditions Will Check (Validating Existing Env, Downloading , Install)

if ($(Read_Xml_File('Python'))[1] -eq 'True')
{
	WriteLog("Downloading & Installing Python")
    $user_choice_valdation+=1
    $python_status = $Validate_object.Validate_Python()
    if (($python_status -eq 1) -or ($python_status -eq -1))
    {
        $Download_object.Download_Python()
        $Install_object.Install_Python()
        $Services_object.Wait_until_python_service_to_install()
    }
	WriteLog("Downloaded & Installation Of Python Is Successfully Completed")
}


##################################################################################


if ($(Read_Xml_File('Winapp'))[1] -eq 'True')
{
	WriteLog("Downloading & Installing Winapp Driver")
    $user_choice_valdation+=1
    $winapp_status = $Validate_object.Validate_Winapp()
    if (($winapp_status -eq 1) -or ($winapp_status -eq -1))
    {
        $Download_object.Download_Winapp()
        $Install_object.Install_WinApp()
    }
    WriteLog("Downloaded & Installation Of Winapp Driver Is Successfully Completed")
}

###################################################################################

if ($(Read_Xml_File('ChromeDriver'))[1] -eq 'True')
{
	WriteLog("Downloading Chrome Driver")
    $user_choice_valdation+=1
    $Download_object.Download_ChromeDriver()
    WriteLog("Chrome Driver Downloaded")
}

##################################################################################

if ($(Read_Xml_File('Winuirecorder'))[1] -eq 'True')
{
    WriteLog("Downloading ui recorder")
	$user_choice_valdation+=1
    $Download_object.Download_Ui_recorder()
    WriteLog("Downloaded ui recorder")
}

###################################################################################

if ($(Read_Xml_File('Pycharm'))[1] -eq 'True')
{
	WriteLog("Downloading & Installing Pycharm")
    $user_choice_valdation+=1
    $pycharm_status = $Validate_object.Validate_Pycharm()
    if (($pycharm_status -eq 1) -or ($pycharm_status -eq -1))
    {
        Write-Host("Pycharm installation started")
        # $Download_object.Download_Pycharm()
        $Install_object.Install_Pycharm()
        # $Service_object.Wait_until_pycharm_service_to_install()
        Write-Host("Pycharm installation completed")
    }
    WriteLog("Downloaded & Installation Of Pycharm Is Successfully Completed")
}

###################################################################################


if ($(Read_Xml_File('Java'))[1] -eq 'True')
{
	WriteLog("Downloading & Installing Java")
    $user_choice_valdation+=1
    $java_status = $Validate_object.Validate_Java()
    if (($java_status -eq 1) -or ($java_status -eq -1))
    {   Write-Host("Java installation started")
        # $Download_object.Download_Java()
        $Install_object.Install_Java()
        # $Service_object.wait_until_java_service_to_install()
        Write-Host("Java installation completed")
    }
    WriteLog("Downloaded & Installation Of Java Is Successfully Completed")
}

#####################################################################################

if ($(Read_Xml_File('Git'))[1] -eq 'True')
{
    WriteLog("Downloading & Installing Git")
    $user_choice_valdation+=1
    $git_status = $Validate_object.Validate_Git()
    WriteLog($git_status)
    if (($git_status -eq 1) -or ($git_status -eq -1))
    {
        $Download_object.Download_Git()
        $Install_object.Install_Git()
    }
    WriteLog("Downloaded & Installation Of Git Is Successfully Completed")
}

if ($user_choice_valdation -eq 0)
{
    WriteLog("User Doesn't Select Any Choice In Configuration")
    Write-Host "User Doesn't Select Any Choice In Configuration"
}

###################################################################################








