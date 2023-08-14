$current_project_location= Get-Location
. $current_project_location\Utilites\Logger.ps1
class Uninstall_Softwares{

[void] Uninstall_Python()
 {
     WriteLog("Uninstalling python function started")
     [Environment]::SetEnvironmentVariable("Path","","User") # Remove the variables completely
     [Environment]::SetEnvironmentVariable( "Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";%USERPROFILE%\AppData\Local\Microsoft\WindowsApps",[EnvironmentVariableTarget]::User)
     Get-Package "*python*" | Uninstall-Package
     try
     {
         cmd.exe /c python --version
     }
     catch
     {
         WriteLog("Python Uninstalled Successfully")
     }
     WriteLog("Python Uninstalled function ended")
 }

}








