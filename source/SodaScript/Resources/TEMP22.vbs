Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & "%windir%\System32\TempCleaner.bat" & Chr(34), 0
Set WshShell = Nothing