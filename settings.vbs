Set UAC = CreateObject("Shell.Application") 
UAC.ShellExecute "C:\test/settings.bat", "", "", "runas", 0 
