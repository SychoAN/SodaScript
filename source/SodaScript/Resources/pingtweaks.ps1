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
Start-Transcript -Path $env:ProgramData\SodaScript\PingTweaks-$time.log| Out-Null
#PingTweaks
Function MTU2{
$BufferSizeMax = 1500
$TestAddress   = ""www.google.com""

$LastMinBuffer = $BufferSizeMin
$LastMaxBuffer = $BufferSizeMax
$MaxFound = $false

[int]$BufferSize = ($BufferSizeMax - 0) / 2

While ($MaxFound -eq $false) {
    Try {
        $Response = ping $TestAddress -n 1 -f -l $BufferSize
        
        If ($Response -like ""*fragmented*"") {throw}
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
Write-Host ""The optimal Maximum Transmission Unit (MTU) is $BufferSize bytes.""

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
$AdapterName = (Get-NetAdapter | Where-Object { $_.Name -Match 'Ethernet'}).Name
netsh interface ipv4 set subinterface ""$AdapterName"" mtu=$BufferSize store=persistent

Write-Host ""The Maximum Transmission Unit (MTU) has been set to $BufferSize""
}
	netsh winsock reset
	netsh winsock reset catalog
	ipconfig /f
	MTU2
	netsh int tcp set global initialRto=2000 netdma=disabled rss=enabled MaxSynRetransmissions=2
	netsh winsock set autotuning on
	netsh int tcp set global autotuninglevel=normal
	netsh interface 6to4 set state disabled
	netsh int tcp set global fastopen=enable
	netsh advfirewall firewall add rule name=""StopThrottling"" dir=in action=block remoteip=173.194.55.0/24,206.111.0.0/16 enable=yes
	netsh int isatap set state disable
	netsh int tcp set global timestamps=disabled
	netsh int tcp set heuristics disabled
	netsh int tcp set heuristics wsh=disabled
	netsh int tcp set global chimney=disabled
	netsh int tcp set global ecncapability=disabled
	netsh int tcp set global rsc=disabled
	netsh int tcp set global nonsackrttresiliency=disabled
	netsh int ipv4 set dynamicport tcp -StartupType 1025 num=64511
	netsh int ipv4 set dynamicport udp -StartupType 1025 num=64511
	netsh int ip set global sourceroutingbehavior=drop
	netsh int tcp set security mpp=disabled
	netsh int tcp set security profiles=disabled
	netsh int ip set global icmpredirects=disabled
	netsh int tcp set security mpp=disabled profiles=disabled
	netsh int ip set global multicastforwarding=disabled
	netsh int tcp set supplemental internet congestionprovider=ctcp
	netsh interface teredo set state disabled
	netsh int isatap set state disable
	netsh int ip set global taskoffload=disabled
	netsh int ip set global routecachelimit=4096
	netsh int ip set global neighborcachelimit=4096
	netsh int tcp set global dca=enabled
	netsh int ip set interface $NetAdapter2 basereachable=3600000 dadtransmits=0 otherstateful=disabled routerdiscovery=disabled store=persistent
	PowerShell Disable-NetAdapterLso -Name ""*""
	powershell ""ForEach($adapter In Get-NetAdapter){Disable-NetAdapterPowerManagement -Name $adapter.Name}""
	powershell ""ForEach($adapter In Get-NetAdapter){Disable-NetAdapterLso -Name $adapter.Name}""
	
	Reg add ""HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"" /v ""TcpTimedWaitDelay"" /t REG_DWORD /d ""30"" /f
	Reg add ""HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"" /v ""MaxConnectionsPerServer"" /t REG_DWORD /d ""10"" /f
	Reg add ""HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"" /v ""MaxUserPort"" /t REG_DWORD /d ""65534"" /f
	Reg add ""HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"" /v ""SackOpts"" /t REG_DWORD /d ""0"" /f
	Reg add ""HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"" /v ""DefaultTTL"" /t REG_DWORD /d ""64"" /f
	
	New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\VxD\MSTCP' -Name 'PMTUDiscovery' -Value '1' -PropertyType String -Force

	$Latency2 = ""HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings""
	if((Test-Path -LiteralPath $Latency2) -ne $true) {  New-Item $Latency2 -force };
		Set-ItemProperty $Latency2 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency2 MaxConnectionsPer1_0Server -Value 10 -Force
	$Latency3 = ""HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings""
	if((Test-Path -LiteralPath $Latency3) -ne $true) {  New-Item $Latency3 -force };
		Set-ItemProperty $Latency3 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency3 MaxConnectionsPer1_0Server -Value 10 -Force
	$Latency4 = ""HKCU:\Software\Microsoft\Windows\CurrentVersion""
	if((Test-Path -LiteralPath $Latency4) -ne $true) {  New-Item $Latency4 -force };
		Set-ItemProperty $Latency4 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency4 MaxConnectionsPer1_0Server -Value 10 -Force
	$Latency5 = ""HKLM:\Software\Microsoft\Windows\CurrentVersion""
	if((Test-Path -LiteralPath $Latency5) -ne $true) {  New-Item $Latency5 -force };
		Set-ItemProperty $Latency5 MaxConnectionsPerServer -Value 10 -Force
		Set-ItemProperty $Latency5 MaxConnectionsPer1_0Server -Value 10 -Force
	$Latency6 = ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider""
	if((Test-Path -LiteralPath $Latency6) -ne $true) {  New-Item $Latency6 -force };
		Set-ItemProperty $Latency6 Class -Value 8 -Force
		Set-ItemProperty $Latency6 LocalPriority -Value 4 -Force
		Set-ItemProperty $Latency6 HostsPriority -Value 5 -Force
		Set-ItemProperty $Latency6 DnsPriority -Value 6 -Force
		Set-ItemProperty $Latency6 NetbtPriority -Value 7 -Force
	$Latency8 = ""HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DnsClient""
	if((Test-Path -LiteralPath $Latency8) -ne $true) {  New-Item $Latency8 -force };
		Set-ItemProperty $Latency8 EnableMulticast -Value 0 -Force
	$Latency10 = ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces""
	if((Test-Path -LiteralPath $Latency10) -ne $true) {  New-Item $Latency10 -force };
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
		Set-ItemProperty $Latency10 DnsQueryTimeouts -Value ""1 1 2 2 4 0"" -Force
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
	$Latency11 = ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters""
	if((Test-Path -LiteralPath $Latency11) -ne $true) {  New-Item $Latency11 -force };
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
		Set-ItemProperty $Latency11 DnsQueryTimeouts -Value ""1 1 2 2 4 0"" -Force
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
		Set-ItemProperty $Latency11 DelayedAckFrequency -Value 1 -Force
		Set-ItemProperty $Latency11 DelayedAckTicks -Value 1 -Force
		Set-ItemProperty $Latency11 CongestionAlgorithm -Value 1 -Force
		Set-ItemProperty $Latency11 MultihopSets -Value f -Force
		Set-ItemProperty $Latency11 FastCopyReceiveThreshold -Value 4000 -Force
		Set-ItemProperty $Latency11 FastSendDatagramThreshold -Value 4000 -Force
	
$RegItems = @(
    ""*EEE""
    ""*WakeOnMagicPacket""
    ""*WakeOnPattern""
    ""*AdvancedEEE""
	""*EEE""
    ""AutoDisableGigabit""
    ""AutoPowerSaveModeEnabled""
    ""EEELinkAdvertisement""
    ""EnableConnectedPowerGating""
    ""EnableDynamicPowerGating""
    ""EnableGreenEthernet""
    ""EnablePME""
    ""EnablePowerManagement""
    ""EnableSavePowerNow""
    ""GigaLite""
    ""*IPChecksumOffloadIPv4""
    ""*JumboPacket""
    ""*LsoV2IPv4""
    ""*LsoV2IPv6""
    ""*PMARPOffload""
    ""*PMNSOffload""
    ""PowerDownPll""
    ""PowerSavingMode""  
    ""ReduceSpeedOnPowerDown""
    ""S5NicKeepOverrideMacAddrV2""
    ""S5WakeOnLan""
    ""*TCPChecksumOffloadIPv4""
    ""*TCPChecksumOffloadIPv6""
    ""*UDPChecksumOffloadIPv4""
    ""*UDPChecksumOffloadIPv6""
    ""ULPMode""
    ""WakeOnLink""
)
$Latency15 = ""HKLM:\SYSTEM\CurrentControlSet\Control\Class\$DriverKey\0001""
Foreach ($RegItem in $RegItems) {  
	IF (Get-ItemProperty -Path $Latency15 -Name $RegItem) {
		Set-ItemProperty -Path $Latency15 -Name $RegItem -Value 0 -Force
	}
	IF (Get-ItemProperty -Path $Latency15 -Name ""ITR"") {
		Set-ItemProperty -Path $Latency15 -Name ""ITR"" -Value 125 -Force
	}
	IF (Get-ItemProperty -Path $Latency15 -Name ""*FlowControl"") {
		Set-ItemProperty -Path $Latency15 -Name ""*FlowControl"" -Value 1514 -Force
	}
	IF (Get-ItemProperty -Path $Latency15 -Name ""*RSS"") {
		Set-ItemProperty -Path $Latency15 -Name ""*RSS"" -Value 1 -Force
	}
	IF (Get-ItemProperty -Path $Latency15 -Name ""*ReceiveBuffers"") {
		Set-ItemProperty -Path $Latency15 -Name ""*ReceiveBuffers"" -Value 256 -Force
	}
	IF (Get-ItemProperty -Path $Latency15 -Name ""*TransmitBuffers"") {
		Set-ItemProperty -Path $Latency15 -Name ""*TransmitBuffers"" -Value 256 -Force
	}
	IF (Get-ItemProperty -Path $Latency15 -Name ""WolShutdownLinkSpeed"") {
		Set-ItemProperty -Path $Latency15 -Name ""WolShutdownLinkSpeed"" -Value 2 -Force
	}
}
	if((Test-Path -LiteralPath ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS"") -ne $true) {  New-Item ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS"" -force };
	if((Test-Path -LiteralPath ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock"") -ne $true) {  New-Item ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock"" -force };
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS' -Name 'Do not use NLA' -Value 1 -Force
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock' -Name 'UseDelayedAcceptance' -Value 0 -Force
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock' -Name 'MaxSockAddrLength' -Value 16 -Force
	Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock' -Name 'MinSockAddrLength' -Value 16 -Force
	
	$TCPTWEAKS = ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*""
	New-ItemProperty ""HKLM:$TCPTWEAKS"" TcpACKFrequency -Value 1 -Force
	New-ItemProperty ""HKLM:$TCPTWEAKS"" TcpDelAckTicks -Value 0 -Force
	New-ItemProperty ""HKLM:$TCPTWEAKS"" TCPNoDelay -Value 1 -Force