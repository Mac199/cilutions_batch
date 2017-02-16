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
c:\windows\system32\inetsrv\appcmd set config "Default Web Site" /section:httpProtocol /+"customHeaders.[name='X-Frame-Options',value='SAMEORIGIN']" 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v FullPath /t REG_DWORD /d 1 /f 
c:\windows\system32\inetsrv\appcmd add vdir /app.name:"Default Web Site/" /path:/MediaSignage /physicalPath:C:\Users\MediaSignage\MediaSignage 
icacls "C:\Users\MediaSignage\MediaSignage" /grant IUSR:(OI)(CI)F /T 
icacls "C:\Users\MediaSignage\MediaSignage" /grant IIS_IUSRS:(OI)(CI)F /T 
icacls "C:\Users\MediaSignage\Documents\PDReceiver" /grant IUSR:(OI)(CI)F /T 
icacls "C:\Users\MediaSignage\Documents\PDReceiver" /grant IIS_IUSRS:(OI)(CI)F /T 
icacls "C:\Program Files\Hughes Network Systems\PDReceiver" /grant HS850\MediaSignage:(OI)(CI)F /T 
powershell -executionpolicy bypass -File "C:\test\install.ps1" 
cd c:\users\mediasignage\MediaSignage 
cscript /nologo c:\users\mediasignage\MediaSignage/NetComment.vbs SET 
The operation completed successfully.
The operation completed successfully.
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\db\ /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_EVT /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\db\ /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX_DEFAULT_DEST /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\load\ /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX_LOAD /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\temphold\ /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX_UPDATE_DEST /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\update\ /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX_WWW_ROOT /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\wwwroot\ /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v LAUNCH_IMMEDIATELY /t REG_SZ /d 1 /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v USE_LONG_FILE_NAME_IN_FINSTALL /t REG_SZ /d 1 /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_GET_LOCAL_ADDRESS /t REG_SZ /d 1 /f  
reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v DISABLEPROGRESSMETER /t REG_SZ /d 1 /f  
echo [InternetShortcut] > "C:\Users\MediaSignage\Favorites\links\Hughes Digital Signage.URL" 
echo URL=http://localhost/MediaSignage/content/current.html >> "C:\Users\MediaSignage\Favorites\Links\Hughes Digital Signage.URL" 
echo  IconIndex=0 >> "C:\Users\MediaSignage\Favorites\Links\Hughes Digital Signage.URL" 
echo [InternetShortcut] > "C:\Users\Support\Favorites\links\Hughes Digital Signage.URL" 
echo URL=http://localhost/MediaSignage/content/current.html >> "C:\Users\Support\Favorites\Links\Hughes Digital Signage.URL" 
echo  IconIndex=0 >> "C:\Users\Support\Favorites\Links\Hughes Digital Signage.URL" 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v CsEnabled /t REG_DWORD /d 0 /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled /t REG_DWORD /d 0 /f 
cp /cygdrive/c/cilutions/kts.ini /cygdrive/c/"program files"/kts.ini 
cp /cygdrive/c/cilutions/kts_allusers.bat /cygdrive/c/"program files"/kts/scripts/allusers.bat 
cp /cygdrive/c/Cilutions/Logout.lnk /cygdrive/c/Users/Support/AppData/Roaming/Microsoft/Windows/"Start Menu"/Programs 
cp /cygdrive/c/Cilutions/"Network Connections".lnk /cygdrive/c/Users/Support/AppData/Roaming/Microsoft/Windows/"Start Menu"/Programs 
reg add "HKLM\system\currentcontrolset\control\lsa"  /v limitblankpassworduse /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System"  /v DisableLogonBackgroundImage /t REG_DWORD /d 1 /f 
cp /cygdrive/c/Cilutions/finstall.bat /cygdrive/c/Users/MediaSignage/Documents/PDReceiver/load 
reg add "HKLM\SYSTEM\CurrentControlSet\services\bthserv" /v Start /t REG_DWORD /d 4 /f 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f 
netsh interface set interface "wi-fi" disabled 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware  /t REG_DWORD /d 1 /f 
net user Support jerich0 /add 
net localgroup administrators [Support] /add 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f 
"C:\Program Files\Windows Resource Kits\Tools\subinacl" /service EPDReceiver /grant=MediaSignage=TOP  
reg add "HKLM\SYSTEM\CurrentControlSet\services\TCPip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 0 /f 
c:\windows\system32\inetsrv\appcmd set config /section:anonymousAuthentication /enabled:True 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableChangePassword /t REG_DWORD /d 0 /f 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 0 /f 
