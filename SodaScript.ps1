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
Set-ConsoleColor 'Black' 'Blue'
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#- SYSTEM INFORMATION #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
$global:progressPreference = 'silentlyContinue'
#HARDWARE
$Processor = (Get-WmiObject Win32_Processor).Name
$CPUThreads = (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors
$CPUCores = (Get-WmiObject Win32_Processor).NumberOfCores
$Graphics = (Get-WmiObject Win32_VideoController).Name
$GraphicsID = (Get-WmiObject Win32_VideoController).PNPDeviceID
$Memory = gwmi Win32_OperatingSystem | Measure-Object -Property TotalVisibleMemorySize -Sum | % {[Math]::Round($_.sum/1024/1024)}
$NetAdapterID = (Get-WmiObject win32_NetworkAdapter).PNPDeviceID
$NetworkAdapter = Get-NetAdapter | Where-Object {$_.Name -like "Ethernet"}
$DriverKey = (Get-WmiObject -Class Win32_PnPEntity | Where-Object {$_.Name -eq $NetworkAdapter.InterfaceDescription}).ClassGuid
#SOFTWARE
$Windows = (Get-WmiObject Win32_OperatingSystem).Caption
$WindowsArc = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$WindowsVer = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
$Project = "SodaScript"
$Temporary = "$env:Temp\$Project"
$Software = "$env:ProgramFiles\$Project"
$Data = "$env:ProgramData\$Project"
$LogFile = "C:\ProgramData\SodaScript\SodaLog.txt"
$StartUP = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-# InternetCheck #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
$InternetCheck = (Test-Connection www.Google.com -Count 1 -Quiet)
if(($InternetCheck) -eq $false){Write-Host "No Internet Connection. Exiting..." ; Start-Sleep 4 ; Exit}
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-# LOG FILE #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
If (Test-Path C:\ProgramData\SodaScript\SodaLog.txt) {
}
Else {
Start-Transcript -Path C:\ProgramData\SodaScript\SodaLog.txt| Out-Null
}
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-# Check-Windows-Version #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
If ($WindowsVer -ge 1607) {
	Write-Host "$Windows version $WindowsVer has been detected! $Project has been started -> Initiating the process..."
	Start-Sleep 2
}
ElseIf ($WindowsVer -lt 1607) {
     Write-Host "While $Project focuses on the most recent versions of Windows, Your $Windows $WindowsVer doesn't meet the minimum Windows version requirement. Exiting..."
	 Start-Sleep 5
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
[system.io.directory]::CreateDirectory("$env:Temp\SodaScript") | Out-Null
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/924882910719381574/NSudoLG.exe", "$env:Temp\SodaScript\NSudoLG.exe")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/924882950447849502/OldClassicCalc.exe", "$env:Temp\SodaScript\OldClassicCalc.exe")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/924882996505505803/Soda_Cleaner.bat", "$env:Temp\SodaScript\Soda_Cleaner.bat")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/924883219541819412/StartIsBack.exe", "$env:Temp\SodaScript\StartIsBack.exe")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/925667123571875870/EmptyStandbyList.exe", "$env:Temp\SodaScript\EmptyStandbyList.exe")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/925667123731255316/MEM22.vbs", "$env:Temp\SodaScript\MEM22.vbs")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/930416777018613800/SodaMEM.bat", "$env:Temp\SodaScript\SodaMEM.bat")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/925667124058394665/TEMP22.vbs", "$env:Temp\SodaScript\TEMP22.vbs")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/925667124205191168/TempCleaner.bat", "$env:Temp\SodaScript\TempCleaner.bat")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/925667190915620904/SodaTools.exe", "$env:Temp\SodaScript\SodaTools.exe")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/930416777161224202/SodaNsudo.bat", "$env:Temp\SodaScript\SodaNsudo.bat")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/928732646547275796/Classic_DarkTheme.themepack", "$env:Temp\SodaScript\Classic_DarkTheme.themepack")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929376790630269008/SA_Menu.wav", "$env:Temp\SodaScript\SA_Menu.wav")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929376791020326982/Welcome_TO......wav", "$env:Temp\SodaScript\Welcome_TO......wav")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929376791330701422/Process.wav", "$env:Temp\SodaScript\Process.wav")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/930416777446449152/Nsudo.vbs", "$env:Temp\SodaScript\Nsudo.vbs")
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

Function CreateRestorePoint {
#Turn On System Protection
	Enable-ComputerRestore -Drive "$env:SystemDrive"

#Create Restore Point
	Checkpoint-Computer -Description "$Project"
	
	bcdedit /export $Data\SodaBCDEDITbckp
	reg export HKCR $Data\HKCR.Reg /y
	reg export HKLM $Data\HKLM.Reg /y
	reg export HKCU $Data\HKCU.Reg /y
}

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

Function RestoreRestorePoint {
	bcdedit /import $Data\SodaBCDEDITbckp
	reg import $Data\HKCR.reg
	reg import $Data\HKLM.reg
	reg import $Data\HKCU.reg
	
#Get Restore Point Sequence
	$GetRestorePoint = Get-ComputerRestorePoint | Where-Object {$_.Description -eq "$Project"}
	$SequenceNumber = $GetRestorePoint.SequenceNumber

#Restore $Project Point
	Restore-Computer -RestorePoint $SequenceNumber
}

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

Add-Type -AssemblyName PresentationFramework
$Button = [Windows.MessageBoxButton]::YesNo
$Warn = [Windows.MessageBoxImage]::Warning


$QuestionCreateRestorePoint = [Windows.MessageBox]::Show("Do you want to create a restore point, so you can undone the script's tweaks? (Recommended)?", "SodaScript",$Button, $Warn)
Switch ($QuestionCreateRestorePoint) {
    Yes {
		Write-Host "The script will create a restore point in moments..."
		CreateRestorePoint
	}

    No {
        Write-Host "The script will continue, but keep in mind that the tweaks cannot be undone."
		Start-Sleep 4
    }
}
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
cls
$MenuSound = New-Object System.Media.SoundPlayer "$Temporary\SA_Menu.wav"
$ProcessSound = New-Object System.Media.SoundPlayer "$Temporary\Process.wav"
$WelcomeSound = New-Object System.Media.SoundPlayer "$Temporary\Welcome_TO......wav"
$WelcomeSound.Play()
Write-Host "
          _______  _        _______  _______  _______  _______   _________ _______ 
|\     /|(  ____ \( \      (  ____ \(  ___  )(       )(  ____ \  \__   __/(  ___  )
| )   ( || (    \/| (      | (    \/| (   ) || () () || (    \/     ) (   | (   ) |
| | _ | || (__    | |      | |      | |   | || || || || (__         | |   | |   | |
| |( )| ||  __)   | |      | |      | |   | || |(_)| ||  __)        | |   | |   | |
| || || || (      | |      | |      | |   | || |   | || (           | |   | |   | |
| () () || (____/\| (____/\| (____/\| (___) || )   ( || (____/\     | |   | (___) |
(_______)(_______/(_______/(_______/(_______)|/     \|(_______/     )_(   (_______)
                                                                                   
"
Start-Sleep 2
Write-Host "

 _______  _______  ______   _______    _______  _______  _______ _________ _______ _________
(  ____ \(  ___  )(  __  \ (  ___  )  (  ____ \(  ____ \(  ____ )\__   __/(  ____ )\__   __/
| (    \/| (   ) || (  \  )| (   ) |  | (    \/| (    \/| (    )|   ) (   | (    )|   ) (   
| (_____ | |   | || |   ) || (___) |  | (_____ | |      | (____)|   | |   | (____)|   | |   
(_____  )| |   | || |   | ||  ___  |  (_____  )| |      |     __)   | |   |  _____)   | |   
      ) || |   | || |   ) || (   ) |        ) || |      | (\ (      | |   | (         | |   
/\____) || (___) || (__/  )| )   ( |  /\____) || (____/\| ) \ \_____) (___| )         | |   
\_______)(_______)(______/ |/     \|  \_______)(_______/|/   \__/\_______/|/          )_(   
                                                                                            
"
Start-Sleep 2
cls
#Main menu, allowing user selection
Function Show-Menu {
	Clear-Host
     Write-Host "
 _______  _______  ______   _______    _______  _______  _______ _________ _______ _________
(  ____ \(  ___  )(  __  \ (  ___  )  (  ____ \(  ____ \(  ____ )\__   __/(  ____ )\__   __/
| (    \/| (   ) || (  \  )| (   ) |  | (    \/| (    \/| (    )|   ) (   | (    )|   ) (   
| (_____ | |   | || |   ) || (___) |  | (_____ | |      | (____)|   | |   | (____)|   | |   
(_____  )| |   | || |   | ||  ___  |  (_____  )| |      |     __)   | |   |  _____)   | |   
      ) || |   | || |   ) || (   ) |        ) || |      | (\ (      | |   | (         | |   
/\____) || (___) || (__/  )| )   ( |  /\____) || (____/\| ) \ \_____) (___| )         | |   
\_______)(_______)(______/ |/     \|  \_______)(_______/|/   \__/\_______/|/          )_(   
                                                                                            
	AbdullahNabil	&	Ehab Emad		<< EgyptionTeam >>
"
     Write-Host "1: Remove ALL Bloatware" -BackgroundColor Blue -ForegroundColor Black
     Write-Host "2: Windows & Gaming Tweaks" -BackgroundColor Blue -ForegroundColor Black
     Write-Host "3: Storage Tweaks" -BackgroundColor Blue -ForegroundColor Black
	 Write-Host "4: Graphics Card Tweaks" -BackgroundColor Blue -ForegroundColor Black
     Write-Host "5: Cleaner !" -BackgroundColor Blue -ForegroundColor Black
	 Write-Host "A: [Advanced]" -BackgroundColor Red -ForegroundColor Black
	 Write-Host "R: Restore EveryThing" -BackgroundColor Green -ForegroundColor Black
     Write-Host "Q: quit." -BackgroundColor Yellow -ForegroundColor Black
}
#Functions go here
Function UninstallBloatware {
$global:progressPreference = 'silentlyContinue'
$QuestionXbox = [Windows.MessageBox]::Show("Using XBOX GameBar ?", "SELECT!",$Button, $Warn)
Switch ($QuestionXbox) {
	No {
		Xbox2
	}

    Yes {

    }
}


$QuestionEdge = [Windows.MessageBox]::Show("Using Microsoft Edge Browser?", "SELECT!",$Button, $Warn)
Switch ($QuestionEdge) {
	No {
		UninstallMicrosoftEdge
	}

    Yes {
#disable (Edge) Prelaunch
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v AllowPrelaunch /t REG_DWORD /d "0" /f
#LowerRam Usage
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Value 0 -PropertyType DWord -Force -ea | Out-Null
    }
}
Write-Host "Removing Bloatware..." ; $ProcessSound.Play()
Write-Host "This Might Take 3-4 Minutes IF HDD" ; $ProcessSound.Play()
	$Bloatware = @(
		"Microsoft.3DBuilder"
		"Microsoft.549981C3F5F10"
		"Microsoft.BingWeather"
		"Microsoft.GetHelp"
		"Microsoft.Getstarted"
		"Microsoft.HEIFImageExtension"
		"Microsoft.Messaging"
		"Microsoft.Microsoft3DViewer"
		"Microsoft.MicrosoftOfficeHub"
		"Microsoft.MicrosoftSolitaireCollection"
		"Microsoft.MicrosoftStickyNotes"
		"Microsoft.MixedReality.Portal"
		"Microsoft.MSPaint"
		"Microsoft.Office.OneNote"
		"Microsoft.OneConnect"
		"Microsoft.People"
		"Microsoft.ScreenSketch"
		"Microsoft.SkypeApp"
		"Microsoft.VP9VideoExtensions"
		"Microsoft.Wallet"
		"Microsoft.WebMediaExtensions"
		"Microsoft.WebpImageExtension"
		"Microsoft.Windows.Photos"
		"Microsoft.WindowsAlarms"
		"Microsoft.WindowsCalculator"
		"Microsoft.WindowsCamera"
		"microsoft.windowscommunicationsapps"
		"Microsoft.WindowsFeedbackHub"
		"Microsoft.WindowsMaps"
		"Microsoft.WindowsSoundRecorder"
		"Microsoft.YourPhone"
		#Music & Video Players
		###########"Microsoft.ZuneMusic"
		###########"Microsoft.ZuneVideo"
		#MicrosoftStore
		###########"Microsoft.WindowsStore"
		###########"Microsoft.StorePurchaseApp"
		###########"Microsoft.DesktopAppInstaller"
		#----------------------------------------

	#Sponsored Appx packages:
		"9E2F88E3.Twitter"
		"king.com.CandyCrushSodaSaga"
		"4DF9E0F8.Netflix"
		"Drawboard.DrawboardPDF"
		"D52A8D61.FarmVille2CountryEscape"
		"GAMELOFTSA.Asphalt8Airborne"
		"flaregamesGmbH.RoyalRevolt2"
		"AdobeSystemsIncorporated.AdobePhotoshopExpress"
		"ActiproSoftwareLLC.562882FEEB491"
		"D5EA27B7.Duolingo-LearnLanguagesforFree"
		"Facebook.Facebook"
		"46928bounde.EclipseManager"
		"A278AB0D.MarchofEmpires"
		"KeeperSecurityInc.Keeper"
		"king.com.BubbleWitch3Saga"
		"89006A2E.AutodeskSketchBook"
		"CAF9E577.Plex"
	)

	Foreach ($Bloat in $Bloatware) {
        Get-AppxPackage $Bloat | Remove-AppxPackage
        Get-AppxPackage $Bloat -AllUsers | Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat| Remove-AppxProvisionedPackage -Online | Out-Null
	}
	
	
#Install OldClassicCalc
	$OldCalcSetup = "OldClassicCalc.exe"

	If (Test-Path $Temporary\$OldCalcSetup) {
		Start-Process -FilePath $Temporary\$OldCalcSetup -Verb runAs -ArgumentList "/VERYSILENT"
		Write-Host "Old Classic Calculator has been installed successfully." ; $ProcessSound.Play()
		Start-Sleep 2
	}
	
#Activate Windows Photo Viewer
	$WindowsPhotoViewer = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"

	If (Test-Path $WindowsPhotoViewer) {
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
	}
	
#Uninstall OneDrive - Not applicable to Server
	Write-Host "Uninstalling OneDrive..." ; $ProcessSound.Play()
	Stop-Process -Name OneDrive -ErrorAction SilentlyContinue
	Start-Sleep -s 3
	$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
	If (!(Test-Path $onedrive)) {
		$onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
	}
	Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
	Start-Sleep -s 3
	Stop-Process -Name explorer -ErrorAction SilentlyContinue
	Start-Sleep -s 3
	Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" -Recurse -ErrorAction SilentlyContinue
}

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
#Remove & Disable Xbox Services
Function Xbox2{
Write-Host "Removing Xbox..." ; $ProcessSound.Play()
	$Bloatware2 = @(
		"Microsoft.Xbox.TCUI"
		"Microsoft.XboxApp"
		"Microsoft.XboxGameOverlay"
		"Microsoft.XboxGamingOverlay"
		"Microsoft.XboxIdentityProvider"
		"Microsoft.XboxSpeechToTextOverlay"
	)

		Foreach ($Bloat in $Bloatware2) {
        Get-AppxPackage $Bloat | Remove-AppxPackage
        Get-AppxPackage $Bloat -AllUsers | Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat| Remove-AppxProvisionedPackage -Online | Out-Null
	}

Remove-Item -Path "HKCU\System\GameConfigStore\Parents" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\System\GameConfigStore\Children" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\System\GameConfigStore\Parents" -Recurse -ErrorAction SilentlyContinue

$XBOX3 = "HKCU:\Software\Microsoft\GameBar"
If (Test-Path $XBOX3) {
	Set-ItemProperty $XBOX3 "ShowStartupPanel" -Value 0
	Set-ItemProperty $XBOX3 "GamePanelStartupTipIndex" -Value 3
	Set-ItemProperty $XBOX3 "AllowAutoGameMode" -Value 0
	Set-ItemProperty $XBOX3 "AutoGameModeEnabled" -Value 0
	Set-ItemProperty $XBOX3 "UseNexusForGameBarEnabled" -Value 0
}
$XBOX4 = "HKCU:\System\GameConfigStore"
If (Test-Path $XBOX4) {
	Set-ItemProperty $XBOX4 "GameDVR_Enabled" -Value 0
	Set-ItemProperty $XBOX4 "GameDVR_FSEBehaviorMode" -Value 2
	Set-ItemProperty $XBOX4 "GameDVR_FSEBehavior" -Value 2
	Set-ItemProperty $XBOX4 "GameDVR_DSEBehavior" -Value 2
	Set-ItemProperty $XBOX4 "GameDVR_HonorUserFSEBehaviorMode" -Value 1
	Set-ItemProperty $XBOX4 "GameDVR_DXGIHonorFSEWindowsCompatible" -Value 1
	Set-ItemProperty $XBOX4 "GameDVR_EFSEFeatureFlags" -Value 0
	Set-ItemProperty $XBOX4 "GameDVR_Enabled" -Value 0
}
$XBOX5 = "HKLM:\SYSTEM\CurrentControlSet\Services"
If (Test-Path $XBOX5) {
	Set-ItemProperty $XBOX5\XboxNetApiSvc "Start" -Value 4
	Set-ItemProperty $XBOX5\XblGameSave "Start" -Value 4
	Set-ItemProperty $XBOX5\XboxGipSvc "Start" -Value 4
	Set-ItemProperty $XBOX5\XblAuthManager "Start" -Value 4
}
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -force | Out-Null };
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR' -Name 'value' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' -Name 'AllowGameDVR' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0 -PropertyType DWord -Force | Out-Null

	#Disable - GameDVR and Broadcast User Service_XXXXX
	REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\BcastDVRUserService" /v Start /t REG_DWORD /d 00000004 /f | Out-Null

	# !-----------Path Error---------------!
	#takeown.exe /f $env:SystemRoot\GameBarPresenceWriter.exe | Out-Null
	#icacls.exe $env:SystemRoot\GameBarPresenceWriter.exe /reset | Out-Null
	#Rename-Item -Path "$env:SystemRoot\System32\GameBarPresenceWriter.exe" -NewName "GameBarPresenceWriter.old" -Force
	
}

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

Function UninstallMicrosoftEdge{
	Start-Process -FilePath "$env:SystemDrive\*\Microsoft\Edge\Application\*\Installer\setup.exe" -ArgumentList "-uninstall -system-level -verbose-logging -force-uninstall"
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

Function HDDandSSD {
	fsutil behavior set disablecompression 1
	fsutil behavior set disableencryption 1
	fsutil behavior set disablelastaccess 1
	fsutil behavior set encryptpagingfile 0
	fsutil behavior set disable8dot3 1
	
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "0" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Superfetch" /v "StartedComponents" /t Reg_DWORD /d "513347" /f | Out-Null
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\PCI\*\*\Device Parameters\StorPort" EnableIdlePowerManagement -Value 0

$QuestionHDDorSSD = [Windows.MessageBox]::Show("Did u install windows on SSD ?", "SodaScript",$Button, $Warn)
Switch ($QuestionHDDorSSD) {
    Yes {
		SSDOnly
	}

    No {
    }
}
}

Function SSDOnly{
	Write-Host "SSD Tweaks..." ; $ProcessSound.Play()
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

	fsutil behavior set disableLastAccess 0
}
Function WindowsTweaks{
Write-Host "Processing..."
#Disable Windows Deffender (For Performance) + (It's Very Weak antivirus We Recommend Kaspersky)
Start-Process "$Temporary\Nsudo.vbs"
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender")) {
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -ErrorAction SilentlyContinue
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -force | Out-Null
    }
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Type DWord -Value 2
	$Deffender3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray"
	If (Test-Path $Deffender3) {
		Set-ItemProperty $Deffender3 HideSystray -Value 1
	}
	REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V DisablePreviewDesktop /T REG_DWORD /D 1 /F | Out-Null

	$Devices = @(
		"Acpi Processor Aggregator"
		"Base System Device"
		"Composite Bus Enumerator"
		"High Precision event timer"
		"Microsoft Windows Management Interface for ACPI"
		"NDIS Virtual Network Adapter Enumerator"
		"Numeric data processor"
		"PCI Data Acquisition and Signal Processing Controller"
		"PCI Simple Communications Controller"
		"PCI memory controller"
		"Programmable interrupt controller"
		"SM BUS Controller"
		"System Timer"
		"UMBus Root Bus Enumerator"
	)

	Foreach ($Device in (Get-PnpDevice).FriendlyName) {
		If ($Device -in $Devices) {
			Get-PnpDevice -FriendlyName $Device | Disable-PnpDevice -ea SilentlyContinue -Confirm:$false | Out-Null
		}
	}

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
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

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "Disabling Unnecessery Services..." ; $ProcessSound.Play()
$Services = @(
	"AJRouter" #AllJoyn Router Service
	"tzautoupdate" #Auto Time Zone Updater
	"DiagTrack" #Connected User Experiences and Telemetry
	"CDPSvc" #Connected Devices Platform Service (Causes 100% CPU USAGE)
	"DusmSvc" #Data Usage
	"MapsBroker" #Downloaded Maps Manager
	"fhsvc" #File History Service
	"GraphicsPerfSvc" #GraphicsPerfSvc
	
	#Hiber-V Services #-#-#-#-#-#
	"HvHost"
	"vmickvpexchange"
	"vmicguestinterface"
	"vmicshutdown"
	"vmicheartbeat"
	"vmicvmsession"
	"vmicrdv"
	"vmictimesync"
	"vmicvss"
	#-#-#-#-#-#-#-#-#-#-#-##-#-#
	
	"iphlpsvc" #IP Helper
	"CscService" #Offline Files
	"p2pimsvc" #Peer Networking Identity Manager
	"pla" # Performance Logs & Alerts
	"QWAVE" #Quality Windows Audio Video Experience
	"RetailDemo" #Retail Demo Service
	"RmSvc" #Radio Management Service
	"SNMPTRAP" #SNMP Trap
	"seclogon" #Secondary Logon
	"ShellHWDetection" #Shell Hardware Detection
	"SysMain" # Super Fetch
	"TabletInputService" #Touch Keyboard and Handwriting....
	"wmiApSrv" # WMI Performance Adapter
	"WerSvc" #Windows Error Reporting
	"FontCache"
	"FontCache3.0.0.0"
	"wisvc" # Windows Insider Service
	"WSearch" #Windows Search
	"W32Time" #Windows Time
	)

Foreach ($Service in (Get-Service).Name) {
	If ($Service -in $Services) {
		Set-Service $Service -StartupType Disabled
	}
}
Set-Service DPS -StartupType manual
Set-Service TrkWks -StartupType manual
#Disable Services from Registry
	$Services = "HKLM:\SYSTEM\CurrentControlSet\services"
	If (Test-Path $Services) {
		Set-ItemProperty $Services\kdnic Start -Value 4
		Set-ItemProperty $Services\Ndu Start -Value 4
		Set-ItemProperty $Services\FontCache Start -Value 4
		Set-ItemProperty $Services\diagnosticshub.standardcollector.service Start -Value 4
		Set-ItemProperty $Services\MMCSS Start -Value 4
		Set-ItemProperty $Services\GpuEnergyDrv Start -Value 4
		Set-ItemProperty $Services\"Origin Web Helper Service" Start -Value 4 -ErrorAction SilentlyContinue
		Set-ItemProperty $Services\ksthunk Start -Value 3
		Set-ItemProperty $Services\AppXSvc Start -Value 3
		Set-ItemProperty $Services\iaStorAVC\Parameters IoLatencyCap -Value 0
		Set-ItemProperty $Services\cbdhsvc Start -Value 3
		Set-ItemProperty $Services\UsoSvc DelayedAutoStart -Value 0
		Set-ItemProperty $Services\UsoSvc Start -Value 3
		Set-ItemProperty $Services\Themes Start -Value 3
	}
#Disable - Sync Host_XXXXX
	REG ADD "HKLM\SYSTEM\CurrentControlSet\services\OneSyncSvc" /v Start /t REG_DWORD /d 00000004 /f | Out-Null
#Disable - User Data Aceess_XXXXX
	REG ADD "HKLM\SYSTEM\CurrentControlSet\services\UserDataSvc" /v Start /t REG_DWORD /d 00000004 /f | Out-Null
#Disable - User Data Storage_XXXXX
	REG ADD "HKLM\SYSTEM\CurrentControlSet\services\UnistoreSvc" /v Start /t REG_DWORD /d 00000004 /f | Out-Null
#Disable - Contact Data_XXXXX
	REG ADD "HKLM\SYSTEM\CurrentControlSet\services\PimIndexMaintenanceSvc" /v Start /t REG_DWORD /d 00000004 /f | Out-Null
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

#Disable Microsoft Compatibility Appraiser Telemetry (:

$Tasks = @(
	"Microsoft Compatibility Appraiser"
    "ProgramDataUpdater"
)

Foreach ($Task in (Get-ScheduledTask).TaskName) {
	If ($Task -in $Tasks) {
		Get-ScheduledTask -TaskName $Task | Disable-ScheduledTask |Out-Null
	}
}

$AutoLogger = "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
If (Test-Path $AutoLogger) {
	Remove-Item -Path $AutoLogger
}

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

#Reduce Processes
Write-Host "Disabling Unnecessery Processes&Tasks !" ; $ProcessSound.Play()

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
		Rename-Item -Path "$env:SystemRoot\System32\$Item" -NewName "$Item.old" -Force
	}
}

takeown.exe /f $env:SystemRoot\HelpPane.exe | Out-Null
icacls.exe $env:SystemRoot\HelpPane.exe /reset | Out-Null
Rename-Item -Path "$env:SystemRoot\HelpPane.exe" -NewName "HelpPane.old" -Force

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "BCDEDIT Tweaks" ; $ProcessSound.Play()
#bcdedit Tweaks
bcdedit /deletevalue useplatformclock| Out-Null
bcdedit /set MSI Default| Out-Null
bcdedit /set allowedinmemorysettings 0x0| Out-Null
bcdedit /set avoidlowmemory 0x8000000| Out-Null
bcdedit /set bootmenupolicy standard| Out-Null
bcdedit /set configaccesspolicy Default| Out-Null
bcdedit /set disabledynamictick yes| Out-Null
bcdedit /set hypervisorlaunchtype off| Out-Null
bcdedit /set increaseuserva 268435328| Out-Null
bcdedit /set isolatedcontext No| Out-Null
bcdedit /set linearaddress57 OptOut| Out-Null
bcdedit /set nolowmem Yes| Out-Null
bcdedit /set usefirmwarepcisettings No| Out-Null
bcdedit /set usephysicaldestination No| Out-Null
bcdedit /set useplatformtick yes| Out-Null
bcdedit /set vm No| Out-Null
bcdedit /set vsmlaunchtype Off| Out-Null
bcdedit /timeout 0| Out-Null
bcdedit /set disableelamdrivers Yes| Out-Null

#Enable F8 boot menu options
bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "Optimizing SvcHostSplitThreshold..." ; $ProcessSound.Play()
$SvcHostSplitThresholdInKB = $Memory * 1048576
Set-ItemProperty "HKLM:\SYSTEM\ControlSet001\Control" SvcHostSplitThresholdInKB -Value $SvcHostSplitThresholdInKB | Out-Null
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "Optimizing PageFile..." ; $ProcessSound.Play()
powershell.exe -exec bypass -enc JABNAGUAbQBvAHIAeQAgAD0AIABnAHcAbQBpACAAVwBpAG4AMwAyAF8ATwBwAGUAcgBhAHQAaQBuAGcAUwB5AHMAdABlAG0AIAB8ACAATQBlAGEAcwB1AHIAZQAtAE8AYgBqAGUAYwB0ACAALQBQAHIAbwBwAGUAcgB0AHkAIABUAG8AdABhAGwAVgBpAHMAaQBiAGwAZQBNAGUAbQBvAHIAeQBTAGkAegBlACAALQBTAHUAbQAgAHwAIAAlACAAewBbAE0AYQB0AGgAXQA6ADoAUgBvAHUAbgBkACgAJABfAC4AcwB1AG0ALwAxADAAMgA0AC8AMQAwADIANAApAH0ADQAKACQAQwBvAG0AcAB1AHQAZQByAFMAeQBzAHQAZQBtACAAPQAgAEcAZQB0AC0AVwBtAGkATwBiAGoAZQBjAHQAIAAtAEMAbABhAHMAcwBOAGEAbQBlACAAVwBpAG4AMwAyAF8AQwBvAG0AcAB1AHQAZQByAFMAeQBzAHQAZQBtAA0ACgANAAoASQBmACAAKAAkAEMAbwBtAHAAdQB0AGUAcgBTAHkAcwB0AGUAbQAuAEEAdQB0AG8AbQBhAHQAaQBjAE0AYQBuAGEAZwBlAGQAUABhAGcAZQBGAGkAbABlACAAPQAgACQAVAByAHUAZQApACAAewANAAoACQAkAEMAbwBtAHAAdQB0AGUAcgBTAHkAcwB0AGUAbQAuAEEAdQB0AG8AbQBhAHQAaQBjAE0AYQBuAGEAZwBlAGQAUABhAGcAZQBGAGkAbABlACAAPQAgACQARgBhAGwAcwBlAA0ACgAJACQAQwBvAG0AcAB1AHQAZQByAFMAeQBzAHQAZQBtAC4AUAB1AHQAKAApAA0ACgANAAoACQAkAFAAYQBnAGUARgBpAGwAZQBTAGUAdAB0AGkAbgBnACAAPQAgAEcAZQB0AC0AVwBtAGkATwBiAGoAZQBjAHQAIAAtAEMAbABhAHMAcwBOAGEAbQBlACAAVwBpAG4AMwAyAF8AUABhAGcAZQBGAGkAbABlAFMAZQB0AHQAaQBuAGcADQAKAAkAJABQAGEAZwBlAEYAaQBsAGUAUwBlAHQAdABpAG4AZwAuAEkAbgBpAHQAaQBhAGwAUwBpAHoAZQAgAD0AIAAkAE0AZQBtAG8AcgB5ACAAKgAgADEANQAzADYADQAKAAkAJABQAGEAZwBlAEYAaQBsAGUAUwBlAHQAdABpAG4AZwAuAE0AYQB4AGkAbQB1AG0AUwBpAHoAZQAgAD0AIAAkAE0AZQBtAG8AcgB5ACAAKgAgADEANQAzADYADQAKAAkAJABQAGEAZwBlAEYAaQBsAGUAUwBlAHQAdABpAG4AZwAuAFAAdQB0ACgAKQANAAoACQB9AA== | Out-Null
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
#ForAllCards
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "0" /f | Out-Null


Write-Host "Doing Some RegistryTweaks..." ; $ProcessSound.Play()

#Gaming Tweaks
	$Gaming = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
	If (Test-Path $Gaming) {
		Set-ItemProperty $Gaming Affinity -Value 0
		Set-ItemProperty $Gaming "Background Only" -Value False
		Set-ItemProperty $Gaming "Clock Rate" -Value 2710
		Set-ItemProperty $Gaming "GPU Priority" -Value 8
		Set-ItemProperty $Gaming Priority -Value 6
		Set-ItemProperty $Gaming "Scheduling Category" -Value High
		Set-ItemProperty $Gaming "SFIO Priority" -Value High
	}

	$Gaming2 = "HKCU:\SOFTWARE\Microsoft\Games"
	If (Test-Path $Gaming2) {
		Set-ItemProperty $Gaming2 FpsAll -Value 1
		Set-ItemProperty $Gaming2 GameFluidity -Value 1
	}
	
	
#AdditionalWorkerThreads
	$AdditionalWorkerThreads = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Executive"
	If ((Test-Path $AdditionalWorkerThreads) -eq $false) {
		New-Item $AdditionalWorkerThreads
	}
	Set-ItemProperty -Path $AdditionalWorkerThreads -Name "AdditionalCriticalWorkerThreads" -Value $CPUThreads
	Set-ItemProperty -Path $AdditionalWorkerThreads -Name "AdditionalDelayedWorkerThreads" -Value $CPUThreads

#DistributeTimers
	$DistributeTimers = "HKLM:\System\CurrentControlSet\Control\Session Manager\kernel"
	If ($CPUCores -le 6) {
		Set-ItemProperty -Path $DistributeTimers -Name "DistributeTimers" -Value 0
	}
	ElseIf ($CPUCores -gt 6) {
		Set-ItemProperty -Path $DistributeTimers -Name "DistributeTimers" -Value 1
	}
	
# TimeStampInterval =0ms
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability' -Name 'TimeStampInterval' -Value 0 -PropertyType DWord -Force | Out-Null
	
	#PRIORITY
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'LowLatencyScalingPercentage' -Value 64 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HighPerformance' -Value 1 -PropertyType DWord -Force | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t Reg_DWORD /d "1" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t Reg_DWORD /d "1" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t Reg_DWORD /d "10000" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t Reg_DWORD /d "0" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t Reg_SZ /d "False" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t Reg_DWORD /d "10000" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t Reg_DWORD /d "18" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t Reg_DWORD /d "6" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t Reg_SZ /d "High" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t Reg_SZ /d "High" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t Reg_SZ /d "True" /f | Out-Null
	Reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "NoLazyMode" /t Reg_DWORD /d "1" /f | Out-Null
	
#Unlocks the ability to modify sleeping CPU cores
	$PowerSettings = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings"
	If (Test-Path $PowerSettings) {
		Set-ItemProperty $PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e ACSettingIndex -Value 0
		Set-ItemProperty $PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e DCSettingIndex -Value 0
		Set-ItemProperty $PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c ACSettingIndex -Value 0
		Set-ItemProperty $PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100 Attributes -Value 2
		Set-ItemProperty $PowerSettings\54533251-82be-4824-96c1-47b60b740d00\943c8cb6-6f93-4227-ad87-e9a3feec08d1 Attributes -Value 2
	}
	
#Driver Tweaks
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f | Out-Null
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

	$Power3 = "HKLM:\SYSTEM\ControlSet001\Control\Power"
	If (Test-Path $Power3) {
		Set-ItemProperty $Power3 MfBufferingThreshold -Value 0
		Set-ItemProperty $Power3 HibernateEnabledDefault -Value 0
		Set-ItemProperty $Power3 HibernateEnabled -Value 0
	}

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
	If (Test-Path $Response) {
		Set-ItemProperty $Response NetworkThrottlingIndex -Value ffffffff
		Set-ItemProperty $Response SystemResponsiveness -Value 0
	}
	
Write-Host "Optimizing Mouse Acculration" ; $ProcessSound.Play()
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
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'SmoothMouseXCurve' -Value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xa0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x80,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'DoubleClickSpeed' -Value '550' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'SmoothMouseYCurve' -Value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x66,0xa6,0x02,0x00,0x00,0x00,0x00,0x00,0xcd,0x4c,0x05,0x00,0x00,0x00,0x00,0x00,0xa0,0x99,0x0a,0x00,0x00,0x00,0x00,0x00,0x38,0x33,0x15,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseHoverTime' -Value '8' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'AttractionRectInsetInDIPS' -Value 5 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'DistanceThresholdInDIPS' -Value 40 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'MagnetismDelayInMilliseconds' -Value 50 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'MagnetismUpdateIntervalInMilliseconds' -Value 16 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'VelocityInDIPSPerSecond' -Value 360 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'CursorSensitivity' -Value 10000 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'CursorUpdateInterval' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'IRRemoteNavigationDelta' -Value 1 -PropertyType DWord -Force | Out-Null
	
	$Mouse2 = "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters"
	If (Test-Path $Mouse2) {
		Set-ItemProperty $Mouse2 ThreadPriority -Value 1f
		Set-ItemProperty $Mouse2 MouseDataQueueSize -Value 32
	}
	
	$Mouse3 = "HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"
	If (Test-Path $Mouse3) {
		Set-ItemProperty $Mouse3 AttractionRectInsetInDIPS -Value 5
		Set-ItemProperty $Mouse3 DistanceThresholdInDIPS -Value 28
		Set-ItemProperty $Mouse3 MagnetismDelayInMilliseconds -Value 32
		Set-ItemProperty $Mouse3 MagnetismUpdateIntervalInMilliseconds -Value 10
		Set-ItemProperty $Mouse3 VelocityInDIPSPerSecond -Value 168
	}
	$Mouse4 = "HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed"
	If (Test-Path $Mouse4) {
		Set-ItemProperty $Mouse4 CursorSensitivity -Value 2710
		Set-ItemProperty $Mouse4 CursorUpdateInterval -Value 1
		Set-ItemProperty $Mouse4 IRRemoteNavigationDelta -Value 1
	}
	
	$QuestionDesktopORLaptop = [Windows.MessageBox]::Show("Using LAPTOP ?", "SELECT!",$Button, $Warn)
Switch ($QuestionDesktopORLaptop) {
	No {Desktop2

	}

    Yes {

    }
}
	
#OtherTweaks
	if((Test-Path -LiteralPath "HKLM:\System\CurrentControlSet\Services\VxD\BIOS") -ne $true) {  New-Item "HKLM:\System\CurrentControlSet\Services\VxD\BIOS" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\System\CurrentControlSet\Services\VxD\VCOMM") -ne $true) {  New-Item "HKLM:\System\CurrentControlSet\Services\VxD\VCOMM" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\System\CurrentControlSet\control\FileSystem") -ne $true) {  New-Item "HKLM:\System\CurrentControlSet\control\FileSystem" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\System\CurrentControlSet\control\Update") -ne $true) {  New-Item "HKLM:\System\CurrentControlSet\control\Update" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\System\CurrentControlSet\Services\VxD\MSTCP") -ne $true) {  New-Item "HKLM:\System\CurrentControlSet\Services\VxD\MSTCP" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\AlwaysUnloadDLL") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\AlwaysUnloadDLL" -force | Out-Null };
	if((Test-Path -LiteralPath "HKCU:\Control Panel\desktop") -ne $true) {  New-Item "HKCU:\Control Panel\desktop" -force | Out-Null };
	if((Test-Path -LiteralPath "HKCU:\Control Panel\desktop\WindowMetrics") -ne $true) {  New-Item "HKCU:\Control Panel\desktop\WindowMetrics" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\VxD\BIOS' -Name 'CPUPriority' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\VxD\BIOS' -Name 'FastDRAM' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\VxD\BIOS' -Name 'PCIconcur' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\VxD\BIOS' -Name 'AGPConcur' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\VxD\VCOMM' -Name 'EnablePowerManagement' -Value ([byte[]](0x00)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\control\FileSystem' -Name 'DriveWriteBehind' -Value ([byte[]](0xff,0xff,0xff,0xff)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\control\FileSystem' -Name 'ReadAheadThreshold' -Value ([byte[]](0xff,0xff,0xff,0xff)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\control\Update' -Name 'UpdateMode' -Value ([byte[]](0x00)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\VxD\MSTCP' -Name 'PMTUDiscovery' -Value '1' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\AlwaysUnloadDLL' -Name '(default)' -Value '1' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\desktop' -Name 'HungAppTimeout' -Value '1' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\desktop' -Name 'WaitToKillAppTimeout' -Value '1' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\desktop' -Name 'AutoEndTasks' -Value '1' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\desktop' -Name 'MenuShowDelay' -Value '0' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\desktop\WindowMetrics' -Name 'Shell Icon Bpp' -Value '16' -PropertyType String -Force | Out-Null
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUserDisabled' -Value 1 -Force | Out-Null
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\MRT") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\MRT' -Name 'DontOfferThroughWUAU' -Value 1 -PropertyType DWord -Force | Out-Null
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\DXGKrnl") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\DXGKrnl" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\DXGKrnl' -Name 'MonitorLatencyTolerance' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\DXGKrnl' -Name 'MonitorRefreshLatencyTolerance' -Value 0 -Force | Out-Null
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Siuf\Rules") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -Value 0 -PropertyType DWord -Force | Out-Null
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel' -Name 'DpcWatchdogProfileOffset' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel' -Name 'KernelSEHOPEnabled' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel' -Name 'SerializeTimerExpiration' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel' -Name 'InterruptSteeringDisabled' -Value 1 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\SESSION MANAGER\kernel' -Name 'DpcWatchdogPeriod' -Value 0 -Force | Out-Null
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\FVE") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\FVE' -Name 'DisableExternalDMAUnderLock' -Value 0 -PropertyType DWord -Force | Out-Null
	if((Test-Path -LiteralPath "HKCU:\Control Panel\Desktop\MuiCached") -ne $true) {  New-Item "HKCU:\Control Panel\Desktop\MuiCached" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\Microsoft\FirewallAPI") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\Microsoft\FirewallAPI" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\Microsoft\PlugPlay\SETUPAPI") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\Microsoft\PlugPlay\SETUPAPI" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\SCM\Regular") -ne $true) {  New-Item "\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\SCM\Regular" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\Microsoft\FirewallAPI' -Name 'Active' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\Microsoft\FirewallAPI' -Name 'ControlFlags' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\Microsoft\PlugPlay\SETUPAPI' -Name 'Active' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\Microsoft\PlugPlay\SETUPAPI' -Name 'ControlFlags' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Tracing\SCM\Regular' -Name 'TracingDisabled' -Value 1 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisableUAR' -Value 1 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisableInventory' -Value 1 -Force | Out-Null
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" -forc | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP' -Name 'CdpSessionUserAuthzPolicy' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP' -Name 'NearShareChannelUserAuthzPolicy' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP' -Name 'RomeSdkChannelUserAuthzPolicy' -Value 0 -PropertyType DWord -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF' -Name 'LogEnable' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF' -Name 'LogLevel' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity' -Name 'Enabled' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity' -Name 'HVCIMATRequired' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity' -Name 'Locked' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'AutoChkTimeout' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'ProtectionMode' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'AutoChkSkipSystemPartition' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'AlpcWakePolicy' -Value 1 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'CoalescingTimerInterval' -Value 0 -Force | Out-Null
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Paint.Picture\DefaultIcon") -ne $true) {  New-Item "HKLM:\SOFTWARE\Classes\Paint.Picture\DefaultIcon" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Paint.Picture\DefaultIcon' -Name '(default)' -Value '%1' -PropertyType String -Force | Out-Null
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement' -Name 'ScoobeSystemSettingEnabled' -Value 0 -Force | Out-Null
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" -force | Out-Null };
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability' -Name 'TimeStampInterval' -Value 0 -Force | Out-Null
	Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'AITEnable' -Value 0 -Force | Out-Null
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'WaitToKillServiceTimeout' -Value '2000' -PropertyType String -Force | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "ContigFileAllocSize" /t REG_DWORD /d "1536" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "DisableDeleteNotification" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "FileNameCache" /t REG_DWORD /d "1024" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "LongPathsEnabled" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsAllowExtendedCharacter8dot3Rename" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsBugcheckOnCorrupt" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsDisableCompression" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsDisableEncryption" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsEncryptPagingFile" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsMemoryUsage" /t REG_DWORD /d "2" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsMftZoneReservation" /t REG_DWORD /d "2" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "PathCache" /t REG_DWORD /d "128" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "RefsDisableLastAccessUpdate" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "UdfsSoftwareDefectManagement" /t REG_DWORD /d "0" /f | Out-Null
	reg add "HKLM\SYSTEM\currentcontrolset\control\filesystem" /v "Win31FileSystem" /t REG_DWORD /d "0" /f | Out-Null
	
	
	#  Disable Variable Refresh Rate
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences' -Name 'DirectXUserGlobalSettings' -Value 'VRROptimizeEnable=0;' -PropertyType String -Force | Out-Null

	$More3 = "HKCU:\Control Panel\Desktop"
	If (Test-Path $More3) {
		Set-ItemProperty $More3 ActiveWndTrackTimeout -Value 0
		Set-ItemProperty $More3 BlockSendInputResets -Value 0
		Set-ItemProperty $More3 CaretTimeout -Value 1388
		Set-ItemProperty $More3 CaretWidth -Value 1
		Set-ItemProperty $More3 ClickLockTime -Value 4b0
		Set-ItemProperty $More3 CoolSwitchColumns -Value 7
		Set-ItemProperty $More3 CoolSwitchRows -Value 3
		Set-ItemProperty $More3 CursorBlinkRate -Value 530
		Set-ItemProperty $More3 DockMoving -Value 1
		Set-ItemProperty $More3 DragFromMaximize -Value 1
		Set-ItemProperty $More3 DragFullWindows -Value 1
		Set-ItemProperty $More3 DragHeight -Value 4
		Set-ItemProperty $More3 DragWidth -Value 4
		Set-ItemProperty $More3 DragFullWindows -Value 0
		Set-ItemProperty $More3 FocusBorderHeight -Value 1
		Set-ItemProperty $More3 FocusBorderWidth -Value 1
		Set-ItemProperty $More3 FontSmoothing -Value 2
		Set-ItemProperty $More3 FontSmoothingGamma -Value 0
		Set-ItemProperty $More3 FontSmoothingOrientation -Value 1
		Set-ItemProperty $More3 FontSmoothingType -Value 2
		Set-ItemProperty $More3 ForegroundFlashCount -Value 0
		Set-ItemProperty $More3 ForegroundLockTimeout -Value 30d40
		Set-ItemProperty $More3 LeftOverlapChars -Value 3
		Set-ItemProperty $More3 PaintDesktopVersion -Value 0
		Set-ItemProperty $More3 Pattern -Value 3
		Set-ItemProperty $More3 RightOverlapChars -Value 3
		Set-ItemProperty $More3 ScreenSaveActive -Value 1
		Set-ItemProperty $More3 SnapSizing -Value 1
		Set-ItemProperty $More3 TileWallpaper -Value 0
		Set-ItemProperty $More3 WallpaperOriginX -Value 0
		Set-ItemProperty $More3 WallpaperOriginY -Value 0
		Set-ItemProperty $More3 WallpaperStyle -Value 10
		Set-ItemProperty $More3 WheelScrollChars -Value 3
		Set-ItemProperty $More3 WheelScrollLines -Value 3
		Set-ItemProperty $More3 Win8DpiScaling -Value 0
		Set-ItemProperty $More3 DpiScalingVer -Value 1000
		Set-ItemProperty $More3 MaxVirtualDesktopDimension -Value 780
		Set-ItemProperty $More3 MaxMonitorDimension -Value 780
		Set-ItemProperty $More3 TranscodedImageCount -Value 1
		Set-ItemProperty $More3 LastUpdated -Value ffffffff
		Set-ItemProperty $More3 AutoColorization -Value 0
		Set-ItemProperty $More3 ImageColor -Value 97c87657
		Set-ItemProperty $More3 AutoEndTasks -Value 1
		Set-ItemProperty $More3 SmoothScroll -Value 0
		Set-ItemProperty $More3 JPEGImportQuality -Value 100
		Set-ItemProperty $More3 HungAppTimeout -Value 1000
		Set-ItemProperty $More3 MenuShowDelay -Value 0
		Set-ItemProperty $More3 WaitToKillAppTimeout -Value 2000
		Set-ItemProperty $More3 LowLevelHooksTimeout -Value 1000
		Set-ItemProperty $More3 LogPixels -Value 96
	}
	
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -PropertyType Binary -Force  | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'TranscodedImageCache' -Value ([byte[]](0x7a,0xc3,0x01,0x00,0x2c,0xf3,0x0e,0x00,0x8a,0x0a,0x00,0x00,0xed,0x05,0x00,0x00,0x4e,0x3b,0xbc,0xb3,0xcf,0xfb,0xd6,0x01,0x43,0x00,0x3a,0x00,0x5c,0x00,0x55,0x00,0x73,0x00,0x65,0x00,0x72,0x00,0x73,0x00,0x5c,0x00,0x64,0x00,0x61,0x00,0x6e,0x00,0x79,0x00,0x74,0x00,0x5c,0x00,0x41,0x00,0x70,0x00,0x70,0x00,0x44,0x00,0x61,0x00,0x74,0x00,0x61,0x00,0x5c,0x00,0x4c,0x00,0x6f,0x00,0x63,0x00,0x61,0x00,0x6c,0x00,0x5c,0x00,0x4d,0x00,0x69,0x00,0x63,0x00,0x72,0x00,0x6f,0x00,0x73,0x00,0x6f,0x00,0x66,0x00,0x74,0x00,0x5c,0x00,0x57,0x00,0x69,0x00,0x6e,0x00,0x64,0x00,0x6f,0x00,0x77,0x00,0x73,0x00,0x5c,0x00,0x54,0x00,0x68,0x00,0x65,0x00,0x6d,0x00,0x65,0x00,0x73,0x00,0x5c,0x00,0x52,0x00,0x6f,0x00,0x61,0x00,0x6d,0x00,0x65,0x00,0x64,0x00,0x54,0x00,0x68,0x00,0x65,0x00,0x6d,0x00,0x65,0x00,0x46,0x00,0x69,0x00,0x6c,0x00,0x65,0x00,0x73,0x00,0x5c,0x00,0x44,0x00,0x65,0x00,0x73,0x00,0x6b,0x00,0x74,0x00,0x6f,0x00,0x70,0x00,0x42,0x00,0x61,0x00,0x63,0x00,0x6b,0x00,0x67,0x00,0x72,0x00,0x6f,0x00,0x75,0x00,0x6e,0x00,0x64,0x00,0x5c,0x00,0x77,0x00,0x61,0x00,0x6c,0x00,0x6c,0x00,0x70,0x00,0x61,0x00,0x70,0x00,0x65,0x00,0x72,0x00,0x2e,0x00,0x70,0x00,0x6e,0x00,0x67,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -Force  | Out-Null
	
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Value 1 -PropertyType DWord -Force | Out-Null
	
	# Enable Hardware Accelerated GPU Scheduling (Windows 10 2004 + NVIDIA 10 Series Above + AMD 5000 and Above)
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode") {
			Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2
		}
	
	#DisableCloudContent
	$CloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	If (Test-Path $CloudContent) {
		Set-ItemProperty $CloudContent ConfigureWindowsSpotlight -Value 2
		Set-ItemProperty $CloudContent IncludeEnterpriseSpotlight -Value 0
		Set-ItemProperty $CloudContent DisableWindowsSpotlightFeatures -Value 1
		Set-ItemProperty $CloudContent DisableWindowsSpotlightWindowsWelcomeExperience -Value 1
		Set-ItemProperty $CloudContent DisableWindowsSpotlightOnActionCenter -Value 1
		Set-ItemProperty $CloudContent DisableWindowsSpotlightOnSettings -Value 1
		Set-ItemProperty $CloudContent DisableThirdPartySuggestions -Value 1
		Set-ItemProperty $CloudContent DisableTailoredExperiencesWithDiagnosticData -Value 1
		Set-ItemProperty $CloudContent DisableWindowsConsumerFeatures -Value 1
	}

	#Restore OLD THINGS
	$OLD = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\MTCUVC"
	If (Test-Path $OLD) {
		Set-ItemProperty $OLD EnableMtcUvc -Value 0
	}

	$OLD2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell"
	If (Test-Path $OLD2) {
		Set-ItemProperty $OLD2 UseWin32TrayClockExperience -Value 1
	}

	$OLD3 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell"
	If (Test-Path $OLD3) {
		Set-ItemProperty $OLD3 UseWin32BatteryFlyout -Value 1
	}

	#Set Explorers LaunchTo Computer
	$LaunchTo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	If (Test-Path $LaunchTo) {
		Set-ItemProperty $LaunchTo LaunchTo -Value 1
	}

	#DisableAutomatic Update Store&Maps
	$Store = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
	If (Test-Path $Store) {
		Set-ItemProperty $Store AutoDownload -Value 2
	}
	
	#Disable Updates are available message
	takeown /F "$env:WinDIR\System32\MusNotification.exe" | Out-Null
	icacls "$env:WinDIR\System32\MusNotification.exe" /deny "$($EveryOne):(X)" | Out-Null
	takeown /F "$env:WinDIR\System32\MusNotificationUx.exe" | Out-Null
	icacls "$env:WinDIR\System32\MusNotificationUx.exe" /deny "$($EveryOne):(X)" | Out-Null
	
	$Maps = "HKLM:\SYSTEM\Maps"
	If (Test-Path $Maps) {
		Set-ItemProperty $Maps AutoUpdateEnabled -Value 0
	}

	#Disable thumbnails, show only file extension icons
	$FolderThumbs = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	If (Test-Path $) {
		Set-ItemProperty $FolderThumbs "IconsOnly" -Value 1
	}
	#WindowsUpdates
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontOfferThroughWUAU" -Type DWord -Value 1
	Reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t Reg_DWORD /d "1" /f | Out-Null
	#Disable offering of drivers through Windows Update
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1

	#Disable Windows Update automatic restart
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -force | Out-Null };
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement" -Type DWord -Value 0
Write-Host "Automatic Updates Disabled !" ; $ProcessSound.Play()

	#Disable automatic maintenance
	$maintenance = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"
	If (Test-Path $maintenance) {
		Set-ItemProperty $maintenance MaintenanceDisabled -Value 1
	}
	#DisableBingSearch&Cortana
	$Cortana = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
	If (Test-Path $Cortana) {
		Set-ItemProperty $Cortana AllowCortana -Value 0
		Set-ItemProperty $Cortana BingSearchEnabled -Value 0
		Set-ItemProperty $Cortana CortanaConsent -Value 0
		Set-ItemProperty $Cortana BackgroundAppGlobalToggle -Value 0
		Set-ItemProperty $Cortana AllowCloudSearch -Value 0
	}
Write-Host "BingSearch&Cortana Disabled" ; $ProcessSound.Play()
	#Turn Off Safe Search
	$SafeSearch = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings"
	If (Test-Path $SafeSearch) {
		Set-ItemProperty $SafeSearch SafeSearchMode -Value 0
	}

	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer") -ne $true) {  New-Item "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableSearchBoxSuggestions' -Value 1 -PropertyType DWord -Force | Out-Null

	#Disable-Sync
	$OneDrive = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
	If (Test-Path $OneDrive) {
		Set-ItemProperty $OneDrive DisableFileSyncNGSC -Value 1
	}

	$Sync = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync"
	If (Test-Path $Sync) {
		Set-ItemProperty $Sync SyncPolicy -Value 5
		Set-ItemProperty $Sync\Groups\Personalization Enabled -Value 0
		Set-ItemProperty $Sync\Groups\Credentials Enabled -Value 0
		Set-ItemProperty $Sync\Groups\Accessibility Enabled -Value 0
		Set-ItemProperty $Sync\Groups\Windows Enabled -Value 0
	}
	
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings' -Name 'Enabled' -Value 0 -PropertyType DWord -Force | Out-Null

	#Steam Tweaks
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Valve\Steam") -ne $true) {  New-Item "HKCU:\SOFTWARE\Valve\Steam" -force | Out-Null };
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'SmoothScrollWebViews' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'DWriteEnable' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'StartupMode' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'H264HWAccel' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'DPIScaling' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Valve\Steam' -Name 'GPUAccelWebViews' -Value 0 -PropertyType DWord -Force | Out-Null
	Remove-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'Steam' -ea SilentlyContinue -Force | Out-Null
	
	#DisableAutoSyncTime
	$Time = "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"
	If (Test-Path $Time) {
		Set-ItemProperty $Time Type -Value "NoSync"
	}
	
	#Disable Storage Sense
	$StorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	If (Test-Path $StorageSense) {
		Set-ItemProperty $StorageSense 01 -Value 0
	}
	
	#DisableWindowsAnimations
	$Animations = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
	If (Test-Path $Animations) {
		Set-ItemProperty $Animations VisualFXSetting -Value 2
	}
	
	$Animations2 = "HKCU:\Software\Microsoft\Windows\DWM"
	If (Test-Path $Animations2) {
		Set-ItemProperty $Animations2 EnableAeroPeek -Value 0
		Set-ItemProperty $Animations2 AlwaysHibernateThumbnails -Value 0
	}

	$Animations3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DWM"
	If (Test-Path $Animations3) {
		Set-ItemProperty $Animations3 DWMWA_TRANSITIONS_FORCEDISABLED -Value 1
		Set-ItemProperty $Animations3 DisallowAnimations -Value 1
	}

	if((Test-Path -LiteralPath "HKCU:\Control Panel\Desktop\WindowMetrics") -ne $true) {  New-Item "HKCU:\Control Panel\Desktop\WindowMetrics" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -PropertyType String -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MaxAnimate' -Value '0' -PropertyType String -Force | Out-Null
	
	Write-Host "All WindowsAnimations Has Been Disabled" ; $ProcessSound.Play()

	#TaskView
	$TaskView = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MultitaskingView\AllUpView"
	If (Test-Path $TaskView) {
		Set-ItemProperty $TaskView AllUpView -Value 0
		Set-ItemProperty $TaskView "Remove TaskView" -Value 1
	}
	#Personliaze
	$Personliaze = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
	If (Test-Path $Personliaze) {
		Set-ItemProperty $Personliaze EnableTransparency -Value 0
	}

	$Personalization = "HKLM:\SOFTWARE\Policies\Microsoft\Personalization"
	If (Test-Path $Personalization) {
		Set-ItemProperty $Personalization NoLockScreen -Value 1
	}

	#Change default Explorer view to This PC
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1

	#Hide recently and frequently used item shortcuts in Explorer
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 0

	#Show Desktop icon in This PC
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" | Out-Null
	}
Write-Host "Hide Music Icon From this PC" ; $ProcessSound.Play()
	#Hide Music icon from This PC
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -Recurse -ErrorAction SilentlyContinue
Write-Host "Hide Pictures Icon From this PC" ; $ProcessSound.Play()
	#Hide Pictures icon from This PC
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -Recurse -ErrorAction SilentlyContinue
Write-Host "Hide Videos Icon From this PC" ; $ProcessSound.Play()
	#Hide Videos icon from This PC
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -Recurse -ErrorAction SilentlyContinue
Write-Host "Hide 3D Objects Icon From this PC" ; $ProcessSound.Play()
	#Hide 3D Objects icon from This PC
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
	#FileSystem
	$FileSystem = "HKLM:\SYSTEM\ControlSet001\Control\FileSystem"
	If (Test-Path $FileSystem) {
		Set-ItemProperty $FileSystem LongPathsEnabled -Value 0
		Set-ItemProperty $FileSystem NtfsAllowExtendedCharacter8dot3Rename -Value 0
		Set-ItemProperty $FileSystem NtfsDisable8dot3NameCreation -Value 1
		Set-ItemProperty $FileSystem NtfsDisableCompression -Value 0
		Set-ItemProperty $FileSystem NtfsDisableEncryption -Value 1
		Set-ItemProperty $FileSystem NtfsDisableLastAccessUpdate -Value 1
		Set-ItemProperty $FileSystem NtfsEncryptPagingFile -Value 0
		Set-ItemProperty $FileSystem NtfsMemoryUsage -Value 0
		Set-ItemProperty $FileSystem RefsDisableLastAccessUpdate -Value 1
	}

	$System = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	If (Test-Path $System) {
		Set-ItemProperty $System EnableActivityFeed -Value 0
		Set-ItemProperty $System PublishUserActivities -Value 0
		Set-ItemProperty $System UploadUserActivities -Value 0
		Set-ItemProperty $System DisableAcrylicBackgroundOnLogon -Value 1
		Set-ItemProperty $System DisableHHDEP -Value 1
		Set-ItemProperty $System EnableCdp -Value 0
		Set-ItemProperty $System EnableMmx -Value 0
		Set-ItemProperty $System DisableLogonBackgroundImage -Value 0
		Set-ItemProperty $System Start -Value "Warn"
	}

	$System2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
	If (Test-Path $System2) {
		Set-ItemProperty $System2 PromptOnSecureDesktop -Value 0
		Set-ItemProperty $System2 EnableLUA -Value 0
		Set-ItemProperty $System2 ConsentPromptBehaviorAdmin -Value 0
		Set-ItemProperty $System2 DelayedDesktopSwitchTimeout -Value 0
		Set-ItemProperty $System2 DisableAutomaticRestartSignOn -Value 1
	}
	#FixKeyBoard Delay
	$KeyboardDelay = "HKCU:\Control Panel\Keyboard"
	If (Test-Path $KeyboardDelay) {
		Set-ItemProperty $KeyboardDelay InitialKeyboardIndicators -Value 0
		Set-ItemProperty $KeyboardDelay KeyboardDelay -Value 0
	}

	$KeyboardDelay2 = "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters"
	If (Test-Path $KeyboardDelay2) {
		Set-ItemProperty $KeyboardDelay2 KeyboardDataQueueSize -Value 32
	}

	#HideFeedsButton
	$ShellFeeds = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	If (Test-Path $ShellFeeds) {
		Set-ItemProperty $ShellFeeds ShellFeedsTaskbarViewMode -Value 2
	}

	#PriorityOptimizations
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*\" -Recurse -ErrorAction SilentlyContinue
	
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenu.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenu.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenuExperienceHost.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenuExperienceHost.exe\PerfOptions" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sppsvc.exe\PerfOptions' -Name 'PagePriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenu.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenu.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenu.exe\PerfOptions' -Name 'PagePriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions' -Name 'PagePriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenuExperienceHost.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenuExperienceHost.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StartMenuExperienceHost.exe\PerfOptions' -Name 'PagePriority' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force | Out-Null
	
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
	If (Test-Path $Explorer) {
		Set-ItemProperty $Explorer NoLowDiskSpaceChecks -Value 1
		Set-ItemProperty $Explorer LinkResolveIgnoreLinkInfo -Value 1
		Set-ItemProperty $Explorer NoResolveSearch -Value 1
		Set-ItemProperty $Explorer NoResolveTrack -Value 1
		Set-ItemProperty $Explorer NoInternetOpenWith -Value 1
		Set-ItemProperty $Explorer NoInstrumentation -Value 1
		Set-ItemProperty $Explorer DisableThumbnails -Value - -ErrorAction SilentlyContinue
	}

	$Explorer2 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	If (Test-Path $Explorer2) {
		Set-ItemProperty $Explorer2 NoInstrumentation -Value 1
		Set-ItemProperty $Explorer2 DisableThumbnails -Value - -ErrorAction SilentlyContinue
	}


	$Explorer3 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers"
	If (Test-Path $Explorer3) {
		Set-ItemProperty $Explorer3 DisableAutoplay -Value 1
	}

	#ExplorerPreferences
	$Explorer4 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
	If (Test-Path $Explorer4) {
		Set-ItemProperty $Explorer4 NetLinkTimeout -Value 3e8
		Set-ItemProperty $Explorer4 AltTabSettings -Value 0
		Set-ItemProperty $Explorer4 HoverSelectDesktops -Value 0
		Set-ItemProperty $Explorer4\Advanced ShowSyncProviderNotifications -Value 0
		Set-ItemProperty $Explorer4\Advanced EnableXamlStartMenu -Value 0
		Set-ItemProperty $Explorer4\Advanced TaskbarAnimations -Value 0
		Set-ItemProperty $Explorer4\Advanced ListviewShadow -Value 0
		Set-ItemProperty $Explorer4\Advanced ListviewAlphaSelect -Value 0
		Set-ItemProperty $Explorer4\Advanced Start_TrackDocs -Value 0
		Set-ItemProperty $Explorer4\Advanced EnableBalloonTips -Value 0
		Set-ItemProperty $Explorer4\Advanced DisallowShaking -Value 1
		Set-ItemProperty $Explorer4\Advanced ExtendedUIHoverTime -Value 1
		Set-ItemProperty $Explorer4\Advanced DontPrettyPath -Value 1
	}
	
	#Disable Folder Thumbnails
	$FolderThumbs = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell"
	If (Test-Path $FolderThumbs) {
		Set-ItemProperty $FolderThumbs Logo -Value "d:\\some2file23.jpg"
	}
	
	#PrivacySettings
	$Privacy = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	If (Test-Path $Privacy) {
		Set-ItemProperty $Privacy HasAccepted -Value 0
	}

	$Privacy2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore"
	If (Test-Path $Privacy2) {
		Set-ItemProperty $Privacy2\radios Value -Value "Deny"
		Set-ItemProperty $Privacy2\appDiagnostics Value -Value "Deny"
		Set-ItemProperty $Privacy2\documentsLibrary Value -Value "Deny"
		Set-ItemProperty $Privacy2\picturesLibrary Value -Value "Deny"
		Set-ItemProperty $Privacy2\videosLibrary Value -Value "Deny"
		Set-ItemProperty $Privacy2\broadFileSystemAccess Value -Value "Deny"
		Set-ItemProperty $Privacy2\chat Value -Value "Deny"
		Set-ItemProperty $Privacy2\contacts Value -Value "Deny"
		Set-ItemProperty $Privacy2\phoneCall Value -Value "Deny"
		Set-ItemProperty $Privacy2\appointments Value -Value "Deny"
		Set-ItemProperty $Privacy2\phoneCallHistory Value -Value "Deny"
		Set-ItemProperty $Privacy2\email Value -Value "Deny"
		Set-ItemProperty $Privacy2\userDataTasks Value -Value "Deny"
	}
	
	Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f | Out-Null
	Reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t Reg_DWORD /d "2" /f | Out-Null

	$Remote = "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance"
	If (Test-Path $Remote) {
		Set-ItemProperty $Remote fAllowToGetHelp -Value 0
	}

	$DiagTrack = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack"
	If (Test-Path $DiagTrack) {
		Set-ItemProperty $DiagTrack ShowedToastAtLevel -Value 1
	}

	$Privacy3 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
	If (Test-Path $Privacy3) {
		Set-ItemProperty $Privacy3 TailoredExperiencesWithDiagnosticDataEnabled -Value 0
	}

	$Privacy4 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey"
	If (Test-Path $Privacy4) {
		Set-ItemProperty $Privacy4 EnableEventTranscript -Value 0
	}

	#DisableTouchFeedBack
	$TouchFeedback = "HKCU:\Control Panel\Cursors"
	If (Test-Path $TouchFeedback) {
		Set-ItemProperty $TouchFeedback ContactVisualization -Value 0
	}

	#DisableContentIndex
	$Index = "HKLM:\SYSTEM\CurrentControlSet\Control\ContentIndex"
	If (Test-Path $Index) {
		Set-ItemProperty $Index StartupDelay -Value 9c40
	}

	#Disable Delivery Optimization
	$Delivery = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings"
	If (Test-Path $Delivery) {
		Set-ItemProperty $Delivery DownloadMode -Value 0
	}

	$Delivery2 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
	If (Test-Path $Delivery2) {
		Set-ItemProperty $Delivery2 ContentDeliveryAllowed -Value 0
		Set-ItemProperty $Delivery2 OemPreInstalledAppsEnabled -Value 0
		Set-ItemProperty $Delivery2 PreInstalledAppsEnabled -Value 0
		Set-ItemProperty $Delivery2 PreInstalledAppsEverEnabled -Value 0
		Set-ItemProperty $Delivery2 SilentInstalledAppsEnabled -Value 0
		Set-ItemProperty $Delivery2 SoftLandingEnabled -Value 0
		Set-ItemProperty $Delivery2 SubscribedContentEnabled -Value 0
		Set-ItemProperty $Delivery2 FeatureManagementEnabled -Value 0
		Set-ItemProperty $Delivery2 SystemPaneSuggestionsEnabled -Value 0
		Set-ItemProperty $Delivery2 RemediationRequired -Value 0
		Set-ItemProperty $Delivery2 SubscribedContent-338393Enabled -Value 0
		Set-ItemProperty $Delivery2 SubscribedContent-353694Enabled -Value 0
		Set-ItemProperty $Delivery2 SubscribedContent-353696Enabled -Value 0
		Set-ItemProperty $Delivery2 SubscribedContent-338387Enabled -Value 0
		Set-ItemProperty $Delivery2 SubscribedContent-338389Enabled -Value 0
		Set-ItemProperty $Delivery2 SubscribedContent-310093Enabled -Value 0
		Set-ItemProperty $Delivery2 SubscribedContent-338388Enabled -Value 0
		Set-ItemProperty $Delivery2 SubscribedContent-314563Enabled -Value 0
		Set-ItemProperty $Delivery2 RotatingLockScreenOverlayEnabled -Value 0
		Set-ItemProperty $Delivery2 RotatingLockScreenEnabled -Value 0
	}

	#DisableWindowsErrorReporting
	$ErrorRepoerting = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	If (Test-Path $ErrorRepoerting) {
		Set-ItemProperty $ErrorRepoerting Disabled -Value 1
	}
	$ErrorRepoerting2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports"
	If (Test-Path $ErrorRepoerting2) {
	Set-ItemProperty $ErrorRepoerting2 PreventHandwritingErrorReports -Value 1
	}
	
	reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t "REG_DWORD" /d "1" /f | Out-Null
	reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WerSvc" /v "Start" /t REG_DWORD /d "4" /f | Out-Null
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wercplsupport" /v "Start" /t REG_DWORD /d "4" /f | Out-Null
	schtasks /Change /TN "Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate" /Disable | Out-Null
	schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable | Out-Null

	#Ease OF Access TWEAKS
	$EaseOFAccess = "HKCU:\Control Panel\Accessibility"
	If (Test-Path $EaseOFAccess) {
		Set-ItemProperty $EaseOFAccess\MouseKeys Flags -Value 0
		Set-ItemProperty $EaseOFAccess\StickyKeys Flags -Value 0
		Set-ItemProperty $EaseOFAccess\ToggleKeys Flags -Value 0
	}

	$EaseOFAccess2 = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AccessibilityTemp"
	If (Test-Path $EaseOFAccess2) {
		Set-ItemProperty $EaseOFAccess2 narrator -Value 0
	}

	$EaseOFAccess3 = "HKCU:\Control Panel\Accessibility\Keyboard Response"
	If (Test-Path $EaseOFAccess3) {
		Set-ItemProperty $EaseOFAccess3 Flags -Value 0
	}

	$Preemptions3 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowSharedUserAppData"
	If (Test-Path $Preemptions3) {
		Set-ItemProperty $Preemptions3 value -Value 0
	}
	$Preemptions4 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace"
	If (Test-Path $Preemptions4) {
		Set-ItemProperty $Preemptions4 PenWorkspaceAppSuggestionsEnabled -Value 0
	}
	$Preemptions5 = "HKCU:\SOFTWARE\Microsoft\Input\Settings"
	If (Test-Path $Preemptions5) {
		Set-ItemProperty $Preemptions5 InsightsEnabled -Value 0
	}

	#Disable GetImage Descriptions, Page Titles And Popular Links
	$Image = "HKCU:\SOFTWARE\Microsoft\Narrator\NoRoam"
	If (Test-Path $Image) {
		Set-ItemProperty $Image OnlineServicesEnabled -Value 0
	}

	#Disable Device History
	$History2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
	If (Test-Path $History2) {
		Set-ItemProperty $History2 DeviceHistoryEnabled -Value 0
	}

	#SPEED-UP SHUTDOWN TIME
	$ShutDown = "HKLM:\SYSTEM"
	If (Test-Path $ShutDown) {
		Set-ItemProperty $ShutDown\CurrentControlSet\Control WaitToKillServiceTimeout -Value 1000
		Set-ItemProperty $ShutDown\ControlSet001\Control WaitToKillServiceTimeout -Value 1000
	}
	
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet002\Control") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet002\Control" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet002\Control' -Name 'WaitToKillServiceTimeout' -Value '1000' -PropertyType String -Force | Out-Null

	$ShutDown2 = "HKU:\S-1-5-19\Control Panel\Desktop"
	If (Test-Path $ShutDown2) {
		Set-ItemProperty $ShutDown2 WaitToKillAppTimeout -Value 2000
	}

	$ShutDown3 = "HKU:\S-1-5-20\Control Panel\Desktop"
	If (Test-Path $ShutDown3) {
		Set-ItemProperty $ShutDown3 WaitToKillAppTimeout -Value 2000
	}

	#Disable System Sounds
	$Sounds = "HKCU:\Control Panel\Sound"
	If (Test-Path $Sounds) {
		Set-ItemProperty $Sounds Beep -Value "no"
		Set-ItemProperty $Sounds ExtendedSounds -Value "no"
	}

	$Sounds2 = "HKCU:\Control Panel\Accessibility"
	If (Test-Path $Sounds2) {
		Set-ItemProperty $Sounds2 "Sound on Activation" -Value 0
		Set-ItemProperty $Sounds2 "Warning Sounds" -Value 0
	}
	#DisableTelemetry
	$Telemetry = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	If (Test-Path $Telemetry) {
		Set-ItemProperty $Telemetry AllowTelemetry -Value 0
		Set-ItemProperty $Telemetry AllowDeviceNameInTelemetry -Value 0
	}
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	If (Test-Path $Telemetry2) {
		Set-ItemProperty $Telemetry2 AllowTelemetry -Value 0
	}
	$Telemetry3 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
	If (Test-Path $Telemetry3) {
		Set-ItemProperty $Telemetry3 Enabled -Value 0
		Set-ItemProperty $Telemetry3 DisabledByGroupPolicy -Value 1
	}
	$Telemetry4 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	If (Test-Path $Telemetry4) {
		Set-ItemProperty $Telemetry4 AllowTelemetry -Value 1
		Set-ItemProperty $Telemetry4 MaxTelemetryAllowed -Value 1
	}
	$Telemetry5 = "HKCU:\Control Panel\International\User Profile"
	If (Test-Path $Telemetry5) {
		Set-ItemProperty $Telemetry5 HttpAcceptLanguageOptOut  -Value 1
	}
	$Telemetry6 = "HKLM:\Software\Policies\Microsoft\Windows\EnhancedStorageDevices"
	If (Test-Path $Telemetry6) {
		Set-ItemProperty $Telemetry6 TCGSecurityActivationDisabled -Value 0
	}
	
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -Value 0 -PropertyType DWord -Force | Out-Null
Write-Host "Telemetry Disabled" ; $ProcessSound.Play()
Start-Sleep 2
Write-Host "Decrease BootTime" ; $ProcessSound.Play()
	#Decrease BootTime
	$Boot = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
	If (Test-Path $Boot) {
	New-ItemProperty $Boot StartupDelayInMSec -Value 0 -Force | Out-Null
	}

	#Disable Hibernation
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Power" -Name "HibernteEnabled" -Type Dword -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowHibernateOption" -Type Dword -Value 0

	$Boot2 = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
	If (Test-Path $Boot2) {
		Set-ItemProperty $Boot2 HiberbootEnabled -Value 0
	}
	#For Valorant (:
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Riot Vanguard" -ErrorAction SilentlyContinue

	#HideSomeSettings in SettingsApp
	$HideSettings = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	If (Test-Path $HideSettings) {
		Set-ItemProperty $HideSettings SettingsPageVisibility -Value "hide:quiethours;project;crossdevice;clipboard;remotedesktop;pen;autoplay;;mobile-devices;network-status;datausage;maps;;search-permissions;cortana-windowssearch;search-moredetails;privacy-activityhistory;findmydevice;windowsinsider;;holographic-audio;privacy-holographic-environment;holographic-headset;holographic-management;"
	}

	#HideSomeSettings in ControlPanel
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'DisallowCPL' -Value 1 -Force | Out-Null
	
	$HideControlPanel = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCPL"
	If (Test-Path $HideControlPanel) {
		Set-ItemProperty $HideControlPanel "Work Folders" -Value "Work Folders"
		Set-ItemProperty $HideControlPanel "Phone And Modem" -Value "Phone And Modem"
		Set-ItemProperty $HideControlPanel "File History" -Value "File History"
		Set-ItemProperty $HideControlPanel "Indexing Options" -Value "Indexing Options"
		Set-ItemProperty $HideControlPanel "AutoPlay" -Value "AutoPlay"
	}
	
	Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To" -Recurse -ErrorAction SilentlyContinue

Write-Host "Memory Optimizations" ; $ProcessSound.Play()
#MemoryOptimizations
	$Memory2 = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
	If (Test-Path $Memory2) {
		Set-ItemProperty $Memory2 ClearPageFileAtShutdown -Value 0
		Set-ItemProperty $Memory2 FeatureSettings -Value 1
		Set-ItemProperty $Memory2 FeatureSettingsOverrideMask -Value 3
		Set-ItemProperty $Memory2 FeatureSettingsOverride -Value 0
		Set-ItemProperty $Memory2 LargeSystemCache -Value 0
		Set-ItemProperty $Memory2 NonPagedPoolQuota -Value 0
		Set-ItemProperty $Memory2 NonPagedPoolSize -Value 0
		Set-ItemProperty $Memory2 SessionPoolSize -Value c0
		Set-ItemProperty $Memory2 SessionViewSize -Value c0
		Set-ItemProperty $Memory2 SystemPages -Value ffffffff
		Set-ItemProperty $Memory2 SecondLevelDataCache -Value c00
		Set-ItemProperty $Memory2 SessionPoolSize -Value c0
		Set-ItemProperty $Memory2 DisablePagingExecutive -Value 1
		Set-ItemProperty $Memory2 PagedPoolSize -Value c0
		Set-ItemProperty $Memory2 PagedPoolQuota -Value 0
		Set-ItemProperty $Memory2 PhysicalAddressExtension -Value 1
		Set-ItemProperty $Memory2 IoPageLockLimit -Value 00fefc00
		Set-ItemProperty $Memory2 PoolUsageMaximum -Value 60
		Set-ItemProperty $Memory2 EnableCfg -Value 0
		Set-ItemProperty $Memory2 MoveImages -Value 0
		Set-ItemProperty $Memory2 SystemCacheLimit -Value 400
		Set-ItemProperty $Memory2 MapAllocationFragment -Value 20000
		Set-ItemProperty $Memory2 PhysicalAddressExtension -Value 1
		Set-ItemProperty $Memory2 DisablePagingCombining -Value 1
	}

	$Memory3 = "HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters"
	If (Test-Path $Memory3) {
		Set-ItemProperty $Memory3 EnableSuperfetch -Value 0
		Set-ItemProperty $Memory3 EnablePrefetcher -Value 0
		Set-ItemProperty $Memory3 SfTracingState -Value 1
		Set-ItemProperty $Memory3 BaseTime -Value 22a20bb3 #In TEST
		Set-ItemProperty $Memory3 BootId -Value 29 #In TEST
	}

	$Memory4 = "HKU:\S-1-5-19\Control Panel\Desktop"
	If (Test-Path Memory4) {
		Set-ItemProperty $Memory4 MenuShowDelay -Value 0
		Set-ItemProperty $Memory4 HungAppTimeout -Value 1000
		Set-ItemProperty $Memory4 AutoEndTasks -Value 1
	}

	$Memory5 = "HKU:\S-1-5-20\Control Panel\Desktop"
	If (Test-Path $Memory5) {
		Set-ItemProperty $Memory5 MenuShowDelay -Value 0
		Set-ItemProperty $Memory5 HungAppTimeout -Value 1000
		Set-ItemProperty $Memory5 AutoEndTasks -Value 1
	}

#Raise the limit of paged pool memory
	fsutil behavior set memoryusage 2 | Out-Null
	fsutil behavior set mftzone 2 | Out-Null
	
	Disable-MMAgent -MemoryCompression

#PingTweaks
Write-Host "PingTweaks...." ; $ProcessSound.Play()
	netsh winsock reset | Out-Null
	netsh winsock reset catalog | Out-Null
	netsh int ip reset C:\resetlog.txt | Out-Null
	netsh int ip reset C:\tcplog.txt | Out-Null
	netsh int tcp set global initialRto=2000 netdma=disabled rss=enabled MaxSynRetransmissions=2 | Out-Null
	netsh int tcp set global autotuninglevel=normal | Out-Null
	netsh interface 6to4 set state disabled | Out-Null
	netsh int isatap set state disable | Out-Null
	netsh int tcp set global timestamps=disabled | Out-Null
	netsh int tcp set heuristics disabled | Out-Null
	netsh int tcp set global chimney=disabled | Out-Null
	netsh int tcp set global ecncapability=disabled | Out-Null
	netsh int tcp set global rsc=disabled | Out-Null
	netsh int tcp set global nonsackrttresiliency=disabled | Out-Null
	netsh int tcp set security mpp=disabled | Out-Null
	netsh int tcp set security profiles=disabled | Out-Null
	netsh int ip set global icmpredirects=disabled | Out-Null
	netsh int tcp set security mpp=disabled profiles=disabled | Out-Null
	netsh int ip set global multicastforwarding=disabled | Out-Null
	netsh int tcp set supplemental internet congestionprovider=ctcp | Out-Null
	netsh interface teredo set state disabled | Out-Null
	netsh int isatap set state disable | Out-Null
	netsh int ip set global taskoffload=disabled | Out-Null
	netsh int ip set global neighborcachelimit=4096 | Out-Null
	netsh int tcp set global dca=enabled | Out-Null
	PowerShell Disable-NetAdapterLso -Name "*" | Out-Null
	powershell "ForEach($adapter In Get-NetAdapter){Disable-NetAdapterPowerManagement -Name $adapter.Name -ErrorAction SilentlyContinue}" | Out-Null
	powershell "ForEach($adapter In Get-NetAdapter){Disable-NetAdapterLso -Name $adapter.Name -ErrorAction SilentlyContinue}" | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t REG_DWORD /d "10" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f | Out-Null
	Reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f | Out-Null
	
	$Latency = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
	If (Test-Path $Latency) {
		Set-ItemProperty $Latency NetworkThrottlingIndex -Value ffffffff
		Set-ItemProperty $Latency SystemResponsiveness -Value 0
	}

	$Latency2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	If (Test-Path $Latency2) {
		Set-ItemProperty $Latency2 MaxConnectionsPerServer -Value 10
		Set-ItemProperty $Latency2 MaxConnectionsPer1_0Server -Value 10
		Set-ItemProperty $Latency2 SmoothScroll -Value 1
	}

	$Latency3 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	If (Test-Path $Latency3) {
		Set-ItemProperty $Latency3 MaxConnectionsPerServer -Value 10
		Set-ItemProperty $Latency3 MaxConnectionsPer1_0Server -Value 10
		Set-ItemProperty $Latency3 SmoothScroll -Value 1
	}

	$Latency4 = "HKCU:\Software\Microsoft\Windows\CurrentVersion"
	If (Test-Path $Latency4) {
		Set-ItemProperty $Latency4 MaxConnectionsPerServer -Value 10
		Set-ItemProperty $Latency4 MaxConnectionsPer1_0Server -Value 10
		Set-ItemProperty $Latency4 SmoothScroll -Value 1
	}

	$Latency5 = "HKLM::\Software\Microsoft\Windows\CurrentVersion"
	If (Test-Path $Latency5) {
		Set-ItemProperty $Latency5 MaxConnectionsPerServer -Value 10
		Set-ItemProperty $Latency5 MaxConnectionsPer1_0Server -Value 10
		Set-ItemProperty $Latency5 SmoothScroll -Value 1
	}

	$Latency6 = "HKLM::\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider"
	If (Test-Path $Latency6) {
		Set-ItemProperty $Latency6 Class -Value 8
		Set-ItemProperty $Latency6 LocalPriority -Value 4
		Set-ItemProperty $Latency6 HostsPriority -Value 5
		Set-ItemProperty $Latency6 DnsPriority -Value 6
		Set-ItemProperty $Latency6 NetbtPriority - Value 7
	}
	$Latency7 = "HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters"
	If (Test-Path $Latency7) {
		Set-ItemProperty $Latency7 DoNotHoldNicBuffers -Value 1
		Set-ItemProperty $Latency7 DefaultReceiveWindow -Value 4000
		Set-ItemProperty $Latency7 DefaultSendWindow -Value 4000
		Set-ItemProperty $Latency7 FastCopyReceiveThreshold -Value 4000
		Set-ItemProperty $Latency7 FastSendDatagramThreshold -Value 4000
		Set-ItemProperty $Latency7 DynamicSendBufferDisable -Value 0
		Set-ItemProperty $Latency7 IgnorePushBitOnReceives -Value 1
		Set-ItemProperty $Latency7 NonBlockingSendSpecialBuffering -Value 1
		Set-ItemProperty $Latency7 DisableRawSecurity -Value 1
		Set-ItemProperty $Latency7 FastSendDatagramThreshold -Value 4000
		Set-ItemProperty $Latency7 EnableDynamicBacklog -Value 1
		Set-ItemProperty $Latency7 MinimumDynamicBacklog -Value 200
		Set-ItemProperty $Latency7 MaximumDynamicBacklog -Value 20000
		Set-ItemProperty $Latency7 DynamicBacklogGrowthDelta -Value 100
	}

	$Latency8 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DnsClient"
	If (Test-Path $Latency8) {
		Set-ItemProperty $Latency8 EnableMulticast -Value 0
	}

	$Latency9 = "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$DriverKey" #WTF It's adding it to \Tcpip\Parameters Not making new key with $DriverKey
	If (Test-Path $Latency9) {
		New-ItemProperty $Latency9 TcpACKFrequency -Value 1 | Out-Null
		New-ItemProperty $Latency9 TcpDelAckTicks -Value 0 | Out-Null
		New-ItemProperty $Latency9 TCPNoDelay -Value 1 | Out-Null
		New-ItemProperty $Latency9 InterfaceMetric -Value 0 | Out-Null
		New-ItemProperty $Latency9 PerformRouterDiscovery -Value 0 | Out-Null
	}
	
	$Latency10 = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
	If (Test-Path $Latency10) {
		Set-ItemProperty $Latency10 TcpAckFrequency -Value 1
		Set-ItemProperty $Latency10 TcpDelAckTicks -Value 0
		Set-ItemProperty $Latency10 NumTcbTablePartitions -Value F
		Set-ItemProperty $Latency10 TCPNoDelay -Value 1
		Set-ItemProperty $Latency10 TcpWindowSize -Value ffff
		Set-ItemProperty $Latency10 SackOpts -Value 0
		Set-ItemProperty $Latency10 TcpMaxDataRetransmissions -Value 2
		Set-ItemProperty $Latency10 Tcp1323Opts -Value 1
		Set-ItemProperty $Latency10 TCPTimedWaitDelay -Value 30
		Set-ItemProperty $Latency10 IRPStackSize -Value 12
		Set-ItemProperty $Latency10 DefaultTTL -Value FF
		Set-ItemProperty $Latency10 KeepAliveTime -Value ea60
		Set-ItemProperty $Latency10 KeepAliveInterval -Value 3e8
		Set-ItemProperty $Latency10 TCPInitialRtt -Value 12c
		Set-ItemProperty $Latency10 TcpMaxDupAcks -Value 1
		Set-ItemProperty $Latency10 TcpRecSegmentSize -Value 255552
		Set-ItemProperty $Latency10 EnablePMTUBHDetect -Value 1
		Set-ItemProperty $Latency10 EnablePMTUDiscovery -Value 0
		Set-ItemProperty $Latency10 GlobalMaxTcpWindowSize -Value ffff
		Set-ItemProperty $Latency10 MaxHashTableSize -Value 10000
		Set-ItemProperty $Latency10 DisableTaskOffload -Value 0
		Set-ItemProperty $Latency10 WorldMaxTcpWindowsSize -Value FFFFFFFF
		Set-ItemProperty $Latency10 TCPAllowedPorts -Value 1
		Set-ItemProperty $Latency10 NTEContextList -Value 3
		Set-ItemProperty $Latency10 DisableLargeMTU -Value 0
		Set-ItemProperty $Latency10 IGMPVersion -Value 2
		Set-ItemProperty $Latency10 IGMPLevel -Value 2
		Set-ItemProperty $Latency10 MaxConnectionsPer1_0Server -Value 10
		Set-ItemProperty $Latency10 MaxConnectionsPerServer -Value 10
		Set-ItemProperty $Latency10 MaxFreeTcbs -Value ffff
		Set-ItemProperty $Latency10 ArpTRSingleRoute -Value 1
		Set-ItemProperty $Latency10 SynAttackProtect -Value 1
		Set-ItemProperty $Latency10 MaxForwardBufferMemory -Value 0x23f00
		Set-ItemProperty $Latency10 ForwardBufferMemory -Value 0x23f00
		Set-ItemProperty $Latency10 NumForwardPackets -Value 0x23f
		Set-ItemProperty $Latency10 MaxNumForwardPackets -Value 0x23f
		Set-ItemProperty $Latency10 MaxUserPort -Value 65534
		Set-ItemProperty $Latency10 TcpMaxSendFree -Value FFFF
		Set-ItemProperty $Latency10 DeadGWDetectDefault -Value 1
		Set-ItemProperty $Latency10 DontAddDefaultGatewayDefault -Value 0
		Set-ItemProperty $Latency10 MaxMpxCt -Value 7d
		Set-ItemProperty $Latency10 EnableICMPRedirect -Value 1
		Set-ItemProperty $Latency10 CacheHashTableBucketSize -Value 1000
		Set-ItemProperty $Latency10 EnableWsd -Value 0
		Set-ItemProperty $Latency10 EnableDynamicBacklog -Value 1
		Set-ItemProperty $Latency10 EnableDHCP -Value 1
		Set-ItemProperty $Latency10 EnableWsd -Value 0
		Set-ItemProperty $Latency10 AllowUnqualifiedQuery -Value 1
		Set-ItemProperty $Latency10 DisableMediaSenseEventLog -Value 1
		Set-ItemProperty $Latency10 DisableRss -Value 0
		Set-ItemProperty $Latency10 DnsQueryTimeouts -Value "1 1 2 2 4 0"
		Set-ItemProperty $Latency10 DisableTcpChimneyOffload -Value 0
		Set-ItemProperty $Latency10 DnsOutstandingQueriesCount -Value 3e8
		Set-ItemProperty $Latency10 EnableAddrMaskReply -Value 0
		Set-ItemProperty $Latency10 EnableBcastArpReply -Value 0
		Set-ItemProperty $Latency10 EnableConnectionRateLimiting -Value 0
		Set-ItemProperty $Latency10 EnableDca -Value 0
		Set-ItemProperty $Latency10 EnableHeuristics -Value 1
		Set-ItemProperty $Latency10 EnableIPAutoConfigurationLimits -Value ff
		Set-ItemProperty $Latency10 EnableTCPA -Value 0
		Set-ItemProperty $Latency10 IPEnableRouter -Value 0
		Set-ItemProperty $Latency10 QualifyingDestinationThreshold -Value ffffffff
		Set-ItemProperty $Latency10 StrictTimeWaitSeqCheck -Value 1
		Set-ItemProperty $Latency10 EnableDca -Value 0
	}

	$Latency11 = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
	If (Test-Path $Latency11) {
		Set-ItemProperty $Latency11 TcpMaxDataRetransmissions -Value 3
		Set-ItemProperty $Latency11 SackOpts -Value 0
		Set-ItemProperty $Latency11 TcpWindowSize -Value ffff
		Set-ItemProperty $Latency11 MaxFreeTcbs -Value 65536
		Set-ItemProperty $Latency11 TcpMaxDupAcks -Value 1
		Set-ItemProperty $Latency11 MSS -Value 5b4
		Set-ItemProperty $Latency11 MaxUserPort -Value 65534
		Set-ItemProperty $Latency11 TCPMaxHalfOpenRetried -Value 0
		Set-ItemProperty $Latency11 TCPMaxHalfOpen -Value 1
		Set-ItemProperty $Latency11 TCPMaxPortsExhausted -Value 5
		Set-ItemProperty $Latency11 TcpCreateAndConnectTcbRateLimitDepth -Value 0
		Set-ItemProperty $Latency11 TcpAckFrequency -Value 1
		Set-ItemProperty $Latency11 TcpDelAckTicks -Value 0
		Set-ItemProperty $Latency11 NumTcbTablePartitions -Value F
		Set-ItemProperty $Latency11 TCPNoDelay -Value 1
		Set-ItemProperty $Latency11 Tcp1323Opts -Value 0
		Set-ItemProperty $Latency11 TCPTimedWaitDelay -Value 30
		Set-ItemProperty $Latency11 IRPStackSize -Value 12
		Set-ItemProperty $Latency11 DefaultTTL -Value 64
		Set-ItemProperty $Latency11 KeepAliveTime -Value ea60
		Set-ItemProperty $Latency11 DnsQueryTimeouts -Value "1 1 2 2 4 0"
		Set-ItemProperty $Latency11 KeepAliveInterval -Value 3e8
		Set-ItemProperty $Latency11 TCPInitialRtt -Value 12c
		Set-ItemProperty $Latency11 TcpRecSegmentSize -Value 255552
		Set-ItemProperty $Latency11 EnablePMTUBHDetect -Value 1
		Set-ItemProperty $Latency11 EnablePMTUDiscovery -Value 0
		Set-ItemProperty $Latency11 GlobalMaxTcpWindowSize -Value ffff
		Set-ItemProperty $Latency11 MaxHashTableSize -Value 10000
		Set-ItemProperty $Latency11 DisableTaskOffload -Value 1
		Set-ItemProperty $Latency11 WorldMaxTcpWindowsSize -Value FFFFFFFF
		Set-ItemProperty $Latency11 TCPAllowedPorts -Value 1
		Set-ItemProperty $Latency11 NTEContextList -Value 3
		Set-ItemProperty $Latency11 DisableLargeMTU -Value 0
		Set-ItemProperty $Latency11 IGMPVersion -Value 2
		Set-ItemProperty $Latency11 IGMPLevel -Value 2
		Set-ItemProperty $Latency11 MaxConnectionsPer1_0Server -Value 10
		Set-ItemProperty $Latency11 MaxConnectionsPerServer -Value 10
		Set-ItemProperty $Latency11 MaxFreeTcbs -Value 65536
		Set-ItemProperty $Latency11 ArpTRSingleRoute -Value 1
		Set-ItemProperty $Latency11 SynAttackProtect -Value 1
		Set-ItemProperty $Latency11 MaxForwardBufferMemory -Value 0x23f00
		Set-ItemProperty $Latency11 ForwardBufferMemory -Value 0x23f00
		Set-ItemProperty $Latency11 NumForwardPackets -Value 0x23f
		Set-ItemProperty $Latency11 MaxNumForwardPackets -Value 0x23f
		Set-ItemProperty $Latency11 TcpMaxSendFree -Value FFFF
		Set-ItemProperty $Latency11 DeadGWDetectDefault -Value 1
		Set-ItemProperty $Latency11 DontAddDefaultGatewayDefault -Value 0
		Set-ItemProperty $Latency11 MaxMpxCt -Value 7d
		Set-ItemProperty $Latency11 EnableICMPRedirect -Value 1
		Set-ItemProperty $Latency11 CacheHashTableBucketSize -Value 1000
		Set-ItemProperty $Latency11 EnableWsd -Value 0
		Set-ItemProperty $Latency11 EnableDynamicBacklog -Value 1
		Set-ItemProperty $Latency11 EnableDHCP -Value 1
		Set-ItemProperty $Latency11 EnableWsd -Value 0
		Set-ItemProperty $Latency11 AllowUnqualifiedQuery -Value 1
		Set-ItemProperty $Latency11 DisableMediaSenseEventLog -Value 1
		Set-ItemProperty $Latency11 DisableRss -Value 0
		Set-ItemProperty $Latency11 DisableTcpChimneyOffload -Value 0
		Set-ItemProperty $Latency11 DnsOutstandingQueriesCount -Value 3e8
		Set-ItemProperty $Latency11 EnableAddrMaskReply -Value 0
		Set-ItemProperty $Latency11 EnableBcastArpReply -Value 0
		Set-ItemProperty $Latency11 EnableConnectionRateLimiting -Value 0
		Set-ItemProperty $Latency11 EnableDca -Value 0
		Set-ItemProperty $Latency11 EnableHeuristics -Value 1
		Set-ItemProperty $Latency11 EnableIPAutoConfigurationLimits -Value ff
		Set-ItemProperty $Latency11 EnableTCPA -Value 0
		Set-ItemProperty $Latency11 IPEnableRouter -Value 0
		Set-ItemProperty $Latency11 QualifyingDestinationThreshold -Value ffffffff
		Set-ItemProperty $Latency11 StrictTimeWaitSeqCheck -Value 1
		Set-ItemProperty $Latency11 EnableDca -Value 0
		Set-ItemProperty $Latency11 DelayedAckFrequency -Value 1
		Set-ItemProperty $Latency11 DelayedAckTicks -Value 1
		Set-ItemProperty $Latency11 CongestionAlgorithm -Value 1
		Set-ItemProperty $Latency11 MultihopSets -Value f
		Set-ItemProperty $Latency11 FastCopyReceiveThreshold -Value 4000
		Set-ItemProperty $Latency11 FastSendDatagramThreshold -Value 4000
	}

	$Latency12 = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
	If (Test-Path $Latency12) {
		Set-ItemProperty $Latency12 DisabledComponents -Value 20
	}

	$Latency13 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"
	If (Test-Path $Latency13) {
		Set-ItemProperty $Latency13 NonBestEffortLimit -Value 0
		Set-ItemProperty $Latency13 TimerResolution -Value 1
	}

	$Latency14 = "HKLM:\SYSTEM\CurrentControlSet\Services\Psched"
	If (Test-Path $Latency14) {
		Set-ItemProperty $Latency14 NonBestEffortLimit -Value 0
	}
$RegItems = @(
    "*EEE"
    "*WakeOnMagicPacket"
    "*WakeOnPattern"
    "AdvancedEEE"
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
		Set-ItemProperty -Path $Latency15 -Name $RegItem -Value 0
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "ITR") {
		Set-ItemProperty -Path $Latency15 -Name "ITR" -Value 125
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "*FlowControl") {
		Set-ItemProperty -Path $Latency15 -Name "*FlowControl" -Value 1514
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "*RSS") {
		Set-ItemProperty -Path $Latency15 -Name "*RSS" -Value 1
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "*ReceiveBuffers") {
		Set-ItemProperty -Path $Latency15 -Name "*ReceiveBuffers" -Value 256
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "*TransmitBuffers") {
		Set-ItemProperty -Path $Latency15 -Name "*TransmitBuffers" -Value 256
	}
	IF (Get-ItemProperty -ErrorAction SilentlyContinue -Path $Latency15 -Name "WolShutdownLinkSpeed") {
		Set-ItemProperty -Path $Latency15 -Name "WolShutdownLinkSpeed" -Value 2
	}
}

if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" -force | Out-Null };
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" -force | Out-Null };
Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS' -Name 'Do not use NLA' -Value 1 -Force | Out-Null
Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock' -Name 'UseDelayedAcceptance' -Value 0 -Force | Out-Null
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters" -force | Out-Null };
Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'TrackNblOwner' -Value 0 -Force | Out-Null
Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'DisableNDISWatchDog' -Value 1 -Force | Out-Null

Write-Host "MoreGamingTweaks..." ; $ProcessSound.Play()
#MoreGamingTweaks
	$More = "HKLM:\SYSTEM\ControlSet001\Control\PriorityControl"
	If (Test-Path $More) {
		Set-ItemProperty $More Win32PrioritySeparation -Value 28
		Set-ItemProperty $More IRQ8Priority -Value 1
		Set-ItemProperty $More IRQ4294967286Priority 2
		Set-ItemProperty $More IRQ4294967287Priority -Value 3
		Set-ItemProperty $More ConvertibleSlateMode -Value 0
		Set-ItemProperty $More IRQ16Priority -Value 2
	}

	$More2 = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
	If (Test-Path $More2) {
		Set-ItemProperty $More2 ConvertibleSlateMode -Value 0
		Set-ItemProperty $More2 IRQ8Priority -Value 1
		Set-ItemProperty $More2 IRQ16Priority -Value 2
		Set-ItemProperty $More2 Win32PrioritySeparation -Value 28
	}
	
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Value 0 -PropertyType DWord -Force | Out-Null

	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Google\Chrome") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Google\Chrome" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Google\Chrome' -Name 'HardwareAccelerationModeEnabled' -Value 0 -PropertyType DWord -Force | Out-Null

	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -Name 'ActiveTimeBias' -Value 360 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -Name 'Bias' -Value 360 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -Name 'DaylightBias' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -Name 'DaylightStart' -Value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -Name 'DynamicDaylightTimeDisabled' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -Name 'StandardStart' -Value ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -Force | Out-Null

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

#Remove AutoLogger file and restrict directory
	$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
		If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
			Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
		}
	icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null
	
	
#OLD PhotoViewer
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.tif' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.tiff' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.bmp' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.dib' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.gif' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jfif' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jpe' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jpeg' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jpg' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.jxr' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name '.png' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -Force | Out-Null

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Write-Host "Installing SodaTools" ; $ProcessSound.Play()
#Configure Soda Software
Move-Item -Path "$Temporary\EmptyStandbyList.exe", "$Temporary\TEMP22.vbs", "$Temporary\MEM22.vbs", "$Temporary\SodaMEM.bat", "$Temporary\TempCleaner.bat" -Destination "$env:SystemRoot\System32"
Copy-Item -Path "$Temporary\SodaTools.exe" -Destination "$StartUP"

Start-Process -FilePath "$StartUP\SodaTools.exe" -Verb RunAs 
Write-Host "SodaTools Has Been Installed" ; $ProcessSound.Play()
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

#Disable Lock screen
	$service = New-Object -com Schedule.Service
	$service.Connect()
	$task = $service.NewTask(0)
	$task.Settings.DisallowStartIfOnBatteries = $false
	$trigger = $task.Triggers.Create(9)
	$trigger = $task.Triggers.Create(11)
	$trigger.StateChange = 8
	$action = $task.Actions.Create(0)
	$action.Path = "reg.exe"
	$action.Arguments = "add HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData /t REG_DWORD /v AllowLockScreen /d 0 /f"
	$service.GetFolder("\").RegisterTaskDefinition("Disable LockScreen", $task, 6, "NT AUTHORITY\SYSTEM", $null, 4) | Out-Null
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#

Function Desktop2 {
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/928735442529034290/Toms-Power-Plan.pow", "$env:Temp\SodaScript\Toms-Power-Plan.pow")
(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/924882978008629278/SetTimerResolutionService.exe", "$env:Temp\SodaScript\SetTimerResolutionService.exe")
	$PowerPlan = "Toms-Power-Plan.pow"
	If (Test-Path $Temporary\$PowerPlan) {
		powercfg -import $Temporary\$PowerPlan 77777777-7777-7777-7777-777777777777 | Out-Null
		powercfg -SETACTIVE "77777777-7777-7777-7777-777777777777" | Out-Null
	}
#DiasblePowerThrottling
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -force | Out-Null };
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' -Name 'PowerThrottlingOff' -Value 1 -PropertyType DWord -Force  | Out-Null

	$Power2 = "HKLM:\SYSTEM\CurrentControlSet\Control\Power"
	If (Test-Path $Power2) {
		Set-ItemProperty $Power2 HibernateEnabled -Value 0
		Set-ItemProperty $Power2 EnergyEstimationEnabled -Value 0
		Set-ItemProperty $Power2\EnergyEstimation\TaggedEnergy DisableTaggedEnergyLogging -Value 1
		Set-ItemProperty $Power2\EnergyEstimation\TaggedEnergy TelemetryMaxTagPerApplication -Value 0
	}
Write-Host "Disable Powersaving on USB & Eathernet !" ; $ProcessSound.Play()
powershell.exe -encodedCommand JABkAGUAdgBpAGMAZQBzAFUAUwBCACAAPQAgAEcAZQB0AC0AUABuAHAARABlAHYAaQBjAGUAIAB8ACAAdwBoAGUAcgBlACAAewAkAF8ALgBJAG4AcwB0AGEAbgBjAGUASQBkACAALQBsAGkAawBlACAAIgAqAFUAUwBCAFwAUgBPAE8AVAAqACIAfQAgACAAfAAgAA0ACgBGAG8AcgBFAGEAYwBoAC0ATwBiAGoAZQBjAHQAIAAtAFAAcgBvAGMAZQBzAHMAIAB7AA0ACgBHAGUAdAAtAEMAaQBtAEkAbgBzAHQAYQBuAGMAZQAgAC0AQwBsAGEAcwBzAE4AYQBtAGUAIABNAFMAUABvAHcAZQByAF8ARABlAHYAaQBjAGUARQBuAGEAYgBsAGUAIAAtAE4AYQBtAGUAcwBwAGEAYwBlACAAcgBvAG8AdABcAHcAbQBpACAADQAKAH0ADQAKAA0ACgBmAG8AcgBlAGEAYwBoACAAKAAgACQAZABlAHYAaQBjAGUAIABpAG4AIAAkAGQAZQB2AGkAYwBlAHMAVQBTAEIAIAApAA0ACgB7AA0ACgAgACAAIAAgAFMAZQB0AC0AQwBpAG0ASQBuAHMAdABhAG4AYwBlACAALQBOAGEAbQBlAHMAcABhAGMAZQAgAHIAbwBvAHQAXAB3AG0AaQAgAC0AUQB1AGUAcgB5ACAAIgBTAEUATABFAEMAVAAgACoAIABGAFIATwBNACAATQBTAFAAbwB3AGUAcgBfAEQAZQB2AGkAYwBlAEUAbgBhAGIAbABlACAAVwBIAEUAUgBFACAASQBuAHMAdABhAG4AYwBlAE4AYQBtAGUAIABMAEkASwBFACAAJwAlACQAKAAkAGQAZQB2AGkAYwBlAC4AUABOAFAARABlAHYAaQBjAGUASQBEACkAJQAnACIAIAAtAFAAcgBvAHAAZQByAHQAeQAgAEAAewBFAG4AYQBiAGwAZQA9ACQARgBhAGwAcwBlAH0AIAAtAFAAYQBzAHMAVABoAHIAdQANAAoAfQANAAoADQAKACQAYQBkAGEAcAB0AGUAcgBzACAAPQAgAEcAZQB0AC0ATgBlAHQAQQBkAGEAcAB0AGUAcgAgAC0AUABoAHkAcwBpAGMAYQBsACAAfAAgAEcAZQB0AC0ATgBlAHQAQQBkAGEAcAB0AGUAcgBQAG8AdwBlAHIATQBhAG4AYQBnAGUAbQBlAG4AdAANAAoAIAAgACAAIABmAG8AcgBlAGEAYwBoACAAKAAkAGEAZABhAHAAdABlAHIAIABpAG4AIAAkAGEAZABhAHAAdABlAHIAcwApAA0ACgAgACAAIAAgACAAIAAgACAAewANAAoAIAAgACAAIAAgACAAIAAgACQAYQBkAGEAcAB0AGUAcgAuAEEAbABsAG8AdwBDAG8AbQBwAHUAdABlAHIAVABvAFQAdQByAG4ATwBmAGYARABlAHYAaQBjAGUAIAA9ACAAJwBEAGkAcwBhAGIAbABlAGQAJwANAAoAIAAgACAAIAAgACAAIAAgACQAYQBkAGEAcAB0AGUAcgAgAHwAIABTAGUAdAAtAE4AZQB0AEEAZABhAHAAdABlAHIAUABvAHcAZQByAE0AYQBuAGEAZwBlAG0AZQBuAHQADQAKACAAIAAgACAAIAAgACAAIAB9AA== | Out-Null
#Set TimerResolution Service
	Copy-Item -Path "$Temporary\SetTimerResolutionService.exe" -Destination "$Data"
	New-Service -Name "TimerResolution" -BinaryPathName '"C:\ProgramData\SodaScript\SetTimerResolutionService.exe"'
Write-Host "TimerResolution Service Has Been Installed" ; $ProcessSound.Play()

#Enable MSI Mode on GPU if supported
$MSISupported = "HKLM:\System\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
If (Test-Path $MSISupported) {
	Set-ItemProperty -Path $MSISupported -Name MSISupported -Value 1 -Force
}

#GPU + NET Affinites
$MSISupported2 = "HKLM:\SYSTEM\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\Affinity Policy"
 If (Test-Path $MSISupported2) {
	Set-ItemProperty -Path $MSISupported2 -Name DevicePolicy -Value 3 -Force
}
$MSISupported3 = "HKLM:\System\CurrentControlSet\Enum\$NetAdapterID\Device Parameters\Interrupt Management\Affinity Policy"
  If (Test-Path $MSISupported3) {
	Set-ItemProperty -Path $MSISupported3 -Name DevicePolicy -Value 5 -Force
}

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
reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MessageNumberLimit" /f | Out-Null

$Services2 = "HKLM:\SYSTEM\CurrentControlSet\services"
	If (Test-Path $Services2) {
Set-ItemProperty $Services2\AmdK8 Start -Value 4
Set-ItemProperty $Services2\IntelPPM Start -Value 4
Set-ItemProperty $Services2\AmdPPM Start -Value 4
Set-ItemProperty $Services2\Processor Start -Value 4
}
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Function GPUTweaker{
	If ($Graphics -like "*NVIDIA*") {
Write-Host "Optimizing Your Nvidia Graphics Card..." ; $ProcessSound.Play()
		(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929974567814983700/Import_NIP.vbs", "$env:Temp\SodaScript\Import_NIP.vbs")
		(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929974567659786240/Base_Profile.nip", "$env:Temp\SodaScript\Base_Profile.nip")
		(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929974567483629578/nvidiaProfileInspector.exe", "$env:Temp\SodaScript\nvidiaProfileInspector.exe")
#Enable Game Mode
	if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\GameBar") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\GameBar" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\GameBar' -Name 'AllowAutoGameMode' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -Value 1 -PropertyType DWord -Force | Out-Null	

		Reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color" /v "NvCplUseColorCorrection" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PlatformSupportMiracast" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t Reg_DWORD /d "1" /f | Out-Null
		reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f | Out-Null
		reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d 0 /f | Out-Null
		reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d 0 /f | Out-Null
		reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d 0 /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t Reg_DWORD /d "1" /f | Out-Null
		reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "NvBackend" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t Reg_DWORD /d "4" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t Reg_DWORD /d "4" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableTiledDisplay" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemption" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableCudaContextPreemption" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "EnableCEPreemption" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisablePreemptionOnS3S4" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "ComputePreemption" /t Reg_DWORD /d "0" /f | Out-Null
		
		Start-Process "$Temporary\nvidiaProfileInspector.exe" "$Temporary\Base_Profile.nip"
		
		#KBoost
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevelAC" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t Reg_DWORD /d "0" /f | Out-Null
		
Write-Host "Optimized Nvidia GPU" ; $ProcessSound.Play()
Start-Sleep 2
}
ElseIf ($Graphics -like "*Radeon*") {
	Write-Host "Optimizing Your AMD Graphics Card..." ; $ProcessSound.Play()
	Start-Sleep 2
	(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929867421693644800/SodaAMD_TWEAKS.REG", "$env:Temp\SodaScript\SodaAMD TWEAKS.REG")
		$Amd1 = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000"
		Set-ItemProperty $Amd1 EnableVceSwClockGating -Value 1
		Set-ItemProperty $Amd1 EnableUvdClockGating -Value 1
		Set-ItemProperty $Amd1 DisableVCEPowerGating -Value 0
		Set-ItemProperty $Amd1 DisableUVDPowerGatingDynamic -Value 0
		Set-ItemProperty $Amd1 DisablePowerGating -Value 1
		Set-ItemProperty $Amd1 DisableSAMUPowerGating -Value 1
		Set-ItemProperty $Amd1 DisableFBCSupport -Value 0
		Set-ItemProperty $Amd1 DisableEarlySamuInit -Value 1
		Set-ItemProperty $Amd1 PP_GPUPowerDownEnabled -Value 0
		Set-ItemProperty $Amd1 DisableDrmdmaPowerGating -Value 1
		Set-ItemProperty $Amd1 PP_SclkDeepSleepDisable -Value 1
		Set-ItemProperty $Amd1 PP_ThermalAutoThrottlingEnable -Value 1
		Set-ItemProperty $Amd1 PP_ActivityTarget -Value 1e
		Set-ItemProperty $Amd1 PP_ODNFeatureEnable -Value 1
		Set-ItemProperty $Amd1 EnableUlps -Value 0
		Set-ItemProperty $Amd1 GCOOPTION_DisableGPIOPowerSaveMode -Value 1
		Set-ItemProperty $Amd1 PP_AllGraphicLevel_DownHyst -Value 14
		Set-ItemProperty $Amd1 PP_AllGraphicLevel_UpHyst -Value 0
		Set-ItemProperty $Amd1 KMD_FRTEnabled -Value 0
		Set-ItemProperty $Amd1 DisableDMACopy -Value 1
		Set-ItemProperty $Amd1 DisableBlockWrite -Value 0
		Set-ItemProperty $Amd1 PP_ODNFeatureEnable -Value 1
		Set-ItemProperty $Amd1 KMD_MaxUVDSessions -Value 20
		Set-ItemProperty $Amd1 DalAllowDirectMemoryAccessTrig -Value 1
		Set-ItemProperty $Amd1 DalAllowDPrefSwitchingForGLSync -Value 0
		Set-ItemProperty $Amd1 WmAgpMaxIdleClk -Value 20
		Set-ItemProperty $Amd1 PP_MCLKStutterModeThreshold -Value 1000
		Set-ItemProperty $Amd1 StutterMode -Value 0
		Set-ItemProperty $Amd1 TVEnableOverscan -Value 0
		Set-ItemProperty $Amd1 Acceleration.Level -Value 0
		Set-ItemProperty $Amd1 DesktopStereoShortcuts -Value 0
		Set-ItemProperty $Amd1 FeatureControl -Value 4
		Set-ItemProperty $Amd1 NVDeviceSupportKFilter -Value 0
		Set-ItemProperty $Amd1 RmCacheLoc -Value 0
		Set-ItemProperty $Amd1 RmDisableInst2Sys -Value 0
		Set-ItemProperty $Amd1 RmFbsrPagedDMA -Value 1
		Set-ItemProperty $Amd1 RMGpuId -Value 100
		Set-ItemProperty $Amd1 RmProfilingAdminOnly -Value 0
		Set-ItemProperty $Amd1 TCCSupported -Value 0
		Set-ItemProperty $Amd1 TrackResetEngine -Value 0
		Set-ItemProperty $Amd1 UseBestResolution -Value 1
		Set-ItemProperty $Amd1 ValidateBlitSubRects -Value 0
			
		#Kboost
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevelAC" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t Reg_DWORD /d "0" /f | Out-Null
	
		Reg add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t Reg_DWORD /d "4" /f | Out-Null
		Reg add "HKLM\System\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t Reg_DWORD /d "4" /f | Out-Null
		
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -force | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" -force | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" -force | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\amdlog") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\amdlog" -force | Out-Null };
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'DisableDMACopy' -Value 1 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'DisableBlockWrite' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'StutterMode' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'EnableUlps' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'PP_SclkDeepSleepDisable' -Value 1 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'PP_ThermalAutoThrottlingEnable' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'DisableDrmdmaPowerGating' -Value 1 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'KMD_EnableComputePreemption' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'KMD_DeLagEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\amdlog' -Name 'Start' -Value 4 -PropertyType DWord -Force | Out-Null
		
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\services\amdkmdap") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\services\amdkmdap" -force | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\Control\CLASS\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\Control\CLASS\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000" -force | Out-Null };
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\services\amdkmdap' -Name 'KMD_APlusISharedMiniSegmentOptions' -Value 7 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\services\amdkmdap' -Name 'KMD_APlusISharedMiniSegmentSize' -Value 67108864 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\services\amdkmdap' -Name 'KMD_PXForceVideoPlaybackToIntegrated' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\CLASS\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000' -Name 'KMD_EnableCrossGpuDisplaySupport' -Value 1 -PropertyType DWord -Force | Out-Null
		
		Reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t Reg_DWORD /d "0" | Out-Null
		Reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t Reg_DWORD /d "0" | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableeRecord" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_SDIEnable" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmSWL1" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ForcePcieLinkSpeed" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_GameManagerSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_10BitMode" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1SS" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuBypassMode" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableLBPWSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnablePllOffInL1" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnablePPSMSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableSpreadSpectrum" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_AllowTDRAfterECC" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DVRSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableDceVmSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableEDIDManagementSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableEventLog" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableHWSHighPriorityQueue" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSDMAPaging" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSVMSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FramePacingSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_UseBestGPUPowerOption" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MobileServerEnabled" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MobileServerRemotePlayEnabled" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalDisableHDCP" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalDisableStutter" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalEnableHDMI20" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalForceAbmEnable" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalForceMaxDisplayClock" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalOptimizeEdpLinkRate" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalPSRFeatureEnable" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL0s" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL1" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePllOffInL1" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuClockGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuLightSleep" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableGPUVirtualizationFeature" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_BlockchainSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_ChillEnabled" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableGDIAcceleration" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_IoMmuGpuIsolation" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSeamlessBoot" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_IsGamingDriver" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_RadeonBoostEnabled" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_CCCNextEnabled" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableAutoWattman" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableLightSleep" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3to2Pulldown_NA" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t Reg_SZ /d "false" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t Reg_SZ /d "false" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t Reg_SZ /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t Reg_SZ /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t Reg_SZ /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t Reg_SZ /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "StutterMode" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableComputePreemption" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t Reg_SZ /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "FlipQueueSize" /t Reg_BINARY /d "3100" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t Reg_BINARY /d "3200" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation_OPTION" /t Reg_BINARY /d "3200" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation" /t Reg_BINARY /d "3100" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "VSyncControl" /t Reg_BINARY /d "3000" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t Reg_BINARY /d "3200" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" /v "ProtectionControl" /t Reg_BINARY /d "0100000001000000" /f | Out-Null

		start-process reg -ArgumentList "import $Temporary\SodaAMD TWEAKS.reg"
		Write-Host "Optimized AMD GPU" ; $ProcessSound.Play()
		Start-Sleep 2
	}
ElseIf ($Graphics -like "*Vega*") {
	Write-Host "Optimizing Your AMD Graphics Card..." ; $ProcessSound.Play()
	Start-Sleep 2
	(new-object System.Net.WebClient).DownloadFile("https://cdn.discordapp.com/attachments/924876990299914241/929867421693644800/SodaAMD_TWEAKS.REG", "$env:Temp\SodaScript\SodaAMD TWEAKS.REG")
		$Amd1 = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000"
		Set-ItemProperty $Amd1 EnableVceSwClockGating -Value 1
		Set-ItemProperty $Amd1 EnableUvdClockGating -Value 1
		Set-ItemProperty $Amd1 DisableVCEPowerGating -Value 0
		Set-ItemProperty $Amd1 DisableUVDPowerGatingDynamic -Value 0
		Set-ItemProperty $Amd1 DisablePowerGating -Value 1
		Set-ItemProperty $Amd1 DisableSAMUPowerGating -Value 1
		Set-ItemProperty $Amd1 DisableFBCSupport -Value 0
		Set-ItemProperty $Amd1 DisableEarlySamuInit -Value 1
		Set-ItemProperty $Amd1 PP_GPUPowerDownEnabled -Value 0
		Set-ItemProperty $Amd1 DisableDrmdmaPowerGating -Value 1
		Set-ItemProperty $Amd1 PP_SclkDeepSleepDisable -Value 1
		Set-ItemProperty $Amd1 PP_ThermalAutoThrottlingEnable -Value 1
		Set-ItemProperty $Amd1 PP_ActivityTarget -Value 1e
		Set-ItemProperty $Amd1 PP_ODNFeatureEnable -Value 1
		Set-ItemProperty $Amd1 EnableUlps -Value 0
		Set-ItemProperty $Amd1 GCOOPTION_DisableGPIOPowerSaveMode -Value 1
		Set-ItemProperty $Amd1 PP_AllGraphicLevel_DownHyst -Value 14
		Set-ItemProperty $Amd1 PP_AllGraphicLevel_UpHyst -Value 0
		Set-ItemProperty $Amd1 KMD_FRTEnabled -Value 0
		Set-ItemProperty $Amd1 DisableDMACopy -Value 1
		Set-ItemProperty $Amd1 DisableBlockWrite -Value 0
		Set-ItemProperty $Amd1 PP_ODNFeatureEnable -Value 1
		Set-ItemProperty $Amd1 KMD_MaxUVDSessions -Value 20
		Set-ItemProperty $Amd1 DalAllowDirectMemoryAccessTrig -Value 1
		Set-ItemProperty $Amd1 DalAllowDPrefSwitchingForGLSync -Value 0
		Set-ItemProperty $Amd1 WmAgpMaxIdleClk -Value 20
		Set-ItemProperty $Amd1 PP_MCLKStutterModeThreshold -Value 1000
		Set-ItemProperty $Amd1 StutterMode -Value 0
		Set-ItemProperty $Amd1 TVEnableOverscan -Value 0
		Set-ItemProperty $Amd1 Acceleration.Level -Value 0
		Set-ItemProperty $Amd1 DesktopStereoShortcuts -Value 0
		Set-ItemProperty $Amd1 FeatureControl -Value 4
		Set-ItemProperty $Amd1 NVDeviceSupportKFilter -Value 0
		Set-ItemProperty $Amd1 RmCacheLoc -Value 0
		Set-ItemProperty $Amd1 RmDisableInst2Sys -Value 0
		Set-ItemProperty $Amd1 RmFbsrPagedDMA -Value 1
		Set-ItemProperty $Amd1 RMGpuId -Value 100
		Set-ItemProperty $Amd1 RmProfilingAdminOnly -Value 0
		Set-ItemProperty $Amd1 TCCSupported -Value 0
		Set-ItemProperty $Amd1 TrackResetEngine -Value 0
		Set-ItemProperty $Amd1 UseBestResolution -Value 1
		Set-ItemProperty $Amd1 ValidateBlitSubRects -Value 0
			
		#Kboost
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevelAC" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t Reg_DWORD /d "0" /f | Out-Null
	
		Reg add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t Reg_DWORD /d "4" /f | Out-Null
		Reg add "HKLM\System\CurrentControlSet\Services\AMD Log Utility" /v "Start" /t Reg_DWORD /d "4" /f | Out-Null
		
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -force | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" -force | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" -force | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\amdlog") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\amdlog" -force | Out-Null };
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'DisableDMACopy' -Value 1 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'DisableBlockWrite' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'StutterMode' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'EnableUlps' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'PP_SclkDeepSleepDisable' -Value 1 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'PP_ThermalAutoThrottlingEnable' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'DisableDrmdmaPowerGating' -Value 1 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'KMD_EnableComputePreemption' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000' -Name 'KMD_DeLagEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\amdlog' -Name 'Start' -Value 4 -PropertyType DWord -Force | Out-Null
		
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\services\amdkmdap") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\services\amdkmdap" -force | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\Control\CLASS\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\Control\CLASS\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000" -force | Out-Null };
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\services\amdkmdap' -Name 'KMD_APlusISharedMiniSegmentOptions' -Value 7 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\services\amdkmdap' -Name 'KMD_APlusISharedMiniSegmentSize' -Value 67108864 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\services\amdkmdap' -Name 'KMD_PXForceVideoPlaybackToIntegrated' -Value 0 -PropertyType DWord -Force | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\CLASS\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000' -Name 'KMD_EnableCrossGpuDisplaySupport' -Value 1 -PropertyType DWord -Force | Out-Null
		
		Reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t Reg_DWORD /d "0" | Out-Null
		Reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t Reg_DWORD /d "0" | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableeRecord" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_SDIEnable" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmSWL1" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ForcePcieLinkSpeed" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_GameManagerSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_10BitMode" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1SS" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuBypassMode" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableLBPWSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnablePllOffInL1" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnablePPSMSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableSpreadSpectrum" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_AllowTDRAfterECC" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DVRSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableDceVmSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableEDIDManagementSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableEventLog" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableHWSHighPriorityQueue" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSDMAPaging" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSVMSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FramePacingSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_UseBestGPUPowerOption" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MobileServerEnabled" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "MobileServerRemotePlayEnabled" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalDisableHDCP" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalDisableStutter" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalEnableHDMI20" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalForceAbmEnable" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalForceMaxDisplayClock" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalOptimizeEdpLinkRate" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DalPSRFeatureEnable" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL0s" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableAspmL1" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePllOffInL1" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuClockGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSamuLightSleep" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableGPUVirtualizationFeature" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_BlockchainSupport" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_ChillEnabled" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableGDIAcceleration" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_IoMmuGpuIsolation" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableSeamlessBoot" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_IsGamingDriver" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_RadeonBoostEnabled" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_CCCNextEnabled" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableAutoWattman" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_DisableLightSleep" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3to2Pulldown_NA" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t Reg_SZ /d "false" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t Reg_SZ /d "false" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t Reg_SZ /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t Reg_SZ /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t Reg_SZ /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t Reg_SZ /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "StutterMode" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t Reg_DWORD /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_EnableComputePreemption" /t Reg_DWORD /d "0" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t Reg_SZ /d "1" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "FlipQueueSize" /t Reg_BINARY /d "3100" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t Reg_BINARY /d "3200" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation_OPTION" /t Reg_BINARY /d "3200" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Tessellation" /t Reg_BINARY /d "3100" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "VSyncControl" /t Reg_BINARY /d "3000" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t Reg_BINARY /d "3200" /f | Out-Null
		Reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" /v "ProtectionControl" /t Reg_BINARY /d "0100000001000000" /f | Out-Null
		
		start-process reg -ArgumentList "import $Temporary\SodaAMD TWEAKS.reg"
		Write-Host "Optimized AMD GPU" ; $ProcessSound.Play()
		Start-Sleep 2
	}
ElseIf ($Graphics -like "*Intel*") {
Write-Host "Optimizing Your Intel Graphics Card..." ; $ProcessSound.Play()
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
			Set-ItemProperty -Path $Intel2 -Name $RegItem -Value 0
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
			Set-ItemProperty -Path $Intel3 -Name $RegItem -Value 0
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
			Set-ItemProperty -Path $Intel4 -Name $RegItem -Value 0
	}
	}
		$IntelHDGraphicsVRAM = $Memory / 8
		
		$IntelGMM = "HKLM:\SOFTWARE\Intel\GMM"
		If ((Test-Path $IntelGMM) -eq $false) {
			New-Item $IntelGMM
		}
		Set-ItemProperty -Path $IntelGMM -Name DedicatedSegmentSize -Value $IntelHDGraphicsVRAM
		$Services2 = "HKLM:\SYSTEM\CurrentControlSet\services"
		Set-ItemProperty $Services2\"igfxCUIService1.0.0.0" Start -Value 4
		Set-ItemProperty $Services2\ICCS Start -Value 4
		Set-ItemProperty $Services2\cphs Start -Value 4
		
		Write-Host "Optimized Intel GPU" ; $ProcessSound.Play()
		Start-Sleep 2
	}
}

#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Function DeepCleaner {
	Start-Process -FilePath "$Temporary\Soda_Cleaner.bat" -Verb RunAs
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Function Secound-Menu{
Function Host2{
	Clear-Host
     Write-Host "
              _                               _ 
     /\      | |                             | |
    /  \   __| |_   ____ _ _ __   ___ ___  __| |
   / /\ \ / _` \ \ / / _` | '_ \ / __/ _ \/ _` |
  / ____ \ (_| |\ V / (_| | | | | (_|  __/ (_| |
 /_/    \_\__,_| \_/ \__,_|_| |_|\___\___|\__,_|
                                                
                                                 
"
     Write-Host "1: More For Low End Device-(IF NOT USING WIFI !)" -BackgroundColor Blue -ForegroundColor Black
	 Write-Host "2: Less Security" -BackgroundColor Blue -ForegroundColor Black
	 Write-Host "3: No Printer" -BackgroundColor Blue -ForegroundColor Black
	 Write-Host "4: Old Theme (For very bad device) (Looks BAD)" -BackgroundColor Blue -ForegroundColor Black
     Write-Host "Q: Back To MainMenu" -BackgroundColor Yellow -ForegroundColor Black
}
#Functions go here
Function LessSecurity{
	#DisableSmartScreen
	$SmartScreen = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	If (Test-Path $SmartScreen) {
		Set-ItemProperty $SmartScreen EnableSmartScreen -Value 0
	}
	#DisableSmartScreenForEdge
	$Edge = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter"
	If (Test-Path $Edge) {
		Set-ItemProperty $Edge EnabledV9 -Value 0
	}
	takeown.exe /f $env:SystemRoot\System32\smartscreen.exe | Out-Null
	icacls.exe $env:SystemRoot\System32\smartscreen.exe /reset | Out-Null
	Rename-Item -Path "$env:SystemRoot\System32\smartscreen.exe" -NewName "smartscreen.old" -Force
	
	#Security!
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet001\Control\Session Manager\kernel") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet001\Control\Session Manager\kernel" -force | Out-Null };
	if((Test-Path -LiteralPath "HKLM:\SYSTEM\ControlSet002\Control\Session Manager\kernel") -ne $true) {  New-Item "HKLM:\SYSTEM\ControlSet002\Control\Session Manager\kernel" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' -Name 'DisableExceptionChainValidation' -Value 1 -PropertyType DWord -Force  | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' -Name 'KernelSEHOPEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\kernel' -Name 'DisableExceptionChainValidation' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\kernel' -Name 'KernelSEHOPEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet002\Control\Session Manager\kernel' -Name 'DisableExceptionChainValidation' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet002\Control\Session Manager\kernel' -Name 'KernelSEHOPEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
	$Security2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
	If (Test-Path $Security2) {
		Set-ItemProperty $Security2 EnableVirtualizationBasedSecurity -Value 0
		Set-ItemProperty $Security2 HVCIMATRequired -Value 0
	}
	
	#Disable FTH
	Reg add "HKLM\Software\Microsoft\FTH\State" /f | Out-Null
	Remove-Item -Path "HKLM\Software\Microsoft\FTH\State" -Recurse -ErrorAction SilentlyContinue
	Reg add "HKLM\Software\Microsoft\FTH" /v "Enabled" /t Reg_DWORD /d "0" /f | Out-Null
	
	#Disable Firewall
	Write-Host "Disabling Firewall..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" -Name "EnableFirewall" -Type DWord -Value 0
}
Function NoNotfications{
	Set-Service WpnService -StartupType Disabled
#Disable - Windows Push Notifications User Service_XXXXX
	REG ADD "HKLM\SYSTEM\ControlSet001\Services\WpnUserService" /v Start /t REG_DWORD /d 00000004 /f | Out-Null
	$Privacy3 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore"
	Set-ItemProperty $Privacy3\userNotificationListener Value -Value "Deny"
#DisableActionCenter
	if((Test-Path -LiteralPath "HKLM:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell") -ne $true) {  New-Item "HKLM:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" -force | Out-Null };
	if((Test-Path -LiteralPath "\SOFTWARE\Policies\Microsoft\Windows\Explorer") -ne $true) {  New-Item "\SOFTWARE\Policies\Microsoft\Windows\Explorer" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'UseActionCenterExperience' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath '\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableNotificationCenter' -Value 1 -PropertyType DWord -Force | Out-Null
	
	#Disable Notifications
	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_TOASTS_ENABLED' -Value 0 -PropertyType DWord -Force | Out-Null

	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" -force | Out-Null };
	if((Test-Path -LiteralPath "HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications") -ne $true) {  New-Item "HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting' -Name 'DisableEnhancedNotifications' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'NoToastApplicationNotification' -Value 1 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'NoToastApplicationNotificationOnLockScreen' -Value 1 -PropertyType DWord -Force | Out-Null

	if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -force | Out-Null };
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'LockScreenToastEnabled' -Value 0 -PropertyType DWord -Force | Out-Null
	New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Value 0 -PropertyType DWord -Force | Out-Null

	Write-Host "Notifications Disabled" ; $ProcessSound.Play()
	Start-Sleep 2
}
Function NoPrinter {
	Set-Service PrintNotify -StartupType Disabled
	Set-Service Spooler -StartupType manual
	Disable-WindowsOptionalFeature -Online -FeatureName "Printing-PrintToPDFServices-Features" -NoRestart |Out-Null
	Disable-WindowsOptionalFeature -Online -FeatureName "Printing-XPSServices-Features" -NoRestart |Out-Null
	#Disable - PrintWorkflow_XXXXX
	REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\PrintWorkflowUserSvc" /v Start /t REG_DWORD /d 00000004 /f | Out-Null
Write-Host "Printer Services Disabled" ; $ProcessSound.Play()
Start-Sleep 2
}
Function NotEnough2{
$QuestionCreateRestorePoint = [Windows.MessageBox]::Show("Using WIFI ?", "SodaScript",$Button, $Warn)
Switch ($QuestionCreateRestorePoint) {
    Yes {Secound-Menu
	}

    No {Store22
    }
}
Function Store22{
#RemoveStore
Write-Host "Removing Store..." ; $ProcessSound.Play()
	$Bloatware2 = @(
		"Microsoft.WindowsStore"
		"Microsoft.StorePurchaseApp"
		"Microsoft.DesktopAppInstaller"
		)
	Foreach ($Bloat in $Bloatware2) {
			Get-AppxPackage $Bloat | Remove-AppxPackage
			Get-AppxPackage $Bloat -AllUsers | Remove-AppxPackage
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat| Remove-AppxProvisionedPackage -Online
		}		
Write-Host "Done." ; $ProcessSound.Play()
NoNotfications
#Disable RuntimeBroker (NO Microsoft Store APPS WILL RUN)
takeown.exe /f $env:SystemRoot\System32\RuntimeBroker.exe | Out-Null
icacls.exe $env:SystemRoot\System32\RuntimeBroker.exe /reset | Out-Null
Rename-Item -Path "$env:SystemRoot\System32\RuntimeBroker.exe" -NewName "RuntimeBroker.old" -Force
#Install Startisback (OLD START MENU & FASTER)
If (Test-Path C:\Program Files (x86)\StartIsBack) {
Write-Host "$Project will not install StartIsBack." ; $ProcessSound.Play()
Start-Sleep 3
}
Else {
Startisback2
}
}
}
Function Startisback2 {
#Configure StartIsBack
$StartIsBackSetup = "StartIsBack.exe"

If (Test-Path $Temporary\$StartIsBackSetup) {
	Start-Process -FilePath $Temporary\$StartIsBackSetup -Verb runAs -ArgumentList "/VERYSILENT"
	Start-Sleep 6
Write-Host "StartIsBack has been installed successfully." ; $ProcessSound.Play()
	Start-Sleep 4
}

	$StartIsBackConfig = "HKCU:\SOFTWARE\StartIsBack"
	If (Test-Path $StartIsBackConfig) {
	Set-ItemProperty -Path $StartIsBackConfig -Name "AutoUpdates" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "ModernIconsColorized" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "AllProgramsFlyout" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "CombineWinX" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Disabled" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "HideOrb" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "HideSecondaryOrb" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "HideUserFrame" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "ImmersiveMenus" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "MetroHotKey" -Value a
	Set-ItemProperty -Path $StartIsBackConfig -Name "MetroHotkeyFunction" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "NoXAMLPrelaunch" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "StartIsApps" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "StartMenuFavorites" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "StartMenuMonitor" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "StartMetroAppsFClassicer" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "StartMetroAppsMFU" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "StartScreenShortcut" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_AdminToolsRoot" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_AskCortana" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_AutoCascade" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_JumpListItems" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_LargeAllAppsIcons" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_LargeMFUIcons" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_MinMFU" -Value 9
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_NotifyNewApps" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_RightPaneIcons" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowCommandPrompt" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowControlPanel" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowDownloads" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowMyComputer" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowMyDocs" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowMyMusic" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowMyPics" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowNetConn" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowNetPlaces" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowPCSettings" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowPrinters" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowRecentDocs" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowRun" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowSetProgramAccessAndDefaults" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowSkyDrive" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowUser" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_ShowVideos" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "Start_SortFoldersFirst" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "TaskbarCenterIcons" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "TaskbarJumpList" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "TaskbarLargerIcons" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "TaskbarSpacierIcons" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "TaskbarTranslucentEffect" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "TerminateOnClose" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "WelcomeShown" -Value 2
	Set-ItemProperty -Path $StartIsBackConfig -Name "WinkeyFunction" -Value 0
	Set-ItemProperty -Path $StartIsBackConfig -Name "TaskbarStyle" -Value "C:\\Program Files (x86)\\StartIsBack\\Styles\\Windows 10.msstyles"
	Set-ItemProperty -Path $StartIsBackConfig -Name "AlterStyle" -Value "C:\\Program Files (x86)\\StartIsBack\\Styles\\Plain8.msstyles"
	Set-ItemProperty -Path $StartIsBackConfig -Name "StartMetroAppsFolder" -Value 1
	Set-ItemProperty -Path $StartIsBackConfig -Name "OrbBitmap" -Value "Windows 10"	
}
#Disable Search (Will Be Replaced with Startisback)
	takeown.exe /f $env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe | Out-Null
	icacls.exe $env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe /reset | Out-Null
	Rename-Item -Path "$env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe" -NewName "SearchApp.old" -Force
#Disable Cortana
	takeown.exe /f $env:SystemRoot\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe | Out-Null
	icacls.exe $env:SystemRoot\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe /reset | Out-Null
	Rename-Item -Path "$env:SystemRoot\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe" -NewName "SearchUI.old" -Force
#Disable Windows StartMenu (Will Be Replaced with Startisback)
	takeown.exe /f $env:SystemRoot\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe | Out-Null
	icacls.exe $env:SystemRoot\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe /reset | Out-Null
	Rename-Item -Path "$env:SystemRoot\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe" -NewName "ShellExperienceHost.old" -Force
	takeown.exe /f $env:SystemRoot\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe | Out-Null
	icacls.exe $env:SystemRoot\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe /reset | Out-Null
	Rename-Item -Path "$env:SystemRoot\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" -NewName "StartMenuExperienceHost.old" -Force
#Hide Taskbar Search button / box
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0
Write-Host "Replaced Windows Startmenu With Startisback" ; $ProcessSound.Play()
Start-Sleep 2
}
Function Oldtheme2{
	Start-Process "$Temporary\Classic_DarkTheme.themepack"
}
#Main menu loop
Do {
	Clear-Host
	Host2
    $input = Read-Host "IT'S Time To Choose>>"
    switch ($input) {
		'1' {$MenuSound.Play() ; NotEnough2 ; break}
		'2' {$MenuSound.Play() ; LessSecurity ; break}
		'3' {$MenuSound.Play() ; NoPrinter ; break}
		'4' {$MenuSound.Play() ; Oldtheme2 ; break}
		'Q' {$MenuSound.Play() ; Show-Menu ; break} # do nothing
		default{
		Write-Host "You entered '$input'" -ForegroundColor Red
		Write-Host "Please select one of the choices from the menu." -ForegroundColor Red
		}
	}
}

Until ($input -eq 'q')
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Function ClearTemporary {
	Remove-Item -Path $Temporary -Recurse -Force -Confirm:$false
}
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
#Main menu loop
Do {
    Show-Menu
    $input = Read-Host "IT'S Time To Choose>>"
    Clear-Host
    switch ($input) {
		'1' {$MenuSound.Play() ; UninstallBloatware ; break}
		'2' {$MenuSound.Play() ; WindowsTweaks ; break}
		'3' {$MenuSound.Play() ; HDDandSSD ; break}
		'4' {$MenuSound.Play() ; GPUTweaker ; break}
		'5' {$MenuSound.Play() ; DeepCleaner ; break}
		'A' {$MenuSound.Play() ; Secound-Menu ; break}
		'R' {$MenuSound.Play() ; RestoreRestorePoint ; break}
		'Q' {$MenuSound.Play() ; break} # do nothing
		default{
		Write-Host "You entered '$input'" -ForegroundColor Red
		Write-Host "Please select one of the choices from the menu." -ForegroundColor Red
		}
	}
}

Until ($input -eq 'q')
#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
Stop-Transcript| Out-Null
ClearTemporary
Write-Host "$Project Has Optimized Your PC successfully!" -BackgroundColor White -ForegroundColor Black
Write-Host "SodaTools>>> Ctrl+F1 To Clean Memory > Ctrl+F2 To Clean Temp" -BackgroundColor White -ForegroundColor Black
Write-Host "Restart Your PC To Apply Changes -> Exiting..." -BackgroundColor Red -ForegroundColor Black
Start-Sleep 3
pause