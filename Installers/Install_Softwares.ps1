$current_project_location= Get-Location
. $current_project_location\Utilites\Logger.ps1
. $current_project_location\Helper\Configuration.ps1

class Install_Softwares
{
    [string]$username = [System.Environment]::UserName
    [string]$global:pythonVersion = $(Read_Xml_File('Python'))[0]
    [string]$global:source = "https://www.python.org/ftp/python/{0}/python-{1}-amd64.exe"
    [string]$destination = "C:\Users\{0}\Downloads\AutoEnv_Installers"
    [string]$pythondownloadpath=""
    [string]$winappdownloadpath=""
    [string]$install_version =""
    [string]$global:parent_directory = (Get-Location)
    [string]$global:winappdriverVersion= $(Read_Xml_File('Winapp'))[0]
    [string]$global:pythonTargetDir ="C:\Python36"
    [string]$global:winappdriverinstalledpath ="C:\Program Files (x86)\Windows Application Driver"
    [string]$global:winappdriversource = "https://github.com/microsoft/WinAppDriver/releases/download/v{0}/WindowsApplicationDriver_{1}.msi"
    [string]$global:javadownloadpath=""
    [string]$global:pycharmdownloadpath=""


    [void] Install_Python()
    {

        $python_path_1 = "C:\Python"
        $python_path_2 = $python_path_1+'\'+'Scripts'

        [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$python_path_1",[EnvironmentVariableTarget]::User)
        [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$python_path_2",[EnvironmentVariableTarget]::User)

        [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$python_path_1",[EnvironmentVariableTarget]::Machine)
        [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$python_path_2",[EnvironmentVariableTarget]::Machine)

        $this.destination = $this.destination.Replace('{0}',$this.username)    
        Set-Location -Path $this.parent_directory
        WriteLog("Start Installing Python")

        if ($(Read_Xml_File('Python'))[2] -eq '32')
        {
            $this.install_version = "python-"+$this.pythonVersion+".exe"
        }
        else
        {
            $this.install_version = "python-"+$this.pythonVersion+"-amd64.exe"
        }

        $version= $this.install_version
        Copy-Item -Path 'Installers\Python_Install.bat' -Destination $this.destination
        Set-Location $this.destination
        Start-Process 'Python_Install.bat' -args "$version"
        Set-Location $this.parent_directory

    }

    [void] Install_WinApp()
    {
        $this.destination = $this.destination.Replace('{0}',$this.username)
        Set-Location -Path $this.destination
        WriteLog("Start Installing WinAppDriver")
        $winapp_install = "WindowsApplicationDriver_{0}.msi".Replace('{0}',$this.winappdriverVersion)
        cmd.exe /c msiexec /i $winapp_install /passive
        Set-Location $this.parent_directory
    }

    [void] Install_Java()
    {
    try {
          WriteLog("Installing Java Started")
          Set-Location $this.parent_directory
     
          # Start Installing Java
          $this.javadownloadpath ="jdk-{0}_windows-x{1}_bin.exe" -f $(Read_Xml_File('Java'))[3], $(Read_Xml_File('Java'))[2]
          $this.destination = $this.destination.Replace('{0}',$this.username)
          Copy-Item -Path 'External_Resources\jdk-11.0.15_windows-x64_bin.exe' -Destination $this.destination
          Set-Location $this.destination
	      cmd.exe /c $this.javadownloadpath /s
          WriteLog("Java Installed Successfully")
        }
    finally {
          $java_path = 'C:\Program Files\Java\jdk-{0}\bin' -f $(Read_Xml_File('Java'))[3]

          [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$java_path",[EnvironmentVariableTarget]::User)
          [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$java_path",[EnvironmentVariableTarget]::User)

          [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$java_path",[EnvironmentVariableTarget]::Machine)
          [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";$java_path",[EnvironmentVariableTarget]::Machine)

          Set-Location $this.parent_directory

    }
 
    }

    [void] Install_Pycharm()
    {
        WriteLog("Installing Pycharm")

        Set-Location $this.parent_directory
        # Start Installing Pycharm
		$this.destination = $this.destination.Replace('{0}',$this.username)    
        $this.pycharmdownloadpath = "pycharm-community-{0}.exe" -f $(Read_Xml_File('Pycharm'))[0]
        Copy-Item -Path 'DownloadLinks\silent.config' -Destination $this.destination
        Copy-Item -Path 'External_Resources\pycharm-community-2022.2.3.exe' -Destination $this.destination
        Set-Location -Path $this.destination
        cmd.exe /c $this.pycharmdownloadpath /S /CONFIG=silent.config
        Set-Location $this.parent_directory
    }

    [void] Install_Git()
    {

     WriteLog("Installing Git")
     Set-Location $this.parent_directory
     # Start Installing Git
     $this.destination = $this.destination.Replace('{0}',$this.username)
     $git_download_path = "Git-{0}-{1}-bit.exe" -f $(Read_Xml_File('Git'))[0], $(Read_Xml_File('Git'))[2]
     Copy-Item -Path 'DownloadLinks\install-defaults.txt' -Destination $this.destination
     
     Set-Location -Path $this.destination

     $optionsFile = Resolve-Path ".\install-defaults.txt"
     
     $commandLineOptions = '/SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS /LOADINF="'+ $optionsFile + '" '

     Start-Process -Wait -FilePath $git_download_path -ArgumentList $commandLineOptions

     if (!(Test-Path -Path "alias:git")) 
     {
        new-item -path alias:git -value 'C:\Program Files\Git\bin\git.exe'
     }
        ### Invoke git commands that set defaults for user.
    git config --global credential.helper wincred
    git config --global push.default simple
    git config --global core.autocrlf true
    Set-Location $this.parent_directory
    }

    [void] Install_Global_Protect()
    {
        WriteLog("Setting up path for winget")
        $wingetpath="C:\Users\{0}\AppData\Local\Microsoft\WindowsApps".Replace('{0}',$this.username)
        [Environment]::SetEnvironmentVariable("Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$wingetpath",[EnvironmentVariableTarget]::User)
        WriteLog("Installing Global Protect")
        $Resources = $this.parent_directory+"\\External_Resources"
        Set-Location $Resources
        WriteLog("Start Installing Global Protect") 
        cmd.exe /c msiexec /i "GlobalProtect64-5.2.8.msi" /passive
        Set-Location $this.parent_directory
    }

}