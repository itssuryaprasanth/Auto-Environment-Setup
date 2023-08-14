$current_project_location= Get-Location
. $current_project_location\Utilites\Logger.ps1
. $current_project_location\Helper\Configuration.ps1


class Download_Softwares
{
    [string]$username = [System.Environment]::UserName
    [string]$global:pythonVersion = $(Read_Xml_File('Python'))[0]
    [string]$global:source = "https://www.python.org/ftp/python/{0}/python-{1}.exe"
    [string]$global:java_source = "https://cfdownload.adobe.com/pub/adobe/coldfusion/java/java{0}/java{1}/jdk-{2}_windows-x{3}_bin.exe"
    [string]$destination = "C:\Users\{0}\Downloads\AutoEnv_Installers"
    [string]$pythondownloadpath =""
    [string]$winappdownloadpath =""
    [string]$winuirecorderpath = "https://github.com/microsoft/WinAppDriver/releases/download/UIR-v{0}/WinAppDriverUIRecorder.zip"
    [string]$global:chromedriverpath="https://chromedriver.storage.googleapis.com/{0}/chromedriver_win{1}.zip"
    [string]$global:winappdriverVersion= $(Read_Xml_File('Winapp'))[0]
    [string]$global:winappdriverinstalledpath ="C:\Program Files (x86)\Windows Application Driver"
    [string]$global:winappdriversource = "https://github.com/microsoft/WinAppDriver/releases/download/v{0}/WindowsApplicationDriver_{1}.msi"
    [string]$global:pycharmdownloadsource = "https://download.jetbrains.com/python/pycharm-community-{0}.exe"
    [string]$global:gitdownloadsource="https://github.com/git-for-windows/git/releases/download/v{0}.windows.1/Git-{1}-{2}-bit.exe"
    [string]$global:parent_directory = (Get-Location)

    [void] Create_Folder()
    {
     $this.destination = $this.destination.Replace('{0}',$this.username)
     try{
             if (!(Test-Path -Path $this.destination))
                {
                   New-Item $this.destination -itemType Directory
                   WriteLog ("Folder Doesn't Exists, Creating New One in --> {0}" -f $this.destination)
                }
             else
                {
                   Remove-Item -Path $this.destination -Recurse -Force
                   WriteLog ("Folder Already Exists, Deleting it From --> {0}" -f $this.destination)
                   
                   New-Item $this.destination -itemType Directory
                   WriteLog("Creating New Folder in --> {0}" -f $this.destination)
         }      }

     catch 
     {
            WriteLog($Error)
     }
    }

    [void] Download_Python()
    {
        Set-Location $this.parent_directory
        if ($(Read_Xml_File('Python'))[2] -eq '64')
        {
            WriteLog("Downloading 64 Bit Python")
            $pythonVersion_bit=$this.pythonVersion + "-amd64.exe"
            $this.source = "https://www.python.org/ftp/python/{0}/python-{1}" -f $this.pythonVersion,$pythonVersion_bit
            [string]$this.pythondownloadpath = $this.destination + "\python-{0}".Replace('{0}', $pythonVersion_bit)
        }
        else
        {
            WriteLog("Downloading 32 Bit Python")
            $this.source = $this.source.Replace('{0}',$this.pythonVersion).Replace('{1}',$this.pythonVersion)
            [string]$this.pythondownloadpath = $this.destination + "\python-{0}.exe".Replace('{0}', $this.pythonVersion)
        }
        # Download python exe from source to destination
        Start-Sleep -Seconds 3
        WriteLog("Downloading Python From Source Website")
        try {
            Invoke-WebRequest -Uri $this.source -OutFile $this.pythondownloadpath
            Write-Host ("Python ({0}) Downloaded" -f $this.pythonVersion)
            WriteLog("Python Downloading Finished")
        }
        catch {
            WriteLog("Python download failed with an error" -f $Error)
            Write-Host("Python download failed")
        }
    }

    [void] Download_Winapp()
    {
        Set-Location $this.parent_directory
        $this.winappdriversource = $this.winappdriversource.Replace('{0}',$this.winappdriverVersion).Replace('{1}',$this.winappdriverVersion)
        [string]$this.winappdownloadpath = $this.destination + "\WindowsApplicationDriver_{0}.msi".Replace('{0}', $this.winappdriverVersion)

        # Download WinAppDriver from source to destination
        WriteLog("Downloading WinappDriver From Source Website")
        Start-Sleep -Seconds 3
        try {
            Invoke-WebRequest -Uri $this.winappdriversource -OutFile $this.winappdownloadpath
            Write-Host("WinApp Driver {0} Downloaded" -f $this.winappdriverVersion)
        }
        catch {
            WriteLog("Winapp download failed with an error")
            WriteLog($Error)
            Write-Host("Winapp download failed")
        }
        
    }

    [void] Download_ChromeDriver()
    {
        Set-Location $this.parent_directory
        $this.chromedriverpath = $this.chromedriverpath.Replace('{0}',$(Read_Xml_File('ChromeDriver'))[0]).Replace('{1}',$(Read_Xml_File('ChromeDriver'))[2])
        $chromedriver_download_path = $this.destination + "\chromedriver_win{0}.zip" -f $(Read_Xml_File('ChromeDriver'))[2]

        # Download Chrome Driver from Source To Destination
        Start-Sleep -Seconds 3
        Invoke-WebRequest -Uri $this.chromedriverpath -OutFile $chromedriver_download_path
        Write-Host("Chrome Driver {0} Downloaded" -f $(Read_Xml_File('ChromeDriver'))[0])
    }

    [void] Download_Java()
    {
        Set-Location $this.parent_directory
		$java_version_without_dots = $(Read_Xml_File('Java'))[3]
		$java_version_without_dots= $java_version_without_dots.Replace('.','')
        $this.java_source = $this.java_source.Replace('{0}', $(Read_Xml_File('Java'))[0]).Replace('{1}',$java_version_without_dots).Replace('{3}' ,$(Read_Xml_File('Java'))[2]).Replace('{2}',$(Read_Xml_File('Java'))[3])
        $java_download_path = $this.destination + "\jdk-{0}_windows-x{1}_bin.exe" -f $(Read_Xml_File('Java'))[3], $(Read_Xml_File('Java'))[2]

        # Download Java From Source To Destination
        Start-Sleep -Seconds 3
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
        try {
            Invoke-WebRequest -Uri $this.java_source -Outfile $java_download_path -UseBasicParsing
            Write-Host("Java {0} Downloaded" -f $(Read_Xml_File('Java'))[3])
        }
        catch {
            WriteLog("Java download failed with an error")
            WriteLog($Error)
            Write-Host("Java download failed")
        }
        
    }

    [void] Download_Ui_recorder()
    {
        Set-Location $this.parent_directory
        $winui_source = $this.winuirecorderpath.Replace('{0}', $(Read_Xml_File('Winuirecorder'))[0])
        $winui_download_path = $this.destination+ "\WinAppDriverUIRecorder.zip"

        # Download Ui recorder From Source To Destination
        Start-Sleep -Seconds 3
        try {
            Invoke-WebRequest -Uri $winui_source -OutFile $winui_download_path
            Write-Host("Ui Recorder {0} Downloaded" -f $(Read_Xml_File('Winuirecorder'))[0])
        }
        catch {
            WriteLog("Ui Recorder download failed with an error")
            WriteLog($Error)
            Write-Host("Ui Recorder download failed")
        }
        

    }

    [void] Download_Pycharm()
    {
        Set-Location $this.parent_directory
        $pycharm_source = $this.pycharmdownloadsource.Replace('{0}',$(Read_Xml_File('Pycharm'))[0])
        $pycharm_download_path = $this.destination+ "\pycharm-community-{0}.exe" -f $(Read_Xml_File('Pycharm'))[0]

        # Download Pycharm From Source To Destination
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
        Invoke-WebRequest -Uri $pycharm_source -OutFile $pycharm_download_path -UseBasicParsing
        Write-Host("Pycharm {0} Downloaded" -f $(Read_Xml_File('Pycharm'))[0])
        WriteLog("Pycharm download failed with an error "-f $Error)
        Write-Host("Pycharm download failed")

    }

   [void] Download_Git()
   {
        Set-Location $this.parent_directory
        $git_source = $this.gitdownloadsource.Replace('{0}',$(Read_Xml_File('Git'))[0]).Replace('{1}',$(Read_Xml_File('Git'))[0]).Replace('{2}',$(Read_Xml_File('Git'))[2])
        $git_download_path = $this.destination+ "\Git-{0}-{1}-bit.exe" -f $(Read_Xml_File('Git'))[0], $(Read_Xml_File('Git'))[2]

        #Download Git From Source To Destination
        Start-Sleep -Seconds 3
        WriteLog($git_source)
        WriteLog($git_download_path)
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
        try {
            Invoke-WebRequest -Uri $git_source -OutFile $git_download_path
            Write-Host("Git {0} Downloaded" -f $(Read_Xml_File('Git'))[0])
        }
        catch {
            WriteLog("Git download failed with an error")
            WriteLog($Error)
            Write-Host("Git download failed")
        }

   }

}

# $obj = [Download_Softwares]::new()
# $obj.Download_Ui_recorder()