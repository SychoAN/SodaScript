using System;
using System.Windows.Forms;

namespace SodaScript
{
    class Moveable
    {
        public const int WM_NCLBUTTONDOWN = 0xA1;
        public const int HT_CAPTION = 0x2;
        [System.Runtime.InteropServices.DllImportAttribute("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);
        [System.Runtime.InteropServices.DllImportAttribute("user32.dll")]
        public static extern bool ReleaseCapture();
        public Moveable(params Control[] controls)
        {
            foreach (var ctrl in controls)
            {
                ctrl.MouseDown += (s, e) =>
                {
                    if (e.Button == MouseButtons.Left)
                    {
                        ReleaseCapture();
                        SendMessage(ctrl.FindForm().Handle, WM_NCLBUTTONDOWN, HT_CAPTION, 0);
                        // Checks if Y = 0, if so maximize the form
                        if (ctrl.FindForm().Location.Y == 0) { ctrl.FindForm().WindowState = FormWindowState.Maximized; }
                    }
                };
            }
        }
    }
}