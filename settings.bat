setlocal 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v RPSessionInterval /t REG_DWORD /d 1 /f  
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v HideFastUserSwitching /t REG_DWORD /d 1 /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters" /v DisabledComponents /t REG_DWORD /d 4294967295 /f 
setx Tmp C:\Windows\TEMP /M 
setx Temp C:\Windows\TEMP /M 
setx Path "c:\cygwin\bin;C:\Ruby193\bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\Hughes Network Systems\PDReceiver\bin;c:\cilutions" /M 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" /v NoFirsttimeprompt /t REG_DWORD /d 1 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f 
wmic useraccount where name='support' set FullName=Support 
wmic useraccount where name='mediasignage' set FullName=MediaSignage 
c:\windows\system32\inetsrv\appcmd set config "Default Web Site/MediaSignage" /section:httpProtocol /+"customHeaders.[name='Cache-Control',value='no-cache, no-store, must-revalidate']" 
c:\windows\system32\inetsrv\appcmd set config /section:httpLogging /dontLog:True 
c:\windows\system32\inetsrv\appcmd set config /section:caching /enableKernelCache:false 
c:\windows\system32\inetsrv\appcmd set config "Default Web Site/MediaSignage" /section:httpProtocol /+"customHeaders.[name='X-Frame-Options',value='SAMEORIGIN']" 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v FullPath /t REG_DWORD /d 1 /f 
c:\windows\system32\inetsrv\appcmd add vdir /app.name:"Default Web Site/" /path:/MediaSignag /physicalPath:C:\Users\MediaSignage\MediaSignage 
icacls "C:\Users\MediaSignage\MediaSignage" /grant IUSR:(OI)(CI)F /T 
icacls "C:\Users\MediaSignage\MediaSignage" /grant IIS_IUSRS:(OI)(CI)F /T 
icacls "C:\Users\MediaSignage\Documents\PDReceiver" /grant IUSR:(OI)(CI)F /T 
icacls "C:\Users\MediaSignage\Documents\PDReceiver" /grant IIS_IUSRS:(OI)(CI)F /T 
powershell -executionpolicy bypass -File "C:\test\install.ps1" 
cd c:\users\mediasignage\MediaSignage 
cscript /nologo c:\users\mediasignage\MediaSignage/NetComment.vbs SET 
The operation completed successfully.
reg add "HKCU\Software\Microsoft\Internet Explorer\MINIE" /v AlwaysShowMenus /t REG_DWORD /d 1 /f 
reg add "HKCU\Software\Microsoft\Internet Explorer\MINIE" /v LinksBandEnabled /t REG_DWORD /d 1 /f 
reg add "HKCU\Software\Microsoft\Internet Explorer\Privacy" /v ClearBrowsingHistoryOnExit /t REG_DWORD /d 1 /f 
The operation completed successfully.
The operation completed successfully.
The operation completed successfully.
The operation completed successfully.
The operation completed successfully.
The operation completed successfully.
The operation completed successfully.
The operation completed successfully.
