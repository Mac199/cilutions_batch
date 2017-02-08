Set UAC = CreateObject("Shell.Application") 
UAC.ShellExecute "C:\test/upgrade_wwwroot.bat", "", "", "runas", 0 
