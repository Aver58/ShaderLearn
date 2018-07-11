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

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        int pid = 0;
        int calcID = 0;
        pid = GetWindowThreadProcessId(GetActiveWindow(), out calcID);
        var processes = Process.GetProcesses();
        var curProcess = Process.GetCurrentProcess();
        UnityEngine.Debug.Log(pid);
        UnityEngine.Debug.Log(processes);
        UnityEngine.Debug.Log(curProcess);

    }
}
