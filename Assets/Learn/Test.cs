using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using UnityEngine;

public class Test : MonoBehaviour {

    [DllImport("user32.dll")]
    private static extern IntPtr GetActiveWindow();
    //[DllImport("user32.dll")]
    //private static extern IntPtr GetFocus();
    [DllImport("User32.dll", CharSet = CharSet.Auto)]
    public static extern int GetWindowThreadProcessId(IntPtr hwnd, out int ID);

    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    internal static extern uint GetCurrentProcessId();

    // Use this for initialization
    void Start () {
     
    }

    // Update is called once per frame
    void Update () {
        UnityEngine.Debug.Log(Process.GetCurrentProcess().ProcessName);
        UnityEngine.Debug.Log(Process.GetCurrentProcess().Id);
        UnityEngine.Debug.Log(GetCurrentProcessId());
        var processes = Process.GetProcessById((int)GetCurrentProcessId());
        UnityEngine.Debug.Log(processes.ProcessName);

        int calcID = 0;
        int pid = GetWindowThreadProcessId(GetActiveWindow(), out calcID);
        UnityEngine.Debug.Log(pid);
        //var processes = Process.GetProcessById(pid);
        //UnityEngine.Debug.Log(processes.ProcessName);
    }
}
