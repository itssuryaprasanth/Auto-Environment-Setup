$current_project_location= Get-Location
. $current_project_location\Utilites\Logger.ps1
class Requirements
{

    [void] Create_Requirement_txt()
    {
        WriteLog("Creating requirements.txt File For Python Packages Installation")
        [string]$requirement_txt_file_location = 'requirements.txt'
        if (!(Test-Path -Path $requirement_txt_file_location))
        {
               WriteLog ("File requirements.txt doesn't exists, creating new one in supportingfiles folder")
               New-Item $requirement_txt_file_location
        }
        else
        {
               Remove-Item $requirement_txt_file_location -Recurse
               WriteLog("File requirements.txt exists, deleting it from supportingfiles folder")
               WriteLog("Creating new requirements.txt file in supportingfiles folder")
               New-Item $requirement_txt_file_location
        }
        WriteLog("Sending Xml Data To requirments.txt file")
        $loc = Get-Location
        $XML_File ='Config.xml'
        [xml]$xml=get-content Config.xml
        $XMLChild = $xml.Configuration.Libraries.Package
        foreach ($item in $XMLChild)
        {
            if($item.Install -eq "True")
            {
                $Name = $item.Name
                $Package = $item.Version
                $Package_With_Version = $Name+"=="+$Package
                Add-Content $requirement_txt_file_location $Package_With_Version
            }

        }
        $size_of_req = (Get-Item $requirement_txt_file_location).Length
        if (($size_of_req -ne 0))
        {
            WriteLog("XML data has been parsed successfully to requriements.txt")
        }
        else
        {
            throw "XML data parsing failed to requirements.txt"
        }
    }
}