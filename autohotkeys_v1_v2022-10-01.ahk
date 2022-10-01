; autohotkeys_v1_v2022-10-01
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



;---------------------------------------------------------
;| MOVE BETWEEN VIRTUAL DESKTOPS  |  Win + Mouse buttoms |
;---------------------------------------------------------
#RButton::Send ^#{Right}           ; Next virtual dekstop     = Win + right click
#MButton::Send #{Tab}              ; Virtual dekstops tasks   = Win + central mouse click
#LButton::Send ^#{Left}            ; Previous virtual dekstop = Win + left click



;-------------------------------------------------------------------------------------------------------------------------
;| MULTIMEDIA AND VOLUME  |  Pause = Pause | Win + Mouse Scroll = Volume up/down | Win + Page Up/Down  = Next/Prev track |
;-------------------------------------------------------------------------------------------------------------------------
Pause::Send {Media_Play_Pause}     ; Pause multimedia = Pause
#PgUp::Send {Media_Prev}           ; Previous song    = Win + Page Up
#PgDn::Send {Media_Next}           ; Next song        = Win + Page Down
#WheelUp::Send  {Volume_Up}        ; Volume up        = Win + Mouse Scroll Up 
#WheelDown::Send {Volume_Down}     ; Volume up        = Win + Mouse Scroll Down



;--------------------------------------------------------
;| DESKTOP CREATE FOLDER YYYY-MM-DD--HHMM--  |  Win + T |
;--------------------------------------------------------
#t:: 
FormatTime, DateToUse, , yyyy-MM-dd--hhmm--
FileCreateDir, %A_Desktop%\%DateToUse%
FileAppend, , %A_Desktop%\%DateToUse%\HEADER.md
Return



;-------------------------------------------------------------------------------
;| CREATE SHORCUTS TO SELECTED FILES AND FOLDER TO DESKTOP  |  Ctr + Shift + S |
;-------------------------------------------------------------------------------
^+s::
    Explorer_GetSelection(hwnd="") 
    {
        hwnd := hwnd ? hwnd : WinExist("A")
        WinGetClass class, ahk_id %hwnd%
        if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
            for window in ComObjCreate("Shell.Application").Windows
            if (window.hwnd==hwnd)
            CurrentWindow := window.Document.SelectedItems
        for item in CurrentWindow 
        {
            SplitPath, % item.path,,,,OutNameNoExt
            FileCreateShortcut, % item.path, % A_Desktop "\" OutNameNoExt ".lnk"
        }
    }
Return



;----------------------------------------
;| EXPLORER SHOW/HIDE LEFT PANEL  | F12 |
;----------------------------------------
#IfWinActive ahk_class CabinetWClass
~F12::
RegRead, NavigationPane_Status, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer, PageSpaceControlSizer
If NavigationPane_Status = a700000001000000000000000a050000
RegWrite, REG_BINARY, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer, PageSpaceControlSizer, a00000000000000000000000ec030000
Else
RegWrite, REG_BINARY, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer, PageSpaceControlSizer, a700000001000000000000000a050000
WinGetClass, eh_Class,A
If (eh_Class = “#32770” OR A_OSVersion = “WIN_VISTA”)
Send, {F5}
Else PostMessage, 0x111, 28931,,, A
Send, !{Up}
Send, {Backspace}
Return
#IfWinActive









