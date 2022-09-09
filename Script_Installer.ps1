class Validation {
 #Declare Variables
 [string]$username = [System.Environment]::UserName
 [string]$global:pythonVersion = "3.6.2"
 [string]$global:source = "https://www.python.org/ftp/python/{0}/python-{1}.exe"
 [string]$destination = "C:\Users\{0}\Downloads\Tools"
 [string]$global:winappdriverVersion= "1.2.1"
 [string]$global:winappdriverinstalledpath ="C:\Program Files (x86)\Windows Application Driver"
 [string]$global:winappdriversource = "https://github.com/microsoft/WinAppDriver/releases/download/v{0}/WindowsApplicationDriver_{1}.msi"
 [string]$pythondownloadpath=""
 [string]$winappdownloadpath=""
 [string]$pythonpathenv= "C:\Users\{0}\AppData\Local\Programs\Python\Python36-32"
 [int]$status=0
 [int]$winapp_status=0
 [void] CreatingFolder()
 {
     $this.destination = $this.destination.Replace('{0}',$this.username)
     $this.source = $this.source.Replace('{0}',$this.pythonVersion).Replace('{1}',$this.pythonVersion)
     $this.winappdriversource = $this.winappdriversource.Replace('{0}',$this.winappdriverVersion).Replace('{1}',$this.winappdriverVersion)
   if (!(Test-Path -Path $this.destination))
   {
       Write-Host "Folder Doesn't Exists, Creating New One"
       New-Item $this.destination -itemType Directory
   }
   else
   {
       Write-Host "Folder Already Exists, Deleting it"
       Remove-Item $this.destination -Recurse
       Write-Host "Creating New One"
       New-Item $this.destination -itemType Directory
   }
}
 [void] Downloadpython()
 {
     [string]$this.pythondownloadpath = $this.destination + "\python-{0}.exe".Replace('{0}', $this.pythonVersion)
      #Download python exe from source to destination
     Invoke-WebRequest -Uri $this.source -OutFile $this.pythondownloadpath
#
 }
 [void] Downloadwinapp()
 {
     [string]$this.winappdownloadpath = $this.destination + "\WindowsApplicationDriver_{0}.msi".Replace('{0}', $this.winappdriverVersion)
     #Download WinAppDriver from source to destination
     Invoke-WebRequest -Uri $this.winappdriversource -OutFile $this.winappdownloadpath
 }
 [void] validatepython()
 {
     try
     {
         # Starting Validation, Checking Software are Installed
         $Installed_Python_Version = python --version
         $Existing_Python_Version = "Python " + $this.pythonVersion
         if (!($Existing_Python_Version -eq $Installed_Python_Version))
          {
             Write-Host "Python Version is not matching with expected version"
             $this.status=2
          }
         else
         {
             Write-Host "Python Version is installed as per expected"
             $this.status=0
         }
     }
     catch
     {
         $this.status=1
     }

 }
 [void] validatewinapp()
 {
    try
    {
        if (!(Test-Path -Path $this.winappdriverinstalledpath))
        {
            Write-Host "Winapp Driver Doesn't Exists"
            $this.winapp_status=1
        }
        else
        {
            Write-Host "Winapp Driver Already Installed"
        }
    }
    catch
     {
        $this.winapp_status=-1
     }
 }

[void] Installingpython()
{
    Set-Location -Path $this.destination
    write-Host "Start Installing Python"
    $version = "python-"+$this.pythonVersion+".exe"
    cmd.exe /c $version /quiet InstallAllUsers = 1 PrependPath = 1 Include_pip = 1 SimpleInstall = 0
    $python_path_1 = $this.pythonpathenv.Replace('{0}',$this.username)
    $python_path_2 = $python_path_1+'\'+'Scripts'
    [Environment]::SetEnvironmentVariable( "Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$python_path_1",[EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable( "Path",[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$python_path_2",[EnvironmentVariableTarget]::User)
    Write-Host "Python Installed Successfully"

}
 [void] Installingwinapp()
 {
     Set-Location -Path $this.destination
    #Start Installing WinAppDriver
     write-Host "Start Installing winappdriver"
     $winapp_download = "WindowsApplicationDriver_{0}.msi".Replace('{0}',$this.winappdriverVersion)
     cmd.exe /c msiexec /i $winapp_download /passive
     Write-Host "WinappDriver Installed Successfully"
 }
 [void] RunSetup()
 {
     $this.CreatingFolder()
     $this.validatepython()
     if ($this.status -eq 1)
     {
         $this.Downloadpython()
         $this.Installingpython()
         $this.validatepython()
     }
     $this.validatewinapp()
     if($this.winapp_status -eq 1)
     {
         $this.Downloadwinapp()
         $this.Installingwinapp()
         $this.validatewcoinapp()
     }
 }
}

$validobj = [Validation]::new()
$validobj.RunSetup()






