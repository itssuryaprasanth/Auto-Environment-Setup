$current_project_location= Get-Location
. $current_project_location\Utilites\Logger.ps1
. $current_project_location\Helper\Configuration.ps1

class Validate_Services

{
    [string]$global:pythonversion = $(Read_Xml_File('Python'))[0]
    [string]$global:running_version=""


    [void] Wait_until_python_service_to_install()
    {
        WriteLog("Wait Until Python Installation")
        Start-Sleep -Seconds 2
        while($true)
          {
            if ($(Read_Xml_File('Python'))[2] -eq '32')
            {
                $this.running_version = $this.pythonVersion
            }
            else
            {
                $this.running_version = $this.pythonVersion+"-amd64"
            } 
            $output = Get-Process | where {$_.ProcessName -eq "python-{0}"-f $this.running_version}

            if (($output -eq $null))
            {
                WriteLog("Python Installation Is Successfully Completed")
                break
            }
        }

    }


    [int] check_global_protect_service()
    {
        WriteLog("check_global_protect_service")
        Start-Sleep -Seconds 2
        $output = Get-Process | where {$_.ProcessName -eq "PanGPS"}

        if (($output -eq $null))
        {
            WriteLog("Global Protect Is Not Available")
            return 1;
        }
        else
        {
            WriteLog("Global Protect Is Available")
            return 0;
        }
    }


    [void] wait_until_java_service_to_install()
    {
        WriteLog("Wait Until Java Installation")
        Start-Sleep -Seconds 2
        while($true)
        {
            $output = Get-Process | where {$_.ProcessName -eq "msiexec"}
            if (($output.Length -eq 1))
            {
                WriteLog("Java Installation Is Successfully Completed")
                break
            }
        }

    }

    [void] Wait_until_pycharm_service_to_install()
    {

        WriteLog("Wait Until Pycharm Installation")
        Start-Sleep -Seconds 2
        while($true)
        {
            $output = Get-Process | where {$_.ProcessName -eq "pycharm-community-{0}"-f $(Read_Xml_File('Pycharm'))[0]}
            if (($output -eq $null))
            {
                WriteLog("Pycharm Installation Is Successfully Completed")
                break
            }
        
        }
    
    }

}
