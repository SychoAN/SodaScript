using System;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Diagnostics;
using System.Management;
using Microsoft.Win32;
using System.IO;
using static System.Environment;

namespace SodaScript
{
    public partial class Form1 : Form
    {
        [DllImport("Gdi32.dll", EntryPoint = "CreateRoundRectRgn")]
        private static extern IntPtr CreateRoundRectRgn
        (
            int nLeftRect,     // x-coordinate of upper-left corner
            int nTopRect,      // y-coordinate of upper-left corner
            int nRightRect,    // x-coordinate of lower-right corner
            int nBottomRect,   // y-coordinate of lower-right corner
            int nWidthEllipse, // width of ellipse
            int nHeightEllipse // height of ellipse
        );
        private const int CS_DROPSHADOW = 0x00020000;
        protected override CreateParams CreateParams
        {
            get
            {
                // add the drop shadow flag for automatically drawing
                // a drop shadow around the form
                CreateParams cp = base.CreateParams;
                cp.ClassStyle |= CS_DROPSHADOW;
                return cp;
            }
        }
        public Form1()
        {
            InitializeComponent();
            this.FormBorderStyle = FormBorderStyle.None;
            Region = System.Drawing.Region.FromHrgn(CreateRoundRectRgn(0, 0, Width, Height, 20, 20));
            button1.Region = Region.FromHrgn(CreateRoundRectRgn(0, 0,
            button1.Width, button1.Height, 20, 20));
            revertButton.Region = Region.FromHrgn(CreateRoundRectRgn(0, 0,
            revertButton.Width, button1.Height, 20, 20));
            label4.Text = "Checking Restore Point...";
            var checkrestoreCommand = @"
			(Get-ComputerRestorePoint | Where-Object {$_.Description -eq ""SodaScript""}).Description 
            ";
            var checkrestoreBytes = System.Text.Encoding.Unicode.GetBytes(checkrestoreCommand);
            var checkrestoreBase64 = Convert.ToBase64String(checkrestoreBytes);
            Process processcheckrestore = new Process();
            ProcessStartInfo checkrestorestartInfo = new ProcessStartInfo();
            checkrestorestartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            checkrestorestartInfo.CreateNoWindow = true;
            checkrestorestartInfo.RedirectStandardOutput = true;
            checkrestorestartInfo.FileName = "powershell.exe";
            checkrestorestartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {checkrestoreBase64}";
            checkrestorestartInfo.Verb = "runas";
            processcheckrestore.StartInfo = checkrestorestartInfo;
            processcheckrestore.Start();
            processcheckrestore.WaitForExit();
            string checkrestoreoutput = processcheckrestore.StandardOutput.ReadToEnd();
            label4.Text = "";
            if (String.IsNullOrEmpty(checkrestoreoutput))
            {
                panel1.Show();
            }
            else
            {
                panel1.Hide();
            }
        }
        public static int windetector = Environment.OSVersion.Version.Build;

        private void pictureBox2_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            new Moveable(formpanel);
        }

        public void enableDeff()
        {
                var enabledeffenderCommand = @"
				      ## enable notifications
				      rp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications' DisableNotifications -Force -ea 0
				      rp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration' Notification_Suppress -Force -ea 0
				      rp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration' UILockdown -Force -ea 0
				      rp 'HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications' DisableNotifications -Force -ea 0
				      rp 'HKLM:\SOFTWARE\Microsoft\Windows Defender\UX Configuration' Notification_Suppress -Force -ea 0
				      rp 'HKLM:\SOFTWARE\Microsoft\Windows Defender\UX Configuration' UILockdown -Force -ea 0
				      ## enable shell smartscreen and set to warn
				      rp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' EnableSmartScreen -Force -ea 0
				      sp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' ShellSmartScreenLevel 'Warn' -Force -ea 0
				      ## enable store smartscreen and set to warn
				      gp Registry::HKEY_Users\S-1-5-21*\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost -ea 0 |% {
					    sp $_.PSPath 'EnableWebContentEvaluation' 1 -Type Dword -Force -ea 0
					    sp $_.PSPath 'PreventOverride' 0 -Type Dword -Force -ea 0
				      }
				      ## enable chredge smartscreen + pua
				      gp Registry::HKEY_Users\S-1-5-21*\SOFTWARE\Microsoft\Edge\SmartScreenEnabled -ea 0 |% {
					    sp $_.PSPath '(Default)' 1 -Type Dword -Force -ea 0
				      }
				      gp Registry::HKEY_Users\S-1-5-21*\SOFTWARE\Microsoft\Edge\SmartScreenPuaEnabled -ea 0 |% {
					    sp $_.PSPath '(Default)' 1 -Type Dword -Force -ea 0
				      }
				      ## enable legacy edge smartscreen
				      ri 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter' -Force -ea 0
				      ## enable av
				      rp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' DisableRealtimeMonitoring -Force -ea 0
				      rp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' DisableAntiSpyware -Force -ea 0
				      rp 'HKLM:\SOFTWARE\Microsoft\Windows Defender' DisableAntiSpyware -Force -ea 0
				      sc.exe config windefend depend= RpcSs
				      net1 start windefend
				      kill -Force -Name MpCmdRun -ea 0
				      start ($env:ProgramFiles+'\Windows Defender\MpCmdRun.exe') -Arg '-EnableService' -win 1
			    ";
                    var enabledeffenderBytes = System.Text.Encoding.Unicode.GetBytes(enabledeffenderCommand);
                    var enabledeffenderBase64 = Convert.ToBase64String(enabledeffenderBytes);
                    Process processenabledeffender = new Process();
                    ProcessStartInfo enabledeffenderstartInfo = new ProcessStartInfo();
                    enabledeffenderstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    enabledeffenderstartInfo.CreateNoWindow = true;
                    enabledeffenderstartInfo.RedirectStandardOutput = true;
                    enabledeffenderstartInfo.FileName = "powershell.exe";
                    enabledeffenderstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {enabledeffenderBase64}";
                    enabledeffenderstartInfo.Verb = "runas";
                    processenabledeffender.StartInfo = enabledeffenderstartInfo;
                    processenabledeffender.Start();
                    processenabledeffender.WaitForExit();
		}

                public void disableDeff()
                {
                var disabledeffCommand = @"
				  ## disable notifications
				  sp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications' DisableNotifications 1 -Type Dword -ea 0
				  sp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration' Notification_Suppress 1 -Type Dword -Force -ea 0
				  sp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration' UILockdown 0 -Type Dword -Force -ea 0
				  sp 'HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications' DisableNotifications 1 -Type Dword -ea 0
				  sp 'HKLM:\SOFTWARE\Microsoft\Windows Defender\UX Configuration' Notification_Suppress 1 -Type Dword -Force -ea 0
				  sp 'HKLM:\SOFTWARE\Microsoft\Windows Defender\UX Configuration' UILockdown 0 -Type Dword -Force -ea 0
				  ## disable shell smartscreen and set to warn
				  sp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' EnableSmartScreen 0 -Type Dword -Force -ea 0
				  sp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' ShellSmartScreenLevel 'Warn' -Force -ea 0
				  ## disable store smartscreen and set to warn
				  gp Registry::HKEY_Users\S-1-5-21*\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost -ea 0 |% {
					sp $_.PSPath 'EnableWebContentEvaluation' 0 -Type Dword -Force -ea 0
					sp $_.PSPath 'PreventOverride' 0 -Type Dword -Force -ea 0
				  }
				  ## disable chredge smartscreen + pua
				  gp Registry::HKEY_Users\S-1-5-21*\SOFTWARE\Microsoft\Edge\SmartScreenEnabled -ea 0 |% {
					sp $_.PSPath '(Default)' 0 -Type Dword -Force -ea 0
				  }
				  gp Registry::HKEY_Users\S-1-5-21*\SOFTWARE\Microsoft\Edge\SmartScreenPuaEnabled -ea 0 |% {
					sp $_.PSPath '(Default)' 0 -Type Dword -Force -ea 0
				  }
				  ## disable legacy edge smartscreen
				  sp 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter' EnabledV9 0 -Type Dword -Force -ea 0
				  ## disable av
				  sp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' DisableRealtimeMonitoring 1 -Type Dword -Force
				  sp 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' DisableAntiSpyware 1 -Type Dword -Force -ea 0
				  sp 'HKLM:\SOFTWARE\Microsoft\Windows Defender' DisableAntiSpyware 1 -Type Dword -Force -ea 0
				  net1 stop windefend
				  sc.exe config windefend depend= RpcSs-TOGGLE
				  kill -Name MpCmdRun -Force -ea 0
				  start ($env:ProgramFiles+'\Windows Defender\MpCmdRun.exe') -Arg '-DisableService' -win 1
				  del ($env:ProgramData+'\Microsoft\Windows Defender\Scans\mpenginedb.db') -Force -ea 0  ## Commented = keep scan history
				  del ($env:ProgramData+'\Microsoft\Windows Defender\Scans\History\Service') -Recurse -Force -ea 0
			    ";
                    var disabledeffenderBytes = System.Text.Encoding.Unicode.GetBytes(disabledeffCommand);
                    var disabledeffenderBase64 = Convert.ToBase64String(disabledeffenderBytes);
                    Process processdisabledeffender = new Process();
                    ProcessStartInfo disabledeffenderstartInfo = new ProcessStartInfo();
                    disabledeffenderstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    disabledeffenderstartInfo.CreateNoWindow = true;
                    disabledeffenderstartInfo.RedirectStandardOutput = true;
                    disabledeffenderstartInfo.FileName = "powershell.exe";
                    disabledeffenderstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {disabledeffenderBase64}";
                    disabledeffenderstartInfo.Verb = "runas";
                    processdisabledeffender.StartInfo = disabledeffenderstartInfo;
                    processdisabledeffender.Start();
                    processdisabledeffender.WaitForExit();
		        }

            public void COMP_Tweaks()
            {
            // Gaming Tweaks
            Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games", true);
            RegistryKey Gaming = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games", true);
            Gaming.SetValue("Affinity", "0", RegistryValueKind.DWord);
            Gaming.SetValue("Clock Rate", "2710", RegistryValueKind.DWord);
            Gaming.SetValue("GPU Priority", "8", RegistryValueKind.DWord);
            Gaming.SetValue("Priority", "6", RegistryValueKind.DWord);
            Gaming.SetValue("NoLazyMode", "1", RegistryValueKind.DWord);
            Gaming.SetValue("Clock Rate", "2710", RegistryValueKind.DWord);
            Gaming.SetValue("Background Only", "False", RegistryValueKind.String);
            Gaming.SetValue("Scheduling Category", "High", RegistryValueKind.String);
            Gaming.SetValue("SFIO Priority", "High", RegistryValueKind.String);
            Gaming.SetValue("Latency Sensitive", "True", RegistryValueKind.String);

            Registry.LocalMachine.CreateSubKey(@"SYSTEM\ControlSet001\Control\PriorityControl", true);
            RegistryKey Gaming2 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\ControlSet001\Control\PriorityControl", true);
            Gaming2.SetValue("Win32PrioritySeparation", "28", RegistryValueKind.DWord);
            Gaming2.SetValue("IRQ8Priority", "1", RegistryValueKind.DWord);
            Gaming2.SetValue("ConvertibleSlateMode", "0", RegistryValueKind.DWord);
            Gaming2.SetValue("IRQ16Priority", "2", RegistryValueKind.DWord);

            Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\PriorityControl", true);
            RegistryKey Gaming3 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\PriorityControl", true);
            Gaming3.SetValue("Win32PrioritySeparation", "28", RegistryValueKind.DWord);
            Gaming3.SetValue("IRQ8Priority", "1", RegistryValueKind.DWord);
            Gaming3.SetValue("ConvertibleSlateMode", "0", RegistryValueKind.DWord);
            Gaming3.SetValue("IRQ16Priority", "2", RegistryValueKind.DWord);
            //speeds up Frames Processing
            Registry.LocalMachine.CreateSubKey(@"Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing", true);
            RegistryKey frameProcess = Registry.LocalMachine.OpenSubKey(@"Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing", true);
            frameProcess.SetValue("Affinity", "0", RegistryValueKind.DWord);
            frameProcess.SetValue("Background Only", "True", RegistryValueKind.String);
            frameProcess.SetValue("BackgroundPriority", "24", RegistryValueKind.DWord);
            frameProcess.SetValue("Clock Rate", "10000", RegistryValueKind.DWord);
            frameProcess.SetValue("GPU Priority", "18", RegistryValueKind.DWord);
            frameProcess.SetValue("Priority", "8", RegistryValueKind.DWord);
            frameProcess.SetValue("Scheduling Category", "High", RegistryValueKind.String);
            frameProcess.SetValue("SFIO Priority", "High", RegistryValueKind.String);
            frameProcess.SetValue("Latency Sensitive", "True", RegistryValueKind.String);
            byte[] powertemplateFile = Properties.Resources.Soda;
            string powertempPath = $"{Path.GetTempFileName()}.pow";
            using (MemoryStream ms = new MemoryStream(powertemplateFile))
            {
                using (FileStream fs = new FileStream(powertempPath, FileMode.OpenOrCreate))
                {
                    ms.WriteTo(fs);
                    fs.Close();
                }
                ms.Close();
            }
            //setting powerplan active first to prevent issues
            Process processpower1 = new Process();
            ProcessStartInfo startInfopower1 = new ProcessStartInfo();
            startInfopower1.WindowStyle = ProcessWindowStyle.Hidden;
            startInfopower1.FileName = "powercfg";
            startInfopower1.CreateNoWindow = true;
            startInfopower1.Arguments = "-SETACTIVE " + @"""88888888-8888-8888-8888-888888888888""";
            startInfopower1.Verb = "runas";
            processpower1.StartInfo = startInfopower1;
            processpower1.Start();
            processpower1.WaitForExit();
            //import Gaming powerplan
            Process processpower = new Process();
            ProcessStartInfo startInfopower = new ProcessStartInfo();
            startInfopower.WindowStyle = ProcessWindowStyle.Hidden;
            startInfopower.FileName = "powercfg";
            startInfopower.CreateNoWindow = true;
            startInfopower.Arguments = "-import " + powertempPath + " 88888888-8888-8888-8888-888888888888";
            startInfopower.Verb = "runas";
            processpower.StartInfo = startInfopower;
            processpower.Start();
            processpower.WaitForExit();
            //set Gaming powerplan
            Process processpower2 = new Process();
            ProcessStartInfo startInfopower2 = new ProcessStartInfo();
            startInfopower2.WindowStyle = ProcessWindowStyle.Hidden;
            startInfopower2.FileName = "powercfg";
            startInfopower2.CreateNoWindow = true;
            startInfopower2.Arguments = "-SETACTIVE " + @"""88888888-8888-8888-8888-888888888888""";
            startInfopower2.Verb = "runas";
            processpower2.StartInfo = startInfopower2;
            processpower2.Start();
            processpower2.WaitForExit();
            var CompPowerCommand = @"
					    $GraphicsID = (Get-WmiObject Win32_VideoController).PNPDeviceID
					    $NetAdapterID = (Get-WmiObject win32_NetworkAdapter).PNPDeviceID
				    #CPU Powersaving (Not For Laptops)
					    Set-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'CoalescingTimerInterval' -Value 0 -Force
					    $Power2 = ""HKLM:\SYSTEM\CurrentControlSet\Control\Power""
						    Set-ItemProperty $Power2 HibernateEnabled -Value 0 -Force
						    Set-ItemProperty $Power2\EnergyEstimation\TaggedEnergy DisableTaggedEnergyLogging -Value 1 -Force
						    Set-ItemProperty $Power2\EnergyEstimation\TaggedEnergy TelemetryMaxTagPerApplication -Value 0 -Force
						    Set-ItemProperty $Power2\EnergyEstimation\TaggedEnergy TelemetryMaxApplication -Value 0 -Force
					    $Power3 = ""HKLM:\SYSTEM\CurrentControlSet\Control\Power""
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
					    $Power4 = ""HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power""
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
				    #Enable MSI Mode on GPU if supported
					    $MSISupported = ""HKLM:\System\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties""
						    Set-ItemProperty -Path $MSISupported -Name MSISupported -Value 1 -Force
					    #GPU + NET Affinites
					    $MSISupported2 = ""HKLM:\SYSTEM\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\Affinity Policy""
						    Set-ItemProperty -Path $MSISupported2 -Name DevicePolicy -Value 3 -Force
					    $MSISupported3 = ""HKLM:\System\CurrentControlSet\Enum\$NetAdapterID\Device Parameters\Interrupt Management\Affinity Policy""
						    Set-ItemProperty -Path $MSISupported3 -Name DevicePolicy -Value 5 -Force
				    #Remove GPU Limits
					    Remove-ItemProperty -Path ""HKLM:\SYSTEM\CurrentControlSet\Enum\$GraphicsID\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"" -Name ""MessageNumberLimit""
				    #Energy
					    reg add ""HKLM\SYSTEM\currentcontrolset\control\session manager\Power"" /v ""CoalescingTimerInterval"" /t REG_DWORD /d ""0"" /f
					    reg add ""HKLM\SYSTEM\currentcontrolset\control\session manager\Memory Management"" /v ""CoalescingTimerInterval"" /t REG_DWORD /d ""0"" /f
					    reg add ""HKLM\SYSTEM\currentcontrolset\control\session manager\kernel"" /v ""CoalescingTimerInterval"" /t REG_DWORD /d ""0"" /f
					    reg add ""HKLM\SYSTEM\currentcontrolset\control\session manager\Executive"" /v ""CoalescingTimerInterval"" /t REG_DWORD /d ""0"" /f
					    reg add ""HKLM\SYSTEM\currentcontrolset\control\session manager"" /v ""CoalescingTimerInterval"" /t REG_DWORD /d ""0"" /f
					    reg add ""HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep"" /v ""CoalescingTimerInterval"" /t REG_DWORD /d ""0"" /f
					    reg add ""HKLM\SYSTEM\CurrentControlSet\Control\Power"" /v ""CoalescingTimerInterval"" /t REG_DWORD /d ""0"" /f
					    reg add ""HKLM\SYSTEM\CurrentControlSet\Control"" /v ""CoalescingTimerInterval"" /t REG_DWORD /d ""0"" /f

					    $Services2 = ""HKLM:\SYSTEM\CurrentControlSet\services""
					    Set-ItemProperty $Services2\IntelPPM Start -Value 4 -Force
					    Set-ItemProperty $Services2\AmdPPM Start -Value 4 -Force
				        ";
            var CompPowerBytes = System.Text.Encoding.Unicode.GetBytes(CompPowerCommand);
            var CompPowerBase64 = Convert.ToBase64String(CompPowerBytes);
            Process processCompPower = new Process();
            ProcessStartInfo CompPowerstartInfo = new ProcessStartInfo();
            CompPowerstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            CompPowerstartInfo.CreateNoWindow = true;
            CompPowerstartInfo.FileName = "powershell.exe";
            CompPowerstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {CompPowerBase64}";
            CompPowerstartInfo.Verb = "runas";
            processCompPower.StartInfo = CompPowerstartInfo;
            processCompPower.Start();
            processCompPower.WaitForExit();

            //Set TimerResolution Service
            var programdatapath = GetFolderPath(SpecialFolder.CommonApplicationData);
            var servicepath = Path.Combine(programdatapath + "\\SodaScript\\SetTimerResolutionService.exe");
            if (System.IO.File.Exists(servicepath))
            {
            }
            else
            {
                byte[] servicetemplateFile = Properties.Resources.SetTimerResolutionService;
                string servicetempPath = $"{Path.GetTempFileName()}.exe";
                using (MemoryStream ms = new MemoryStream(servicetemplateFile))
                {
                    using (FileStream fs = new FileStream(servicetempPath, FileMode.OpenOrCreate))
                    {
                        ms.WriteTo(fs);
                        fs.Close();
                    }
                    ms.Close();
                }
                try
                {
                    System.IO.File.Copy(servicetempPath, servicepath, true);
                }
                catch { }
            }
            var timerresCommand = @"
                        $Data = ""$env:ProgramData\SodaScript""
                        If (Test-Path $Data\SetTimerResolutionService.exe) {
	                        $ServiceLoacation = ""$Data\SetTimerResolutionService.exe""
                        New-Service -Name ""TimerResolution"" -BinaryPathName $ServiceLoacation -ea silentlyContinue
                        }
                        Else {
	                        $ServiceLoacation = ""$Data\SetTimerResolutionService.exe""
	                        Copy-Item -Path ""$Temporary\SetTimerResolutionService.exe"" -Destination ""$Data"" -Force
	                        New-Service -Name ""TimerResolution"" -BinaryPathName $ServiceLoacation -ea silentlyContinue
                        Write-Host ""TimerResolution Service Has Been Installed""
                        }
                        ";
            var timerresBytes = System.Text.Encoding.Unicode.GetBytes(timerresCommand);
            var timerresBase64 = Convert.ToBase64String(timerresBytes);
            Process processtimerres = new Process();
            ProcessStartInfo timerresstartInfo = new ProcessStartInfo();
            timerresstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            timerresstartInfo.CreateNoWindow = true;
            timerresstartInfo.FileName = "powershell.exe";
            timerresstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {timerresBase64}";
            timerresstartInfo.Verb = "runas";
            processtimerres.StartInfo = timerresstartInfo;
            processtimerres.Start();
            processtimerres.WaitForExit();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (!compplayerBOX.Checked && !dispowersaveBOX.Checked && !performancetweaksBOX.Checked && !BloatBOX.Checked && !LessSecurityBOX.Checked && !widgetsBOX.Checked && !InputExperianceBOX.Checked && !winUpdateBOX.Checked)
            {
                string message = "Please Check at least one of the Checkboxs";
                string title = "ERROR";
                MessageBox.Show(message, title);
            }
            else {
            circularProgressBar1.Minimum = 0;
            circularProgressBar1.Maximum = 100;
            circularProgressBar1.Visible = true;
            circularProgressBar1.Value = 0;
                if (BloatBOX.Checked)
                {
                    var BloatCommand = @"
                    $Bloatware = @(
                    ""Microsoft.3DBuilder""
                    ""Microsoft.Getstarted""
                    ""Microsoft.BingWeather""
                    ""Microsoft.BingNews""
                    ""Microsoft.GetHelp""
                    ""Microsoft.People""
                    ""Microsoft.WindowsFeedbackHub""
                    ""MicrosoftTeams""
                    ""Microsoft.MicrosoftStickyNotes""
                    ""Microsoft.Todos""
                    )
                    Foreach ($Bloat in $Bloatware) {
                    Get-AppxPackage $Bloat | Remove-AppxPackage
                    Get-AppxPackage $Bloat -AllUsers | Remove-AppxPackage
                    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat| Remove-AppxProvisionedPackage -Online
	                }
                    ";
                    var BloatCommandBytes = System.Text.Encoding.Unicode.GetBytes(BloatCommand);
                    var BloatCommandBase64 = Convert.ToBase64String(BloatCommandBytes);
                    Process processBloat = new Process();
                    ProcessStartInfo BloatstartInfo = new ProcessStartInfo();
                    BloatstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    BloatstartInfo.CreateNoWindow = true;
                    BloatstartInfo.FileName = "powershell.exe";
                    BloatstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {BloatCommandBase64}";
                    BloatstartInfo.Verb = "runas";
                    processBloat.StartInfo = BloatstartInfo;
                    processBloat.Start();
                    processBloat.WaitForExit();
                }
                circularProgressBar1.Value = 20;
                if (performancetweaksBOX.Checked)
                {
                var CPUCommand = @"
			    $Processor = (Get-WmiObject Win32_Processor).Name
			    $CPUThreads = (Get-WmiObject Win32_Processor).NumberOfLogicalProcessors
			    $CPUCores = (Get-WmiObject Win32_Processor).NumberOfCores
			    $L3Cache = (Get-WmiObject -ClassName Win32_Processor).L3CacheSize
			    $L2Cache = (Get-WmiObject -ClassName Win32_Processor).L2CacheSize
			    #RSS Tweaks
	                if ($CPUCores -eq 4){
                                New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 4 -PropertyType DWord -Force
 
                    }
                            if ($CPUCores -eq 6){
                                New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 6 -PropertyType DWord -Force
         
                    }
                            if ($CPUCores -eq 8){
                                New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 8 -PropertyType DWord -Force
         
                    }
                            if ($CPUCores -eq 10){
                                New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 10 -PropertyType DWord -Force
         
                    }
                            if ($CPUCores -eq 12){
                                New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 12 -PropertyType DWord -Force
         
                    }
                            if ($CPUCores -eq 20){
                                New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\NDIS\Parameters' -Name 'MaxNumRssCpus' -Value 20 -PropertyType DWord -Force
         
                    }
                # Enable Intel TSX
                    if ($Processor -Like ""*Intel*""){
                        if ((Test-Path -LiteralPath ""HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"") -ne $true) { New-Item ""HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel"" -Force };
                        New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' -Name 'DisableTsx' -Value 0 -PropertyType DWord -Force
                     }

                    if ((Test-Path -LiteralPath ""HKLM:\System\CurrentControlSet\Services\VxD\BIOS"") -ne $true) { New-Item ""HKLM:\System\CurrentControlSet\Services\VxD\BIOS"" -Force };
                    New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\VxD\BIOS' -Name 'CPUPriority' -Value 1 -PropertyType DWord -Force

                #SecondLevelDataCache
	                $Memory2 = ""HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management""

                    if ((Test-Path -LiteralPath $Memory2) -ne $true) { New-Item $Memory2 -Force };
                            Set-ItemProperty $Memory2 SecondLevelDataCache -Value $L2Cache -Force


                # ThirdLevelDataCache
                        if ((Test-Path -LiteralPath ""HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management"") -ne $true) { New-Item ""HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management"" -Force };
                        if ($L3Cache -eq 2048){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 8264 -PropertyType DWord -Force
         
                }
                        elseif($L3Cache -eq 3072){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 12402 -PropertyType DWord -Force
        
                }
                        elseif($L3Cache -eq 4096){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 16534 -PropertyType DWord -Force
        
                }
                        elseif($L3Cache -eq 6144){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 24900 -PropertyType DWord -Force
        
                }
                        elseif($L3Cache -eq 8192){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 33170 -PropertyType DWord -Force
        
                }
                        elseif($L3Cache -eq 16384){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 91012 -PropertyType DWord -Force
        
                }
                        elseif($L3Cache -eq 32768){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 206696 -PropertyType DWord -Force
        
                }
                        elseif($L3Cache -eq 65536){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 415030 -PropertyType DWord -Force
        
                }
                        elseif($L3Cache -eq 131072){
                            New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Memory Management' -Name 'thirdLevelDataCache' -Value 1249394 -PropertyType DWord -Force
        
                }
                 #AdditionalWorkerThreads
	                $AdditionalWorkerThreads = ""HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Executive""

                    if ((Test-Path -LiteralPath $AdditionalWorkerThreads) -ne $true) { New-Item $AdditionalWorkerThreads -Force };
                            Set-ItemProperty -Path $AdditionalWorkerThreads -Name ""AdditionalCriticalWorkerThreads"" -Value $CPUThreads -Force

                    Set-ItemProperty -Path $AdditionalWorkerThreads -Name ""AdditionalDelayedWorkerThreads"" -Value $CPUThreads -Force

                #DistributeTimers
	                $DistributeTimers = ""HKLM:\System\CurrentControlSet\Control\Session Manager\kernel""

                    if ((Test-Path -LiteralPath $DistributeTimers) -ne $true) { New-Item $DistributeTimers -Force };
                            If($CPUCores -le 6) {
                                Set-ItemProperty -Path $DistributeTimers -Name ""DistributeTimers"" -Value 0 -Force
        
                    }
                            ElseIf($CPUCores -gt 6) {
                                Set-ItemProperty -Path $DistributeTimers -Name ""DistributeTimers"" -Value 1 -Force
        
                    }
                    ";
                    var CPUCommandBytes = System.Text.Encoding.Unicode.GetBytes(CPUCommand);
                    var CPUCommandBase64 = Convert.ToBase64String(CPUCommandBytes);
                    Process processcpu = new Process();
                    ProcessStartInfo CPUstartInfo = new ProcessStartInfo();
                    CPUstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    CPUstartInfo.CreateNoWindow = true;
                    CPUstartInfo.FileName = "powershell.exe";
                    CPUstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {CPUCommandBase64}";
                    CPUstartInfo.Verb = "runas";
                    processcpu.StartInfo = CPUstartInfo;
                    processcpu.Start();
                    processcpu.WaitForExit();
                    //Windows services
                    string[] todisabled = {
                    "DiagTrack",
                    "DusmSvc",
                    "iphlpsvc",
                    "seclogon",
                    "ShellHWDetection",
                    "WerSvc"
                    };

                        string[] tomanual = {
                    "DPS",
                    "TrkWks"
                    };

                    foreach (string disablle in todisabled)
                    {
                        Process processdis = new Process();
                        ProcessStartInfo startInfodis = new ProcessStartInfo();
                        startInfodis.WindowStyle = ProcessWindowStyle.Hidden;
                        startInfodis.CreateNoWindow = true;
                        startInfodis.FileName = "sc.exe";
                        startInfodis.Arguments = "config " + disablle + " start= disabled";
                        startInfodis.Verb = "runas";
                        processdis.StartInfo = startInfodis;
                        processdis.Start();
                        processdis.WaitForExit();
                    }
                    foreach (string manuall in tomanual)
                    {
                        Process processman = new Process();
                        ProcessStartInfo startInfoman = new ProcessStartInfo();
                        startInfoman.WindowStyle = ProcessWindowStyle.Hidden;
                        startInfoman.FileName = "sc.exe";
                        startInfoman.CreateNoWindow = true;
                        startInfoman.Arguments = "config " + manuall + " start= demand";
                        startInfoman.Verb = "runas";
                        processman.StartInfo = startInfoman;
                        processman.Start();
                        processman.WaitForExit();
                    }
                    //Fsutil And Bcdedit Tweaks
                    var BCDCommand = @"
					#Avoid the use of uncontiguous portions of low-memory from the OS. Boosts memory performance and improves microstuttering at least 80% of the cases. 
			        bcdedit /set firstmegabytepolicy UseAll
			        bcdedit /set avoidlowmemory 0x8000000
					bcdedit /set nolowmem Yes
					
			        bcdedit /timeout 0

			        #Enable F8 boot menu options
			        bcdedit /set `{current`} bootmenupolicy Legacy
			        #----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#----------#
			        #Raise the limit of paged pool memory
				        fsutil behavior set memoryusage 2
				        fsutil behavior set mftzone 2

			        #Storage Tweaks
			        fsutil behavior set disablelastaccess 1
			        fsutil behavior set disable8dot3 1
                    ";
                    var BCDCommandBytes = System.Text.Encoding.Unicode.GetBytes(BCDCommand);
                    var BCDCommandBase64 = Convert.ToBase64String(BCDCommandBytes);
                    Process processbcd = new Process();
                    ProcessStartInfo BCDstartInfo = new ProcessStartInfo();
                    BCDstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    BCDstartInfo.CreateNoWindow = true;
                    BCDstartInfo.FileName = "powershell.exe";
                    BCDstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {BCDCommandBase64}";
                    BCDstartInfo.Verb = "runas";
                    processbcd.StartInfo = BCDstartInfo;
                    processbcd.Start();
                    processbcd.WaitForExit();

                    //Disable High Precision event timer
                    var deviceCommand = @"
                    Get-PnpDevice -FriendlyName ""High Precision event timer"" | Disable-PnpDevice -ea SilentlyContinue -Confirm:$false
                    ";
                    var deviceCommandBytes = System.Text.Encoding.Unicode.GetBytes(deviceCommand);
                    var deviceCommandBase64 = Convert.ToBase64String(deviceCommandBytes);
                    Process processdevice = new Process();
                    ProcessStartInfo devicestartInfo = new ProcessStartInfo();
                    devicestartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    devicestartInfo.CreateNoWindow = true;
                    devicestartInfo.FileName = "powershell.exe";
                    devicestartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {deviceCommandBase64}";
                    devicestartInfo.Verb = "runas";
                    processdevice.StartInfo = devicestartInfo;
                    processdevice.Start();
                    processdevice.WaitForExit();

                    // Force contiguous memory allocation in the DirectX Graphics Kernel
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\GraphicsDrivers", true);
                    RegistryKey tweak12 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\GraphicsDrivers", true);
                    tweak12.SetValue("DpiMapIommuContiguous", "1", RegistryValueKind.DWord);

                    // TimeStampInterval
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability", true);
                    RegistryKey TimeStampInterval = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability", true);
                    TimeStampInterval.SetValue("TimeStampInterval", "1", RegistryValueKind.DWord);

                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\ControlSet001\Control\Power", true);
                    RegistryKey Power = Registry.LocalMachine.OpenSubKey(@"SYSTEM\ControlSet001\Control\Power", true);
                    Power.SetValue("MfBufferingThreshold", "0", RegistryValueKind.DWord);
                    Power.SetValue("HibernateEnabledDefault", "0", RegistryValueKind.DWord);
                    Power.SetValue("HibernateEnabled", "0", RegistryValueKind.DWord);

                    //Network throttling & System responsiveness
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile", true);
                    RegistryKey Response = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile", true);
                    Response.SetValue("NetworkThrottlingIndex", "ffffffff", RegistryValueKind.String);
                    Response.SetValue("SystemResponsiveness", "0", RegistryValueKind.DWord);

                    //MemoryOptimizations
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management", true);
                    RegistryKey MemTweaks = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management", true);
                    MemTweaks.SetValue("FeatureSettings", "1", RegistryValueKind.DWord);
                    MemTweaks.SetValue("FeatureSettingsOverrideMask", "3", RegistryValueKind.DWord);
                    MemTweaks.SetValue("FeatureSettingsOverride", "0", RegistryValueKind.DWord);
                    //Specifies the maximum amount of system VA space that can be used by the system cache.
                    MemTweaks.SetValue("SystemCacheLimit", "400", RegistryValueKind.DWord);

                    Registry.CurrentUser.CreateSubKey(@"S-1-5-19\Control Panel\Desktop", true);
                    RegistryKey MemTweaks2 = Registry.CurrentUser.OpenSubKey(@"S-1-5-19\Control Panel\Desktop", true);
                    MemTweaks2.SetValue("MenuShowDelay", "20", RegistryValueKind.DWord);

                    Registry.CurrentUser.CreateSubKey(@"S-1-5-20\Control Panel\Desktop", true);
                    RegistryKey MemTweaks3 = Registry.CurrentUser.OpenSubKey(@"S-1-5-20\Control Panel\Desktop", true);
                    MemTweaks3.SetValue("MenuShowDelay", "20", RegistryValueKind.DWord);

                    //Disable Variable Refresh Rate
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\DirectX\UserGpuPreferences", true);
                    RegistryKey VRR1 = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\DirectX\UserGpuPreferences", true);
                    VRR1.SetValue("DirectXUserGlobalSettings", "VRROptimizeEnable=0;", RegistryValueKind.String);

                    //Add TempCleaner To Startup
                    var programdatapath2 = GetFolderPath(SpecialFolder.CommonApplicationData);
                    string programFiles = Environment.ExpandEnvironmentVariables("%ProgramW6432%");
                    string programFilesX86 = Environment.ExpandEnvironmentVariables("%ProgramFiles(x86)%");
                    string WindowsLocation2 = Environment.GetEnvironmentVariable("SystemRoot");

                    string tempbat = Properties.Resources.TempCleaner;
                    System.IO.File.WriteAllText(WindowsLocation2 + "\\System32\\TempCleaner.bat", tempbat);
                    string tempvbs = Properties.Resources.TEMP22;
                    System.IO.File.WriteAllText(programdatapath2 + "\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp\\TempCleaner.vbs", tempvbs);

                    //BROWSERS TWEAKS
                    //Firefox Tweaks
                    if (System.IO.File.Exists(programFiles + "\\Mozilla Firefox\\firefox.exe"))
                    {
                        string fireuser = Properties.Resources.user;
                        System.IO.File.WriteAllText(programdatapath2 + "\\SodaScript\\user.js", fireuser);
                        var userfCommand = @"
                        $Data = ""$env:ProgramData\SodaScript""
			            $UserData = ""$env:AppData\Mozilla\Firefox\Profiles""
                        $Profiles = (Get-ChildItem -Path $UserData -Directory).Name
                        Foreach ($Profile in $Profiles) {
                            Copy-Item -Path ""$env:Temp\SodaScript\user.js"" -Destination ""$UserData\$Profile"" -Force
                        }
                        ";
                        var userfCommandBytes = System.Text.Encoding.Unicode.GetBytes(userfCommand);
                        var userfCommandBase64 = Convert.ToBase64String(userfCommandBytes);
                        Process processuserf = new Process();
                        ProcessStartInfo userfstartInfo = new ProcessStartInfo();
                        userfstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                        userfstartInfo.CreateNoWindow = true;
                        userfstartInfo.FileName = "powershell.exe";
                        userfstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {userfCommandBase64}";
                        userfstartInfo.Verb = "runas";
                        processuserf.StartInfo = userfstartInfo;
                        processuserf.Start();
                        processuserf.WaitForExit();
                    }
                    //Chrome Tweaks
                    if (System.IO.File.Exists(programFiles + "\\Google\\Chrome\\Application\\chrome.exe"))
                    {
                        var chrometwkCommand = @"
                        Remove-Item -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}' -Recurse
                        Remove-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'Google Update'
                        New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Google\Chrome' -Name 'StartupBoostEnabled' -Value 0 -PropertyType DWord -Force
                        New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Google\Chrome' -Name 'HardwareAccelerationModeEnabled' -Value 0 -PropertyType DWord -Force
                        New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Google\Chrome' -Name 'BackgroundModeEnabled' -Value 0 -PropertyType DWord -Force
                        Get-ScheduledTask -TaskName ""GoogleUpdateTask*"" | Disable-ScheduledTask
                        ";
                        var chrometwkCommandBytes = System.Text.Encoding.Unicode.GetBytes(chrometwkCommand);
                        var chrometwkCommandBase64 = Convert.ToBase64String(chrometwkCommandBytes);
                        Process processchrometwk = new Process();
                        ProcessStartInfo chrometwkstartInfo = new ProcessStartInfo();
                        chrometwkstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                        chrometwkstartInfo.CreateNoWindow = true;
                        chrometwkstartInfo.FileName = "powershell.exe";
                        chrometwkstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {chrometwkCommandBase64}";
                        chrometwkstartInfo.Verb = "runas";
                        processchrometwk.StartInfo = chrometwkstartInfo;
                        processchrometwk.Start();
                        processchrometwk.WaitForExit();
                    }
                    //Edge Tweaks
                    if (System.IO.File.Exists(programFilesX86 + "\\Microsoft\\Edge\\Application\\msedge.exe"))
                    {
                        var edgetwkCommand = @"
                        #disable (Edge) Prelaunch
                        reg add ""HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main"" /v AllowPrelaunch /t REG_DWORD /d ""0"" /f
                        reg add ""HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge"" /v StartupBoostEnabled /t REG_DWORD /d ""0"" /f
                        #LowerRam Usage
                        New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Value 0 -PropertyType DWord -Force
                        Remove-Item -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{9459C573-B17A-45AE-9F64-1857B5D58CEE}' -Recurse
                        Get-ScheduledTask -TaskName ""MicrosoftEdgeUpdate*"" -ea silentlyContinue | Disable-ScheduledTask
                        New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'StartupBoostEnabled' -Value 0 -PropertyType DWord -Force
                        New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'HardwareAccelerationModeEnabled' -Value 0 -PropertyType DWord -Force
                        New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Edge' -Name 'BackgroundModeEnabled' -Value 0 -PropertyType DWord -Force
                        ";
                        var edgetwkCommandBytes = System.Text.Encoding.Unicode.GetBytes(edgetwkCommand);
                        var edgetwkCommandBase64 = Convert.ToBase64String(edgetwkCommandBytes);
                        Process processedgetwk = new Process();
                        ProcessStartInfo edgetwkstartInfo = new ProcessStartInfo();
                        edgetwkstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                        edgetwkstartInfo.CreateNoWindow = true;
                        edgetwkstartInfo.FileName = "powershell.exe";
                        edgetwkstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {edgetwkCommandBase64}";
                        edgetwkstartInfo.Verb = "runas";
                        processedgetwk.StartInfo = edgetwkstartInfo;
                        processedgetwk.Start();
                        processedgetwk.WaitForExit();
                    }
                    if (windetector >= 22000)
                    {
                    // win11 Tweaks
                    string[] tomanual11 = {
                    "CDPSvc",
                    "RmSvc",
                    "TabletInputService"
                    };
                        foreach (string manual11 in tomanual11)
                        {
                            Process processman11 = new Process();
                            ProcessStartInfo startInfoman11 = new ProcessStartInfo();
                            startInfoman11.WindowStyle = ProcessWindowStyle.Hidden;
                            startInfoman11.CreateNoWindow = true;
                            startInfoman11.FileName = "sc.exe";
                            startInfoman11.Arguments = "config " + manual11 + " start= demand";
                            startInfoman11.Verb = "runas";
                            processman11.StartInfo = startInfoman11;
                            processman11.Start();
                        }
                        // Disable_Open_with_to_select_default_app_for_file_type_when_new_app_installed
                        Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Windows\Explorer", true);
                        RegistryKey new_app = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Windows\Explorer", true);
                        new_app.SetValue("NoNewAppAlert", "1", RegistryValueKind.DWord);

                        // Disable Show more options context menu
                        Registry.CurrentUser.CreateSubKey(@"Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", true);
                        RegistryKey RightClick_Menu = Registry.CurrentUser.OpenSubKey(@"Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32", true);
                        RightClick_Menu.SetValue("(Default)", "", RegistryValueKind.String);

                        // Show File Name Extensions
                        RegistryKey file_name = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", true);
                        file_name.SetValue("HideFileExt", "0", RegistryValueKind.DWord);

                        // Remove System requirements not met Watermark
                        Registry.CurrentUser.CreateSubKey(@"Control Panel\UnsupportedHardwareNotificationCache", true);
                        RegistryKey sys_requirement = Registry.CurrentUser.OpenSubKey(@"Control Panel\UnsupportedHardwareNotificationCache", true);
                        sys_requirement.SetValue("SV1", "0", RegistryValueKind.DWord);
                        sys_requirement.SetValue("SV2", "0", RegistryValueKind.DWord);
                    }
                    else
                    {
                    string[] todisabled11 = {
                    "CDPSvc",
                    "RmSvc",
                    "TabletInputService"
                    };
                        foreach (string disable11 in todisabled11)
                        {
                            Process processdis11 = new Process();
                            ProcessStartInfo startInfodis11 = new ProcessStartInfo();
                            startInfodis11.WindowStyle = ProcessWindowStyle.Hidden;
                            startInfodis11.CreateNoWindow = true;
                            startInfodis11.FileName = "sc.exe";
                            startInfodis11.Arguments = "config " + disable11 + " start= demand";
                            startInfodis11.Verb = "runas";
                            processdis11.StartInfo = startInfodis11;
                            processdis11.Start();
                        }
                    }
                    // Disable Sync Provider Notifications in File Explorer
                    RegistryKey syncprovider = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", true);
                    syncprovider.SetValue("ShowSyncProviderNotifications", "0", RegistryValueKind.DWord);

                    //DisableCloudContent
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Windows\CloudContent", true);
                    RegistryKey CloudContent = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Windows\CloudContent", true);
                    CloudContent.SetValue("DisableWindowsConsumerFeatures", "1", RegistryValueKind.DWord);
                    CloudContent.SetValue("DisableTailoredExperiencesWithDiagnosticData", "1", RegistryValueKind.DWord);
                    CloudContent.SetValue("DisableThirdPartySuggestions", "1", RegistryValueKind.DWord);
                    CloudContent.SetValue("DisableWindowsSpotlightOnSettings", "1", RegistryValueKind.DWord);
                    CloudContent.SetValue("DisableWindowsSpotlightOnActionCenter", "1", RegistryValueKind.DWord);
                    CloudContent.SetValue("DisableWindowsSpotlightWindowsWelcomeExperience", "1", RegistryValueKind.DWord);
                    CloudContent.SetValue("DisableWindowsSpotlightFeatures", "1", RegistryValueKind.DWord);
                    CloudContent.SetValue("IncludeEnterpriseSpotlight", "0", RegistryValueKind.DWord);
                    CloudContent.SetValue("ConfigureWindowsSpotlight", "2", RegistryValueKind.DWord);

                    //Disable Folder Contents Info
                    Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", true);
                    RegistryKey winadvanced = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", true);
                    winadvanced.SetValue("FolderContentsInfoTip", "0", RegistryValueKind.DWord);
                    winadvanced.SetValue("Start_TrackProgs", "0", RegistryValueKind.DWord);

                    //Disable automatic maintenance
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance", true);
                    RegistryKey maintenance = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance", true);
                    maintenance.SetValue("MaintenanceDisabled", "1", RegistryValueKind.DWord);

                    //Desktop Tweaks
                    Registry.CurrentUser.CreateSubKey(@"Control Panel\Desktop", true);
                    RegistryKey desktop1 = Registry.CurrentUser.OpenSubKey(@"Control Panel\Desktop", true);
                    desktop1.SetValue("MenuShowDelay", "20", RegistryValueKind.DWord);

                    // Disable Settings Header
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171", true);
                    RegistryKey header1 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\4095660171", true);
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835", true);
                    RegistryKey header2 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2674077835", true);
                    header1.SetValue("EnabledState", "1", RegistryValueKind.DWord);
                    header1.SetValue("EnabledStateOptions", "1", RegistryValueKind.DWord);
                    header1.SetValue("Variant", "0", RegistryValueKind.DWord);
                    header1.SetValue("VariantPayload", "0", RegistryValueKind.DWord);
                    header1.SetValue("VariantPayloadKind", "0", RegistryValueKind.DWord);
                    header2.SetValue("EnabledState", "1", RegistryValueKind.DWord);
                    header2.SetValue("EnabledStateOptions", "1", RegistryValueKind.DWord);
                    header2.SetValue("Variant", "0", RegistryValueKind.DWord);
                    header2.SetValue("VariantPayload", "0", RegistryValueKind.DWord);
                    header2.SetValue("VariantPayloadKind", "0", RegistryValueKind.DWord);

                    //Disable NTFS tunnelling
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\FileSystem", true);
                    RegistryKey ntfstunnel = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\FileSystem", true);
                    ntfstunnel.SetValue("MaximumTunnelEntries", "0", RegistryValueKind.DWord);
                    circularProgressBar1.Value = 50;
                    //Graphics card Tweaks
                    ManagementObjectSearcher searcher =
                    new ManagementObjectSearcher("SELECT * FROM Win32_DisplayConfiguration");

                    string graphicsCard = "";
                    foreach (ManagementObject mo in searcher.Get())
                    {
                        foreach (PropertyData property in mo.Properties)
                        {
                            if (property.Name == "Description")
                            {
                                graphicsCard += property.Value.ToString();
                            }
                        }
                    }
                    bool checkNvidaiCard = graphicsCard.Contains("NVIDIA");
                    if (checkNvidaiCard == true)
                    {
                        Registry.CurrentUser.CreateSubKey(@"Software\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color", true);
                        RegistryKey nvidia1 = Registry.CurrentUser.OpenSubKey(@"Software\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color", true);
                        nvidia1.SetValue("NvCplUseColorCorrection", "0", RegistryValueKind.DWord);
                        Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\GraphicsDrivers", true);
                        RegistryKey nvidia2 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\GraphicsDrivers", true);
                        nvidia2.SetValue("PlatformSupportMiracast", "0", RegistryValueKind.DWord);
                        Registry.LocalMachine.CreateSubKey(@"SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client", true);
                        RegistryKey nvidia3 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client", true);
                        nvidia3.SetValue("OptInOrOutPreference", "0", RegistryValueKind.DWord);
                        Registry.LocalMachine.CreateSubKey(@"SOFTWARE\NVIDIA Corporation\Global\FTS", true);
                        RegistryKey nvidia4 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\NVIDIA Corporation\Global\FTS", true);
                        nvidia4.SetValue("EnableRID44231", "0", RegistryValueKind.DWord);
                        nvidia4.SetValue("EnableRID64640", "0", RegistryValueKind.DWord);
                        nvidia4.SetValue("EnableRID66610", "0", RegistryValueKind.DWord);
                        Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS", true);
                        RegistryKey nvidia5 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client", true);
                        nvidia5.SetValue("EnableRID61684", "1", RegistryValueKind.DWord);
                        RegistryKey nvidia6 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Services\GpuEnergyDrv", true);
                        nvidia6.SetValue("Start", "4", RegistryValueKind.DWord);
                        RegistryKey nvidia7 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Services\GpuEnergyDr", true);
                        nvidia7.SetValue("Start", "4", RegistryValueKind.DWord);
                        Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler", true);
                        RegistryKey nvidia8 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler", true);
                        nvidia8.SetValue("EnablePreemption", "0", RegistryValueKind.DWord);
                        Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Services\NvTelemetryContainer", true);
                        RegistryKey nvidia9 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Services\NvTelemetryContainer", true);
                        nvidia9.SetValue("Start", "4", RegistryValueKind.DWord);
                        Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000", true);
                        RegistryKey nvidia10 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000", true);
                        nvidia10.SetValue("PowerMizerEnable", "1", RegistryValueKind.DWord);
                        nvidia10.SetValue("PowerMizerLevel", "1", RegistryValueKind.DWord);
                        nvidia10.SetValue("PowerMizerLevelAC", "1", RegistryValueKind.DWord);
                        nvidia10.SetValue("TCCSupported", "0", RegistryValueKind.DWord);
                        try
                        {
                            string nvidia11 = @"Software\Microsoft\Windows\CurrentVersion\Run";
                            using (RegistryKey nvidiakey11 = Registry.LocalMachine.OpenSubKey(nvidia11, true))
                            {
                                nvidiakey11.DeleteValue("NvBackend");
                            }
                        }
                        catch { }
                        byte[] nvidiainspector = Properties.Resources.nvidiaProfileInspector;
                        string nvtempPath = $"{Path.GetTempFileName()}.exe";
                        using (MemoryStream ms = new MemoryStream(nvidiainspector))
                        {
                            using (FileStream fs = new FileStream(nvtempPath, FileMode.OpenOrCreate))
                            {
                                ms.WriteTo(fs);
                                fs.Close();
                            }
                            ms.Close();
                        }
                        byte[] nvidiaprofile = Properties.Resources.Base_Profile;
                        string nv2tempPath = $"{Path.GetTempFileName()}.nip";
                        using (MemoryStream ms = new MemoryStream(nvidiaprofile))
                        {
                            using (FileStream fs = new FileStream(nv2tempPath, FileMode.OpenOrCreate))
                            {
                                ms.WriteTo(fs);
                                fs.Close();
                            }
                            ms.Close();
                        }
                        Process addnvidiaprofile = new Process();
                        ProcessStartInfo startInfonv = new ProcessStartInfo();
                        startInfonv.WindowStyle = ProcessWindowStyle.Hidden;
                        startInfonv.CreateNoWindow = true;
                        startInfonv.FileName = nvtempPath;
                        startInfonv.Arguments = nv2tempPath;
                        addnvidiaprofile.StartInfo = startInfonv;
                        addnvidiaprofile.Start();
                    }
                    circularProgressBar1.Value = 30;
                    bool checkAMDCard = graphicsCard.Contains("AMD");
                    if (checkAMDCard == true)
                    {
                        Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000", true);
                        RegistryKey AMD11 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000", true);
                        AMD11.SetValue("LTRSnoopL1Latency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("LTRSnoopL0Latency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("LTRNoSnoopL1Latency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("LTRMaxNoSnoopLatency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("KMD_RpmComputeLatency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("DalUrgentLatencyNs", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("memClockSwitchLatency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("PP_RTPMComputeF1Latency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("PP_DGBMMMaxTransitionLatencyUvd", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("PP_DGBPMMaxTransitionLatencyGfx", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("DalNBLatencyForUnderFlow", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("DalDramClockChangeLatencyNs", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("BGM_LTRSnoopL1Latency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("BGM_LTRSnoopL0Latency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("BGM_LTRNoSnoopL1Latency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("BGM_LTRNoSnoopL0Latency", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("BGM_LTRMaxSnoopLatencyValue", "1", RegistryValueKind.DWord);
                        AMD11.SetValue("BGM_LTRMaxNoSnoopLatencyValue", "1", RegistryValueKind.DWord);
                    }
                    bool checkIntelCard = graphicsCard.Contains("Intel");
                    if (checkIntelCard == true)
                    {
                        var intelgpuCommand = @"
                        $Memory = ((Get-WmiObject -Class ""Win32_PhysicalMemory"" | Measure-Object -Property Capacity -Sum).Sum) / 1024 / 1024
                            $RegItems2 = @(
		                    ""Enable4KDisplay""
		                    ""WideGamutFeatureEnable""
		                    ""XVYCCFeatureEnable""
		                    ""DeepColorHDMIDisable""
		                    ""Disable_OverlayDSQualityEnhancement""
		                    ""AllowDeepCStates""
		                    ""DelayedDetectionForDP""
		                    ""DelayedDetectionForHDMI""
	                    )
	                    $Intel2 = ""HKLM:\SYSTEM\ControlSet002\Control\Class\{4D36E968-E325-11CE-BFC1-08002BE10318}\0000""
	                    Foreach ($RegItem in $RegItems2) {
		                    IF (Get-ItemProperty -Path $Intel2 -Name $RegItem) {
			                    Set-ItemProperty -Path $Intel2 -Name $RegItem -Value 0 -Force
	                    }
	                    }
	                    $RegItems3 = @(
		                    ""InputYUVRangeApplyAlways""
		                    ""SharpnessEnabledAlways""
		                    ""NoiseReductionEnabledAlways""
		                    ""ProcAmpApplyAlways""
	                    )
	                    $Intel3 = ""HKCU:\Software\Intel\Display\igfxcui\Media""
	                    Foreach ($RegItem in $RegItems3) {
		                    IF (Get-ItemProperty -Path $Intel3 -Name $RegItem) {
			                    Set-ItemProperty -Path $Intel3 -Name $RegItem -Value 0 -Force
		                    }
	                    }
		
		                    $RegItems4 = @(
		                    ""ProcAmpApplyAlways""
		                    ""InputYUVRangeApplyAlways""
		                    ""SharpnessEnabledAlways""
		                    ""NoiseReductionEnabledAlways""
		                    ""ProcAmpApplyAlways""
		                    ""EnableTCC""
		                    ""EnableFMD""
		                    ""NoiseReductionEnableChroma""
		                    ""SharpnessEnabledAlways""
		                    ""UISharpnessOptimalEnabledAlways""
		                    ""EnableSTE""
		                    ""SkinTone""
		                    ""EnableACE""
		                    ""EnableNLAS""
		                    ""EnableIS""
		                    ""InputYUVRangeApplyAlways""
	                    )
	                    $Intel4 = ""HKLM:\Software\INTEL\Display\igfxcui\MediaKeys""
	                    Foreach ($RegItem in $RegItems4) {
		                    IF (Get-ItemProperty -Path $Intel4 -Name $RegItem) {
			                    Set-ItemProperty -Path $Intel4 -Name $RegItem -Value 0 -Force
	                    }
	                    }
		                    $IntelHDGraphicsVRAM = $Memory / 8
		                    $IntelGMM = ""HKLM:\SOFTWARE\Intel\GMM""
		                    If ((Test-Path $IntelGMM) -eq $false) {
			                    New-Item $IntelGMM -Force
		                    }
		                    Set-ItemProperty -Path $IntelGMM -Name DedicatedSegmentSize -Value $IntelHDGraphicsVRAM
		                    $Services2 = ""HKLM:\SYSTEM\CurrentControlSet\services""
		                    Set-ItemProperty $Services2\""igfxCUIService1.0.0.0"" Start -Value 3 -Force
		                    Set-ItemProperty $Services2\ICCS Start -Value 4 -Force
		                    Set-ItemProperty $Services2\cphs Start -Value 4 -Force
		
                        ";
                        var intelgpuCommandBytes = System.Text.Encoding.Unicode.GetBytes(intelgpuCommand);
                        var intelgpuCommandBase64 = Convert.ToBase64String(intelgpuCommandBytes);
                        Process processintelgpu = new Process();
                        ProcessStartInfo intelgpustartInfo = new ProcessStartInfo();
                        intelgpustartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                        intelgpustartInfo.CreateNoWindow = true;
                        intelgpustartInfo.FileName = "powershell.exe";
                        intelgpustartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {intelgpuCommandBase64}";
                        intelgpustartInfo.Verb = "runas";
                        processintelgpu.StartInfo = intelgpustartInfo;
                        processintelgpu.Start();
                        processintelgpu.WaitForExit();
                    }
                    var MoreTweaksCommand = @"
			        #Remove Steam From Startup
                        Remove-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'Steam' -ErrorAction SilentlyContinue

                    #Hide MoveTo & CopyTo From Right Click Menu
                        Remove-Item -Path ""HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To"" -Recurse -ErrorAction SilentlyContinue
			            Remove-Item -Path ""HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To"" -Recurse -ErrorAction SilentlyContinue

			            Remove-Item -Path ""HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions"" -Recurse -ErrorAction SilentlyContinue
			            Remove-Item -Path ""HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps"" -Recurse -ErrorAction SilentlyContinue

			        #Hide Music icon from This PC
			            Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}"" -Recurse -ErrorAction SilentlyContinue
			            Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}"" -Recurse -ErrorAction SilentlyContinue
			        #Hide Pictures icon from This PC
			            Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}"" -Recurse -ErrorAction SilentlyContinue
			            Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}"" -Recurse -ErrorAction SilentlyContinue
			        #Hide Videos icon from This PC
			            Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"" -Recurse -ErrorAction SilentlyContinue
			            Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}"" -Recurse -ErrorAction SilentlyContinue
			        #Hide 3D Objects icon from This PC
			            Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"" -Recurse -ErrorAction SilentlyContinue
			
			        #Remove Edit With Paint 3D
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.3mf\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.bmp\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.fbx\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.gif\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.jfif\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.jpe\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.jpeg\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.jpg\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.png\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.tif\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			            Remove-Item -LiteralPath ""HKCR:\SystemFileAssociations\.tiff\Shell\3D Edit"" -force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
			        
                    #don't add -shortcut when creating a shortcut
                        reg add ""HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"" / v ""link"" / t REG_BINARY / d ""00000000"" / f | Out - Null
					
				    #Disable Services from Registry
					    $Services = ""HKLM:\SYSTEM\CurrentControlSet\services""
						    Set-ItemProperty $Services\Ndu Start -Value 4 -Force
						    Set-ItemProperty $Services\MMCSS Start -Value 4 -Force
						    Set-ItemProperty $Services\GpuEnergyDrv Start -Value 4 -Force
						    Set-ItemProperty $Services\""Origin Web Helper Service"" Start -Value 4 -Force -ea SilentlyContinue
						    Set-ItemProperty $Services\AppXSvc Start -Value 3 -Force
						    Set-ItemProperty $Services\iaStorAVC\Parameters IoLatencyCap -Value 0 -Force
						    Set-ItemProperty $Services\cbdhsvc Start -Value 3 -Force
						    Set-ItemProperty $Services\UsoSvc DelayedAutoStart -Value 0 -Force
						    Set-ItemProperty $Services\UsoSvc Start -Value 3 -Force
				    #Change Windows Feedback Frequency to Never-Feedback_Frequency
					    New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -Value 0 -PropertyType DWord -Force
				    # FIX Devices are not working before you log in
					    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\FVE' -Name 'DisableExternalDMAUnderLock' -Value 0 -PropertyType DWord -Force
                    # Enable Hardware Accelerated GPU Scheduling
				    IF (Get-ItemProperty -Path ""HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"" -Name ""HwSchMode"") {
						    Set-ItemProperty -Path ""HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"" -Name ""HwSchMode"" -Value 2
					    }

                    #Turn Off Night Light (So if it breaks, it will not stay on the Night Light forever XD)
                    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$$windows.data.bluelightreduction.bluelightreductionstate\Current /v Data /t REG_BINARY /d 0200000088313cdb4584d4010000000043420100d00a02c614dabef0d9dd88a1ea0100 /f

				    ";
                    var MoreCommandBytes = System.Text.Encoding.Unicode.GetBytes(MoreTweaksCommand);
                    var MoreCommandBase64 = Convert.ToBase64String(MoreCommandBytes);
                    Process processMore = new Process();
                    ProcessStartInfo MorestartInfo = new ProcessStartInfo();
                    MorestartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    MorestartInfo.CreateNoWindow = true;
                    MorestartInfo.FileName = "powershell.exe";
                    MorestartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {MoreCommandBase64}";
                    MorestartInfo.Verb = "runas";
                    processMore.StartInfo = MorestartInfo;
                    processMore.Start();
                    processMore.WaitForExit();
                    //Disable cached logon for privacy & security
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", true);
                    RegistryKey cachedlogon = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", true);
                    cachedlogon.SetValue("CachedLogonsCount", "0", RegistryValueKind.DWord);

                    //Disable Background Apps
                    Registry.LocalMachine.CreateSubKey(@"Software\Policies\Microsoft\Windows\AppPrivacy", true);
                    RegistryKey backgroundapps = Registry.LocalMachine.OpenSubKey(@"Software\Policies\Microsoft\Windows\AppPrivacy", true);
                    backgroundapps.SetValue("LetAppsRunInBackground", "2", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications", true);
                    RegistryKey backgroundapps2 = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications", true);
                    backgroundapps2.SetValue("GlobalUserDisabled", "1", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Search", true);
                    RegistryKey backgroundapps3 = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Search", true);
                    backgroundapps3.SetValue("BackgroundAppGlobalToggle", "0", RegistryValueKind.DWord);

                    //Disable Shortcut Arrows
                    string WindowsLocation = Environment.GetEnvironmentVariable("SystemRoot");
                    if (System.IO.File.Exists(WindowsLocation + "\\System32\\blank.ico"))
                    { }
                    else
                    {
                        Icon icon = Properties.Resources.transparent;
                        Stream IconStream1 = System.IO.File.OpenWrite(WindowsLocation + "\\System32\\" + "transparent.ico");
                        icon.Save(IconStream1);
                        Icon icon2 = Properties.Resources.blank;
                        Stream IconStream2 = System.IO.File.OpenWrite(WindowsLocation + "\\System32\\" + "blank.ico");
                        icon2.Save(IconStream2);
                        var shortarrowsCommand = @"
                        if((Test-Path -LiteralPath ""HKLM:\SOFTWARE\Classes\IE.AssocFile.URL"") -ne $true) {  New-Item ""HKLM:\SOFTWARE\Classes\IE.AssocFile.URL"" -force | Out-Null };
	                    if((Test-Path -LiteralPath ""HKLM:\SOFTWARE\Classes\InternetShortcut"") -ne $true) {  New-Item ""HKLM:\SOFTWARE\Classes\InternetShortcut"" -force | Out-Null };
	                    if((Test-Path -LiteralPath ""HKLM:\SOFTWARE\Classes\lnkfile"") -ne $true) {  New-Item ""HKLM:\SOFTWARE\Classes\lnkfile"" -force | Out-Null };
	                    if((Test-Path -LiteralPath ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"") -ne $true) {  New-Item ""HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"" -force | Out-Null };
	                    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\IE.AssocFile.URL' -Name 'IsShortcut' -Value '' -PropertyType String -Force | Out-Null
	                    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\InternetShortcut' -Name 'IsShortcut' -Value '' -PropertyType String -Force | Out-Null
	                    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\lnkfile' -Name 'IsShortcut' -Value '' -PropertyType String -Force | Out-Null
	                    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons' -Name '29' -Value '%windir%\System32\blank.ico' -PropertyType String -Force | Out-Null
	                    ";
                        var shortarrowsCommandBytes = System.Text.Encoding.Unicode.GetBytes(shortarrowsCommand);
                        var shortarrowsCommandBase64 = Convert.ToBase64String(shortarrowsCommandBytes);
                        Process processshortarrows = new Process();
                        ProcessStartInfo startInfoshortarrows = new ProcessStartInfo();
                        startInfoshortarrows.WindowStyle = ProcessWindowStyle.Hidden;
                        startInfoshortarrows.CreateNoWindow = true;
                        startInfoshortarrows.FileName = "powershell.exe";
                        startInfoshortarrows.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {shortarrowsCommandBase64}";
                        startInfoshortarrows.Verb = "runas";
                        processshortarrows.StartInfo = startInfoshortarrows;
                        processshortarrows.Start();
                        processshortarrows.WaitForExit();
                    }
                    //Fix Mouse Delay
                    var MouseCommand = @"
                    $time = Get-Date -Format ""yyyy-MM-dd---HH.mm""
                    Start-Transcript -Path $env:ProgramData\SodaScript\MouseTweaks-$time.log| Out-Null
			        #DecreaseMouseDelay
				    if((Test-Path -LiteralPath ""HKCU:\Control Panel\Mouse"") -ne $true) {  New-Item ""HKCU:\Control Panel\Mouse"" -force };
				    if((Test-Path -LiteralPath ""HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"") -ne $true) {  New-Item ""HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism"" -force };
				    if((Test-Path -LiteralPath ""HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed"") -ne $true) {  New-Item ""HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed"" -force };
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'ActiveWindowTracking' -Value 0 -PropertyType DWord -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'Beep' -Value 'No' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'DoubleClickHeight' -Value '4' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'DoubleClickWidth' -Value '4' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'ExtendedSounds' -Value 'No' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseHoverHeight' -Value '4' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseHoverWidth' -Value '4' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseSensitivity' -Value '10' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseTrails' -Value '0' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'SnapToDefaultButton' -Value '0' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'SwapMouseButtons' -Value '0' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -Value '0' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -Value '0' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -Value '0' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'DoubleClickSpeed' -Value '550' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseHoverTime' -Value '8' -PropertyType String -Force
				    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'AttractionRectInsetInDIPS' -Value 5 -PropertyType DWord -Force
				    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'DistanceThresholdInDIPS' -Value 40 -PropertyType DWord -Force
				    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'MagnetismDelayInMilliseconds' -Value 50 -PropertyType DWord -Force
				    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'MagnetismUpdateIntervalInMilliseconds' -Value 16 -PropertyType DWord -Force
				    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism' -Name 'VelocityInDIPSPerSecond' -Value 360 -PropertyType DWord -Force
				    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'CursorSensitivity' -Value 10000 -PropertyType DWord -Force
				    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'CursorUpdateInterval' -Value 1 -PropertyType DWord -Force
				    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed' -Name 'IRRemoteNavigationDelta' -Value 1 -PropertyType DWord -Force
				    $Mouse2 = ""HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters""
				    if((Test-Path -LiteralPath $Mouse2) -ne $true) {  New-Item $Mouse2 -force };
					    Set-ItemProperty $Mouse2 MouseDataQueueSize -Value 32 -Force
				    $Mouse3 = ""HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism""
				    if((Test-Path -LiteralPath $Mouse3) -ne $true) {  New-Item $Mouse3 -force };
					    Set-ItemProperty $Mouse3 AttractionRectInsetInDIPS -Value 5 -Force
					    Set-ItemProperty $Mouse3 DistanceThresholdInDIPS -Value 28 -Force
					    Set-ItemProperty $Mouse3 MagnetismDelayInMilliseconds -Value 32 -Force
					    Set-ItemProperty $Mouse3 MagnetismUpdateIntervalInMilliseconds -Value 10 -Force
					    Set-ItemProperty $Mouse3 VelocityInDIPSPerSecond -Value 168 -Force
				    $Mouse4 = ""HKLM:\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed""
				    if((Test-Path -LiteralPath $Mouse4) -ne $true) {  New-Item $Mouse4 -force };
					    Set-ItemProperty $Mouse4 CursorSensitivity -Value 2710 -Force
					    Set-ItemProperty $Mouse4 CursorUpdateInterval -Value 1 -Force
					    Set-ItemProperty $Mouse4 IRRemoteNavigationDelta -Value 1 -Force
                    ";
                    var MouseCommandBytes = System.Text.Encoding.Unicode.GetBytes(MouseCommand);
                    var MouseCommandBase64 = Convert.ToBase64String(MouseCommandBytes);
                    Process processmouse = new Process();
                    ProcessStartInfo startInfomouse = new ProcessStartInfo();
                    startInfomouse.WindowStyle = ProcessWindowStyle.Hidden;
                    startInfomouse.CreateNoWindow = true;
                    startInfomouse.FileName = "powershell.exe";
                    startInfomouse.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {MouseCommandBase64}";
                    startInfomouse.Verb = "runas";
                    processmouse.StartInfo = startInfomouse;
                    processmouse.Start();
                    processmouse.WaitForExit();
                    //FixKeyBoard Delay
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Services\kbdclass\Parameters", true);
                    RegistryKey keyboard1 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Services\kbdclass\Parameters", true);
                    keyboard1.SetValue("KeyboardDataQueueSize", "32", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"Control Panel\Keyboard", true);
                    RegistryKey keyboard2 = Registry.CurrentUser.OpenSubKey(@"Control Panel\Keyboard", true);
                    keyboard2.SetValue("InitialKeyboardIndicators", "0", RegistryValueKind.DWord);
                    keyboard2.SetValue("KeyboardDelay", "0", RegistryValueKind.DWord);

                    //Steam Tweaks
                    RegistryKey Steamm = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Valve\Steam", true);
                    Steamm.SetValue("SmoothScrollWebViews", "0", RegistryValueKind.DWord);
                    Steamm.SetValue("DWriteEnable", "0", RegistryValueKind.DWord);
                    Steamm.SetValue("StartupMode", "0", RegistryValueKind.DWord);
                    Steamm.SetValue("H264HWAccel", "0", RegistryValueKind.DWord);
                    Steamm.SetValue("DPIScaling", "0", RegistryValueKind.DWord);
                    Steamm.SetValue("GPUAccelWebViews", "0", RegistryValueKind.DWord);

                    //Decrease BootTime
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize", true);
                    RegistryKey Boottime = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize", true);
                    Boottime.SetValue("StartupDelayInMSec", "0", RegistryValueKind.DWord);

                    //Activate Windows Photo Viewer
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations", true);
                    RegistryKey oldphotoviewer = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations", true);
                    oldphotoviewer.SetValue(".tif", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".tiff", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".bmp", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".dib", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".jfif", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".jpe", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".jpeg", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".jpg", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".jxr", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);
                    oldphotoviewer.SetValue(".png", "PhotoViewer.FileAssoc.Tiff", RegistryValueKind.String);

                    //Disable Show me suggested content in the settings app.
                    //Disable Show me the windows welcome experience after updates.
                    //Disable Show suggestions in start.
                    //Disable Auto installation of unnecessary bloatware.
                    //Disable Get fun facts and tips, etc. on lock screen.
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", true);
                    RegistryKey Dilevery2 = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager", true);
                    Dilevery2.SetValue("ContentDeliveryAllowed", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("OemPreInstalledAppsEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("PreInstalledAppsEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("PreInstalledAppsEverEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SilentInstalledAppsEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SoftLandingEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContentEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("FeatureManagementEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SystemPaneSuggestionsEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("RemediationRequired", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContent-338393Enabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContent-353694Enabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContent-353696Enabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContent-338387Enabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContent-338389Enabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContent-310093Enabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContent-338388Enabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("SubscribedContent-314563Enabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("RotatingLockScreenOverlayEnabled", "0", RegistryValueKind.DWord);
                    Dilevery2.SetValue("RotatingLockScreenEnabled", "0", RegistryValueKind.DWord);
                    circularProgressBar1.Value = 50;
                    //Disable Application Impact Telemetry
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Windows\AppCompat", true);
                    RegistryKey tlmtry2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Windows\AppCompat", true);
                    tlmtry2.SetValue("AITEnable", "0", RegistryValueKind.DWord);

                    //Disable check disk on boot 
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\Session Manager", true);
                    RegistryKey chkonboot = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\Session Manager", true);
                    chkonboot.SetValue("AutoChkTimeout", "0", RegistryValueKind.DWord);
                    chkonboot.SetValue("AutoChkSkipSystemPartition", "0", RegistryValueKind.DWord);

                    //WindowsUpdates & Disable Delivery Optimization
                    Registry.LocalMachine.CreateSubKey(@"Software\Policies\Microsoft\Windows\WindowsUpdate\AU", true);
                    RegistryKey winnupdates = Registry.LocalMachine.OpenSubKey(@"Software\Policies\Microsoft\Windows\WindowsUpdate\AU", true);
                    winnupdates.SetValue("NoAutoUpdate", "1", RegistryValueKind.DWord);
                    //Disable Windows Update automatic restart
                    winnupdates.SetValue("NoAutoRebootWithLoggedOnUsers", "1", RegistryValueKind.DWord);
                    winnupdates.SetValue("AUPowerManagement", "0", RegistryValueKind.DWord);
                    //DeliveryOptimization
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings", true);
                    RegistryKey delivry = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings", true);
                    delivry.SetValue("DownloadMode", "0", RegistryValueKind.DWord);
                    delivry.SetValue("DODownloadMode", "0", RegistryValueKind.DWord);
                    delivry.SetValue("SystemSettingsDownloadMode", "0", RegistryValueKind.DWord);
                    //Disable AutoStore Updates
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate", true);
                    RegistryKey store = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate", true);
                    store.SetValue("AutoDownload", "2", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\WindowsStore", true);
                    RegistryKey store2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\WindowsStore", true);
                    store2.SetValue("AutoDownload", "2", RegistryValueKind.DWord);

                    //DisableAutomatic Update Maps
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\Maps", true);
                    RegistryKey mapsupdate = Registry.LocalMachine.OpenSubKey(@"SYSTEM\Maps", true);
                    mapsupdate.SetValue("AutoUpdateEnabled", "0", RegistryValueKind.DWord);

                    //FileSystem
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\ControlSet001\Control\FileSystem", true);
                    RegistryKey filesys1 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\ControlSet001\Control\FileSystem", true);
                    filesys1.SetValue("RefsDisableLastAccessUpdate", "1", RegistryValueKind.DWord);
                    filesys1.SetValue("NtfsDisableLastAccessUpdate", "1", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\FileSystem", true);
                    RegistryKey filesys2 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\FileSystem", true);
                    filesys2.SetValue("RefsDisableLastAccessUpdate", "1", RegistryValueKind.DWord);
                    filesys2.SetValue("NtfsDisableLastAccessUpdate", "1", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Windows\System", true);
                    RegistryKey system1 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Windows\System", true);
                    //Disable ActiveHistory
                    system1.SetValue("PublishUserActivities", "0", RegistryValueKind.DWord);
                    system1.SetValue("UploadUserActivities", "0", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Search", true);
                    RegistryKey History2 = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Search", true);
                    History2.SetValue("DeviceHistoryEnabled", "0", RegistryValueKind.DWord);
                    //Disable Shared Experiences
                    system1.SetValue("EnableCdp", "0", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", true);
                    RegistryKey system2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", true);
                    //Disable secure desktop during UAC request
                    system2.SetValue("PromptOnSecureDesktop", "0", RegistryValueKind.DWord);
                    //SpeedUp startup time
                    system2.SetValue("DelayedDesktopSwitchTimeout", "0", RegistryValueKind.DWord);

                    //DisableBingSearch&Cortana
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Windows\Windows Search", true);
                    RegistryKey cortana = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Windows\Windows Search", true);
                    cortana.SetValue("AllowCortana", "0", RegistryValueKind.DWord);
                    cortana.SetValue("BingSearchEnabled", "0", RegistryValueKind.DWord);
                    cortana.SetValue("CortanaConsent", "0", RegistryValueKind.DWord);
                    cortana.SetValue("BackgroundAppGlobalToggle", "0", RegistryValueKind.DWord);
                    cortana.SetValue("AllowCloudSearch", "0", RegistryValueKind.DWord);

                    //No LockScreen
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Personalization", true);
                    RegistryKey lockscrenn = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Personalization", true);
                    lockscrenn.SetValue("NoLockScreen", "1", RegistryValueKind.DWord);

                    //Change default Explorer view to This PC
                    Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", true);
                    RegistryKey winadvanced2 = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", true);
                    winadvanced2.SetValue("LaunchTo", "1", RegistryValueKind.DWord);

                    //Hide recently and frequently used item shortcuts in Explorer
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", true);
                    RegistryKey explorerrr = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", true);
                    explorerrr.SetValue("ShowRecent", "0", RegistryValueKind.DWord);
                    explorerrr.SetValue("ShowFrequent", "0", RegistryValueKind.DWord);
                    explorerrr.SetValue("ShowCloudFilesInQuickAccess", "0", RegistryValueKind.DWord);

                    //Show Desktop icon in This PC
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}", true);

                    //Show BSoD Details instead of sad face :(
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\CrashControl", true);
                    RegistryKey crashbsod = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\CrashControl", true);
                    crashbsod.SetValue("DisplayParameters", "1", RegistryValueKind.DWord);

                    //ExplorerTweaks
                    Registry.LocalMachine.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", true);
                    RegistryKey explorer1 = Registry.LocalMachine.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", true);
                    explorer1.SetValue("NoInstrumentation", "1", RegistryValueKind.DWord);
                    explorer1.SetValue("DisableThumbnails", "-", RegistryValueKind.String);

                    Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", true);
                    RegistryKey explorer2 = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Policies\Explorer", true);
                    explorer2.SetValue("NoInstrumentation", "1", RegistryValueKind.DWord);
                    explorer2.SetValue("DisableThumbnails", "-", RegistryValueKind.String);

                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers", true);
                    RegistryKey explorer3 = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers", true);
                    explorer3.SetValue("DisableAutoplay", "1", RegistryValueKind.DWord);

                    //ExplorerPreferences
                    winadvanced.SetValue("ShowSyncProviderNotifications", "0", RegistryValueKind.DWord);
                    winadvanced.SetValue("Start_TrackDocs", "0", RegistryValueKind.DWord);
                    winadvanced.SetValue("EnableBalloonTips", "0", RegistryValueKind.DWord);
                    winadvanced.SetValue("ExtendedUIHoverTime", "1", RegistryValueKind.DWord);

                    //Disable Folder Thumbnails
                    Registry.CurrentUser.CreateSubKey(@"Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell", true);
                    RegistryKey folderthumb = Registry.CurrentUser.OpenSubKey(@"Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell", true);
                    folderthumb.SetValue("Logo", "d:\\some22file233333.jpg", RegistryValueKind.String);

                    //PrivacySettings
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy", true);
                    RegistryKey privacy1 = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy", true);
                    privacy1.SetValue("HasAccepted", "0", RegistryValueKind.DWord);

                    string[] denylist = {
                    "radios",
                    "appDiagnostics",
                    "documentsLibrary",
                    "picturesLibrary",
                    "videosLibrary",
                    "broadFileSystemAccess",
                    "chat",
                    "contacts",
                    "phoneCall",
                    "appointments",
                    "phoneCallHistory",
                    "email",
                    "userDataTasks"
                    };

                    foreach (string privacysetting in denylist)
                    {
                        Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\" + privacysetting, true);
                        RegistryKey privacy2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\" + privacysetting, true);
                        privacy2.SetValue("Value", "Deny", RegistryValueKind.String);
                    }

                    //HideSomeSettings in SettingsApp
                    if (windetector >= 22000) { }
                    else
                    {
                        Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer", true);
                        RegistryKey HideSettings = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer", true);
                        HideSettings.SetValue("SettingsPageVisibility", "hide:quiethours;project;crossdevice;remotedesktop;pen;autoplay;;mobile-devices;network-status;datausage;maps;;search-permissions;cortana-windowssearch;search-moredetails;privacy-activityhistory;findmydevice;windowsinsider;;holographic-audio;privacy-holographic-environment;holographic-headset;holographic-management;", RegistryValueKind.String);
                    }

                    //Disable Hibernation
                    Registry.LocalMachine.CreateSubKey(@"System\CurrentControlSet\Control\Session Manager\Power", true);
                    RegistryKey Hibernation1 = Registry.LocalMachine.OpenSubKey(@"System\CurrentControlSet\Control\Session Manager\Power", true);
                    Hibernation1.SetValue("HibernteEnabled", "0", RegistryValueKind.DWord);
                    Hibernation1.SetValue("HiberbootEnabled", "0", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings", true);
                    RegistryKey Hibernation2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings", true);
                    Hibernation2.SetValue("ShowHibernateOption", "0", RegistryValueKind.DWord);

                    //DisableTelemetry
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Windows\DataCollection", true);
                    RegistryKey telmetry1 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Windows\DataCollection", true);
                    telmetry1.SetValue("AllowTelemetry", "0", RegistryValueKind.DWord);
                    telmetry1.SetValue("AllowDeviceNameInTelemetry", "0", RegistryValueKind.DWord);

                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection", true);
                    RegistryKey telmetry2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection", true);
                    telmetry2.SetValue("AllowTelemetry", "0", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo", true);
                    RegistryKey telmetry3 = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo", true);
                    telmetry3.SetValue("Enabled", "0", RegistryValueKind.DWord);
                    telmetry3.SetValue("DisabledByGroupPolicy", "1", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection", true);
                    RegistryKey telmetry4 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection", true);
                    telmetry4.SetValue("AllowTelemetry", "0", RegistryValueKind.DWord);
                    telmetry4.SetValue("MaxTelemetryAllowed", "0", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"Control Panel\International\User Profile", true);
                    RegistryKey telmetry5 = Registry.CurrentUser.OpenSubKey(@"Control Panel\International\User Profile", true);
                    telmetry5.SetValue("HttpAcceptLanguageOptOut", "1", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack", true);
                    RegistryKey telmetry6 = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack", true);
                    telmetry6.SetValue("ShowedToastAtLevel", "1", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy", true);
                    RegistryKey telmetry7 = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy", true);
                    telmetry7.SetValue("TailoredExperiencesWithDiagnosticDataEnabled", "0", RegistryValueKind.DWord);

                    //Disable Automatic Backup
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager", true);
                    RegistryKey autobackup = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager", true);
                    autobackup.SetValue("EnablePeriodicBackup", "0", RegistryValueKind.DWord);

                    //DisableWindowsErrorReporting
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\Windows Error Reporting", true);
                    RegistryKey winreport = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\Windows Error Reporting", true);
                    winreport.SetValue("Disabled", "1", RegistryValueKind.DWord);
                    winreport.SetValue("DontSendAdditionalData", "1", RegistryValueKind.DWord);
                    winreport.SetValue("LoggingDisabled", "1", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports", true);
                    RegistryKey winreport2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports", true);
                    winreport2.SetValue("PreventHandwritingErrorReports", "1", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting", true);
                    RegistryKey winreport3 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting", true);
                    winreport3.SetValue("DoReport", "0", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"Software\Policies\Microsoft\Windows\Windows Error Reporting", true);
                    RegistryKey winreport4 = Registry.LocalMachine.OpenSubKey(@"Software\Policies\Microsoft\Windows\Windows Error Reporting", true);
                    winreport4.SetValue("Disabled", "1", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Services\WerSvc", true);
                    RegistryKey winreport5 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Services\WerSvc", true);
                    winreport5.SetValue("Start", "4", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SYSTEM\CurrentControlSet\Services\wercplsupport", true);
                    RegistryKey winreport6 = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Services\wercplsupport", true);
                    winreport6.SetValue("Start", "4", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"Software\WOW6432Node\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting", true);
                    RegistryKey winreport7 = Registry.LocalMachine.OpenSubKey(@"Software\WOW6432Node\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting", true);
                    winreport7.SetValue("value", "0", RegistryValueKind.DWord);

                    //Disable GetImage Descriptions, Page Titles And Popular Links
                    Registry.CurrentUser.CreateSubKey(@"SOFTWARE\Microsoft\Narrator\NoRoam", true);
                    RegistryKey Image1 = Registry.CurrentUser.OpenSubKey(@"SOFTWARE\Microsoft\Narrator\NoRoam", true);
                    Image1.SetValue("OnlineServicesEnabled", "0", RegistryValueKind.DWord);
                    //Ping & PacketLoss Tweaks
					var pingCommand = @"
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

	                    $Latency = ""HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider""
	                    if((Test-Path -LiteralPath $Latency) -ne $true) {  New-Item $Latency -force };
		                    Set-ItemProperty $Latency Class -Value 8 -Force
		                    Set-ItemProperty $Latency LocalPriority -Value 4 -Force
		                    Set-ItemProperty $Latency HostsPriority -Value 5 -Force
		                    Set-ItemProperty $Latency DnsPriority -Value 6 -Force
		                    Set-ItemProperty $Latency NetbtPriority -Value 7 -Force
	                    
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
                    ";
                    var pingCommandBytes = System.Text.Encoding.Unicode.GetBytes(pingCommand);
                    var pingCommandBase64 = Convert.ToBase64String(pingCommandBytes);
                    Process processping = new Process();
                    ProcessStartInfo pingstartInfo = new ProcessStartInfo();
                    pingstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    pingstartInfo.CreateNoWindow = true;
                    pingstartInfo.FileName = "powershell.exe";
                    pingstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {pingCommandBase64}";
                    pingstartInfo.Verb = "runas";
                    processping.StartInfo = pingstartInfo;
                    processping.Start();
                    processping.WaitForExit();
                    var ping2Command = @"
                    $NetworkAdapter = Get-NetAdapter | Where-Object {$_.Name -like ""Ethernet""}
	                $DriverKey = (Get-WmiObject -Class Win32_PnPEntity | Where-Object {$_.Name -eq $NetworkAdapter.InterfaceDescription}).ClassGuid
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
                        ""*JumboPacket""
                        ""*LsoV2IPv4""
                        ""*LsoV2IPv6""
                        ""PowerDownPll""
                        ""PowerSavingMode""  
                        ""ReduceSpeedOnPowerDown""
                        ""S5NicKeepOverrideMacAddrV2""
                        ""S5WakeOnLan""
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
		                    Set-ItemProperty -Path $Latency15 -Name ""*ReceiveBuffers"" -Value 512 -Force
	                    }
	                    IF (Get-ItemProperty -Path $Latency15 -Name ""*TransmitBuffers"") {
		                    Set-ItemProperty -Path $Latency15 -Name ""*TransmitBuffers"" -Value 512 -Force
	                    }
	                    IF (Get-ItemProperty -Path $Latency15 -Name ""WolShutdownLinkSpeed"") {
		                    Set-ItemProperty -Path $Latency15 -Name ""WolShutdownLinkSpeed"" -Value 2 -Force
	                    }
                    }
                    ";
                    var ping2CommandBytes = System.Text.Encoding.Unicode.GetBytes(ping2Command);
                    var ping2CommandBase64 = Convert.ToBase64String(ping2CommandBytes);
                    Process processping2 = new Process();
                    ProcessStartInfo ping2startInfo = new ProcessStartInfo();
                    ping2startInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    ping2startInfo.CreateNoWindow = true;
                    ping2startInfo.FileName = "powershell.exe";
                    ping2startInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {ping2CommandBase64}";
                    ping2startInfo.Verb = "runas";
                    processping2.StartInfo = ping2startInfo;
                    processping2.Start();
                    processping2.WaitForExit();
                }
                circularProgressBar1.Value = 70;
                if (compplayerBOX.Checked)
                {
                    COMP_Tweaks();
                }
                if (dispowersaveBOX.Checked)
                {
                    var savepowerCommand = @"
                    $devicesUSB = Get-PnpDevice | where {$_.InstanceId -like ""*USB\ROOT*""}  | 
                    ForEach-Object -Process {
                    Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi 
                    }

                    foreach ( $device in $devicesUSB )
                    {
                        Set-CimInstance -Namespace root\wmi -Query ""SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE '%$($device.PNPDeviceID)%'"" -Property @{Enable=$False} -PassThru
                    }

                    $adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement
                        foreach ($adapter in $adapters)
                            {
                            $adapter.AllowComputerToTurnOffDevice = 'Disabled'
                            $adapter | Set-NetAdapterPowerManagement
                            }
                    if((Test-Path -LiteralPath ""HKLM:\SYSTEM\CurrentControlSet\Services\USB"") -ne $true) {  New-Item ""HKLM:\SYSTEM\CurrentControlSet\Services\USB"" -force | Out-Null };
                    New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\USB' -Name 'DisableSelectiveSuspend' -Value 1 -PropertyType DWord -Force | Out-Null
                    ";
                    var savepowerCommandBytes = System.Text.Encoding.Unicode.GetBytes(savepowerCommand);
                    var savepowerCommandBase64 = Convert.ToBase64String(savepowerCommandBytes);
                    Process processsavepower = new Process();
                    ProcessStartInfo savepowerstartInfo = new ProcessStartInfo();
                    savepowerstartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    savepowerstartInfo.CreateNoWindow = true;
                    savepowerstartInfo.FileName = "powershell.exe";
                    savepowerstartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {savepowerCommandBase64}";
                    savepowerstartInfo.Verb = "runas";
                    processsavepower.StartInfo = savepowerstartInfo;
                    processsavepower.Start();
                    processsavepower.WaitForExit();
                }
                circularProgressBar1.Value = 80;
                if (InputExperianceBOX.Checked)
                {
                    if (windetector >= 22000){
                        var inputexperianceCommand = @"
                      Stop-Process -name TextInputHost -ea silentlyContinue | Out-Null
                      Remove-Item 'C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy' -Recurse -force -ea silentlycontinue
                        ";
                        var inputexperianceCommandBytes = System.Text.Encoding.Unicode.GetBytes(inputexperianceCommand);
                        var inputexperianceCommandBase64 = Convert.ToBase64String(inputexperianceCommandBytes);
                        Process processinputexperiance = new Process();
                        ProcessStartInfo inputexperiancestartInfo = new ProcessStartInfo();
                        inputexperiancestartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                        inputexperiancestartInfo.CreateNoWindow = true;
                        inputexperiancestartInfo.FileName = "powershell.exe";
                        inputexperiancestartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {inputexperianceCommandBase64}";
                        inputexperiancestartInfo.Verb = "runas";
                        processinputexperiance.StartInfo = inputexperiancestartInfo;
                        processinputexperiance.Start();
                        processinputexperiance.WaitForExit();
                    }
                }
                if (LessSecurityBOX.Checked)
                {
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", true);
                    RegistryKey DisUAC = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", true);
                    DisUAC.SetValue("EnableLUA", "0", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", true);
                    RegistryKey adminpermissions = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", true);
                    adminpermissions.SetValue("ProtectionMode", "0", RegistryValueKind.DWord);
                    Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Policies\Associations", true);
                    RegistryKey filesecWarning = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Policies\Associations", true);
                    filesecWarning.SetValue("LowRiskFileTypes", ".avi;.bat;.cmd;.exe;.htm;.html;.lnk;.mpg;.mpeg;.mov;.mp3;.mp4;.mkv;.msi;.m3u;.rar;.reg;.txt;.vbs;.wav;.ps1;.zip;.7z", RegistryValueKind.String);
                }
                if (winUpdateBOX.Checked)
                {
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\MRT", true);
                    RegistryKey softwareremovel1 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\MRT", true);
                    softwareremovel1.SetValue("DontOfferThroughWUAU", "1", RegistryValueKind.DWord);

                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching", true);
                    RegistryKey drivers1 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching", true);
                    drivers1.SetValue("SearchOrderConfig", "0", RegistryValueKind.DWord);
                    Registry.LocalMachine.CreateSubKey(@"SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate", true);
                    RegistryKey drivers2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate", true);
                    drivers2.SetValue("ExcludeWUDriversInQualityUpdate", "1", RegistryValueKind.DWord);
                }
                circularProgressBar1.Value = 100;
                circularProgressBar1.Visible = false;
                }
        }

        private void CreateresPointButton_Click(object sender, EventArgs e)
        {
            RestoreCreatedlabel.ForeColor = Color.Black;
            RestoreCreatedlabel.Text = "Creating a RestorePoint...";
            var MakerestoreCommand = @"
            #Turn On System Protection
	            Enable-ComputerRestore -Drive ""$env:SystemDrive""
	
            #Increase Disk Space Usage
                vssadmin resize shadowstorage /on=$env:SystemDrive /for=$env:SystemDrive /maxsize=10GB

            #Create Restore Point
	            Checkpoint-Computer -Description ""SodaScript"" -RestorePointType ""MODIFY_SETTINGS""
            ";
            var MakerestoreBytes = System.Text.Encoding.Unicode.GetBytes(MakerestoreCommand);
            var MakerestoreBase64 = Convert.ToBase64String(MakerestoreBytes);
            Process processMakerestore = new Process();
            ProcessStartInfo MakerestorestartInfo = new ProcessStartInfo();
            MakerestorestartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            MakerestorestartInfo.CreateNoWindow = true;
            MakerestorestartInfo.RedirectStandardOutput = true;
            MakerestorestartInfo.FileName = "powershell.exe";
            MakerestorestartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {MakerestoreBase64}";
            MakerestorestartInfo.Verb = "runas";
            processMakerestore.StartInfo = MakerestorestartInfo;
            processMakerestore.Start();
            processMakerestore.WaitForExit();
            panel1.Hide();
            RestoreCreatedlabel.Text = "RestorePoint Created Successfully";
            RestoreCreatedlabel.ForeColor = System.Drawing.Color.ForestGreen;
        }

        private void revertButton_Click(object sender, EventArgs e)
        {
            var checkrestoreCommand = @"
			(Get-ComputerRestorePoint | Where-Object {$_.Description -eq ""SodaScript""}).Description 
            ";
            var checkrestoreBytes = System.Text.Encoding.Unicode.GetBytes(checkrestoreCommand);
            var checkrestoreBase64 = Convert.ToBase64String(checkrestoreBytes);
            Process processcheckrestore = new Process();
            ProcessStartInfo checkrestorestartInfo = new ProcessStartInfo();
            checkrestorestartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            checkrestorestartInfo.CreateNoWindow = true;
            checkrestorestartInfo.RedirectStandardOutput = true;
            checkrestorestartInfo.FileName = "powershell.exe";
            checkrestorestartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {checkrestoreBase64}";
            checkrestorestartInfo.Verb = "runas";
            processcheckrestore.StartInfo = checkrestorestartInfo;
            processcheckrestore.Start();
            processcheckrestore.WaitForExit();
            string checkrestoreoutput = processcheckrestore.StandardOutput.ReadToEnd();
            if (String.IsNullOrEmpty(checkrestoreoutput))
            {
                string message = "You didn't create a restore point...Sorry nothing to do";
                string title = "Error";
                MessageBox.Show(message, title);
            }
            else
            {
                string message = "All tweaks will be reverted, and your pc will restart...ARE YOU SURE ?!";
                string title = "Warning";
                MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                DialogResult result = MessageBox.Show(message, title, buttons);
                if (result == DialogResult.Yes)
                {
                    label4.Text = "Reverting Tweaks...";
                    var RESrestoreCommand = @"
			        #Get Restore Point Sequence
	                $GetRestorePoint = Get-ComputerRestorePoint | Where-Object {$_.Description -eq ""SodaScript""}
	                $SequenceNumber = $GetRestorePoint.SequenceNumber

                    #Restore SodaScript Point
	                Restore-Computer -RestorePoint $SequenceNumber
                    ";
                    var RESrestoreBytes = System.Text.Encoding.Unicode.GetBytes(RESrestoreCommand);
                    var RESrestoreBase64 = Convert.ToBase64String(RESrestoreBytes);
                    Process processRESrestore = new Process();
                    ProcessStartInfo RESrestorestartInfo = new ProcessStartInfo();
                    RESrestorestartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    RESrestorestartInfo.CreateNoWindow = true;
                    RESrestorestartInfo.RedirectStandardOutput = true;
                    RESrestorestartInfo.FileName = "powershell.exe";
                    RESrestorestartInfo.Arguments = $"-ExecutionPolicy unrestricted -EncodedCommand {RESrestoreBase64}";
                    RESrestorestartInfo.Verb = "runas";
                    processRESrestore.StartInfo = RESrestorestartInfo;
                    processRESrestore.Start();
                    processRESrestore.WaitForExit();
                    label4.Text = "";
                } 
            }
        }
		
        private void complaptopBOX_CheckedChanged(object sender, EventArgs e)
        {
            if (dispowersaveBOX.Checked)
            {
                string message = "This Can Make your Laptop Temperature very high !";
                string title = "Warning";
                MessageBox.Show(message, title);
            }
        }

        private void widgetsBOX_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            disableDeff();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            enableDeff();
        }
    }
}