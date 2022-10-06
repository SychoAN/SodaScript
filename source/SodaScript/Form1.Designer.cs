using System.Windows.Forms;

namespace SodaScript
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.label1 = new System.Windows.Forms.Label();
            this.formpanel = new System.Windows.Forms.Panel();
            this.pictureBox3 = new System.Windows.Forms.PictureBox();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.pictureBox2 = new System.Windows.Forms.PictureBox();
            this.button1 = new System.Windows.Forms.Button();
            this.revertButton = new System.Windows.Forms.Button();
            this.compplayerBOX = new System.Windows.Forms.CheckBox();
            this.performancetweaksBOX = new System.Windows.Forms.CheckBox();
            this.circularProgressBar1 = new CircularProgressBar_NET5.CircularProgressBar();
            this.panel1 = new System.Windows.Forms.Panel();
            this.CreateresPointButton = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.RestoreCreatedlabel = new System.Windows.Forms.Label();
            this.dispowersaveBOX = new System.Windows.Forms.CheckBox();
            this.widgetsBOX = new System.Windows.Forms.CheckBox();
            this.BloatBOX = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.label5 = new System.Windows.Forms.Label();
            this.panel3 = new System.Windows.Forms.Panel();
            this.label6 = new System.Windows.Forms.Label();
            this.panel4 = new System.Windows.Forms.Panel();
            this.winUpdateBOX = new System.Windows.Forms.CheckBox();
            this.LessSecurityBOX = new System.Windows.Forms.CheckBox();
            this.InputExperianceBOX = new System.Windows.Forms.CheckBox();
            this.button3 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.formpanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).BeginInit();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            this.panel4.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label1.ForeColor = System.Drawing.Color.Coral;
            this.label1.Location = new System.Drawing.Point(43, 3);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(160, 24);
            this.label1.TabIndex = 0;
            this.label1.Text = "SodaScript_v4.0";
            // 
            // formpanel
            // 
            this.formpanel.Controls.Add(this.pictureBox3);
            this.formpanel.Controls.Add(this.pictureBox1);
            this.formpanel.Controls.Add(this.label1);
            this.formpanel.Controls.Add(this.pictureBox2);
            this.formpanel.Location = new System.Drawing.Point(-1, 1);
            this.formpanel.Margin = new System.Windows.Forms.Padding(4);
            this.formpanel.Name = "formpanel";
            this.formpanel.Size = new System.Drawing.Size(773, 43);
            this.formpanel.TabIndex = 1;
            this.formpanel.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // pictureBox3
            // 
            this.pictureBox3.Image = global::SodaScript.Properties.Resources.Minimize_Button;
            this.pictureBox3.Location = new System.Drawing.Point(568, 0);
            this.pictureBox3.Margin = new System.Windows.Forms.Padding(4);
            this.pictureBox3.Name = "pictureBox3";
            this.pictureBox3.Size = new System.Drawing.Size(43, 43);
            this.pictureBox3.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox3.TabIndex = 4;
            this.pictureBox3.TabStop = false;
            this.pictureBox3.Click += new System.EventHandler(this.pictureBox3_Click);
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = global::SodaScript.Properties.Resources.soda_can;
            this.pictureBox1.Location = new System.Drawing.Point(4, -7);
            this.pictureBox1.Margin = new System.Windows.Forms.Padding(4);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(43, 50);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox1.TabIndex = 2;
            this.pictureBox1.TabStop = false;
            // 
            // pictureBox2
            // 
            this.pictureBox2.Image = global::SodaScript.Properties.Resources.Close_Button;
            this.pictureBox2.Location = new System.Drawing.Point(608, 0);
            this.pictureBox2.Margin = new System.Windows.Forms.Padding(4);
            this.pictureBox2.Name = "pictureBox2";
            this.pictureBox2.Size = new System.Drawing.Size(43, 43);
            this.pictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox2.TabIndex = 3;
            this.pictureBox2.TabStop = false;
            this.pictureBox2.Click += new System.EventHandler(this.pictureBox2_Click);
            // 
            // button1
            // 
            this.button1.BackColor = System.Drawing.Color.Gray;
            this.button1.FlatAppearance.BorderColor = System.Drawing.Color.Gray;
            this.button1.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Gray;
            this.button1.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Coral;
            this.button1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.button1.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.button1.Location = new System.Drawing.Point(3, 384);
            this.button1.Margin = new System.Windows.Forms.Padding(4);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(239, 90);
            this.button1.TabIndex = 3;
            this.button1.Text = "Optimize";
            this.button1.UseVisualStyleBackColor = false;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // revertButton
            // 
            this.revertButton.BackColor = System.Drawing.Color.IndianRed;
            this.revertButton.FlatAppearance.BorderColor = System.Drawing.Color.Gray;
            this.revertButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Gray;
            this.revertButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Coral;
            this.revertButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.revertButton.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.revertButton.Location = new System.Drawing.Point(411, 384);
            this.revertButton.Margin = new System.Windows.Forms.Padding(4);
            this.revertButton.Name = "revertButton";
            this.revertButton.Size = new System.Drawing.Size(239, 90);
            this.revertButton.TabIndex = 11;
            this.revertButton.Text = "Revert All";
            this.revertButton.UseVisualStyleBackColor = false;
            this.revertButton.Click += new System.EventHandler(this.revertButton_Click);
            // 
            // compplayerBOX
            // 
            this.compplayerBOX.AutoSize = true;
            this.compplayerBOX.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.compplayerBOX.ForeColor = System.Drawing.Color.Coral;
            this.compplayerBOX.Location = new System.Drawing.Point(4, 4);
            this.compplayerBOX.Margin = new System.Windows.Forms.Padding(4);
            this.compplayerBOX.Name = "compplayerBOX";
            this.compplayerBOX.Size = new System.Drawing.Size(163, 17);
            this.compplayerBOX.TabIndex = 6;
            this.compplayerBOX.Text = "I am a Comptitive Player";
            this.compplayerBOX.UseVisualStyleBackColor = true;
            // 
            // performancetweaksBOX
            // 
            this.performancetweaksBOX.AutoSize = true;
            this.performancetweaksBOX.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.performancetweaksBOX.ForeColor = System.Drawing.Color.Coral;
            this.performancetweaksBOX.Location = new System.Drawing.Point(2, 4);
            this.performancetweaksBOX.Margin = new System.Windows.Forms.Padding(4);
            this.performancetweaksBOX.Name = "performancetweaksBOX";
            this.performancetweaksBOX.Size = new System.Drawing.Size(145, 17);
            this.performancetweaksBOX.TabIndex = 8;
            this.performancetweaksBOX.Text = "Performance Tweaks";
            this.performancetweaksBOX.UseVisualStyleBackColor = true;
            // 
            // circularProgressBar1
            // 
            this.circularProgressBar1.AnimationFunction = WinFormAnimation_NET5.KnownAnimationFunctions.QuarticEaseIn;
            this.circularProgressBar1.AnimationSpeed = 200;
            this.circularProgressBar1.BackColor = System.Drawing.Color.Transparent;
            this.circularProgressBar1.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.circularProgressBar1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(64)))), ((int)(((byte)(64)))), ((int)(((byte)(64)))));
            this.circularProgressBar1.InnerColor = System.Drawing.Color.FromArgb(((int)(((byte)(224)))), ((int)(((byte)(224)))), ((int)(((byte)(224)))));
            this.circularProgressBar1.InnerMargin = 2;
            this.circularProgressBar1.InnerWidth = -1;
            this.circularProgressBar1.Location = new System.Drawing.Point(216, 123);
            this.circularProgressBar1.MarqueeAnimationSpeed = 2000;
            this.circularProgressBar1.Name = "circularProgressBar1";
            this.circularProgressBar1.OuterColor = System.Drawing.Color.Gray;
            this.circularProgressBar1.OuterMargin = -25;
            this.circularProgressBar1.OuterWidth = 26;
            this.circularProgressBar1.ProgressColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(128)))), ((int)(((byte)(0)))));
            this.circularProgressBar1.ProgressWidth = 25;
            this.circularProgressBar1.SecondaryFont = new System.Drawing.Font("Segoe UI", 20.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.circularProgressBar1.Size = new System.Drawing.Size(218, 205);
            this.circularProgressBar1.StartAngle = 270;
            this.circularProgressBar1.SubscriptColor = System.Drawing.Color.FromArgb(((int)(((byte)(166)))), ((int)(((byte)(166)))), ((int)(((byte)(166)))));
            this.circularProgressBar1.SubscriptMargin = new System.Windows.Forms.Padding(10, -35, 0, 0);
            this.circularProgressBar1.SubscriptText = "";
            this.circularProgressBar1.SuperscriptColor = System.Drawing.Color.FromArgb(((int)(((byte)(166)))), ((int)(((byte)(166)))), ((int)(((byte)(166)))));
            this.circularProgressBar1.SuperscriptMargin = new System.Windows.Forms.Padding(10, 35, 0, 0);
            this.circularProgressBar1.SuperscriptText = "";
            this.circularProgressBar1.TabIndex = 12;
            this.circularProgressBar1.Text = "OPTIMIZING";
            this.circularProgressBar1.TextMargin = new System.Windows.Forms.Padding(4, 4, 0, 0);
            this.circularProgressBar1.Value = 68;
            this.circularProgressBar1.Visible = false;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.PapayaWhip;
            this.panel1.Controls.Add(this.CreateresPointButton);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Location = new System.Drawing.Point(0, 45);
            this.panel1.Margin = new System.Windows.Forms.Padding(4);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(650, 33);
            this.panel1.TabIndex = 13;
            this.panel1.Visible = false;
            // 
            // CreateresPointButton
            // 
            this.CreateresPointButton.BackColor = System.Drawing.Color.Orange;
            this.CreateresPointButton.FlatAppearance.BorderColor = System.Drawing.Color.Gray;
            this.CreateresPointButton.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Gray;
            this.CreateresPointButton.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Coral;
            this.CreateresPointButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.CreateresPointButton.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.CreateresPointButton.Location = new System.Drawing.Point(447, 1);
            this.CreateresPointButton.Margin = new System.Windows.Forms.Padding(4);
            this.CreateresPointButton.Name = "CreateresPointButton";
            this.CreateresPointButton.Size = new System.Drawing.Size(202, 33);
            this.CreateresPointButton.TabIndex = 14;
            this.CreateresPointButton.Text = "Create RestorePoint";
            this.CreateresPointButton.UseVisualStyleBackColor = false;
            this.CreateresPointButton.Click += new System.EventHandler(this.CreateresPointButton_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.BackColor = System.Drawing.Color.Red;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label2.ForeColor = System.Drawing.Color.Coral;
            this.label2.Location = new System.Drawing.Point(0, 3);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(322, 24);
            this.label2.TabIndex = 0;
            this.label2.Text = "You Didn\'t create a restore point !";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label4.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label4.Location = new System.Drawing.Point(213, 107);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(0, 24);
            this.label4.TabIndex = 16;
            // 
            // RestoreCreatedlabel
            // 
            this.RestoreCreatedlabel.AutoSize = true;
            this.RestoreCreatedlabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.RestoreCreatedlabel.ForeColor = System.Drawing.Color.ForestGreen;
            this.RestoreCreatedlabel.Location = new System.Drawing.Point(213, 107);
            this.RestoreCreatedlabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.RestoreCreatedlabel.Name = "RestoreCreatedlabel";
            this.RestoreCreatedlabel.Size = new System.Drawing.Size(0, 24);
            this.RestoreCreatedlabel.TabIndex = 14;
            // 
            // dispowersaveBOX
            // 
            this.dispowersaveBOX.AutoSize = true;
            this.dispowersaveBOX.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.dispowersaveBOX.ForeColor = System.Drawing.Color.Coral;
            this.dispowersaveBOX.Location = new System.Drawing.Point(4, 28);
            this.dispowersaveBOX.Margin = new System.Windows.Forms.Padding(4);
            this.dispowersaveBOX.Name = "dispowersaveBOX";
            this.dispowersaveBOX.Size = new System.Drawing.Size(230, 17);
            this.dispowersaveBOX.TabIndex = 9;
            this.dispowersaveBOX.Text = "Disable PowerSaving for all devices";
            this.dispowersaveBOX.UseVisualStyleBackColor = true;
            this.dispowersaveBOX.CheckedChanged += new System.EventHandler(this.complaptopBOX_CheckedChanged);
            // 
            // widgetsBOX
            // 
            this.widgetsBOX.AutoSize = true;
            this.widgetsBOX.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.widgetsBOX.ForeColor = System.Drawing.Color.Coral;
            this.widgetsBOX.Location = new System.Drawing.Point(0, 66);
            this.widgetsBOX.Margin = new System.Windows.Forms.Padding(4);
            this.widgetsBOX.Name = "widgetsBOX";
            this.widgetsBOX.Size = new System.Drawing.Size(173, 17);
            this.widgetsBOX.TabIndex = 14;
            this.widgetsBOX.Text = "Disable Windows Widgets";
            this.widgetsBOX.UseVisualStyleBackColor = true;
            this.widgetsBOX.CheckedChanged += new System.EventHandler(this.widgetsBOX_CheckedChanged);
            // 
            // BloatBOX
            // 
            this.BloatBOX.AutoSize = true;
            this.BloatBOX.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.BloatBOX.ForeColor = System.Drawing.Color.Coral;
            this.BloatBOX.Location = new System.Drawing.Point(2, 32);
            this.BloatBOX.Margin = new System.Windows.Forms.Padding(4);
            this.BloatBOX.Name = "BloatBOX";
            this.BloatBOX.Size = new System.Drawing.Size(136, 17);
            this.BloatBOX.TabIndex = 18;
            this.BloatBOX.Text = "Bloatware Remover";
            this.BloatBOX.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.BackColor = System.Drawing.Color.ForestGreen;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label3.ForeColor = System.Drawing.Color.Coral;
            this.label3.Location = new System.Drawing.Point(94, 107);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(51, 24);
            this.label3.TabIndex = 0;
            this.label3.Text = "Safe";
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.Color.PapayaWhip;
            this.panel2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel2.Controls.Add(this.BloatBOX);
            this.panel2.Controls.Add(this.performancetweaksBOX);
            this.panel2.Location = new System.Drawing.Point(93, 135);
            this.panel2.Margin = new System.Windows.Forms.Padding(4);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(183, 53);
            this.panel2.TabIndex = 19;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.BackColor = System.Drawing.Color.Red;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label5.ForeColor = System.Drawing.Color.Coral;
            this.label5.Location = new System.Drawing.Point(92, 191);
            this.label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(349, 24);
            this.label5.TabIndex = 20;
            this.label5.Text = "Advanced (disable AntiVirus for this)";
            // 
            // panel3
            // 
            this.panel3.BackColor = System.Drawing.Color.PapayaWhip;
            this.panel3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel3.Controls.Add(this.compplayerBOX);
            this.panel3.Controls.Add(this.dispowersaveBOX);
            this.panel3.Location = new System.Drawing.Point(322, 135);
            this.panel3.Margin = new System.Windows.Forms.Padding(4);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(234, 53);
            this.panel3.TabIndex = 21;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.BackColor = System.Drawing.Color.Red;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label6.ForeColor = System.Drawing.Color.Coral;
            this.label6.Location = new System.Drawing.Point(322, 107);
            this.label6.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(66, 24);
            this.label6.TabIndex = 22;
            this.label6.Text = "HEAT";
            // 
            // panel4
            // 
            this.panel4.BackColor = System.Drawing.Color.PapayaWhip;
            this.panel4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel4.Controls.Add(this.winUpdateBOX);
            this.panel4.Controls.Add(this.LessSecurityBOX);
            this.panel4.Controls.Add(this.InputExperianceBOX);
            this.panel4.Controls.Add(this.button3);
            this.panel4.Controls.Add(this.button2);
            this.panel4.Controls.Add(this.widgetsBOX);
            this.panel4.Location = new System.Drawing.Point(92, 219);
            this.panel4.Margin = new System.Windows.Forms.Padding(4);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(426, 144);
            this.panel4.TabIndex = 23;
            // 
            // winUpdateBOX
            // 
            this.winUpdateBOX.AutoSize = true;
            this.winUpdateBOX.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.winUpdateBOX.ForeColor = System.Drawing.Color.Coral;
            this.winUpdateBOX.Location = new System.Drawing.Point(0, 116);
            this.winUpdateBOX.Margin = new System.Windows.Forms.Padding(4);
            this.winUpdateBOX.Name = "winUpdateBOX";
            this.winUpdateBOX.Size = new System.Drawing.Size(412, 17);
            this.winUpdateBOX.TabIndex = 19;
            this.winUpdateBOX.Text = "Tell WinUpdate to not download drivers and Software Removal Tool";
            this.winUpdateBOX.UseVisualStyleBackColor = true;
            // 
            // LessSecurityBOX
            // 
            this.LessSecurityBOX.AutoSize = true;
            this.LessSecurityBOX.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.LessSecurityBOX.ForeColor = System.Drawing.Color.Coral;
            this.LessSecurityBOX.Location = new System.Drawing.Point(0, 43);
            this.LessSecurityBOX.Margin = new System.Windows.Forms.Padding(4);
            this.LessSecurityBOX.Name = "LessSecurityBOX";
            this.LessSecurityBOX.Size = new System.Drawing.Size(340, 17);
            this.LessSecurityBOX.TabIndex = 18;
            this.LessSecurityBOX.Text = "LessSecurity Tweaks ( Like UAC, FileSecurity Warning)";
            this.LessSecurityBOX.UseVisualStyleBackColor = true;
            // 
            // InputExperianceBOX
            // 
            this.InputExperianceBOX.AutoSize = true;
            this.InputExperianceBOX.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.InputExperianceBOX.ForeColor = System.Drawing.Color.Coral;
            this.InputExperianceBOX.Location = new System.Drawing.Point(0, 90);
            this.InputExperianceBOX.Margin = new System.Windows.Forms.Padding(4);
            this.InputExperianceBOX.Name = "InputExperianceBOX";
            this.InputExperianceBOX.Size = new System.Drawing.Size(420, 17);
            this.InputExperianceBOX.TabIndex = 17;
            this.InputExperianceBOX.Text = "Disable Windows Input Experience (disables clipboard and emoji Box)";
            this.InputExperianceBOX.UseVisualStyleBackColor = true;
            // 
            // button3
            // 
            this.button3.BackColor = System.Drawing.Color.Gray;
            this.button3.FlatAppearance.BorderColor = System.Drawing.Color.Gray;
            this.button3.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Gray;
            this.button3.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Coral;
            this.button3.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.button3.Font = new System.Drawing.Font("Segoe UI", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.button3.Location = new System.Drawing.Point(246, 5);
            this.button3.Margin = new System.Windows.Forms.Padding(4);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(172, 33);
            this.button3.TabIndex = 16;
            this.button3.Text = "Enable WinDeffender";
            this.button3.UseVisualStyleBackColor = false;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // button2
            // 
            this.button2.BackColor = System.Drawing.Color.Salmon;
            this.button2.FlatAppearance.BorderColor = System.Drawing.Color.Gray;
            this.button2.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Gray;
            this.button2.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Coral;
            this.button2.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.button2.Font = new System.Drawing.Font("Segoe UI", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.button2.Location = new System.Drawing.Point(4, 5);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(166, 33);
            this.button2.TabIndex = 15;
            this.button2.Text = "Disable WinDeffender";
            this.button2.UseVisualStyleBackColor = false;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(10F, 21F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.PapayaWhip;
            this.ClientSize = new System.Drawing.Size(651, 487);
            this.Controls.Add(this.circularProgressBar1);
            this.Controls.Add(this.panel4);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.RestoreCreatedlabel);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.revertButton);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.formpanel);
            this.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form1";
            this.formpanel.ResumeLayout(false);
            this.formpanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            this.panel4.ResumeLayout(false);
            this.panel4.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Label label1;
        private Panel formpanel;
        private PictureBox pictureBox3;
        private PictureBox pictureBox1;
        private PictureBox pictureBox2;
        private Button button1;
        private Button revertButton;
        private CheckBox compplayerBOX;
        private CheckBox performancetweaksBOX;
        private CircularProgressBar_NET5.CircularProgressBar circularProgressBar1;
        private Panel panel1;
        private Label label2;
        private Button CreateresPointButton;
        private CheckBox dispowersaveBOX;
        private Label RestoreCreatedlabel;
        private Label label4;
        private CheckBox widgetsBOX;
        private CheckBox BloatBOX;
        private Label label3;
        private Panel panel2;
        private Label label5;
        private Panel panel3;
        private Label label6;
        private Panel panel4;
        private Button button3;
        private Button button2;
        private CheckBox InputExperianceBOX;
        private CheckBox LessSecurityBOX;
        private CheckBox winUpdateBOX;
    }
}