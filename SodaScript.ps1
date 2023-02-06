If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

function Set-ConsoleColor ($bc, $fc) {
    $Host.UI.RawUI.BackgroundColor = $bc
    $Host.UI.RawUI.ForegroundColor = $fc
    Clear-Host
}
mode con: cols=115 lines=30
Set-ConsoleColor 'Black' 'Red'
$host.ui.RawUI.WindowTitle = "SodaScript_v4.4"
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#- SYSTEM INFORMATION #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
$global:progressPreference = 'silentlyContinue'
Write-Host "Getting System Information..."
#HARDWARE
$Processor = (Get-WmiObject Win32_Processor).Name
$CPUThreads = (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors
$CPUCores = (Get-WmiObject Win32_Processor).NumberOfCores
$Graphics = (Get-WmiObject Win32_VideoController).Name
$GraphicsID = (Get-WmiObject Win32_VideoController).PNPDeviceID
$Memory = ((Get-WmiObject -Class "Win32_PhysicalMemory" | Measure-Object -Property Capacity -Sum).Sum) / 1024 / 1024
$NetAdapterID = (Get-WmiObject win32_NetworkAdapter).PNPDeviceID
$NetworkAdapter = Get-NetAdapter | Where-Object {$_.Name -like "Ethernet"}
$NetAdapter2 = (Get-NetAdapter | Where-Object {$_.Name -like "Ethernet"}).ifIndex
$DriverKey = (Get-WmiObject -Class Win32_PnPEntity | Where-Object {$_.Name -eq $NetworkAdapter.InterfaceDescription}).ClassGuid
$DetectSSD = (Get-PhysicalDisk).MediaType
$PCorLap = (Get-WmiObject -Class Win32_ComputerSystem).PCSystemType
$PlanCheck = powercfg /GetActiveScheme
$RestoreCheck = (Get-ComputerRestorePoint | Where-Object {$_.Description -eq "SodaScript"}).Description
$L3Cache = (Get-WmiObject -ClassName Win32_Processor).L3CacheSize
$L2Cache = (Get-WmiObject -ClassName Win32_Processor).L2CacheSize
#SOFTWARE
$Windows = (Get-WmiObject Win32_OperatingSystem).Caption
$Check11 = ($Windows).Contains("11")
$WindowsVer = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
$Project = "SodaScript"
$Data = "$env:ProgramData\$Project"
$Temporary = "$env:Temp\$Project"
$StartUP = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
If ((Test-Path $Data) -eq $false) {
	New-Item -Path $Data -ItemType "Directory" | Out-Null
}
If ((Test-Path $Temporary) -eq $false) {
	New-Item -Path $Temporary -ItemType "Directory" | Out-Null
}
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-# InternetCheck #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
$InternetCheck = (Test-Connection www.Google.com -Count 1 -Quiet)
if(($InternetCheck) -eq $false){Write-Host "No Internet Connection. Exiting..." -BackgroundColor Red -ForegroundColor Black ; Start-Sleep 3 ; Exit}
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-# LOG FILE #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
$time = Get-Date -Format "SodaScript-yyyy-MM-dd---HH.mm"
Start-Transcript -Path $Data\soda-$time.log| Out-Null
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "Lodaing Optimization Files..."
If ((Test-Path "$env:Temp\SodaScript\transparent.ico") -eq $false) {
	(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/961135549861728286/transparent.ico", "$env:Temp\SodaScript\transparent.ico")
}
If ((Test-Path "$env:Temp\SodaScript\blank.ico") -eq $false) {
	(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/961135576004829224/blank.ico", "$env:Temp\SodaScript\blank.ico")
}
If ((Test-Path "$env:Temp\SodaScript\TempCleaner.bat") -eq $false) {
	(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/1010621649663557763/TempCleaner.bat", "$env:Temp\SodaScript\TempCleaner.bat")
}
If ((Test-Path "$env:Temp\SodaScript\TEMP22.vbs") -eq $false) {
	(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/925667124058394665/TEMP22.vbs", "$env:Temp\SodaScript\TEMP22.vbs")
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Function CreateRestorePoint {
#Turn On System Protection
	Enable-ComputerRestore -Drive "$env:SystemDrive"
	
#Increase Disk Space Usage
vssadmin resize shadowstorage /on=$env:SystemDrive /for=$env:SystemDrive /maxsize=10GB | Out-Null

#Create Restore Point
	Checkpoint-Computer -Description "SodaScript" -RestorePointType "MODIFY_SETTINGS"
	
	bcdedit /export $Data\SodaBCDEDITbckp
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
If ($RestoreCheck -eq "SodaScript") {
}
Else {
		Write-Host "The script will create a restore point in moments..."
		CreateRestorePoint
	}
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
cls
#Main menu, allowing user selection
Function Show-Menu {
	Clear-Host
     Write-Host "
 ________  ________  ________  ________          ________  ________  ________  ___  ________  _________   
|\   ____\|\   __  \|\   ___ \|\   __  \        |\   ____\|\   ____\|\   __  \|\  \|\   __  \|\___   ___\ 
\ \  \___|\ \  \|\  \ \  \_|\ \ \  \|\  \       \ \  \___|\ \  \___|\ \  \|\  \ \  \ \  \|\  \|___ \  \_| 
 \ \_____  \ \  \\\  \ \  \ \\ \ \   __  \       \ \_____  \ \  \    \ \   _  _\ \  \ \   ____\   \ \  \  
  \|____|\  \ \  \\\  \ \  \_\\ \ \  \ \  \       \|____|\  \ \  \____\ \  \\  \\ \  \ \  \___|    \ \  \ 
    ____\_\  \ \_______\ \_______\ \__\ \__\        ____\_\  \ \_______\ \__\\ _\\ \__\ \__\        \ \__\
   |\_________\|_______|\|_______|\|__|\|__|       |\_________\|_______|\|__|\|__|\|__|\|__|         \|__|
   \|_________|                                    \|_________|                                           
    
		AbdullahNabil	     &	       Ehab Emad		    << EgyptionTeam >>
" -ForegroundColor White
Write-Host "
+======================+======================+
| O: Optimize          | R: Revert            |
+----------------------+----------------------+
" -ForegroundColor red
	$scriptVersion = "SodaScript_v4.3"
	$UpdateCheck = (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/SychoAN/SodaScript/master/latest.txt")
	if ($UpdateCheck -eq $scriptVersion){
	}
	Else {
Write-Host "
+========================+
| U: Update Available !  |
+------------------------+
" -BackgroundColor Green -ForegroundColor White
	}
}
#Functions go here
Function Update1{
	$UpdateCheck = (New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/SychoAN/SodaScript/master/latest.txt")
Write-Host "New Version Detected !"
	Write-Host "Downloading..."
	(new-object System.Net.WebClient).DownloadFile("https://github.com/SychoAN/SodaScript/releases/latest/download/SodaScript.ps1", "$PSScriptRoot\SodaScript.ps1")
	Write-Host "Restarting..."
	Start-Sleep 2
	Start-Process $PSHOME\powershell.exe -ArgumentList "-File $PSScriptRoot\SodaScript.ps1"
	Exit
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Function WindowsTweaks{
$global:progressPreference = 'silentlyContinue'
Write-Host "Removing Bloatware..."
Write-Host "This Might Take 3-4 Minutes IF HDD"
$Bloatware = @(
                    "Microsoft.3DBuilder"
                    "Microsoft.Getstarted"
                    "Microsoft.BingWeather"
                    "Microsoft.BingNews"
                    "Microsoft.GetHelp"
                    "Microsoft.People"
                    "Microsoft.WindowsFeedbackHub"
                    "MicrosoftTeams"
                    "Microsoft.MicrosoftStickyNotes"
                    "Microsoft.Todos"
                    "Microsoft.SkypeApp"
                    "Microsoft.Office.OneNote"
                    "Microsoft.MicrosoftOfficeHub"
                    "Microsoft.MixedReality.Portal"
                    )
                    Foreach ($Bloat in $Bloatware) {
                    Get-AppxPackage $Bloat | Remove-AppxPackage
                    Get-AppxPackage $Bloat -AllUsers | Remove-AppxPackage
                    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat| Remove-AppxProvisionedPackage -Online
	                }
#disable (Edge) Prelaunch
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v AllowPrelaunch /t REG_DWORD /d "0" /f | Out-Null
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d "0" /f | Out-Null
#LowerRam Usage
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Value 0 -PropertyType DWord -Force | Out-Null
Remove-Item -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{9459C573-B17A-45AE-9F64-1857B5D58CEE}' -Recurse -ErrorAction SilentlyContinue
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Edge") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'StartupBoostEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'HardwareAccelerationModeEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'BackgroundModeEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
Get-ScheduledTask -TaskName "MicrosoftEdgeUpdate*" | Disable-ScheduledTask | Out-Null 

#Uninstall OneDrive - Not applicable to Server
	Stop-Process -Name OneDrive -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
	$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
	If (!(Test-Path $onedrive)) {
		Write-Host "Uninstalling OneDrive..."
		$onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
	}
	Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
	Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
	
#Activate Windows Photo Viewer
	$WindowsPhotoViewer = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
	if((Test-Path -LiteralPath $WindowsPhotoViewer) -ne $true) {  New-Item $WindowsPhotoViewer -force | Out-Null };
		Set-ItemProperty $WindowsPhotoViewer ".tif" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".tiff" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".bmp" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".dib" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".gif" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".jfif" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".jpe" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".jpeg" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".jpg" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".jxr" -Value "PhotoViewer.FileAssoc.Tiff"
		Set-ItemProperty $WindowsPhotoViewer ".png" -Value "PhotoViewer.FileAssoc.Tiff"
cls
Write-Host "Disabling Unnecessery Devices..."
# Devices
Get-PnpDevice -FriendlyName "High Precision event timer" | Disable-PnpDevice -ea SilentlyContinue -Confirm:$false | Out-Null
Get-PnpDevice -FriendlyName "Composite Bus Enumerator" | Disable-PnpDevice -ea SilentlyContinue -Confirm:$false | Out-Null
Get-PnpDevice -FriendlyName "NDIS Virtual Network Adapter Enumerator" | Disable-PnpDevice -ea SilentlyContinue -Confirm:$false | Out-Null
Get-PnpDevice -FriendlyName "UMBus Root Bus Enumerator" | Disable-PnpDevice -ea SilentlyContinue -Confirm:$false | Out-Null
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "Disabling Unnecessery Features..."
$Features = @(
	"MediaPlayback"
	"SMB1Protocol"
	"WCF-Services45"
	"Xps-Foundation-Xps-Viewer"
    )

Foreach ($Feature in (Get-WindowsOptionalFeature -Online).FeatureName) {
	If ($Feature -in $Features) {
		Disable-WindowsOptionalFeature -Online -FeatureName $Feature -NoRestart |Out-Null
	}
}

#Remove AutoLogger file and restrict directory
	$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
		If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
			Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
		}
	icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "Disabling Unnecessery Services..."
$Services = @(
"DiagTrack" #Connected User Experiences and Telemetry. If you're concerned with privacy and don't want to send usage data to Microsoft for analysis, then this service is one to go.
"DusmSvc" #Data Usage
"iphlpsvc" #IP Helper
"seclogon" #Secondary Logon
"ShellHWDetection" #Shell Hardware Detection
"WerSvc" #Windows Error Reporting
	)
Foreach ($Service in (Get-Service).Name) {
	If ($Service -in $Services) {
		Set-Service $Service -StartupType Disabled
	}
}
if ($Check11){ 
Set-Service CDPSvc -StartupType manual
Set-Service RmSvc -StartupType manual
Set-Service TabletInputService -StartupType manual
}
else { 
Set-Service CDPSvc -StartupType Disabled
Set-Service RmSvc -StartupType Disabled
Set-Service TabletInputService -StartupType Disabled
}
Set-Service DPS -StartupType manual
Set-Service TrkWks -StartupType manual
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
$AutoLogger = "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
If (Test-Path $AutoLogger) {
	Remove-Item -Path $AutoLogger
}
Write-Host "Disabling Some Scheduled Tasks..."
# Scheduled Tasks
Get-ScheduledTask -TaskName "Background Synchronization" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "BfeOnServiceStartTypeChange" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "BgTaskRegistrationMaintenanceTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Consolidator" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "DmClient" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "DmClientOnScenarioDownload" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "FamilySafetyMonitor" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "FamilySafetyRefreshTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "ForceSynchronizeTime" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "GoogleUpdateTaskMachineCore*" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "GoogleUpdateTaskMachineUA*" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "WinSAT" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Microsoft-Windows-DiskDiagnosticDataCollector" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Microsoft-Windows-DiskDiagnosticResolver" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "MicrosoftEdgeUpdateTaskMachineCore" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Office Automatic Updates 2.0" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Office Feature Updates Logon" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Office Feature Updates" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Office Serviceability Manager" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "OfficeTelemetryAgentFallBack2016" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "OfficeTelemetryAgentLogOn2016" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "*OneDrive Standalone Update*" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "ProcessMemoryDiagnosticEvents" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "ProgramDataUpdater" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Proxy" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "QueueReporting" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "RecommendedTroubleshootingScanner" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "RegIdleBackup" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "ResolutionHost" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "RunFullMemoryDiagnostic" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SR" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Scheduled" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "ScheduledDefrag" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SilentCleanup" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "StartIsBack health check" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "StartupAppTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SvcRestartTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SvcRestartTaskLogon" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SvcRestartTaskNetwork" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Synchronize Language Settings" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SynchronizeTime" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SynchronizeTimeZone" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "UsbCeip" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "VerifyWinRE" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Windows Defender Cache Maintenance" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Windows Defender Cleanup" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Windows Defender Scheduled Scan" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Windows Defender Verification" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "XblGameSaveTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "update-*-1001" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "update-sys" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Schedule Work" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "MaintenanceTasks" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "IndexerAutomaticMaintenance" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "MicrosoftEdgeUpdateBrowserReplacementTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "CleanupOfflineContent" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "MNO Metadata Parser" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "EnableErrorDetailsUpdate" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "CertPathCheck" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Maintenance" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "PcaPatchDbTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "BackgroundDownload" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "BraveSoftwareUpdateTaskMachineUA" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "BraveSoftwareUpdateTaskMachineCore" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "StartIsBack health check" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Consolidator" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "BthSQM" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "KernelCeipTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "UsbCeip" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Uploader" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "ProgramDataUpdater" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "StartupAppTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Microsoft-Windows-DiskDiagnosticDataCollector" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Microsoft-Windows-DiskDiagnosticResolver" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "AnalyzeSystem" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "FamilySafetyMonitor" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "FamilySafetyRefresh" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "FamilySafetyUpload" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Proxy" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "WinSAT" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "AitAgent" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "QueueReporting" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "CreateObjectTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Diagnostics" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "File History (maintenance mode)" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Sqm-Tasks" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "GatherNetworkInfo" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SmartScreenSpecific" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Automatic App Update" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "ForceSynchronizeTime" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "SynchronizeTime" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "FODCleanupTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "DmClient" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "DmClientOnScenarioDownload" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "PcaPatchDbTask" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Device" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "Device User" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "OfficeTelemetryAgentFallBack2016" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "OfficeTelemetryAgentLogOn2016" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "OfficeTelemetryAgentFallBack" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
Get-ScheduledTask -TaskName "OfficeTelemetryAgentLogOn" -ea SilentlyContinue | Disable-ScheduledTask | Out-Null
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "StorageTweaks..."
#Storage Tweaks
	fsutil behavior set disablecompression 1 | Out-Null
	fsutil behavior set disableencryption 1 | Out-Null
	fsutil behavior set disablelastaccess 1 | Out-Null
	fsutil behavior set encryptpagingfile 0 | Out-Null
	fsutil behavior set disable8dot3 1 | Out-Null
	
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f | Out-Null
	# Disalbe paths over 260 characters
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "0" /f | Out-Null
	
If ($DetectSSD -eq "HDD") {
}
ElseIf ($DetectSSD -eq "SSD") {
SSDOnly
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
# Reduce Processes
$Items = @(
	"backgroundTaskHost.exe"
	"CompPkgSrv.exe"
	"SettingSyncHost.exe"
	"upfc.exe"
)

Foreach ($Item in $Items) {
	If (Test-Path $env:SystemRoot\System32\$Item) {
		takeown.exe /f $Item | Out-Null
		icacls.exe $Item /reset | Out-Null
		Rename-Item -Path "$env:SystemRoot\System32\$Item" -NewName "$Item.old" -Force -ea silentlyContinue
	}
}
$HelpPane = "$env:SystemRoot\HelpPane.exe"
	If (Test-Path $HelpPane) {
		takeown.exe /f $HelpPane | Out-Null
		icacls.exe $HelpPane /reset | Out-Null
		Rename-Item -Path "$HelpPane" -NewName "HelpPane.old" -Force
	}

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "bcdedit Tweaks..."
#bcdedit Tweaks
bcdedit /deletevalue useplatformclock | Out-Null
bcdedit /set firstmegabytepolicy UseAll | Out-Null
bcdedit /set MSI Default | Out-Null
bcdedit /set allowedinmemorysettings 0x0 | Out-Null
bcdedit /set avoidlowmemory 0x8000000 | Out-Null
bcdedit /set bootmenupolicy standard | Out-Null
bcdedit /set configaccesspolicy Default | Out-Null
bcdedit /set hypervisorlaunchtype off | Out-Null
bcdedit /set increaseuserva 268435328 | Out-Null
bcdedit /set isolatedcontext No | Out-Null
bcdedit /set linearaddress57 OptOut | Out-Null
bcdedit /set nolowmem Yes | Out-Null
bcdedit /set usefirmwarepcisettings No | Out-Null
bcdedit /set usephysicaldestination No | Out-Null
bcdedit /set vm No | Out-Null
bcdedit /set vsmlaunchtype Off | Out-Null
bcdedit /timeout 0 | Out-Null

#Enable F8 boot menu options
bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
#ForAllCards

	#Disable ModernStandby
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f | Out-Null
	
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "0" /f | Out-Null

If ($Graphics -like "*NVIDIA*") {
Write-Host "Optimizing Your Nvidia Graphics Card..."
		(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929974567659786240/Base_Profile.nip", "$env:Temp\SodaScript\Base_Profile.nip")
		(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929974567483629578/nvidiaProfileInspector.exe", "$env:Temp\SodaScript\nvidiaProfileInspector.exe")

		Reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color" /v "NvCplUseColorCorrection" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PlatformSupportMiracast" /t Reg_DWORD /d "0" /f | Out-Null
		reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f | Out-Null
		reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d 0 /f | Out-Null
		reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d 0 /f | Out-Null
		reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d 0 /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t Reg_DWORD /d "1" /f | Out-Null
		Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'NvBackend' -ea SilentlyContinue -Force | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t Reg_DWORD /d "4" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t Reg_DWORD /d "0" /f | Out-Null
		
		Start-Process "$Temporary\nvidiaProfileInspector.exe" "$Temporary\Base_Profile.nip"
		
		# Disable NVIDIA Telemetry
		reg add "HKLM\SYSTEM\CurrentControlSet\Services\NvTelemetryContainer" /v "Start" /t REG_DWORD /d "4" /f | Out-Null
		#KBoost
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevelAC" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t Reg_DWORD /d "0" /f | Out-Null
		
}
ElseIf ($Graphics -like "*AMD*") {
Write-Host "Optimizing Your AMD Graphics Card..."

	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v LTRSnoopL1Latency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v LTRSnoopL0Latency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v LTRNoSnoopL1Latency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v LTRMaxNoSnoopLatency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v KMD_RpmComputeLatency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v DalUrgentLatencyNs /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v memClockSwitchLatency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v PP_RTPMComputeF1Latency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v PP_DGBMMMaxTransitionLatencyUvd /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v PP_DGBPMMaxTransitionLatencyGfx /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v DalNBLatencyForUnderFlow /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v DalDramClockChangeLatencyNs /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v BGM_LTRSnoopL1Latency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v BGM_LTRSnoopL0Latency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v BGM_LTRNoSnoopL1Latency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v BGM_LTRNoSnoopL0Latency /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v BGM_LTRMaxSnoopLatencyValue /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v BGM_LTRMaxNoSnoopLatencyValue /t REG_DWORD /d 1 /f | Out-Null

}
ElseIf ($Graphics -like "*Intel*") {
Write-Host "Optimizing Your Intel Graphics Card..."
	$RegItems2 = @(
		"Enable4KDisplay"
		"WideGamutFeatureEnable"
		"XVYCCFeatureEnable"
		"DeepColorHDMIDisable"
		"Disable_OverlayDSQualityEnhancement"
		"AllowDeepCStates"
		"DelayedDetectionForDP"
		"DelayedDetectionForHDMI"
	)
	$Intel2 = "HKLM:\SYSTEM\ControlSet002\Control\Class\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000"
	Foreach ($RegItem in $RegItems2) {
		IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Intel2 -Name $RegItem) {
			Set-ItemProperty -Path $Intel2 -Name $RegItem -Value 0 -Force
	}
	}
	$RegItems3 = @(
		"InputYUVRangeApplyAlways"
		"SharpnessEnabledAlways"
		"NoiseReductionEnabledAlways"
		"ProcAmpApplyAlways"
	)
	$Intel3 = "HKCU:\Software\Intel\Display\igfxcui\Media"
	Foreach ($RegItem in $RegItems3) {
		IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Intel3 -Name $RegItem) {
			Set-ItemProperty -Path $Intel3 -Name $RegItem -Value 0 -Force
		}
	}
		
		$RegItems4 = @(
		"ProcAmpApplyAlways"
		"InputYUVRangeApplyAlways"
		"SharpnessEnabledAlways"
		"NoiseReductionEnabledAlways"
		"ProcAmpApplyAlways"
		"EnableTCC"
		"EnableFMD"
		"NoiseReductionEnableChroma"
		"SharpnessEnabledAlways"
		"UISharpnessOptimalEnabledAlways"
		"EnableSTE"
		"SkinTone"
		"EnableACE"
		"EnableNLAS"
		"EnableIS"
		"InputYUVRangeApplyAlways"
	)
	$Intel4 = "HKLM:\Software\INTEL\Display\igfxcui\MediaKeys"
	Foreach ($RegItem in $RegItems4) {
		IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Intel4 -Name $RegItem) {
			Set-ItemProperty -Path $Intel4 -Name $RegItem -Value 0 -Force
	}
	}
		$IntelHDGraphicsVRAM = $Memory / 8
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Intel\GMM") -ne $true) {  New-Item "HKLM:\SOFTWARE\Intel\GMM" -force | Out-Null };
		$IntelGMM = "HKLM:\SOFTWARE\Intel\GMM"
		If ((Test-Path $IntelGMM) -eq $false) {
			New-Item $IntelGMM -Force | Out-Null
		}
		Set-ItemProperty -Path $IntelGMM -Name DedicatedSegmentSize -Value $IntelHDGraphicsVRAM
		$Services2 = "HKLM:\SYSTEM\CurrentControlSet\services"
		Set-ItemProperty $Services2\"igfxCUIService1.0.0.0" Start -Value 3 -Force
		Set-ItemProperty $Services2\ICCS Start -Value 4 -Force
		Set-ItemProperty $Services2\cphs Start -Value 4 -Force
		
	}
Write-Host "RegistryTweaks..."
#Gaming Tweaks
	$Gaming = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
	if((Test-Path -LiteralPath $Gaming) -ne $true) {  New-Item $Gaming -force | Out-Null };
		Set-ItemProperty $Gaming Affinity -Value 0 -Force
		Set-ItemProperty $Gaming "Background Only" -Value False -Force
		Set-ItemProperty $Gaming "Clock Rate" -Value 2710 -Force
		Set-ItemProperty $Gaming "GPU Priority" -Value 8 -Force
		Set-ItemProperty $Gaming Priority -Value 6 -Force
		Set-ItemProperty $Gaming "Scheduling Category" -Value High -Force
		Set-ItemProperty $Gaming "SFIO Priority" -Value High -Force
		Set-ItemProperty $Gaming "NoLazyMode" -Value 1 -Force
		Set-ItemProperty $Gaming "Latency Sensitive" -Value True -Force

#PRIORITY
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'LowLatencyScalingPercentage' -Value 64 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HighPerformance' -Value 1 -PropertyType DWord -Force | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t Reg_DWORD /d "1" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t Reg_DWORD /d "1" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t Reg_DWORD /d "10000" /f | Out-Null

#SecondLevelDataCache
	$Memory2 = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
	if((Test-Path -LiteralPath $Memory2) -ne $true) {  New-Item $Memory2 -force | Out-Null };
		Set-ItemProperty $Memory2 SecondLevelDataCache -Value $L2Cache -Force

	
#ThirdLevelDataCache
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" -force | Out-Null };
	if ($L3Cache -eq 2048){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 8264 -PropertyType DWord -Force | Out-Null
	}
	elseif ($L3Cache -eq 3072){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 12402 -PropertyType DWord -Force | Out-Null
	}
	elseif ($L3Cache -eq 4096){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 16534 -PropertyType DWord -Force | Out-Null
	}
	elseif ($L3Cache -eq 6144){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 24900 -PropertyType DWord -Force | Out-Null
	}
	elseif ($L3Cache -eq 8192){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 33170 -PropertyType DWord -Force | Out-Null
	}
	elseif ($L3Cache -eq 16384){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 91012 -PropertyType DWord -Force | Out-Null
	}
	elseif ($L3Cache -eq 32768){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 206696 -PropertyType DWord -Force | Out-Null
	}
	elseif ($L3Cache -eq 65536){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 415030 -PropertyType DWord -Force | Out-Null
	}
	elseif ($L3Cache -eq 131072){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 1249394 -PropertyType DWord -Force | Out-Null
	}
#AdditionalWorkerThreads
	$AdditionalWorkerThreads = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Executive"
	if((Test-Path -LiteralPath $AdditionalWorkerThreads) -ne $true) {  New-Item $AdditionalWorkerThreads -force | Out-Null };
	Set-ItemProperty -Path $AdditionalWorkerThreads -Name "AdditionalCriticalWorkerThreads" -Value $CPUThreads -Force
	Set-ItemProperty -Path $AdditionalWorkerThreads -Name "AdditionalDelayedWorkerThreads" -Value $CPUThreads -Force

#DistributeTimers
	$DistributeTimers = "HKLM:\System\CurrentControlSet\Control\Session Manager\kernel"
	if((Test-Path -LiteralPath $DistributeTimers) -ne $true) {  New-Item $DistributeTimers -force | Out-Null };
	If ($CPUCores -le 6) {
		Set-ItemProperty -Path $DistributeTimers -Name "DistributeTimers" -Value 0 -Force
	}
	ElseIf ($CPUCores -gt 6) {
		Set-ItemProperty -Path $DistributeTimers -Name "DistributeTimers" -Value 1 -Force
	}
#Disable NTFS tunnelling
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'MaximumTunnelEntries' -Value 0 -PropertyType DWord -Force | Out-Null

# TimeStampInterval
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability' -Name 'TimeStampInterval' -Value 1 -PropertyType DWord -Force | Out-Null
	
#Unlocks the ability to modify sleeping CPU cores
	$PowerSettings = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings"
	If (Test-Path $PowerSettings) {
		Set-ItemProperty $PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e ACSettingIndex -Value 0 -Force
		Set-ItemProperty $PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e DCSettingIndex -Value 0 -Force
		Set-ItemProperty $PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c ACSettingIndex -Value 0 -Force
		Set-ItemProperty $PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100 Attributes -Value 2 -Force
		Set-ItemProperty $PowerSettings\54533251-82be-4824-96c1-47b60b740d00\943c8cb6-6f93-4227-ad87-e9a3feec08d1 Attributes -Value 2 -Force
	}
	
#Driver Tweaks
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDebugMode" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t REG_SZ /d "True" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t REG_DWORD /d "24" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t REG_DWORD /d "10000" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t REG_DWORD /d "18" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t REG_DWORD /d "8" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t REG_SZ /d "High" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t REG_SZ /d "High" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f | Out-Null

	$Power3 = "HKLM:\SYSTEM\ControlSet001\Control\Power"
	if((Test-Path -LiteralPath $Power3) -ne $true) {  New-Item $Power3 -force | Out-Null };
		Set-ItemProperty $Power3 MfBufferingThreshold -Value 0 -Force
		Set-ItemProperty $Power3 HibernateEnabledDefault -Value 0 -Force
		Set-ItemProperty $Power3 HibernateEnabled -Value 0 -Force

	$ProcessorPowerSettingsRoot = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00"
	If (Test-Path $ProcessorPowerSettingsRoot) {
		$SubSettings = @(
    		# P-states
    		"06cadf0e-64ed-448a-8927-ce7bf90eb35d" # Processor Performance Increase Threshold - The percentage of processor utilization, in terms of maximum processor utilization, that is required to increase the processor to a higher performance state.
    		"12a0ab44-fe28-4fa9-b3bd-4b64f44960a6" # Processor Performance Decrease Threshold - The percentage of processor utilization, in terms of maximum processor utilization, that is required to reduce the processor to a lower performance state.
    		"465e1f50-b610-473a-ab58-00d1077dc418" # Processor Performance Decrease Policy - Specifies how a target performance state is selected if the current processor utilization is below the value of the Processor Performance Decrease Threshold setting.
    		"40fbefc7-2e9d-4d25-a185-0cfd8574bac6" # Processor Performance Increase Policy - Specifies how a target performance state is selected if the current processor utilization is above the value of the Processor Performance Increase Threshold setting.
    		"4d2b0152-7d5c-498b-88e2-34345392a2c5" # Processor Performance Time Check Interval - Specifies the duration, in milliseconds, between subsequent evaluations of the processor performance state and Core Parking algorithms.
    		"45bcc044-d885-43e2-8605-ee0ec6e96b59" # Processor Performance Boost Policy - Configures the processor performance boost policy. The behavior of this setting can differ between processor vendors and specific processor models. The processor vendor should be consulted before changing the value of this setting.
    		# Core parking
    		"ea062031-0e34-4ff1-9b6d-eb1059334028" # Processor Performance Core Parking Max Cores - The maximum percentage of logical processors (in terms of all logical processors that are enabled on the system) that can be in the unparked state at any given time. For example, on a system with 16 logical processors, configuring the value of this setting to 50% ensures that no more than 8 logical processors are ever in the unparked state at the same time. The Core Parking algorithm is disabled if the value of this setting is not greater than the value of the Processor Performance Core Parking Minimum Cores setting.
    		"0cc5b647-c1df-4637-891a-dec35c318583" # Processor Performance Core Parking Min Cores - The minimum percentage of logical processors (in terms of all logical processors that are enabled on the system) that can be placed in the unparked state at any given time. For example, on a system with 16 logical processors, configuring the value of this setting to 25% ensures that at least 4 logical processors are always in the unparked state. The Core Parking algorithm is disabled if the value of this setting is not less than the value of the Processor Performance Core Parking Maximum Cores setting.
    		#C-states
    		"c4581c31-89ab-4597-8e2b-9c9cab440e6b" # Processor Idle Time Check - Specifies the duration, in microseconds, between subsequent evaluations of the processor idle state algorithm.
    		"4b92d758-5a24-4851-a470-815d78aee119" # Processor Idle Demote Threshold - The amount of processor idleness that is required before a processor is set to the next higher power processor idle state. When the processor idleness goes below the value of this setting, the processor transitions to the next lower numbered C-state.
    		"7b224883-b3cc-4d79-819f-8374152cbe7c" # Processor Idle Promote Threshold - The amount of processor idleness that is required before a processor is set to the next lower power processor idle state. When the processor idleness goes above the value of this setting, the processor transitions to the next higher numbered C-state.
		)
	}
	Foreach($setting in $SubSettings) {
    	Set-ItemProperty $ProcessorPowerSettingsRoot\$setting Attributes -Value 0
	}
#ShowHiddenPowerSettings
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\19cbb8fa-5279-450e-9fac-8a3d5fedd0c1\12bbebe6-58d6-4636-95bb-3217ef867c1a") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\19cbb8fa-5279-450e-9fac-8a3d5fedd0c1\12bbebe6-58d6-4636-95bb-3217ef867c1a" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\245d8541-3943-4422-b025-13a784f679b7") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\245d8541-3943-4422-b025-13a784f679b7" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\44f3beca-a7c0-460e-9df2-bb8b99e0cba6") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\44f3beca-a7c0-460e-9df2-bb8b99e0cba6" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\44f3beca-a7c0-460e-9df2-bb8b99e0cba6\3619c3f2-afb2-4afc-b0e9-e7fef372de36") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\44f3beca-a7c0-460e-9df2-bb8b99e0cba6\3619c3f2-afb2-4afc-b0e9-e7fef372de36" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\5FB4938D-1EE8-4b0f-9A3C-5036B0AB995C\DD848B2A-8A5D-4451-9AE2-39CD41658F6C") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\5FB4938D-1EE8-4b0f-9A3C-5036B0AB995C\DD848B2A-8A5D-4451-9AE2-39CD41658F6C" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\68AFB2D9-EE95-47A8-8F50-4115088073B1") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\68AFB2D9-EE95-47A8-8F50-4115088073B1" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\F15576E8-98B7-4186-B944-EAFA664402D9") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\F15576E8-98B7-4186-B944-EAFA664402D9" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\468FE7E5-1158-46EC-88BC-5B96C9E44FD0") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\468FE7E5-1158-46EC-88BC-5B96C9E44FD0" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\49CB11A5-56E2-4AFB-9D38-3DF47872E21B") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\49CB11A5-56E2-4AFB-9D38-3DF47872E21B" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\60C07FE1-0556-45CF-9903-D56E32210242") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\60C07FE1-0556-45CF-9903-D56E32210242" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\82011705-FB95-4D46-8D35-4042B1D20DEF") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\82011705-FB95-4D46-8D35-4042B1D20DEF" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\9FE527BE-1B70-48DA-930D-7BCF17B44990") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\9FE527BE-1B70-48DA-930D-7BCF17B44990" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\C763EE92-71E8-4127-84EB-F6ED043A3E3D") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\C763EE92-71E8-4127-84EB-F6ED043A3E3D" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\03680956-93BC-4294-BBA6-4E0F09BB717F") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\03680956-93BC-4294-BBA6-4E0F09BB717F" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\10778347-1370-4ee0-8bbd-33bdacaade49") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\10778347-1370-4ee0-8bbd-33bdacaade49" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\34C7B99F-9A6D-4b3c-8DC7-B6693B78CEF4") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\34C7B99F-9A6D-4b3c-8DC7-B6693B78CEF4" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\13D09884-F74E-474A-A852-B6BDE8AD03A8") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\13D09884-F74E-474A-A852-B6BDE8AD03A8" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\5C5BB349-AD29-4ee2-9D0B-2B25270F7A81") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\5C5BB349-AD29-4ee2-9D0B-2B25270F7A81" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\E69653CA-CF7F-4F05-AA73-CB833FA90AD4") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\E69653CA-CF7F-4F05-AA73-CB833FA90AD4" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\94D3A615-A899-4AC5-AE2B-E4D8F634367F") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\94D3A615-A899-4AC5-AE2B-E4D8F634367F" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\19cbb8fa-5279-450e-9fac-8a3d5fedd0c1\12bbebe6-58d6-4636-95bb-3217ef867c1a' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\245d8541-3943-4422-b025-13a784f679b7' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\44f3beca-a7c0-460e-9df2-bb8b99e0cba6\3619c3f2-afb2-4afc-b0e9-e7fef372de36' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\5FB4938D-1EE8-4b0f-9A3C-5036B0AB995C\DD848B2A-8A5D-4451-9AE2-39CD41658F6C' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\68AFB2D9-EE95-47A8-8F50-4115088073B1' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\F15576E8-98B7-4186-B944-EAFA664402D9' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\468FE7E5-1158-46EC-88BC-5B96C9E44FD0' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\49CB11A5-56E2-4AFB-9D38-3DF47872E21B' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\60C07FE1-0556-45CF-9903-D56E32210242' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\82011705-FB95-4D46-8D35-4042B1D20DEF' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\9FE527BE-1B70-48DA-930D-7BCF17B44990' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\8619B916-E004-4dd8-9B66-DAE86F806698\C763EE92-71E8-4127-84EB-F6ED043A3E3D' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\03680956-93BC-4294-BBA6-4E0F09BB717F' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\10778347-1370-4ee0-8bbd-33bdacaade49' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\9596FB26-9850-41fd-AC3E-F7C3C00AFD4B\34C7B99F-9A6D-4b3c-8DC7-B6693B78CEF4' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\13D09884-F74E-474A-A852-B6BDE8AD03A8' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\5C5BB349-AD29-4ee2-9D0B-2B25270F7A81' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\DE830923-A562-41AF-A086-E3A2C6BAD2DA\E69653CA-CF7F-4F05-AA73-CB833FA90AD4' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\94D3A615-A899-4AC5-AE2B-E4D8F634367F' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec' -Name 'Attributes' -Value 2 -PropertyType DWord -Force | Out-Null

#Network throttling&System responsiveness
	$Response = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
	if((Test-Path -LiteralPath $Response) -ne $true) {  New-Item $Response -force | Out-Null };
		Set-ItemProperty $Response NetworkThrottlingIndex -Value ffffffff -Force
		Set-ItemProperty $Response SystemResponsiveness -Value 0 -Force
	
#Enable Intel TSX
if ($Processor -Like "*Intel*"){
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' -Name 'DisableTsx' -Value 0 -PropertyType DWord -Force | Out-Null
}

#Edge Tweaks
if (Test-Path "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"){
Write-Host "Tweaking Edge Browser..."
#disable (Edge) Prelaunch
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v AllowPrelaunch /t REG_DWORD /d "0" /f | Out-Null
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d "0" /f | Out-Null
#LowerRam Usage
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Value 0 -PropertyType DWord -Force | Out-Null
Remove-Item -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{9459C573-B17A-45AE-9F64-1857B5D58CEE}' -Recurse -ErrorAction SilentlyContinue
Get-ScheduledTask -TaskName "MicrosoftEdgeUpdate*" -ea silentlyContinue | Disable-ScheduledTask | Out-Null
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Edge") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'StartupBoostEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'HardwareAccelerationModeEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'BackgroundModeEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
}
#Chrome Tweaks
if (Test-Path "$Env:Programfiles\Google\Chrome\Application\chrome.exe"){
Write-Host "Tweaking Chrome Browser..."
Remove-Item -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}' -Recurse -ErrorAction SilentlyContinue
Remove-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'Google Update' -ErrorAction SilentlyContinue
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Google\Chrome") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Google\Chrome" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Google\Chrome' -Name 'StartupBoostEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Google\Chrome' -Name 'HardwareAccelerationModeEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Google\Chrome' -Name 'BackgroundModeEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/960310618492133457/Better-removebg-preview.ico", "$Data\BetterChrome.ico")
	$SourceFilePath3 = "$Env:Programfiles\Google\Chrome\Application\chrome.exe"
	$ShortcutPath3 = "$env:USERPROFILE\Desktop\BetterChrome.lnk"
	$WScriptObj3 = New-Object -ComObject ("WScript.Shell")
	$shortcut3 = $WscriptObj3.CreateShortcut($ShortcutPath3)
	$shortcut3.TargetPath = $SourceFilePath3
	$Shortcut3.Arguments = "--disable-background-networking --in-process-gpu --disable-smooth-scrolling --disable-default-apps --disable-renderer-backgrounding --force-fieldtrials=*BackgroundTracing/default/"
	$shortcut3.IconLocation = "$Data\BetterChrome.ico"
	$shortcut3.Save()
Get-ScheduledTask -TaskName "GoogleUpdateTask*" | Disable-ScheduledTask | Out-Null
}
#Firefox Tweaks
if (test-path "$Env:Programfiles\Mozilla Firefox\firefox.exe"){
Write-Host "Tweaking Firefox Browser..."
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/960333357793812531/user.js", "$env:Temp\SodaScript\user.js")
$UserData = "$env:AppData\Mozilla\Firefox\Profiles"
$Profiles = (Get-ChildItem -Path $UserData -Directory).Name
Foreach ($Profile in $Profiles) {
    Copy-Item -Path "$env:Temp\SodaScript\user.js" -Destination "$UserData\$Profile" -Force
}
}
#MemoryOptimizations
	$Memory2 = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
	if((Test-Path -LiteralPath $Memory2) -ne $true) {  New-Item $Memory2 -force | Out-Null };
		Set-ItemProperty $Memory2 FeatureSettings -Value 1 -Force
		Set-ItemProperty $Memory2 FeatureSettingsOverrideMask -Value 3 -Force
		Set-ItemProperty $Memory2 FeatureSettingsOverride -Value 0 -Force
		Set-ItemProperty $Memory2 SystemCacheLimit -Value 400 -Force

#DecreaseMouseDelay
	if((Test-Path -LiteralPath "HKCU:\Control Panel\Mouse") -ne $true) {  New-Item "HKCU:\Control Panel\Mouse" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'ActiveWindowTracking' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'Beep' -Value 'No' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'DoubleClickHeight' -Value '4' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'DoubleClickWidth' -Value '4' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'ExtendedSounds' -Value 'No' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseHoverHeight' -Value '4' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseHoverWidth' -Value '4' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseSensitivity' -Value '10' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseTrails' -Value '0' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'SnapToDefaultButton' -Value '0' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'SwapMouseButtons' -Value '0' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -Value '0' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -Value '0' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -Value '0' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'DoubleClickSpeed' -Value '550' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseHoverTime' -Value '8' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'AttractionRectInsetInDIPS' -Value 5 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'DistanceThresholdInDIPS' -Value 40 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'MagnetismDelayInMilliseconds' -Value 50 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'MagnetismUpdateIntervalInMilliseconds' -Value 16 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'VelocityInDIPSPerSecond' -Value 360 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'CursorSensitivity' -Value 10000 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'CursorUpdateInterval' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'IRRemoteNavigationDelta' -Value 1 -PropertyType DWord -Force | Out-Null
DetectnApplyMouseFIX

	$Mouse2 = "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters"
	if((Test-Path -LiteralPath $Mouse2) -ne $true) {  New-Item $Mouse2 -force | Out-Null };
		Set-ItemProperty $Mouse2 MouseDataQueueSize -Value 32 -Force
	$Mouse3 = "HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"
	if((Test-Path -LiteralPath $Mouse3) -ne $true) {  New-Item $Mouse3 -force | Out-Null };
		Set-ItemProperty $Mouse3 AttractionRectInsetInDIPS -Value 5 -Force
		Set-ItemProperty $Mouse3 DistanceThresholdInDIPS -Value 28 -Force
		Set-ItemProperty $Mouse3 MagnetismDelayInMilliseconds -Value 32 -Force
		Set-ItemProperty $Mouse3 MagnetismUpdateIntervalInMilliseconds -Value 10 -Force
		Set-ItemProperty $Mouse3 VelocityInDIPSPerSecond -Value 168 -Force
	$Mouse4 = "HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed"
	if((Test-Path -LiteralPath $Mouse4) -ne $true) {  New-Item $Mouse4 -force | Out-Null };
		Set-ItemProperty $Mouse4 CursorSensitivity -Value 2710 -Force
		Set-ItemProperty $Mouse4 CursorUpdateInterval -Value 1 -Force
		Set-ItemProperty $Mouse4 IRRemoteNavigationDelta -Value 1 -Force

#Disable Night Light (So if it breaks, it will not stay on the Night Light forever XD)
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate\Current /v Data /t REG_BINARY /d 0200000088313cdb4584d4010000000043420100d00a02c614dabef0d9dd88a1ea0100 /f | Out-Null

# Laptop & Desktop Tweaks
If ($PCorLap -eq "2") {
}
ElseIf ($PCorLap -eq "1") {
Desktop2
}
#MoreGamingTweaks
	$More = "HKLM:\SYSTEM\ControlSet001\Control\PriorityControl"
	if((Test-Path -LiteralPath $More) -ne $true) {  New-Item $More -force | Out-Null };
		Set-ItemProperty $More Win32PrioritySeparation -Value 28 -Force
		Set-ItemProperty $More IRQ8Priority -Value 1 -Force
		Set-ItemProperty $More ConvertibleSlateMode -Value 0 -Force
		Set-ItemProperty $More IRQ16Priority -Value 2 -Force
	$More2 = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
	if((Test-Path -LiteralPath $More2) -ne $true) {  New-Item $More2 -force | Out-Null };
		Set-ItemProperty $More2 ConvertibleSlateMode -Value 0 -Force
		Set-ItemProperty $More2 IRQ8Priority -Value 1 -Force
		Set-ItemProperty $More2 IRQ16Priority -Value 2 -Force
		Set-ItemProperty $More2 Win32PrioritySeparation -Value 28 -Force
	
#OtherTweaks
	if((Test-Path -LiteralPath "HKLM:\System\CurrentControlSet\control\Update") -ne $true) {  New-Item "HKLM:\System\CurrentControlSet\control\Update" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\control\FileSystem' -Name 'DriveWriteBehind' -Value ([byte[]](0xff,0xff,0xff,0xff)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\control\FileSystem' -Name 'ReadAheadThreshold' -Value ([byte[]](0xff,0xff,0xff,0xff)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\control\Update' -Name 'UpdateMode' -Value ([byte[]](0x00)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\desktop' -Name 'MenuShowDelay' -Value '20' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Value '0' -PropertyType String -Force | Out-Null
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUserDisabled' -Value 1 -Force | Out-Null

	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\MRT' -Name 'DontOfferThroughWUAU' -Value 1 -PropertyType DWord -Force | Out-Null

	if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel' -Name 'KernelSEHOPEnabled' -Value 0 -Force | Out-Null

	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'AutoChkTimeout' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'ProtectionMode' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'AutoChkSkipSystemPartition' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'CoalescingTimerInterval' -Value 0 -Force | Out-Null
	
	#Disable Application Impact Telemetry
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'AITEnable' -Value 0 -Force | Out-Null
	
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Value 0 -PropertyType DWord -Force | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t Reg_DWORD /d "0" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f | Out-Null

	#Disable cached logon for privacy & security
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "CachedLogonsCount" /t REG_DWORD /d "0" /f | Out-Null
	
	# Disable Settings Header
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171' -Name 'EnabledState' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171' -Name 'EnabledStateOptions' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171' -Name 'Variant' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171' -Name 'VariantPayload' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171' -Name 'VariantPayloadKind' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835' -Name 'EnabledState' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835' -Name 'EnabledStateOptions' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835' -Name 'Variant' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835' -Name 'VariantPayload' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835' -Name 'VariantPayloadKind' -Value 0 -PropertyType DWord -Force | Out-Null

	#Disable Variable Refresh Rate
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences' -Name 'DirectXUserGlobalSettings' -Value 'VRROptimizeEnable=0;' -PropertyType String -Force | Out-Null
	
	# Show File Name Extensions
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0 -PropertyType DWord -Force | Out-Null
	
	# 11 Tweaks
	if ($Check11){
	#Hide Widgets
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 -Force
	
	# Remove Chat From Taskbar
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarMn -Value 0 -Force | Out-Null
	
	# Restore Windows button To left
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarAI -Value 0 -Force  | Out-Null

	# Disable Start Menu Context Menus
	if((Test-Path -LiteralPath "HKCU:\Software\Policies\Microsoft\Windows\Explorer") -ne $true) {  New-Item "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\Explorer' -Name 'DisableContextMenusInStart' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableContextMenusInStart' -Value 1 -PropertyType DWord -Force | Out-Null
	
	# Disable_Open_with_to_select_default_app_for_file_type_when_new_app_installed
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'NoNewAppAlert' -Value 1 -PropertyType DWord -Force | Out-Null
	
	# Disable Show more options context menu
	if((Test-Path -LiteralPath "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32") -ne $true) {  New-Item "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Name '(default)' -Value '' -PropertyType String -Force | Out-Null
	
	# Disable Sync Provider Notifications in File Explorer
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSyncProviderNotifications' -Value 0 -PropertyType DWord -Force | Out-Null
	
	# Disable Pen Visual Effects
	if((Test-Path -LiteralPath "HKCU:\Control Panel\Cursors") -ne $true) {  New-Item "HKCU:\Control Panel\Cursors" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Cursors' -Name 'PenVisualization' -Value 0 -PropertyType DWord -Force | Out-Null
	
	# Remove System requirements not met Watermark
	if((Test-Path -LiteralPath "HKCU:\Control Panel\UnsupportedHardwareNotificationCache") -ne $true) {  New-Item "HKCU:\Control Panel\UnsupportedHardwareNotificationCache" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\UnsupportedHardwareNotificationCache' -Name 'SV1' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\UnsupportedHardwareNotificationCache' -Name 'SV2' -Value 0 -PropertyType DWord -Force | Out-Null
	
	# Change Start Layout to Show More Pins
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_Layout' -Value 1 -PropertyType DWord -Force | Out-Null
}
	# Enable Hardware Accelerated GPU Scheduling
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode") {
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2
		}
	
	#DisableCloudContent
	$CloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	if((Test-Path -LiteralPath $CloudContent) -ne $true) {  New-Item $CloudContent -force | Out-Null };
		Set-ItemProperty $CloudContent ConfigureWindowsSpotlight -Value 2 -Force
		Set-ItemProperty $CloudContent IncludeEnterpriseSpotlight -Value 0 -Force
		Set-ItemProperty $CloudContent DisableWindowsSpotlightFeatures -Value 1 -Force
		Set-ItemProperty $CloudContent DisableWindowsSpotlightWindowsWelcomeExperience -Value 1 -Force
		Set-ItemProperty $CloudContent DisableWindowsSpotlightOnActionCenter -Value 1 -Force
		Set-ItemProperty $CloudContent DisableWindowsSpotlightOnSettings -Value 1 -Force
		Set-ItemProperty $CloudContent DisableThirdPartySuggestions -Value 1 -Force
		Set-ItemProperty $CloudContent DisableTailoredExperiencesWithDiagnosticData -Value 1 -Force
		Set-ItemProperty $CloudContent DisableWindowsConsumerFeatures -Value 1 -Force
	
#Disable Shortcut Arrows
	Copy-Item -Path "$Temporary\blank.ico" -Destination "$env:SYSTEMROOT\System32"-Force
	Copy-Item -Path "$Temporary\transparent.ico" -Destination "$env:SYSTEMROOT\System32" -Force
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\IE.AssocFile.URL") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\IE.AssocFile.URL" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\InternetShortcut") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\InternetShortcut" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\lnkfile") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\lnkfile" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\IE.AssocFile.URL' -Name 'IsShortcut' -Value '' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\InternetShortcut' -Name 'IsShortcut' -Value '' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\lnkfile' -Name 'IsShortcut' -Value '' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons' -Name '29' -Value '%windir%\System32\blank.ico' -PropertyType String -Force | Out-Null
	
#Disable Folder Contents Info
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'FolderContentsInfoTip' -Value 0 -PropertyType DWord -Force | Out-Null
	
#WindowsUpdates & Disable Delivery Optimization
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\MRT") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -force | Out-Null };
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontOfferThroughWUAU" -Type DWord -Value 1
	Reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t Reg_DWORD /d "1" /f | Out-Null
	
	$Delivery = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings"
	if((Test-Path -LiteralPath $Delivery) -ne $true) {  New-Item $Delivery -force | Out-Null };
		Set-ItemProperty $Delivery DownloadMode -Value 0 -Force

	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "2" /f | Out-Null

#DisableAutomatic Update Store&Maps
	$Store = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
	if((Test-Path -LiteralPath $Store) -ne $true) {  New-Item $Store -force | Out-Null };
		Set-ItemProperty $Store AutoDownload -Value 2 -Force
	$Maps = "HKLM:\SYSTEM\Maps"
	if((Test-Path -LiteralPath $Maps) -ne $true) {  New-Item $Maps -force | Out-Null };
		Set-ItemProperty $Maps AutoUpdateEnabled -Value 0 -Force

#Disable offering of drivers through Windows Update
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -force | Out-Null };
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value 0
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -force | Out-Null };
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1

#Disable Windows Update automatic restart
	if((Test-Path -LiteralPath HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU) -ne $true) {  New-Item HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -force | Out-Null };
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0

#Disable automatic maintenance
	$maintenance = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"
	if((Test-Path -LiteralPath $maintenance) -ne $true) {  New-Item $maintenance -force | Out-Null };
		Set-ItemProperty $maintenance MaintenanceDisabled -Value 1 -Force
	
#Disable security and maintenance notification
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting' -Name 'DisableEnhancedNotifications' -Value 1 -PropertyType DWord -Force | Out-Null
	$Sec_AND_Maintence = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance"
	if((Test-Path -LiteralPath $Sec_AND_Maintence) -ne $true) {  New-Item $Sec_AND_Maintence -force | Out-Null };
	Set-ItemProperty $Sec_AND_Maintence Enabled -Value 0 -Force
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" -force | Out-Null };
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" -force | Out-Null };
	if((Test-Path -LiteralPath "Registry::\HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance") -ne $true) {  New-Item "Registry::\HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance' -Name 'Enabled' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance' -Name 'Enabled' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'Registry::\HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance' -Name 'Enabled' -Value 0 -PropertyType DWord -Force | Out-Null
	
#DisableBingSearch&Cortana
	$Cortana = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
	if((Test-Path -LiteralPath $Cortana) -ne $true) {  New-Item $Cortana -force | Out-Null };
		Set-ItemProperty $Cortana AllowCortana -Value 0 -Force
		Set-ItemProperty $Cortana BingSearchEnabled -Value 0 -Force
		Set-ItemProperty $Cortana CortanaConsent -Value 0 -Force
		Set-ItemProperty $Cortana BackgroundAppGlobalToggle -Value 0 -Force
		Set-ItemProperty $Cortana AllowCloudSearch -Value 0 -Force

#Show BSoD Details instead of sad face :(
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f | Out-Null

#Disable SyncCenter
	$mobsync2 = "$env:SystemRoot\System32\mobsync.exe"
	If (Test-Path $mobsync2) {
		takeown.exe /f $mobsync2 | Out-Null
		icacls.exe $mobsync2 /reset | Out-Null
		Rename-Item -Path "$mobsync2" -NewName "mobsync.old" -Force
	}
	
#Steam Tweaks
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Valve\Steam") -ne $true) {  New-Item "HKCU:\SOFTWARE\Valve\Steam" -force | Out-Null };
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'SmoothScrollWebViews' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'DWriteEnable' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'StartupMode' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'H264HWAccel' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'DPIScaling' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'GPUAccelWebViews' -Value 0 -PropertyType DWord -Force | Out-Null
	Remove-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'Steam' -ErrorAction SilentlyContinue

	$Steam = "HKCU:\SOFTWARE\Valve\Steam"
	If (Test-Path $Steam){
	New-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam' -Name 'SmoothScrollWebViews' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam' -Name 'DWriteEnable' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam' -Name 'StartupMode' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam' -Name 'H264HWAccel' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam' -Name 'DPIScaling' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam' -Name 'GPUAccelWebViews' -Value 0 -PropertyType DWord -Force | Out-Null
	}
	
#Disable Storage Sense
	$StorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	if((Test-Path -LiteralPath $StorageSense) -ne $true) {  New-Item $StorageSense -force | Out-Null };
		Set-ItemProperty $StorageSense 01 -Value 0 -Force
	
#Disable powershell telemetry
	setx POWERSHELL_TELEMETRY_OPTOUT 1 | Out-Null
	
#TaskView
	$TaskView = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultitaskingView\AllUpView"
	if((Test-Path -LiteralPath $TaskView) -ne $true) {  New-Item $TaskView -force | Out-Null };
		Set-ItemProperty $TaskView AllUpView -Value 0 -Force
		Set-ItemProperty $TaskView "Remove TaskView" -Value 1 -Force
#No LockScreen
	$Personalization = "HKLM:\SOFTWARE\Policies\Microsoft\Personalization"
	if((Test-Path -LiteralPath $Personalization) -ne $true) {  New-Item $Personalization -force | Out-Null };
		Set-ItemProperty $Personalization NoLockScreen -Value 1 -Force

#Change default Explorer view to This PC
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1 -Force

#Hide recently and frequently used item shortcuts in Explorer
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0 -Force
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 0 -Force

#Show Desktop icon in This PC
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" | Out-Null
	}
#Hide Music icon from This PC
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -Recurse -ErrorAction SilentlyContinue
#Hide Pictures icon from This PC
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -Recurse -ErrorAction SilentlyContinue
#Hide Videos icon from This PC
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -Recurse -ErrorAction SilentlyContinue
#Hide 3D Objects icon from This PC
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	
#Remove Edit With Paint 3D
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.3mf\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.bmp\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.fbx\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.gif\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.jfif\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.jpe\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.jpeg\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.jpg\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.png\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.tif\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -LiteralPath "HKCR:\SystemFileAssociations\.tiff\Shell\3D Edit" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	
#FileSystem
	$FileSystem = "HKLM:\SYSTEM\ControlSet001\Control\FileSystem"
	if((Test-Path -LiteralPath $FileSystem) -ne $true) {  New-Item $FileSystem -force | Out-Null };
		Set-ItemProperty $FileSystem LongPathsEnabled -Value 0 -Force
		Set-ItemProperty $FileSystem NtfsAllowExtendedCharacter8dot3Rename -Value 0 -Force
		Set-ItemProperty $FileSystem NtfsDisable8dot3NameCreation -Value 2 -Force
		Set-ItemProperty $FileSystem NtfsDisableCompression -Value 0 -Force
		Set-ItemProperty $FileSystem NtfsEncryptPagingFile -Value 0 -Force
		Set-ItemProperty $FileSystem NtfsMemoryUsage -Value 2 -Force
		Set-ItemProperty $FileSystem RefsDisableLastAccessUpdate -Value 1 -Force
		Set-ItemProperty $FileSystem NtfsDisableLastAccessUpdate -Value 1 -Force
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'DisableDeleteNotification' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'FilterSupportedFeaturesMode' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'NtfsBugcheckOnCorrupt' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'NtfsDisableLfsDowngrade' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'NtfsDisableVolsnapHints' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'NtfsQuotaNotifyRate' -Value 3600 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'ScrubMode' -Value 2 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'SymlinkLocalToLocalEvaluation' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'SymlinkLocalToRemoteEvaluation' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'SymlinkRemoteToLocalEvaluation' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'SymlinkRemoteToRemoteEvaluation' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'UdfsCloseSessionOnEject' -Value 3 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'UdfsSoftwareDefectManagement' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'Win31FileSystem' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'Win95TruncatedExtensions' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'NtfsMftZoneReservation' -Value 4 -PropertyType DWord -Force | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "ContigFileAllocSize" /t REG_DWORD /d "1536" /f | Out-Null

	$System = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	if((Test-Path -LiteralPath $System) -ne $true) {  New-Item $System -force | Out-Null };
		Set-ItemProperty $System EnableActivityFeed -Value 0 -Force
		Set-ItemProperty $System PublishUserActivities -Value 0 -Force
		Set-ItemProperty $System UploadUserActivities -Value 0 -Force
		Set-ItemProperty $System DisableAcrylicBackgroundOnLogon -Value 1 -Force
		Set-ItemProperty $System DisableHHDEP -Value 1 -Force
		Set-ItemProperty $System EnableCdp -Value 0 -Force
		Set-ItemProperty $System EnableMmx -Value 0 -Force
		Set-ItemProperty $System DisableLogonBackgroundImage -Value 0 -Force
		Set-ItemProperty $System Start -Value "Warn" -Force

	$System2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
	if((Test-Path -LiteralPath $System2) -ne $true) {  New-Item $System2 -force | Out-Null };
		Set-ItemProperty $System2 PromptOnSecureDesktop -Value 0 -Force
		Set-ItemProperty $System2 EnableLUA -Value 0 -Force
		Set-ItemProperty $System2 ConsentPromptBehaviorAdmin -Value 0 -Force
		Set-ItemProperty $System2 DelayedDesktopSwitchTimeout -Value 0 -Force
		Set-ItemProperty $System2 DisableAutomaticRestartSignOn -Value 1 -Force

#FixKeyBoard Delay
	$KeyboardDelay = "HKCU:\Control Panel\Keyboard"
	if((Test-Path -LiteralPath $KeyboardDelay) -ne $true) {  New-Item $KeyboardDelay -force | Out-Null };
		Set-ItemProperty $KeyboardDelay InitialKeyboardIndicators -Value 0 -Force
		Set-ItemProperty $KeyboardDelay KeyboardDelay -Value 0 -Force

	$KeyboardDelay2 = "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters"
	if((Test-Path -LiteralPath $KeyboardDelay2) -ne $true) {  New-Item $KeyboardDelay2 -force | Out-Null };
		Set-ItemProperty $KeyboardDelay2 KeyboardDataQueueSize -Value 32 -Force

#HideFeedsButton
	$ShellFeeds = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	if((Test-Path -LiteralPath $ShellFeeds) -ne $true) {  New-Item $ShellFeeds -force | Out-Null };
		Set-ItemProperty $ShellFeeds ShellFeedsTaskbarViewMode -Value 2 -Force

#PriorityOptimizations
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*\" -Recurse -ErrorAction SilentlyContinue
	
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenu.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenu.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenuExperienceHost.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenuExperienceHost.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions' -Name 'PagePriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions' -Name 'PagePriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Affinity" /t Reg_DWORD /d "0" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Background Only" /t Reg_SZ /d "True" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "BackgroundPriority" /t Reg_DWORD /d "24" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Clock Rate" /t Reg_DWORD /d "10000" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "GPU Priority" /t Reg_DWORD /d "18" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Priority" /t Reg_DWORD /d "8" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Scheduling Category" /t Reg_SZ /d "High" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "SFIO Priority" /t Reg_SZ /d "High" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t Reg_SZ /d "True" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationAuditOptions /t Reg_BINARY /d "222222222222222222222222222222222222222222222222" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v MitigationOptions /t Reg_BINARY /d "222222222222222222222222222222222222222222222222" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v CpuPriorityClass /t Reg_DWORD /d "4" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v IoPriority /t Reg_DWORD /d "3" /f | Out-Null
	
#ExplorerTweaks
	$Explorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	if((Test-Path -LiteralPath $Explorer) -ne $true) {  New-Item $Explorer -force | Out-Null };
		Set-ItemProperty $Explorer NoInstrumentation -Value 1 -Force
		Set-ItemProperty $Explorer DisableThumbnails -Value - -Force -ErrorAction SilentlyContinue

	$Explorer2 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	if((Test-Path -LiteralPath $Explorer2) -ne $true) {  New-Item $Explorer2 -force | Out-Null };
		Set-ItemProperty $Explorer2 NoInstrumentation -Value 1 -Force
		Set-ItemProperty $Explorer2 DisableThumbnails -Value - -Force -ErrorAction SilentlyContinue

	$Explorer3 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers"
	if((Test-Path -LiteralPath $Explorer3) -ne $true) {  New-Item $Explorer3 -force | Out-Null };
		Set-ItemProperty $Explorer3 DisableAutoplay -Value 1 -Force

#ExplorerPreferences
	$Explorer4 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
	if((Test-Path -LiteralPath $Explorer4) -ne $true) {  New-Item $Explorer4 -force | Out-Null };
	if((Test-Path -LiteralPath $Explorer4\Advanced) -ne $true) {  New-Item $Explorer4\Advanced -force | Out-Null };
		Set-ItemProperty $Explorer4\Advanced ShowSyncProviderNotifications -Value 0 -Force #Disable File Explorer Ads (OneDrive, New Features etc.)
		Set-ItemProperty $Explorer4\Advanced Start_TrackDocs -Value 0 -Force
		Set-ItemProperty $Explorer4\Advanced EnableBalloonTips -Value 0 -Force
		Set-ItemProperty $Explorer4\Advanced ExtendedUIHoverTime -Value 1 -Force
	
	#Disable Folder Thumbnails
	$FolderThumbs = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell"
	if((Test-Path -LiteralPath $FolderThumbs) -ne $true) {  New-Item $FolderThumbs -force | Out-Null };
		Set-ItemProperty $FolderThumbs Logo -Value "d:\\some2file23.jpg" -Force
	
	#PrivacySettings
	$Privacy = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	if((Test-Path -LiteralPath $Privacy) -ne $true) {  New-Item $Privacy -force | Out-Null };
		Set-ItemProperty $Privacy HasAccepted -Value 0 -Force

	$Privacy2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore"
	if((Test-Path -LiteralPath $Privacy2\radios) -ne $true) {  New-Item $Privacy2\radios -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\appDiagnostics) -ne $true) {  New-Item $Privacy2\appDiagnostics -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\documentsLibrary) -ne $true) {  New-Item $Privacy2\documentsLibrary -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\picturesLibrary) -ne $true) {  New-Item $Privacy2\picturesLibrary -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\videosLibrary) -ne $true) {  New-Item $Privacy2\videosLibrary -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\broadFileSystemAccess) -ne $true) {  New-Item $Privacy2\broadFileSystemAccess -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\chat) -ne $true) {  New-Item $Privacy2\chat -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\contacts) -ne $true) {  New-Item $Privacy2\contacts -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\phoneCall) -ne $true) {  New-Item $Privacy2\phoneCall -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\appointments) -ne $true) {  New-Item $Privacy2\appointments -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\phoneCallHistory) -ne $true) {  New-Item $Privacy2\phoneCallHistory -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\email) -ne $true) {  New-Item $Privacy2\email -force | Out-Null };
	if((Test-Path -LiteralPath $Privacy2\userDataTasks) -ne $true) {  New-Item $Privacy2\userDataTasks -force | Out-Null };
		Set-ItemProperty $Privacy2\radios Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\appDiagnostics Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\documentsLibrary Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\picturesLibrary Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\videosLibrary Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\broadFileSystemAccess Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\chat Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\contacts Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\phoneCall Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\appointments Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\phoneCallHistory Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\email Value -Value "Deny" -Force
		Set-ItemProperty $Privacy2\userDataTasks Value -Value "Deny" -Force

	Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f | Out-Null
	Reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t Reg_DWORD /d "2" /f | Out-Null
	
	$DiagTrack = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack"
	if((Test-Path -LiteralPath $DiagTrack) -ne $true) {  New-Item $DiagTrack -force | Out-Null };
		Set-ItemProperty $DiagTrack ShowedToastAtLevel -Value 1 -Force

	$Privacy3 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
	if((Test-Path -LiteralPath $Privacy3) -ne $true) {  New-Item $Privacy3 -force | Out-Null };
		Set-ItemProperty $Privacy3 TailoredExperiencesWithDiagnosticDataEnabled -Value 0 -Force

	#Disable Automatic Backup
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" /v "EnablePeriodicBackup" /t REG_DWORD /d "0" /f | Out-Null

	#Remove restore previous versions from context menu
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{596AB062-B4D2-4215-9F74-E9109B0A8153}" /t REG_SZ /d "{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f | Out-Null
	
	# Remove News & Interests + Feeds
	reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "IsFeedsAvailable" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d "2" /f | Out-Null

	# dont add "- shortcut" when creating a shortcut
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f | Out-Null

	#Disable Show me suggested content in the settings app.
	#Disable Show me the windows welcome experience after updates.
	#Disable Show suggestions in start.
	#Disable Auto installation of unnecessary bloatware.
	#Disable Get fun facts and tips, etc. on lock screen.
	$Delivery2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	if((Test-Path -LiteralPath $Delivery2) -ne $true) {  New-Item $Delivery2 -force | Out-Null };
		Set-ItemProperty $Delivery2 ContentDeliveryAllowed -Value 0 -Force
		Set-ItemProperty $Delivery2 OemPreInstalledAppsEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 PreInstalledAppsEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 PreInstalledAppsEverEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SilentInstalledAppsEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SoftLandingEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContentEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 FeatureManagementEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SystemPaneSuggestionsEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 RemediationRequired -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContent-338393Enabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContent-353694Enabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContent-353696Enabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContent-338387Enabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContent-338389Enabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContent-310093Enabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContent-338388Enabled -Value 0 -Force
		Set-ItemProperty $Delivery2 SubscribedContent-314563Enabled -Value 0 -Force
		Set-ItemProperty $Delivery2 RotatingLockScreenOverlayEnabled -Value 0 -Force
		Set-ItemProperty $Delivery2 RotatingLockScreenEnabled -Value 0 -Force
	Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" -Recurse -ErrorAction SilentlyContinue

	#DisableWindowsErrorReporting
	$ErrorRepoerting = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	if((Test-Path -LiteralPath $ErrorRepoerting) -ne $true) {  New-Item $ErrorRepoerting -force | Out-Null };
		Set-ItemProperty $ErrorRepoerting Disabled -Value 1 -Force
	$ErrorRepoerting2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports"
	if((Test-Path -LiteralPath $ErrorRepoerting2) -ne $true) {  New-Item $ErrorRepoerting2 -force | Out-Null };
	Set-ItemProperty $ErrorRepoerting2 PreventHandwritingErrorReports -Value 1 -Force
	reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t "REG_DWORD" /d "1" /f | Out-Null
	reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WerSvc" /v "Start" /t REG_DWORD /d "4" /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t REG_DWORD /d "4" /f | Out-Null
	if((Test-Path -LiteralPath "HKLM:\Software\WOW6432Node\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting") -ne $true) {  New-Item "HKLM:\Software\WOW6432Node\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\Software\WOW6432Node\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting' -Name 'value' -Value 0 -PropertyType DWord -Force | Out-Null
	
	#Office Telemetry
	if((Test-Path -LiteralPath "HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications") -ne $true) {  New-Item "HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications" -force | Out-Null };
	if((Test-Path -LiteralPath "HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes") -ne $true) {  New-Item "HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'accesssolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'olksolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'onenotesolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'pptsolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'projectsolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'publishersolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'visiosolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'wdsolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedapplications' -Name 'xlsolution' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes' -Name 'agave' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes' -Name 'appaddins' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes' -Name 'comaddins' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes' -Name 'documentfiles' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes' -Name 'templatefiles' -Value 1 -PropertyType DWord -Force | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v "EnableLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v "EnableLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v "EnableUpload" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v "EnableUpload" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d 1 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common" /v "QMEnable" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common" /v "QMEnable" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d 0 /f | Out-Null
	reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d 0 /f | Out-Null
	
	#Disable GetImage Descriptions, Page Titles And Popular Links
	$Image = "HKCU:\SOFTWARE\Microsoft\Narrator\NoRoam"
	if((Test-Path -LiteralPath $Image) -ne $true) {  New-Item $Image -force | Out-Null };
		Set-ItemProperty $Image OnlineServicesEnabled -Value 0 -Force

	#Disable Device History
	$History2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
	if((Test-Path -LiteralPath $History2) -ne $true) {  New-Item $History2 -force | Out-Null };
		Set-ItemProperty $History2 DeviceHistoryEnabled -Value 0 -Force

	#DisableTelemetry
	$Telemetry = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	if((Test-Path -LiteralPath $Telemetry) -ne $true) {  New-Item $Telemetry -force | Out-Null };
		Set-ItemProperty $Telemetry AllowTelemetry -Value 0 -Force
		Set-ItemProperty $Telemetry AllowDeviceNameInTelemetry -Value 0 -Force
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	if((Test-Path -LiteralPath $Telemetry2) -ne $true) {  New-Item $Telemetry2 -force | Out-Null };
		Set-ItemProperty $Telemetry2 AllowTelemetry -Value 0 -Force
	$Telemetry3 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
	if((Test-Path -LiteralPath $Telemetry3) -ne $true) {  New-Item $Telemetry3 -force | Out-Null };
		Set-ItemProperty $Telemetry3 Enabled -Value 0 -Force
		Set-ItemProperty $Telemetry3 DisabledByGroupPolicy -Value 1 -Force
	$Telemetry4 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	if((Test-Path -LiteralPath $Telemetry4) -ne $true) {  New-Item $Telemetry4 -force | Out-Null };
		Set-ItemProperty $Telemetry4 AllowTelemetry -Value 1 -Force
		Set-ItemProperty $Telemetry4 MaxTelemetryAllowed -Value 1 -Force
	$Telemetry5 = "HKCU:\Control Panel\International\User Profile"
	if((Test-Path -LiteralPath $Telemetry5) -ne $true) {  New-Item $Telemetry5 -force | Out-Null };
		Set-ItemProperty $Telemetry5 HttpAcceptLanguageOptOut -Value 1 -Force
	$Telemetry6 = "HKLM:\Software\Policies\Microsoft\Windows\EnhancedStorageDevices"
	if((Test-Path -LiteralPath $Telemetry6) -ne $true) {  New-Item $Telemetry6 -force | Out-Null };
		Set-ItemProperty $Telemetry6 TCGSecurityActivationDisabled -Value 0 -Force
		
	#Disable Open File security warning
	powershell.exe -exec bypass -enc CQBpAGYAKAAoAFQAZQBzAHQALQBQAGEAdABoACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAiAEgASwBDAFUAOgBcAFMAbwBmAHQAdwBhAHIAZQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwBcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFAAbwBsAGkAYwBpAGUAcwBcAEEAcwBzAG8AYwBpAGEAdABpAG8AbgBzACIAKQAgAC0AbgBlACAAJAB0AHIAdQBlACkAIAB7ACAAIABOAGUAdwAtAEkAdABlAG0AIAAiAEgASwBDAFUAOgBcAFMAbwBmAHQAdwBhAHIAZQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwBcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFAAbwBsAGkAYwBpAGUAcwBcAEEAcwBzAG8AYwBpAGEAdABpAG8AbgBzACIAIAAtAGYAbwByAGMAZQAgAC0AZQBhACAAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQAgAH0AOwANAAoACQBOAGUAdwAtAEkAdABlAG0AUAByAG8AcABlAHIAdAB5ACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAnAEgASwBDAFUAOgBcAFMAbwBmAHQAdwBhAHIAZQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwBcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFAAbwBsAGkAYwBpAGUAcwBcAEEAcwBzAG8AYwBpAGEAdABpAG8AbgBzACcAIAAtAE4AYQBtAGUAIAAnAEwAbwB3AFIAaQBzAGsARgBpAGwAZQBUAHkAcABlAHMAJwAgAC0AVgBhAGwAdQBlACAAJwAuAGEAdgBpADsALgBiAGEAdAA7AC4AYwBtAGQAOwAuAGUAeABlADsALgBoAHQAbQA7AC4AaAB0AG0AbAA7AC4AbABuAGsAOwAuAG0AcABnADsALgBtAHAAZQBnADsALgBtAG8AdgA7AC4AbQBwADMAOwAuAG0AcAA0ADsALgBtAGsAdgA7AC4AbQBzAGkAOwAuAG0AMwB1ADsALgByAGEAcgA7AC4AcgBlAGcAOwAuAHQAeAB0ADsALgB2AGIAcwA7AC4AdwBhAHYAOwAuAHAAcwAxADsALgB6AGkAcAA7AC4ANwB6ACcAIAAtAFAAcgBvAHAAZQByAHQAeQBUAHkAcABlACAAUwB0AHIAaQBuAGcAIAAtAEYAbwByAGMAZQAgAC0AZQBhACAAUwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA7AA== | Out-Null
	
	#App Tracking
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -Value 0 -PropertyType DWord -Force | Out-Null

	#Disable Hibernation
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0
	
	$Boot2 = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
	if((Test-Path -LiteralPath $Boot2) -ne $true) {  New-Item $Boot2 -force | Out-Null };
		Set-ItemProperty $Boot2 HiberbootEnabled -Value 0
	
	Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To" -Recurse -ErrorAction SilentlyContinue

	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'TrackNblOwner' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'DisableNDISWatchDog' -Value 1 -Force | Out-Null
	#RSS Tweaks
	if ($CPUCores -eq 4){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 4 -PropertyType DWord -Force | Out-Null
	}
	if ($CPUCores -eq 6){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 6 -PropertyType DWord -Force | Out-Null
	}
	if ($CPUCores -eq 8){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 8 -PropertyType DWord -Force | Out-Null
	}
	if ($CPUCores -eq 10){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 10 -PropertyType DWord -Force | Out-Null
	}
	if ($CPUCores -eq 12){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 12 -PropertyType DWord -Force | Out-Null
	}
	if ($CPUCores -eq 20){
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 20 -PropertyType DWord -Force | Out-Null
	}
	
	#Disable System Sounds
	$Sounds = "HKCU:\Control Panel\Sound"
	if((Test-Path -LiteralPath $Sounds) -ne $true) {  New-Item $Sounds -force | Out-Null };
		Set-ItemProperty $Sounds Beep -Value "no" -Force
		Set-ItemProperty $Sounds ExtendedSounds -Value "no" -Force

	#Sound communications do nothing
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Multimedia\Audio") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Multimedia\Audio" -force | Out-Null };

	#Disable startup sound
	if((Test-Path -LiteralPath "HKLM:\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation") -ne $true) {  New-Item "HKLM:\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" -force | Out-Null };

	#Sound scheme none
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\CriticalBatteryAlarm\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\DeviceFail\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\FaxBeep\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\LowBatteryAlarm\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MailBeep\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\MessageNudge\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Default\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.IM\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Mail\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Proximity\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.Reminder\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\Notification.SMS\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\ProximityConnection\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemHand\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\SystemNotification\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\.Default\WindowsUAC\.Current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\DisNumbersSound\.current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOffSound\.current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubOnSound\.current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\HubSleepSound\.current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\MisrecoSound\.current" -force | Out-Null };
	Remove-Item -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current" -force;
	if((Test-Path -LiteralPath "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current") -ne $true) {  New-Item "HKCU:\AppEvents\Schemes\Apps\sapisvr\PanelSound\.current" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Multimedia\Audio' -Name 'UserDuckingPreference' -Value 3 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation' -Name 'DisableStartupSound' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\AppEvents\Schemes' -Name '(default)' -Value '.None' -PropertyType String -Force | Out-Null
	
	
	#PingTweaks
Write-Host "PingTweaks...."
	netsh winsock reset | Out-Null
	netsh winsock reset catalog | Out-Null
	ipconfig /f | Out-Null
	MTU2
	netsh int tcp set global initialRto=2000 netdma=disabled rss=enabled MaxSynRetransmissions=2 | Out-Null
	netsh winsock set autotuning on | Out-Null
	netsh int tcp set global autotuninglevel=normal | Out-Null
	netsh interface 6to4 set state disabled | Out-Null
	netsh int tcp set global fastopen=enable | Out-Null
	netsh advfirewall firewall add rule name="StopThrottling" dir=in action=block remoteip=173.194.55.0/24,206.111.0.0/16 enable=yes | Out-Null
	netsh int isatap set state disable | Out-Null
	netsh int tcp set global timestamps=disabled | Out-Null
	netsh int tcp set heuristics disabled | Out-Null
	netsh int tcp set heuristics wsh=disabled | Out-Null
	netsh int tcp set global chimney=disabled | Out-Null
	netsh int tcp set global ecncapability=disabled | Out-Null
	netsh int tcp set global rsc=disabled | Out-Null
	netsh int tcp set global nonsackrttresiliency=disabled | Out-Null
	netsh int ipv4 set dynamicport tcp -StartupType 1025 num=64511 | Out-Null
	netsh int ipv4 set dynamicport udp -StartupType 1025 num=64511 | Out-Null
	netsh int ip set global sourceroutingbehavior=drop | Out-Null
	netsh int tcp set security mpp=disabled | Out-Null
	netsh int tcp set security profiles=disabled | Out-Null
	netsh int ip set global icmpredirects=disabled | Out-Null
	netsh int tcp set security mpp=disabled profiles=disabled | Out-Null
	netsh int ip set global multicastforwarding=disabled | Out-Null
	netsh int tcp set supplemental internet congestionprovider=ctcp | Out-Null
	netsh interface teredo set state disabled | Out-Null
	netsh int isatap set state disable | Out-Null
	netsh int ip set global taskoffload=disabled | Out-Null
	netsh int ip set global routecachelimit=4096 | Out-Null
	netsh int ip set global neighborcachelimit=4096 | Out-Null
	netsh int tcp set global dca=enabled | Out-Null
	netsh int ip set interface $NetAdapter2 basereachable=3600000 dadtransmits=0 otherstateful=disabled routerdiscovery=disabled store=persistent | Out-Null
	PowerShell Disable-NetAdapterLso -Name "*" | Out-Null
	powershell "ForEach($adapter In Get-NetAdapter){Disable-NetAdapterPowerManagement -Name $adapter.Name -ErrorAction SilentlyContinue}" | Out-Null
	powershell "ForEach($adapter In Get-NetAdapter){Disable-NetAdapterLso -Name $adapter.Name -ErrorAction SilentlyContinue}" | Out-Null
	
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t REG_DWORD /d "10" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f | Out-Null
	
	$Latency2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	if((Test-Path -LiteralPath $Latency2) -ne $true) {  New-Item $Latency2 -force | Out-Null };
		Set-ItemProperty $Latency2 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency2 MaxConnectionsPer1_0Server -Value 10 -Force
		Set-ItemProperty $Latency2 SmoothScroll -Value 1 -Force
	$Latency3 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	if((Test-Path -LiteralPath $Latency3) -ne $true) {  New-Item $Latency3 -force | Out-Null };
		Set-ItemProperty $Latency3 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency3 MaxConnectionsPer1_0Server -Value 10 -Force
		Set-ItemProperty $Latency3 SmoothScroll -Value 1 -Force
	$Latency4 = "HKCU:\Software\Microsoft\Windows\CurrentVersion"
	if((Test-Path -LiteralPath $Latency4) -ne $true) {  New-Item $Latency4 -force | Out-Null };
		Set-ItemProperty $Latency4 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency4 MaxConnectionsPer1_0Server -Value 10 -Force
		Set-ItemProperty $Latency4 SmoothScroll -Value 1 -Force
	$Latency5 = "HKLM:\Software\Microsoft\Windows\CurrentVersion"
	if((Test-Path -LiteralPath $Latency5) -ne $true) {  New-Item $Latency5 -force | Out-Null };
		Set-ItemProperty $Latency5 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency5 MaxConnectionsPer1_0Server -Value 10 -Force
		Set-ItemProperty $Latency5 SmoothScroll -Value 1 -Force
	$Latency6 = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider"
	if((Test-Path -LiteralPath $Latency6) -ne $true) {  New-Item $Latency6 -force | Out-Null };
		Set-ItemProperty $Latency6 Class -Value 8 -Force
		Set-ItemProperty $Latency6 LocalPriority -Value 4 -Force
		Set-ItemProperty $Latency6 HostsPriority -Value 5 -Force
		Set-ItemProperty $Latency6 DnsPriority -Value 6 -Force
		Set-ItemProperty $Latency6 NetbtPriority -Value 7 -Force
	$Latency8 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DnsClient"
	if((Test-Path -LiteralPath $Latency8) -ne $true) {  New-Item $Latency8 -force | Out-Null };
		Set-ItemProperty $Latency8 EnableMulticast -Value 0 -Force
	$Latency10 = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
	if((Test-Path -LiteralPath $Latency10) -ne $true) {  New-Item $Latency10 -force | Out-Null };
		Set-ItemProperty $Latency10 TcpAckFrequency -Value 1 -Force
		Set-ItemProperty $Latency10 TcpDelAckTicks -Value 0 -Force
		Set-ItemProperty $Latency10 NumTcbTablePartitions -Value F -Force
		Set-ItemProperty $Latency10 TCPNoDelay -Value 1 -Force
		Set-ItemProperty $Latency10 TcpWindowSize -Value ffff -Force
		Set-ItemProperty $Latency10 SackOpts -Value 0 -Force
		Set-ItemProperty $Latency10 TcpMaxDataRetransmissions -Value 2 -Force
		Set-ItemProperty $Latency10 Tcp1323Opts -Value 1 -Force
		Set-ItemProperty $Latency10 TCPTimedWaitDelay -Value 30 -Force
		Set-ItemProperty $Latency10 IRPStackSize -Value 12 -Force
		Set-ItemProperty $Latency10 DefaultTTL -Value FF -Force
		Set-ItemProperty $Latency10 KeepAliveTime -Value ea60 -Force
		Set-ItemProperty $Latency10 KeepAliveInterval -Value 3e8 -Force
		Set-ItemProperty $Latency10 TCPInitialRtt -Value 12c -Force
		Set-ItemProperty $Latency10 TcpMaxDupAcks -Value 1 -Force
		Set-ItemProperty $Latency10 TcpRecSegmentSize -Value 255552 -Force
		Set-ItemProperty $Latency10 EnablePMTUBHDetect -Value 1 -Force
		Set-ItemProperty $Latency10 EnablePMTUDiscovery -Value 0 -Force
		Set-ItemProperty $Latency10 GlobalMaxTcpWindowSize -Value ffff -Force
		Set-ItemProperty $Latency10 MaxHashTableSize -Value 10000 -Force
		Set-ItemProperty $Latency10 DisableTaskOffload -Value 0 -Force
		Set-ItemProperty $Latency10 WorldMaxTcpWindowsSize -Value FFFFFFFF -Force
		Set-ItemProperty $Latency10 TCPAllowedPorts -Value 1 -Force
		Set-ItemProperty $Latency10 NTEContextList -Value 3 -Force
		Set-ItemProperty $Latency10 DisableLargeMTU -Value 0 -Force
		Set-ItemProperty $Latency10 IGMPVersion -Value 2 -Force
		Set-ItemProperty $Latency10 IGMPLevel -Value 2 -Force
		Set-ItemProperty $Latency10 MaxConnectionsPer1_0Server -Value 10 -Force
		Set-ItemProperty $Latency10 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency10 MaxFreeTcbs -Value ffff -Force
		Set-ItemProperty $Latency10 ArpTRSingleRoute -Value 1 -Force
		Set-ItemProperty $Latency10 SynAttackProtect -Value 1 -Force
		Set-ItemProperty $Latency10 MaxForwardBufferMemory -Value 0x23f00 -Force
		Set-ItemProperty $Latency10 ForwardBufferMemory -Value 0x23f00 -Force
		Set-ItemProperty $Latency10 NumForwardPackets -Value 0x23f -Force
		Set-ItemProperty $Latency10 MaxNumForwardPackets -Value 0x23f -Force
		Set-ItemProperty $Latency10 MaxUserPort -Value 65534 -Force
		Set-ItemProperty $Latency10 TcpMaxSendFree -Value FFFF -Force
		Set-ItemProperty $Latency10 DeadGWDetectDefault -Value 1 -Force
		Set-ItemProperty $Latency10 DontAddDefaultGatewayDefault -Value 0 -Force
		Set-ItemProperty $Latency10 MaxMpxCt -Value 7d -Force
		Set-ItemProperty $Latency10 EnableICMPRedirect -Value 1 -Force
		Set-ItemProperty $Latency10 CacheHashTableBucketSize -Value 1000 -Force
		Set-ItemProperty $Latency10 EnableWsd -Value 0 -Force
		Set-ItemProperty $Latency10 EnableDynamicBacklog -Value 1 -Force
		Set-ItemProperty $Latency10 EnableDHCP -Value 1 -Force
		Set-ItemProperty $Latency10 EnableWsd -Value 0 -Force
		Set-ItemProperty $Latency10 AllowUnqualifiedQuery -Value 1 -Force
		Set-ItemProperty $Latency10 DisableMediaSenseEventLog -Value 1 -Force
		Set-ItemProperty $Latency10 DisableRss -Value 0 -Force
		Set-ItemProperty $Latency10 DnsQueryTimeouts -Value "1 1 2 2 4 0" -Force
		Set-ItemProperty $Latency10 DisableTcpChimneyOffload -Value 0 -Force
		Set-ItemProperty $Latency10 DnsOutstandingQueriesCount -Value 3e8 -Force
		Set-ItemProperty $Latency10 EnableAddrMaskReply -Value 0 -Force
		Set-ItemProperty $Latency10 EnableBcastArpReply -Value 0 -Force
		Set-ItemProperty $Latency10 EnableConnectionRateLimiting -Value 0 -Force
		Set-ItemProperty $Latency10 EnableDca -Value 0 -Force
		Set-ItemProperty $Latency10 EnableHeuristics -Value 1 -Force
		Set-ItemProperty $Latency10 EnableIPAutoConfigurationLimits -Value ff -Force
		Set-ItemProperty $Latency10 EnableTCPA -Value 0 -Force
		Set-ItemProperty $Latency10 IPEnableRouter -Value 0 -Force
		Set-ItemProperty $Latency10 QualifyingDestinationThreshold -Value ffffffff -Force
		Set-ItemProperty $Latency10 StrictTimeWaitSeqCheck -Value 1 -Force
		Set-ItemProperty $Latency10 EnableDca -Value 0 -Force
	$Latency11 = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
	if((Test-Path -LiteralPath $Latency11) -ne $true) {  New-Item $Latency11 -force | Out-Null };
		Set-ItemProperty $Latency11 TcpMaxDataRetransmissions -Value 3 -Force
		Set-ItemProperty $Latency11 SackOpts -Value 0 -Force
		Set-ItemProperty $Latency11 TcpWindowSize -Value ffff -Force
		Set-ItemProperty $Latency11 MaxFreeTcbs -Value 65536 -Force
		Set-ItemProperty $Latency11 TcpMaxDupAcks -Value 1 -Force
		Set-ItemProperty $Latency11 MSS -Value 5b4 -Force
		Set-ItemProperty $Latency11 MaxUserPort -Value 65534 -Force
		Set-ItemProperty $Latency11 TCPMaxHalfOpenRetried -Value 0 -Force
		Set-ItemProperty $Latency11 TCPMaxHalfOpen -Value 1 -Force
		Set-ItemProperty $Latency11 TCPMaxPortsExhausted -Value 5 -Force
		Set-ItemProperty $Latency11 TcpCreateAndConnectTcbRateLimitDepth -Value 0 -Force
		Set-ItemProperty $Latency11 TcpAckFrequency -Value 1 -Force
		Set-ItemProperty $Latency11 TcpDelAckTicks -Value 0 -Force
		Set-ItemProperty $Latency11 NumTcbTablePartitions -Value F -Force
		Set-ItemProperty $Latency11 TCPNoDelay -Value 1 -Force
		Set-ItemProperty $Latency11 Tcp1323Opts -Value 0 -Force
		Set-ItemProperty $Latency11 TCPTimedWaitDelay -Value 30 -Force
		Set-ItemProperty $Latency11 IRPStackSize -Value 12 -Force
		Set-ItemProperty $Latency11 DefaultTTL -Value 64 -Force
		Set-ItemProperty $Latency11 KeepAliveTime -Value ea60 -Force
		Set-ItemProperty $Latency11 DnsQueryTimeouts -Value "1 1 2 2 4 0" -Force
		Set-ItemProperty $Latency11 KeepAliveInterval -Value 3e8 -Force
		Set-ItemProperty $Latency11 TCPInitialRtt -Value 12c -Force
		Set-ItemProperty $Latency11 TcpRecSegmentSize -Value 255552 -Force
		Set-ItemProperty $Latency11 EnablePMTUBHDetect -Value 1 -Force
		Set-ItemProperty $Latency11 EnablePMTUDiscovery -Value 0 -Force
		Set-ItemProperty $Latency11 GlobalMaxTcpWindowSize -Value ffff -Force
		Set-ItemProperty $Latency11 MaxHashTableSize -Value 10000 -Force
		Set-ItemProperty $Latency11 DisableTaskOffload -Value 1 -Force
		Set-ItemProperty $Latency11 WorldMaxTcpWindowsSize -Value FFFFFFFF -Force
		Set-ItemProperty $Latency11 TCPAllowedPorts -Value 1 -Force
		Set-ItemProperty $Latency11 NTEContextList -Value 3 -Force
		Set-ItemProperty $Latency11 DisableLargeMTU -Value 0 -Force
		Set-ItemProperty $Latency11 IGMPVersion -Value 2 -Force
		Set-ItemProperty $Latency11 IGMPLevel -Value 2 -Force
		Set-ItemProperty $Latency11 MaxConnectionsPer1_0Server -Value 10 -Force
		Set-ItemProperty $Latency11 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency11 MaxFreeTcbs -Value 65536 -Force
		Set-ItemProperty $Latency11 ArpTRSingleRoute -Value 1 -Force
		Set-ItemProperty $Latency11 SynAttackProtect -Value 1 -Force
		Set-ItemProperty $Latency11 MaxForwardBufferMemory -Value 0x23f00 -Force
		Set-ItemProperty $Latency11 ForwardBufferMemory -Value 0x23f00 -Force
		Set-ItemProperty $Latency11 NumForwardPackets -Value 0x23f -Force
		Set-ItemProperty $Latency11 MaxNumForwardPackets -Value 0x23f -Force
		Set-ItemProperty $Latency11 TcpMaxSendFree -Value FFFF -Force
		Set-ItemProperty $Latency11 DeadGWDetectDefault -Value 1 -Force
		Set-ItemProperty $Latency11 DontAddDefaultGatewayDefault -Value 0 -Force
		Set-ItemProperty $Latency11 MaxMpxCt -Value 7d -Force
		Set-ItemProperty $Latency11 EnableICMPRedirect -Value 1 -Force
		Set-ItemProperty $Latency11 CacheHashTableBucketSize -Value 1000 -Force
		Set-ItemProperty $Latency11 EnableWsd -Value 0 -Force
		Set-ItemProperty $Latency11 EnableDynamicBacklog -Value 1 -Force
		Set-ItemProperty $Latency11 EnableDHCP -Value 1 -Force
		Set-ItemProperty $Latency11 EnableWsd -Value 0 -Force
		Set-ItemProperty $Latency11 AllowUnqualifiedQuery -Value 1 -Force
		Set-ItemProperty $Latency11 DisableMediaSenseEventLog -Value 1 -Force
		Set-ItemProperty $Latency11 DisableRss -Value 0 -Force
		Set-ItemProperty $Latency11 DisableTcpChimneyOffload -Value 0 -Force
		Set-ItemProperty $Latency11 DnsOutstandingQueriesCount -Value 3e8 -Force
		Set-ItemProperty $Latency11 EnableAddrMaskReply -Value 0 -Force
		Set-ItemProperty $Latency11 EnableBcastArpReply -Value 0 -Force
		Set-ItemProperty $Latency11 EnableConnectionRateLimiting -Value 0 -Force
		Set-ItemProperty $Latency11 EnableDca -Value 0 -Force
		Set-ItemProperty $Latency11 EnableHeuristics -Value 1 -Force
		Set-ItemProperty $Latency11 EnableIPAutoConfigurationLimits -Value ff -Force
		Set-ItemProperty $Latency11 EnableTCPA -Value 0 -Force
		Set-ItemProperty $Latency11 IPEnableRouter -Value 0 -Force
		Set-ItemProperty $Latency11 QualifyingDestinationThreshold -Value ffffffff -Force
		Set-ItemProperty $Latency11 StrictTimeWaitSeqCheck -Value 1 -Force
		Set-ItemProperty $Latency11 EnableDca -Value 0 -Force
		Set-ItemProperty $Latency11 DelayedAckFrequency -Value 1 -Force
		Set-ItemProperty $Latency11 DelayedAckTicks -Value 1 -Force
		Set-ItemProperty $Latency11 CongestionAlgorithm -Value 1 -Force
		Set-ItemProperty $Latency11 MultihopSets -Value f -Force
		Set-ItemProperty $Latency11 FastCopyReceiveThreshold -Value 4000 -Force
		Set-ItemProperty $Latency11 FastSendDatagramThreshold -Value 4000 -Force
	
$RegItems = @(
    "*EEE"
    "*WakeOnMagicPacket"
    "*WakeOnPattern"
    "*AdvancedEEE"
	"*EEE"
    "AutoDisableGigabit"
    "AutoPowerSaveModeEnabled"
    "EEELinkAdvertisement"
    "EnableConnectedPowerGating"
    "EnableDynamicPowerGating"
    "EnableGreenEthernet"
    "EnablePME"
    "EnablePowerManagement"
    "EnableSavePowerNow"
    "GigaLite"
    "*IPChecksumOffloadIPv4"
    "*JumboPacket"
    "*LsoV2IPv4"
    "*LsoV2IPv6"
    "*PMARPOffload"
    "*PMNSOffload"
    "PowerDownPll"
    "PowerSavingMode"  
    "ReduceSpeedOnPowerDown"
    "S5NicKeepOverrideMacAddrV2"
    "S5WakeOnLan"
    "*TCPChecksumOffloadIPv4"
    "*TCPChecksumOffloadIPv6"
    "*UDPChecksumOffloadIPv4"
    "*UDPChecksumOffloadIPv6"
    "ULPMode"
    "WakeOnLink"
)
$Latency15 = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\$DriverKey\0001"
Foreach ($RegItem in $RegItems) {  
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name $RegItem) {
		Set-ItemProperty -Path $Latency15 -Name $RegItem -Value 0 -Force
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "ITR") {
		Set-ItemProperty -Path $Latency15 -Name "ITR" -Value 125 -Force
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "*FlowControl") {
		Set-ItemProperty -Path $Latency15 -Name "*FlowControl" -Value 1514 -Force
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "*RSS") {
		Set-ItemProperty -Path $Latency15 -Name "*RSS" -Value 1 -Force
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "*ReceiveBuffers") {
		Set-ItemProperty -Path $Latency15 -Name "*ReceiveBuffers" -Value 256 -Force
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "*TransmitBuffers") {
		Set-ItemProperty -Path $Latency15 -Name "*TransmitBuffers" -Value 256 -Force
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "WolShutdownLinkSpeed") {
		Set-ItemProperty -Path $Latency15 -Name "WolShutdownLinkSpeed" -Value 2 -Force
	}
}
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS' -Name 'Do not use NLA' -Value 1 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock' -Name 'UseDelayedAcceptance' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock' -Name 'MaxSockAddrLength' -Value 16 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock' -Name 'MinSockAddrLength' -Value 16 -Force | Out-Null

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
# AutoClean Temp On Startup
If (Test-Path $StartUP\TEMP22.vbs) {
}
Else {
	Write-Host "Adding Auto Clean Temp On Startup"
	Move-Item -Path "$Temporary\TempCleaner.bat" -Destination "$env:SystemRoot\System32" -Force
	Copy-Item -Path "$Temporary\TEMP22.vbs" -Destination "$StartUP" -Force
}
Write-Host "Soda Has Optimized Your PC successfully!" -BackgroundColor White -ForegroundColor Black
Write-Host "Restart Your PC To Apply Changes -> Exiting..." -BackgroundColor Red -ForegroundColor Black
Start-Sleep 4
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Function MTU2{
$BufferSizeMax = 1500
$TestAddress   = "www.google.com"

$LastMinBuffer = $BufferSizeMin
$LastMaxBuffer = $BufferSizeMax
$MaxFound = $false

[int]$BufferSize = ($BufferSizeMax - 0) / 2

While ($MaxFound -eq $false) {
    Try {
        $Response = ping $TestAddress -n 1 -f -l $BufferSize
        
        If ($Response -like "*fragmented*") {throw}
            If ($LastMinBuffer -eq $BufferSize) {
                $MaxFound = $true
                break
            } Else {
                $LastMinBuffer = $BufferSize
                $BufferSize = $BufferSize + (($LastMaxBuffer - $LastMinBuffer) / 2)
            }

    } Catch {
        $LastMaxBuffer = $BufferSize

        If (($LastMaxBuffer - $LastMinBuffer) -le 3) {
            $BufferSize = $BufferSize - 1
        } Else {
            $BufferSize = $LastMinBuffer + (($LastMaxBuffer - $LastMinBuffer) / 2)
        }
    }
}

$BufferSize = $BufferSize + 28 #20 bytes for IP header + 8 bytes ICMP request header
Write-Host "The optimal Maximum Transmission Unit (MTU) is $BufferSize bytes."

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
$AdapterName = (Get-NetAdapter | Where-Object { $_.Name -Match 'Ethernet'}).Name
netsh interface ipv4 set subinterface "$AdapterName" mtu=$BufferSize store=persistent | Out-Null

Write-Host "The Maximum Transmission Unit (MTU) has been set to $BufferSize"
}
Function SSDOnly{
	Write-Host "SSD Tweaks..."
	#fix SSD Freezing issue (by disabling powersaving on ssd)
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port0") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port0" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port1") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port1" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port2") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port2" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port3") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port3" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port4") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port4" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port5") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port5" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port0' -Name 'LPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port0' -Name 'LPMDSTATE' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port0' -Name 'DIPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port1' -Name 'LPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port1' -Name 'LPMDSTATE' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port1' -Name 'DIPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port2' -Name 'LPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port2' -Name 'LPMDSTATE' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port2' -Name 'DIPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port3' -Name 'LPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port3' -Name 'LPMDSTATE' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port3' -Name 'DIPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port4' -Name 'LPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port4' -Name 'LPMDSTATE' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port4' -Name 'DIPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port5' -Name 'LPM' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port5' -Name 'LPMDSTATE' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port5' -Name 'DIPM' -Value 0 -PropertyType DWord -Force | Out-Null

	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize' -Name 'StartupDelayInMSec' -Value 0 -PropertyType DWord -Force | Out-Null
	
	fsutil behavior set DisableDeleteNotify 0 | Out-Null
	fsutil behavior set disableLastAccess 0 | Out-Null
}
#Detecting Windows Scale Layout Automatically and applying mouse fix according to it!
#Credits <DaddyMadu>
Function DetectnApplyMouseFIX {
Add-Type @'
  using System; 
  using System.Runtime.InteropServices;
  using System.Drawing;

  public class DPI {  
    [DllImport("gdi32.dll")]
    static extern int GetDeviceCaps(IntPtr hdc, int nIndex);

    public enum DeviceCap {
      VERTRES = 10,
      DESKTOPVERTRES = 117
    } 

    public static float scaling() {
      Graphics g = Graphics.FromHwnd(IntPtr.Zero);
      IntPtr desktop = g.GetHdc();
      int LogicalScreenHeight = GetDeviceCaps(desktop, (int)DeviceCap.VERTRES);
      int PhysicalScreenHeight = GetDeviceCaps(desktop, (int)DeviceCap.DESKTOPVERTRES);

      return (float)PhysicalScreenHeight / (float)LogicalScreenHeight;
    }
  }
'@ -ReferencedAssemblies 'System.Drawing.dll'

$checkscreenscale = [Math]::round([DPI]::scaling(), 2) * 100
if($checkscreenscale -eq "100") {
Write-Output "Windows screen scale is Detected as 100%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,C0,CC,0C,00,00,00,00,00,80,99,19,00,00,00,00,00,40,66,26,00,00,00,00,00,00,33,33,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} elseif($checkscreenscale -eq "125") {
Write-Output "Windows screen scale is Detected as 125%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,00,00,10,00,00,00,00,00,00,00,20,00,00,00,00,00,00,00,30,00,00,00,00,00,00,00,40,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} elseif($checkscreenscale -eq "150") {
Write-Output "Windows screen scale is Detected as 150%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,30,33,13,00,00,00,00,00,60,66,26,00,00,00,00,00,90,99,39,00,00,00,00,00,C0,CC,4C,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} elseif($checkscreenscale -eq "175") {
Write-Output "Windows screen scale is Detected as 175%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,60,66,16,00,00,00,00,00,C0,CC,2C,00,00,00,00,00,20,33,43,00,00,00,00,00,80,99,59,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} elseif($checkscreenscale -eq "200") {
Write-Output "Windows screen scale is Detected as 200%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,90,99,19,00,00,00,00,00,20,33,33,00,00,00,00,00,B0,CC,4C,00,00,00,00,00,40,66,66,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} elseif($checkscreenscale -eq "225") {
Write-Output "Windows screen scale is Detected as 225%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,C0,CC,1C,00,00,00,00,00,80,99,39,00,00,00,00,00,40,66,56,00,00,00,00,00,00,33,73,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} elseif($checkscreenscale -eq "250") {
Write-Output "Windows screen scale is Detected as 250%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,00,00,20,00,00,00,00,00,00,00,40,00,00,00,00,00,00,00,60,00,00,00,00,00,00,00,80,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} elseif($checkscreenscale -eq "300") {
Write-Output "Windows screen scale is Detected as 300%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,60,66,26,00,00,00,00,00,C0,CC,4C,00,00,00,00,00,20,33,73,00,00,00,00,00,80,99,99,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} elseif($checkscreenscale -eq "350") {
Write-Output "Windows screen scale is Detected as 350%, Applying Mouse Fix for it..."
$YourInputX = "00,00,00,00,00,00,00,00,C0,CC,2C,00,00,00,00,00,80,99,59,00,00,00,00,00,40,66,86,00,00,00,00,00,00,33,B3,00,00,00,00,00"
$YourInputY = "00,00,00,00,00,00,00,00,00,00,38,00,00,00,00,00,00,00,70,00,00,00,00,00,00,00,A8,00,00,00,00,00,00,00,E0,00,00,00,00,00"
$RegPath   = 'HKCU:\Control Panel\Mouse'
$hexifiedX = $YourInputX.Split(',') | % { "0x$_"}
$hexifiedY = $YourInputY.Split(',') | % { "0x$_"}
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseXCurve" -Type Binary -Value (([byte[]]$hexifiedX))
Set-ItemProperty -Path "$RegPath" -Name "SmoothMouseYCurve" -Type Binary -Value (([byte[]]$hexifiedY))
} else {
Write-Output "HOUSTON WE HAVE A PROBLEM! screen scale is not set to traditional value, nothing has been set!"
}
}
Function Desktop2 {
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/1060512011877896202/Soda.pow", "$env:Temp\SodaScript\Soda_Powerplan.pow")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/924882978008629278/SetTimerResolutionService.exe", "$env:Temp\SodaScript\SetTimerResolutionService.exe")
##Soda PowerPlan
Write-Host "Applying Gaming PowerPlan..."
$PowerPlan = "Soda_Powerplan.pow"
	If (Test-Path $Temporary\$PowerPlan) {
		powercfg -import $Temporary\$PowerPlan 88888888-8888-8888-8888-888888888888
		powercfg -SETACTIVE "88888888-8888-8888-8888-888888888888"
	}
#DiasblePowerThrottling
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' -Name 'PowerThrottlingOff' -Value 1 -PropertyType DWord -Force  | Out-Null

	$Power2 = "HKLM:\SYSTEM\CurrentControlSet\Control\Power"
	if((Test-Path -LiteralPath $Power2) -ne $true) {  New-Item $Power2 -force | Out-Null };
	if((Test-Path -LiteralPath $Power2\EnergyEstimation\TaggedEnergy) -ne $true) {  New-Item $Power2\EnergyEstimation\TaggedEnergy -force | Out-Null };
		Set-ItemProperty $Power2 HibernateEnabled -Value 0 -Force
		Set-ItemProperty $Power2 EnergyEstimationEnabled -Value 0 -Force
		Set-ItemProperty $Power2\EnergyEstimation\TaggedEnergy DisableTaggedEnergyLogging -Value 1 -Force
		Set-ItemProperty $Power2\EnergyEstimation\TaggedEnergy TelemetryMaxTagPerApplication -Value 0 -Force
	
	$Power3 = "HKLM:\SYSTEM\CurrentControlSet\Control\Power"
	if((Test-Path -LiteralPath $Power3) -ne $true) {  New-Item $Power3 -force | Out-Null };
		Set-ItemProperty $Power3 Latency -Value 0 -Force
		Set-ItemProperty $Power3 HighPerformance -Value 1 -Force
		Set-ItemProperty $Power3 ExitLatency -Value 0 -Force
		Set-ItemProperty $Power3 ExitLatencyCheckEnabled -Value 1 -Force
		Set-ItemProperty $Power3 LowLatency -Value 1 -Force
		Set-ItemProperty $Power3 HighestPerformance -Value 1 -Force
		Set-ItemProperty $Power3 LatencyToleranceDefault -Value 1 -Force
		Set-ItemProperty $Power3 LatencyToleranceFSVP -Value 1 -Force
		Set-ItemProperty $Power3 LatencyTolerancePerfOverride -Value 1 -Force
		Set-ItemProperty $Power3 LatencyToleranceScreenOffIR -Value 1 -Force
		Set-ItemProperty $Power3 LatencyToleranceVSyncEnabled -Value 1 -Force
		Set-ItemProperty $Power3 RtlCapabilityCheckLatency -Value 1 -Force
		
	$Power4 = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power"
	if((Test-Path -LiteralPath $Power4) -ne $true) {  New-Item $Power4 -force | Out-Null };
	Set-ItemProperty $Power4 DefaultD3TransitionLatencyActivelyUsed -Value 1 -Force
	Set-ItemProperty $Power4 DefaultD3TransitionLatencyIdleLongTime -Value 1 -Force
	Set-ItemProperty $Power4 DefaultD3TransitionLatencyIdleMonitorOff -Value 1 -Force
	Set-ItemProperty $Power4 DefaultD3TransitionLatencyIdleNoContext -Value 1 -Force
	Set-ItemProperty $Power4 DefaultD3TransitionLatencyIdleShortTime -Value 1 -Force
	Set-ItemProperty $Power4 DefaultD3TransitionLatencyIdleVeryLongTime -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceIdle0 -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceIdle0MonitorOff -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceIdle1 -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceIdle1MonitorOff -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceMemory -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceNoContext -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceNoContextMonitorOff -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceOther -Value 1 -Force
	Set-ItemProperty $Power4 DefaultLatencyToleranceTimerPeriod -Value 1 -Force
	Set-ItemProperty $Power4 DefaultMemoryRefreshLatencyToleranceActivelyUsed -Value 1 -Force
	Set-ItemProperty $Power4 DefaultMemoryRefreshLatencyToleranceMonitorOff -Value 1 -Force
	Set-ItemProperty $Power4 DefaultMemoryRefreshLatencyToleranceNoContext -Value 1 -Force
	Set-ItemProperty $Power4 Latency -Value 1 -Force
	Set-ItemProperty $Power4 MaxIAverageGraphicsLatencyInOneBucket -Value 1 -Force
	Set-ItemProperty $Power4 MiracastPerfTrackGraphicsLatency -Value 1 -Force
	Set-ItemProperty $Power4 MonitorLatencyTolerance -Value 1 -Force
	Set-ItemProperty $Power4 MonitorRefreshLatencyTolerance -Value 1 -Force
	Set-ItemProperty $Power4 TransitionLatency -Value 1 -Force
	
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f | Out-Null

Write-Host "Diasbled Power Throttling"
#Set TimerResolution Service
If (Test-Path $Data\SetTimerResolutionService.exe) {
	$ServiceLoacation = "$Data\SetTimerResolutionService.exe"
New-Service -Name "TimerResolution" -BinaryPathName $ServiceLoacation -ea silentlyContinue | Out-Null
}
Else {
	$ServiceLoacation = "$Data\SetTimerResolutionService.exe"
	Copy-Item -Path "$Temporary\SetTimerResolutionService.exe" -Destination "$Data" -Force
	New-Service -Name "TimerResolution" -BinaryPathName $ServiceLoacation -ea silentlyContinue | Out-Null
Write-Host "TimerResolution Service Has Been Installed"
}

#TimeLimitInSeconds
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}' -Name 'TimeLimitInSeconds' -Value 18 -PropertyType DWord -Force | Out-Null

#LowLatencyScaling
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'LowLatencyScalingPercentage' -Value 100 -PropertyType DWord -Force | Out-Null

#Enable MSI Mode on GPU if supported
$MSISupported = "HKLM:\System\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
if((Test-Path -LiteralPath $MSISupported) -ne $true) {  New-Item $MSISupported -force | Out-Null };
	Set-ItemProperty -Path $MSISupported -Name MSISupported -Value 1 -Force
#GPU + NET Affinites
$MSISupported2 = "HKLM:\SYSTEM\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\Affinity Policy"
if((Test-Path -LiteralPath $MSISupported2) -ne $true) {  New-Item $MSISupported2 -force | Out-Null };
	Set-ItemProperty -Path $MSISupported2 -Name DevicePolicy -Value 3 -Force
$MSISupported3 = "HKLM:\System\CurrentControlSet\Enum\$NetAdapterID\Device Parameters\Interrupt Management\Affinity Policy"
if((Test-Path -LiteralPath $MSISupported3) -ne $true) {  New-Item $MSISupported3 -force | Out-Null };
	Set-ItemProperty -Path $MSISupported3 -Name DevicePolicy -Value 5 -Force

#Energy
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\currentcontrolset\control\session manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f | Out-Null
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f | Out-Null

#Remove GPU Limits
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" -Name "MessageNumberLimit" -ErrorAction SilentlyContinue

$Services2 = "HKLM:\SYSTEM\CurrentControlSet\services"
if((Test-Path -LiteralPath $Services2) -ne $true) {  New-Item $Services2 -force | Out-Null };
Set-ItemProperty $Services2\IntelPPM Start -Value 4 -Force
Set-ItemProperty $Services2\AmdPPM Start -Value 4 -Force

#EthernetTweaks
Write-Host "EthernetTweaks..."
	$EthernetInterface = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*"
	$EthernetIPAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -like "Ethernet"}).IPAddress
	$TCPChangerPATH = ((Get-ItemProperty -Path $EthernetInterface | Where-Object {$_.DhcpIPAddress -eq $EthernetIPAddress}).PSPath).SubString(54)
	New-ItemProperty "HKLM:$TCPChangerPATH" TcpACKFrequency -Value 1 -Force | Out-Null
	New-ItemProperty "HKLM:$TCPChangerPATH" TcpDelAckTicks -Value 0 -Force | Out-Null
	New-ItemProperty "HKLM:$TCPChangerPATH" TCPNoDelay -Value 1 -Force | Out-Null
}

Function RestoreRestorePoint {
	bcdedit /import $Data\SodaBCDEDITbckp
	
#Get Restore Point Sequence
	$GetRestorePoint = Get-ComputerRestorePoint | Where-Object {$_.Description -eq "SodaScript"}
	$SequenceNumber = $GetRestorePoint.SequenceNumber

#Restore $Project Point
	Restore-Computer -RestorePoint $SequenceNumber
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
#Main menu loop
Do {
    Show-Menu
    $input = Read-Host "IT'S Time To Choose>>"
    Clear-Host
    switch ($input) {
		'O' {WindowsTweaks ; break}
		'R' {RestoreRestorePoint ; break}
		'EE' {break} # do nothing
		'U' {Update1 ; break}
		default{
		Write-Host "You entered '$input'" -ForegroundColor Red
		Write-Host "Please select one of the choices from the menu." -ForegroundColor Red
		}
	}
}

Until ($input -eq 'ee')
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
