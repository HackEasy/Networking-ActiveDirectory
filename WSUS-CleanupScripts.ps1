#        Th3 M4d_Sc13nT15t is here to stay...
#    We trust you have received teh usual lecture
#        from the local System Administrator. 
#   It usually boils down to these three things:
#  		#1) Respect the privacy of others.
#  		#2) Think before you type.
#  		#3) With great poewr comes great responsibility.

:: Set your server name here or keep the defaults.
SET SERVERNAME=%COMPUTERNAME%.%USERDNSDOMAIN%
SET SERVERPORT=8530

:: Set the working directory
SETX /M AJSUCKS %~dp0

:: Force script elevation if not already elevated
"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system">nul 2>&1
IF NOT "%ERRORLEVEL%"=="0" (
  powershell.exe /C "Start-Process -Filepath '%~dpnx0' -Verb RunAs"
  exit /b
)

:: Run from the install directory
PUSHD CD "%~dp0"

:: https://gallery.technet.microsoft.com/WSUS-cleanup-script-7e019537
powershell.exe -ExecutionPolicy Bypass /C ".\wsus-cleanup-updates-v4\wsus-cleanup-updates-v4.ps1"

:: https://gallery.technet.microsoft.com/scriptcenter/fd39c7d4-05bb-4c2d-8a99-f92ca8d08218
powershell.exe -ExecutionPolicy Bypass /C ".\wsuscleanup\wsuscleanup.ps1"

:: https://gallery.technet.microsoft.com/scriptcenter/WSUS-Maintenance-w-logging-d507a15a
powershell.exe -ExecutionPolicy Bypass /C ".\Wsus-Maintenance\Wsus-Maintenance.ps1 %SERVERNAME% %SERVERPORT%"

:: https://gallery.technet.microsoft.com/scriptcenter/WSUS-Content-Cleanup-68986b06
powershell.exe -ExecutionPolicy Bypass /C ".\Start-WSUSCleanup\Start-WSUSCleanup.ps1"

:: https://github.com/samersultan/wsus-cleanup
powershell.exe -ExecutionPolicy Bypass /C ".\WSUS-Cleanup\WSUS-Cleanup.ps1"

:: https://www.urtech.ca/2016/10/solved-how-to-clean-up-and-repair-wsus/
sqlcmd -I -S \\.\pipe\MICROSOFT##WID\tsql\query -i WsusDBMaintenance\WsusDBMaintenance.sql

:: https://damgoodadmin.com/2017/11/05/fully-automate-software-update-maintenance-in-cm/
:: https://damgoodadmin.com/2018/10/17/latest-software-maintenance-script-making-wsus-suck-slightly-less/ (UNTESTED)
powershell.exe -ExecutionPolicy Bypass /C ".\Invoke-DGASoftwareUpdateMaintenance\Invoke-DGASoftwareUpdateMaintenance.ps1"

:: Pause so the user can read the output if desired.
PAUSE 