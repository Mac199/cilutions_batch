@echo off
setlocal enabledelayedexpansion
set myDIR=%CD%
set signageDIR=c:\users\mediasignage\MediaSignage

@echo Using Installation Directory  "%myDIR%"
@echo Using Signage Directory       "%signageDIR%"

@echo Stopping Signage
@call "%signageDIR%\stop.bat"
rem taskkill /IM monitor_control.exe /F /T

rem # patch installation starts here
set rootdir=%myDIR%
set foo=%rootdir%
set cut=
:loop
if not "!foo!"=="" (
    set /a cut += 1
    set foo=!foo:~1!
    goto :loop
)
echo Root dir: %rootdir%
echo strlen  : %cut%

rem also remove leading \ if present
if not %rootdir:~-1%==\ set /a cut += 1

if exist upgrade_wwwroot.bat del /F /Q upgrade_wwwroot.bat
echo Set UAC = CreateObject^("Shell.Application"^) > "upgrade_wwwroot.vbs"
echo UAC.ShellExecute "%myDIR%/upgrade_wwwroot.bat", "", "", "runas", 0 >> "upgrade_wwwroot.vbs"




rem ****** Create settings.vbs and settings.bat to run commands with elevated privileges *****
echo Set UAC = CreateObject^("Shell.Application"^) > "settings.vbs"
echo UAC.ShellExecute "%myDIR%/settings.bat", "", "", "runas", 0 >> "settings.vbs"

rem Create settings.bat
echo setlocal > "%myDIR%\settings.bat"

rem turn off UAC
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >> "%myDIR%\settings.bat"

rem turn on system protection
echo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v RPSessionInterval /t REG_DWORD /d 1 /f  >> "%myDIR%\settings.bat"
echo vssadmin resize shadowstorage /for=c: /on=c: /maxsize=3%
rem disable fast user switching
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v HideFastUserSwitching /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"

rem disable IPv 6
echo reg add "HKLM\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters" /v DisabledComponents /t REG_DWORD /d 4294967295 /f >> "%myDIR%\settings.bat"

rem enviroment variables
echo setx Tmp %SystemRoot%\TEMP /M >> "%myDIR%\settings.bat"
echo setx Temp %SystemRoot%\TEMP /M >> "%myDIR%\settings.bat"
echo setx Path "c:\cygwin\bin;C:\Ruby193\bin;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files\Hughes Network Systems\PDReceiver\bin;c:\cilutions" /M >> "%myDIR%\settings.bat"

rem Group Policy - Turn off ActiveX Opt-In Prompt
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" /v NoFirsttimeprompt /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"

rem Group Policy - Disable Windows Defender
echo reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"

rem Set Users names as Support and MediaSignage
echo wmic useraccount where name='support' set FullName=Support >> "%myDIR%\settings.bat"
echo wmic useraccount where name='mediasignage' set FullName=MediaSignage >> "%myDIR%\settings.bat"

rem IIS: Disable caching and logging
rem echo c:\windows\system32\inetsrv\appcmd set config "Default Web Site/MediaSignage" -section:staticContent /clientCache.cacheControlMode:DisableCache >> "%myDIR%\settings.bat"
echo c:\windows\system32\inetsrv\appcmd set config "Default Web Site/MediaSignage" /section:httpProtocol /+"customHeaders.[name='Cache-Control',value='no-cache, no-store, must-revalidate']" >> "%myDIR%\settings.bat"
echo c:\windows\system32\inetsrv\appcmd set config /section:httpLogging /dontLog:True >> "%myDIR%\settings.bat"

rem disable kernel cache
echo c:\windows\system32\inetsrv\appcmd set config /section:caching /enableKernelCache:false >> "%myDIR%\settings.bat"

rem fix click-jacking
echo c:\windows\system32\inetsrv\appcmd set config "Default Web Site/MediaSignage" /section:httpProtocol /+"customHeaders.[name='X-Frame-Options',value='SAMEORIGIN']" >> "%myDIR%\settings.bat"

rem file explorer settings
echo reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"
echo reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >> "%myDIR%\settings.bat"
echo reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v FullPath /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"

rem add mediasignage virtual directories
echo c:\windows\system32\inetsrv\appcmd add vdir /app.name:"Default Web Site/" /path:/MediaSignage /physicalPath:C:\Users\MediaSignage\MediaSignage >> "%myDIR%\settings.bat"
rem Add IIS_IUSRS with Full permissions to MediaSignage and PDReceiver directories
echo icacls "C:\Users\MediaSignage\MediaSignage" /grant IUSR:(OI)(CI)F /T >> "%myDIR%\settings.bat"
echo icacls "C:\Users\MediaSignage\MediaSignage" /grant IIS_IUSRS:(OI)(CI)F /T >> "%myDIR%\settings.bat"
echo icacls "C:\Users\MediaSignage\Documents\PDReceiver" /grant IUSR:(OI)(CI)F /T >> "%myDIR%\settings.bat"
echo icacls "C:\Users\MediaSignage\Documents\PDReceiver" /grant IIS_IUSRS:(OI)(CI)F /T >> "%myDIR%\settings.bat"
 
rem Reset Network adapter power options (disable sleep)
echo powershell -executionpolicy bypass -File "%myDIR%\install.ps1" >> "%myDIR%\settings.bat"

rem Update Machine Description with the new version
echo cd %signageDIR% >> "%myDIR%\settings.bat"
echo cscript /nologo %signageDIR%/NetComment.vbs SET >> "%myDIR%\settings.bat"

rem allow website caches and databases
reg add "HKCU\Software\Microsoft\Internet Explorer\BrowserStorage\AppCache" /v AllowWebsiteCaches /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"
reg add "HKCU\Software\Microsoft\Internet Explorer\BrowserStorage\IndexedDB" /v AllowWebsiteDatabases /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"

rem install PDReceiver change registry setting
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\db\ /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_EVT /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\db\ /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX_DEFAULT_DEST /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\load\ /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX_LOAD /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\temphold\ /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX_UPDATE_DEST /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\update\ /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_SFX_WWW_ROOT /t REG_SZ /d C:\Users\MediaSignage\Documents\PDReceiver\wwwroot\ /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v LAUNCH_IMMEDIATELY /t REG_SZ /d 1 /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v USE_LONG_FILE_NAME_IN_FINSTALL /t REG_SZ /d 1 /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v SFS_GET_LOCAL_ADDRESS /t REG_SZ /d 1 /f  >> "%myDIR%\settings.bat"
echo reg add "HKLM\SOFTWARE\Hughes Network Systems\PDReceiver" /v DISABLEPROGRESSMETER /t REG_SZ /d 1 /f  >> "%myDIR%\settings.bat"

rem add localhost to favorites toolbar and make it visible
rem IE Setting - add localhost to favorites toolbar 
echo CREATING IE SHOTCUTS FOR MediaSignage
echo echo [InternetShortcut] ^> "C:\Users\MediaSignage\Favorites\links\MediaSignage.URL" >> "%myDIR%\settings.bat"
echo echo URL=http://localhost/MediaSignage/content/current.html ^>^> "C:\Users\MediaSignage\Favorites\Links\MediaSignage.URL" >> "%myDIR%\settings.bat"
echo echo  IconIndex=0 ^>^> "C:\Users\MediaSignage\Favorites\Links\MediaSignage.URL" >> "%myDIR%\settings.bat"
echo  CREATED IE SHOTCUTS

echo CREATING IE SHOTCUTS FOR Support
echo echo [InternetShortcut] ^> "C:\Users\Support\Favorites\links\MediaSignage.URL" >> "%myDIR%\settings.bat"
echo echo URL=http://localhost/MediaSignage/content/current.html ^>^> "C:\Users\Support\Favorites\Links\MediaSignage.URL" >> "%myDIR%\settings.bat"
echo echo  IconIndex=0 ^>^> "C:\Users\Support\Favorites\Links\MediaSignage.URL" >> "%myDIR%\settings.bat"
echo  CREATED IE SHOTCUTS


echo reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v CsEnabled /t REG_DWORD /d 0 /f >> "%myDIR%\settings.bat"
echo reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled /t REG_DWORD /d 0 /f >> "%myDIR%\settings.bat"

echo cp /cygdrive/c/cilutions/kts.ini /cygdrive/c/"program files"/kts.ini >> "%myDIR%\settings.bat"
echo cp /cygdrive/c/cilutions/kts_allusers.bat /cygdrive/c/"program files"/kts/scripts/allusers.bat >> "%myDIR%\settings.bat"
echo cp /cygdrive/c/Cilutions/Logout.lnk /cygdrive/c/Users/Support/AppData/Roaming/Microsoft/Windows/"Start Menu"/Programs >> "%myDIR%\settings.bat"
echo cp /cygdrive/c/Cilutions/"Network Connections".lnk /cygdrive/c/Users/Support/AppData/Roaming/Microsoft/Windows/"Start Menu"/Programs >> "%myDIR%\settings.bat"

rem get rid of the logon background image
echo reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System"  /v DisableLogonBackgroundImage /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"

rem add finstall
echo cp /cygdrive/c/Cilutions/finstall.bat /cygdrive/c/Users/MediaSignage/Documents/PDReceiver/load >> "%myDIR%\settings.bat"

rem disable bluetooth
echo reg add "HKLM\SYSTEM\CurrentControlSet\services\bthserv" /v Start /t REG_DWORD /d 4 /f >> "%myDIR%\settings.bat"
rem disableantispyware = 1
echo reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"
rem turn wifi off
echo netsh interface set interface "wi-fi" disabled >> "%myDIR%\settings.bat"

rem IE Setting Disable IE 11 auto update
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f >> "%myDIR%\settings.bat"
rem grant MediaSignage user EPD service access
echo "C:\Program Files\Windows Resource Kits\Tools\subinacl" /service EPDReceiver /grant=MediaSignage=TOP  >> "%myDIR%\settings.bat"
rem Run elevated set up
if exist "%myDIR%\settings.bat" runas /user:support /savecred "wscript \"%myDIR%/settings.vbs \""

rem IE Settings
rem IE Setting - Display Mixed Content = enabled for all zones
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v 1609 /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v 1609 /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 1609 /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v 1609 /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v 1609 /t REG_DWORD /d 0 /f
echo "" | runas /user:mediasignage /savecred "reg add \"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0\" /v 1609 /t REG_DWORD /d 0 /f"
echo "" | runas /user:mediasignage /savecred "reg add \"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1\" /v 1609 /t REG_DWORD /d 0 /f"
echo "" | runas /user:mediasignage /savecred "reg add \"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\" /v 1609 /t REG_DWORD /d 0 /f"
echo "" | runas /user:mediasignage /savecred "reg add \"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3\" /v 1609 /t REG_DWORD /d 0 /f"
echo "" | runas /user:mediasignage /savecred "reg add \"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4\" /v 1609 /t REG_DWORD /d 0 /f"

rem IE Setting - Enable "Do Not Track" request
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v DoNotTrack /t REG_DWORD /d 1 /f
echo "" | runas /user:mediasignage /savecred "reg add \"HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\" /v DoNotTrack /t REG_DWORD /d 1 /f"

rem IE Setting - Enable Memory Protection
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v DEPOff /t REG_DWORD /d 0 /f
echo "" | runas /user:mediasignage /savecred "reg add \"HKCU\SOFTWARE\Microsoft\Internet Explorer\Main\" /v DEPOff /t REG_DWORD /d 0 /f"

rem IE Setting - always show favorites toolbar
reg add "HKCU\Software\Microsoft\Internet Explorer\MINIE" /v AlwaysShowMenus /t REG_DWORD /d 1 /f 
reg add "HKCU\Software\Microsoft\Internet Explorer\MINIE" /v LinksBandEnabled /t REG_DWORD /d 1 /f 

rem IE Setting - delete browing history on exit
reg add "HKCU\Software\Microsoft\Internet Explorer\Privacy" /v ClearBrowsingHistoryOnExit /t REG_DWORD /d 1 /f

rem days to keep pages in history
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Url History" /v DaysToKeep /t REG_DWORD /d 1 /f

rem reset zoom level for new windows and tabs
reg add "HKCU\Software\Microsoft\Internet Explorer\Zoom" /v ResetZoomOnStartup2 /t REG_DWORD /d 1 /f 
rem set background 
reg add "HKCU\control panel\desktop" /v wallpaper /t REG_SZ /d "C:\Cilutions\Content\Abstract-background_16x9_1920x1080.png" /f
rem set power seetings
powercfg -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg.exe -change -monitor-timeout-ac 0
powercfg.exe -change -monitor-timeout-dc 0  
powercfg.exe -change -disk-timeout-ac 0
powercfg.exe -change -disk-timeout-dc 0
powercfg.exe -change -standby-timeout-ac 0
powercfg.exe -change -standby-timeout-dc 0
powercfg.exe -change -hibernate-timeout-ac 0
powercfg.exe -change -hibernate-timeout-dc 0
powercfg -SETACTIVE a1841308-3541-4fab-bc81-f71556f20b4a
powercfg.exe -change -monitor-timeout-ac 0
powercfg.exe -change -monitor-timeout-dc 0
powercfg.exe -change -disk-timeout-ac 0
powercfg.exe -change -disk-timeout-dc 0
powercfg.exe -change -standby-timeout-ac 0
powercfg.exe -change -standby-timeout-dc 0
powercfg.exe -change -hibernate-timeout-ac 0
powercfg.exe -change -hibernate-timeout-dc 0
powercfg -SETACTIVE 381b4222-f694-41f0-9685-ff5bb260df2e
powercfg.exe -change -monitor-timeout-ac 0
powercfg.exe -change -monitor-timeout-dc 0
powercfg.exe -change -disk-timeout-ac 0
powercfg.exe -change -disk-timeout-dc 0
powercfg.exe -change -standby-timeout-ac 0
powercfg.exe -change -standby-timeout-dc 0
powercfg.exe -change -hibernate-timeout-ac 0
powercfg.exe -change -hibernate-timeout-dc 0

rem disable windows indexing
net stop Wsearch
