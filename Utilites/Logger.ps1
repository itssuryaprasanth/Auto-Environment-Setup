$Stamp_Log = (Get-Date).toString("yyyy_MM_dd_HH_mm_ss")
Function WriteLog
{
   Param ([string]$logstring)
   [string]$Level = "INFO"
   [string]$Log_destination = "C:\Users\{0}\Downloads\AutoEnv_Installers\Logs"
   $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
   $Line = "$Stamp $Level $logstring"
   $Log_destination = $Log_destination.Replace('{0}',[System.Environment]::UserName)
   $Path = "$Log_destination\$(gc env:computername)_$Stamp_Log.log"
   If (!(Test-Path $Path)) {New-Item -Path $Path -Force}
   Add-Content -Path $Path -Value $Line
}

