$Project = ""SodaScript""
$Data = ""$env:ProgramData\$Project""
$Temporary = ""$env:Temp\$Project""
$StartUP = ""$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp""
If ((Test-Path $Data) -eq $false) {
	New-Item -Path $Data -ItemType ""Directory"" | Out-Null
}
If ((Test-Path $Temporary) -eq $false) {
	New-Item -Path $Temporary -ItemType ""Directory"" | Out-Null
}
$time = Get-Date -Format ""SodaScript-yyyy-MM-dd---HH.mm""
Start-Transcript -Path $env:ProgramData\SodaScript\ScheduledTasks-$time.log| Out-Null
# Scheduled Tasks
Get-ScheduledTask -TaskName ""Background Synchronization"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Microsoft Compatibility Appraiser"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""BfeOnServiceStartTypeChange"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""BgTaskRegistrationMaintenanceTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Consolidator"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""DmClient"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""DmClientOnScenarioDownload"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""FamilySafetyMonitor"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""FamilySafetyRefreshTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""ForceSynchronizeTime"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""GoogleUpdateTaskMachineCore*"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""GoogleUpdateTaskMachineUA*"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""WinSAT"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Microsoft-Windows-DiskDiagnosticDataCollector"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Microsoft-Windows-DiskDiagnosticResolver"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""MicrosoftEdgeUpdateTaskMachineCore"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Office Automatic Updates 2.0"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Office Feature Updates Logon"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Office Feature Updates"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Office Serviceability Manager"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""OfficeTelemetryAgentFallBack2016"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""OfficeTelemetryAgentLogOn2016"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""*OneDrive Standalone Update*"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""ProcessMemoryDiagnosticEvents"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""ProgramDataUpdater"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Proxy"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""QueueReporting"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""RecommendedTroubleshootingScanner"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""RegIdleBackup"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""ResolutionHost"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""RunFullMemoryDiagnostic"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SR"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Scheduled"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""ScheduledDefrag"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SilentCleanup"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""StartIsBack health check"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""StartupAppTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SvcRestartTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SvcRestartTaskLogon"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SvcRestartTaskNetwork"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Synchronize Language Settings"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SynchronizeTime"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SynchronizeTimeZone"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""UsbCeip"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""VerifyWinRE"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Windows Defender Cache Maintenance"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Windows Defender Cleanup"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Windows Defender Scheduled Scan"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Windows Defender Verification"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""XblGameSaveTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""update-*-1001"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""update-sys"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Schedule Work"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""MaintenanceTasks"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""IndexerAutomaticMaintenance"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""MicrosoftEdgeUpdateBrowserReplacementTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""CleanupOfflineContent"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""MNO Metadata Parser"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""EnableErrorDetailsUpdate"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""CertPathCheck"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Maintenance"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Microsoft Compatibility Appraiser"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""PcaPatchDbTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""BackgroundDownload"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""BraveSoftwareUpdateTaskMachineUA"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""BraveSoftwareUpdateTaskMachineCore"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""StartIsBack health check"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Consolidator"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""BthSQM"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""KernelCeipTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""UsbCeip"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Uploader"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Microsoft Compatibility Appraiser"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""ProgramDataUpdater"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""StartupAppTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Microsoft-Windows-DiskDiagnosticDataCollector"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Microsoft-Windows-DiskDiagnosticResolver"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""AnalyzeSystem"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""FamilySafetyMonitor"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""FamilySafetyRefresh"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""FamilySafetyUpload"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Proxy"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""WinSAT"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""AitAgent"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""QueueReporting"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""CreateObjectTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Diagnostics"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""File History (maintenance mode)"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Sqm-Tasks"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""GatherNetworkInfo"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SmartScreenSpecific"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Automatic App Update"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""ForceSynchronizeTime"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""SynchronizeTime"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""FODCleanupTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""DmClient"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""DmClientOnScenarioDownload"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""PcaPatchDbTask"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Device"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""Device User"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""OfficeTelemetryAgentFallBack2016"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""OfficeTelemetryAgentLogOn2016"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""OfficeTelemetryAgentFallBack"" -ea SilentlyContinue | Disable-ScheduledTask
Get-ScheduledTask -TaskName ""OfficeTelemetryAgentLogOn"" -ea SilentlyContinue | Disable-ScheduledTask