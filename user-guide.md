1. Clone the repository.
2. Create a directory called External_Resources.(Follow exact naming convention to avoid failures)
3. Store pycharm, java in External_Resources directory.(We are carrying these files due to firewall restrictions in some co-operate networks). if there is no restrictions, open to
   AutoEnv_Shell_Script.ps1 and uncomment below lines
   $Download_object.Download_Pycharm()
   $Service_object.Wait_until_pycharm_service_to_install()
   $Download_object.Download_Java()
   $Service_object.wait_until_java_service_to_install()
4. Logs are stored in Downloads\AutoEnv_Installers\Logs
5. Main executor is AutoEnv_Setup.bat. After running this a Validation bat will be created to validate softwares are installed or not.
