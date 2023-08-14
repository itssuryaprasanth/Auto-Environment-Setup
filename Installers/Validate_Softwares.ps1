$current_project_location= Get-Location
. $current_project_location\Utilites\Logger.ps1
. $current_project_location\Installers\Uninstall_Softwares.ps1
. $current_project_location\Helper\Configuration.ps1

class Validating_Softwares
{
    [string]$username = [System.Environment]::UserName
    [int]$global:status = 0
    [int]$global:winapp = 0
    [string]$global:winappdriverinstalledpath ="C:\Program Files (x86)\Windows Application Driver"
    [string]$global:pythonVersion=$(Read_Xml_File('Python'))[0]
    [string]$global:javaVersion= $(Read_Xml_File('Java'))[3]
    [string]$global:Python_Install_Path="C:\Python\Scripts"
    [string]$global:java_status =0
    [string]$global:pycharm_installed_path="C:\Users\{0}\AppData\Local\JetBrains\PyCharm Community Edition {1}\bin"
    [string]$global:pycharm =0
    [string]$global:gitVersion =$(Read_Xml_File('Git'))[0]
    [string]$global:gitstatus =0

#    [void] Wait_Until_Python_Is_Setup_In_Env()
#    {
#
#        if ((Test-Path -Path $this.Python_Install_Path))
#        {
#
#            while($true)
#            {
#                $Installed_Python_Version = py --version
#                $Expected_Python_Version = "Python " +$this.pythonVersion
#                if ($Installed_Python_Version -eq $Expected_Python_Version)
#                {
#                    break
#
#                }
#            }
#        }
#
#    }

    [int] Validate_Python()
    {
        try
        {
            # $this.Wait_Until_Python_Is_Setup_In_Env()
            $Installed_Python_Version = python --version
            WriteLog("Installed Python Version {0}" -f $Installed_Python_Version)
            $Expected_Python_Version = "Python " +$this.pythonVersion
            WriteLog("Expected_Python_Version {0}" -f $Expected_Python_Version)

            if (!($Expected_Python_Version -eq $Installed_Python_Version))
            {
                WriteLog("Python Version is not matching with expected version")
                $this.status = 1
                return $this.status
            }
            else
            {
                Write-Host "Expected python version is installed successfully"
                WriteLog("Expected python version is installed successfully")
                $this.status=0
                return $this.status
            }
        }
        catch
        {
            WriteLog("Python is not installed in your system")
            $this.status = -1
            return $this.status
        }
    }

    [int] Validate_Winapp()
    {
        try
        {
            if (!(Test-Path -Path $this.winappdriverinstalledpath))
            {
                WriteLog("WinAppDriver doesn't exists in your system")
                $this.winapp =1
                return $this.winapp
            }
            else
            {
                Write-Host "Expected WinAppDriver installed in your system"
                WriteLog("Expected WinAppDriver installed in your system")
                $this.winapp=0
                return $this.winapp
            }
        }
        catch
        {
            Writelog("WinAppDriver is not installed in your system")
            $this.winapp = -1
            return $this.winapp
        }
    }

    [int] Validate_Java()
    {
     try 
     {
         $java_version = &"java.exe" -version 2>&1
         $output = $java_version[0].tostring()
         $Installed_Java_Version= $output.Substring(14,7)
         $Expected_Java_Version= $this.javaVersion
		 WriteLog("Installed Java_Version {0}" -f $Installed_Java_Version)
         WriteLog("Expected_Java_Version {0}" -f $Expected_Java_Version)
        if (!($Expected_Java_Version -eq $Installed_Java_Version))
          {
            WriteLog("Java_Version is not matching with expected version")
            $this.status = 1
            return $this.status
          }
        else
         {
            Write-Host "Java is installed"
            WriteLog("Java_Version is installed as per expected")
            $this.status=0
            return $this.status
         }
    }
        catch
        {
            WriteLog("Java is not installed in your local")
            $this.status = -1
            return $this.status
        }

    }

    [int] Validate_Pycharm()
    {
        try
        {
            $this.pycharm_installed_path= $this.pycharm_installed_path.Replace('{0}',$this.username).Replace('{1}',$(Read_Xml_File('Pycharm'))[0])
            if (!(Test-Path -Path $this.pycharm_installed_path))
            {
                WriteLog("Pycharm doesn't exists in your system")
                $this.pycharm =1
                return $this.pycharm
            }
            else
            {
                Write-Host "Expected Pycharm installed in your system"
                WriteLog("Expected Pycharm installed in your system")
                $this.pycharm=0
                return $this.pycharm
            }
        }
        catch
        {
            Writelog("Pycharm is not installed in your system")
            $this.pycharm = -1
            return $this.pycharm
        }

  }

  [int] Validate_Git()
    {
        try
        {
            $git_version= &"git.exe" -v 2>&1
		    $output= $git_version.tostring()
		    $installed_git_version = $output.Substring(12,6)
		    $output = $Installed_Git_Version[0].tostring()
            WriteLog("Installed Git Version {0}" -f $Installed_Git_Version)
            $Expected_Git_Version = $this.gitVersion
            WriteLog("Expected_Git_Version {0}" -f $Expected_Git_Version)

            if (!($Expected_Git_Version -eq $installed_git_version))
            {
                WriteLog("Git Version is not matching with expected version")
                $this.gitstatus = 1
                return $this.gitstatus
            }
            else
            {
                Write-Host "Expected Git version is installed successfully"
                WriteLog("Expected Git version is installed successfully")
                $this.gitstatus=0
                return $this.gitstatus
            }
        }
        catch
        {
            WriteLog("Git is not installed in your system")
            $this.gitstatus = -1
            return $this.gitstatus
        }
    }




}
#$obj = [Validating_Softwares]::new()
#$obj.Validate_Java()