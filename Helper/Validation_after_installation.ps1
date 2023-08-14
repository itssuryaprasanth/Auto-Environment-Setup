$current_project_location= Get-Location
. $current_project_location\Installers\Validate_Softwares.ps1
. $current_project_location\Utilites\Logger.ps1
. $current_project_location\Helper\Configuration.ps1

$Validate_object = [Validating_Softwares]::new()

# Post Conditions

if ($(Read_Xml_File('Python'))[1] -eq 'True')
{
    $installer_status = $Validate_object.Validate_Python()
    if (!($installer_status -eq 0))
    {
        throw "Python Is Not Installed Properly"
    }
}


if ($(Read_Xml_File('Winapp'))[1] -eq 'True')
{
    $winapp_status = $Validate_object.Validate_Winapp()
    if (!($winapp_status -eq 0))
    {
        throw "Winapp Is Not Installed Properly"
    }
}

if ($(Read_Xml_File('Java'))[1] -eq 'True')
{
    $Java_status = $Validate_object.Validate_Java()
    if (!($Java_status -eq 0))
    {
        throw "Java Is Not Installed Properly"
    }
}

if ($(Read_Xml_File('Pycharm'))[1] -eq 'True')
{
    $Pycharm_Status = $Validate_object.Validate_Pycharm()
    if (!($Pycharm_Status -eq 0))
    {
        throw "Pycharm Is Not Installed Properly"
    }
}
if ($(Read_Xml_File('Git'))[1] -eq 'True')
{
    $Git_Status = $Validate_object.Validate_Git()
    if (!($Git_Status -eq 0))
    {
        throw "Git Is Not Installed Properly"
    }
}
[string]$Log_destination = "C:\Users\{0}\Downloads\AutoEnv_Installers\Logs"
$list = New-Object Collections.Generic.List[String]
$Log_destination = $Log_destination.Replace('{0}',[System.Environment]::UserName)
$get_files_count = (Get-ChildItem -Recurse -Path $Log_destination | Measure-Object).Count
$Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
$Path = "$Log_destination\Auto_Env_Execution_Report_$Stamp_Log.log"
if ($get_files_count -eq 2)
{
    $files = Get-ChildItem -Path $Log_destination –File
    Get-Content -Path $files.FullName | Set-Content $Path
    Set-Location -Path $Log_destination
    foreach($single_file in $files)
    {
        Remove-Item -Path $single_file -Recurse -Force
    }
}






