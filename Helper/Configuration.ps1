Function Read_Xml_File
{
    Param ([string]$Software)
    $Xpath_Path ='/Configuration/Installers/{0}'.Replace('{0}',$Software)
    $xml_data = 10,"blue",10,10.1234
    if (($Software -eq 'Java'))
    {
        $version = Select-Xml -Path Config.xml -XPath $Xpath_Path | ForEach-Object { $_.Node.Version }
        $download_status = Select-Xml -Path Config.xml -XPath $Xpath_Path | ForEach-Object { $_.Node.Install }
        $windows_bit = Select-Xml -Path Config.xml -XPath $Xpath_Path | ForEach-Object { $_.Node.Bit }
        $Jdk_version = Select-Xml -Path Config.xml -XPath $Xpath_Path | ForEach-Object { $_.Node.Jdk }
    }
    else
    {
        $version = Select-Xml -Path Config.xml -XPath $Xpath_Path | ForEach-Object { $_.Node.Version }
        $download_status = Select-Xml -Path Config.xml -XPath $Xpath_Path | ForEach-Object { $_.Node.Install }
        $windows_bit = Select-Xml -Path Config.xml -XPath $Xpath_Path | ForEach-Object { $_.Node.Bit }
    }
    $xml_data[0] = $version
    $xml_data[1] = $download_status
    $xml_data[2] = $windows_bit
    $xml_data[3] = $Jdk_version
    return $xml_data
}
