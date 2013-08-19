#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.4.8
 Author:         Dick Davies

 Script Function:
	AutoIt script to time the use of a PC for use in a simple net cafe environment.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


;Ideas

; BlockInput(1) Turns off keyboard and mouse 

; Get time in mins & secs
$tick = @sec
$tock = @min

; Trap exits
; 0 Natural closing. 
; 1 close by Exit function. 
; 2 close by clicking on exit of the systray. 
; 3 close by user logoff. 
; 4 close by Windows shutdown. 

Opt("OnExitFunc", "endscript")
MsgBox(0,"","first statement")

Func endscript()
    MsgBox(0,"","after last statement " & @EXITMETHOD)
EndFunc


; Process is running
If ProcessExists("notepad.exe") Then
    MsgBox(0, "Example", "Notepad is running.")
EndIf




; Disable and Enable a Network card using 'Shell.Application'
;

$oLanConnection = "Local Area Connection"; Change this to the name of the adapter to be disabled !
$bEnable = true                ; Change this to 'false' to DISABLE the network adapter

if @OSType<>"WIN32_NT" then
    Msgbox(0,"","This script requires Windows 2000 or higher.")
    exit
endif


if @OSVersion="WIN_2000" then
    $strFolderName = "Network and Dial-up Connections"
else
    $strFolderName = "Network Connections"; Windows XP
endif

Select
    Case StringInStr("0409,0809,0c09,1009,1409,1809,1c09,2009,_
                    2409,2809,2c09,3009,3409", @OSLang)    ; English (United States)
       $strEnableVerb  = "En&able"
       $strDisableVerb = "Disa&ble"

; Add here the correct Verbs for your Operating System Language
EndSelect


;Virtual folder containing icons for the Control Panel applications. (value = 3)
Const $ssfCONTROLS = 3

$ShellApp = ObjCreate("Shell.Application")
$oControlPanel = $shellApp.Namespace($ssfCONTROLS)


; Find 'Network connections' control panel item
$oNetConnections=""

For $FolderItem in $oControlPanel.Items
    If $FolderItem.Name = $strFolderName then
        $oNetConnections = $FolderItem.GetFolder
        Exitloop
    Endif
Next

      
If not IsObj($oNetConnections) Then
    MsgBox(0,"Error","Couldn't find " & $strFolderName & " folder."
    Exit
EndIf
        

For $FolderItem In $oNetConnections.Items
    If StringLower($FolderItem.Name) = StringLower($oLanConnection) Then
        $oLanConnection = $FolderItem
        Exitloop
    EndIf
Next

If not IsObj($oLanConnection) Then
     MsgBox(0,"Error","Couldn't find " & $oLanConnection & " Item."
     Exit
EndIf

$oEnableVerb=""
$oDisableVerb=""

For $Verb In $oLanConnection.Verbs
If $Verb.Name = $strEnableVerb Then
   $oEnableVerb = $Verb
EndIf
If $Verb.Name = $strDisableVerb Then
   $oDisableVerb = $Verb
EndIf
Next

If $bEnable then
If IsObj($oEnableVerb) Then $oEnableVerb.DoIt    ; Enable network card
Endif

If not $bEnable then
If IsObj($oDisableVerb) Then $oDisableVerb.DoIt; Disable network card
EndIf

Sleep(1000)




