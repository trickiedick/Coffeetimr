#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Z:\files\Shared Documents\Programming\Cafetimer\timer.ico
#AutoIt3Wrapper_outfile=Z:\files\Shared Documents\Programming\Cafetimer\coffeetimr.exe
#AutoIt3Wrapper_Res_Comment=Internet Café simple timer application
#AutoIt3Wrapper_Res_Description=Café Timer
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Richard Davies (dick.davies@gmail.com)
#AutoIt3Wrapper_Res_Icon_Add=r.ico
#AutoIt3Wrapper_Res_Icon_Add=y.ico
#AutoIt3Wrapper_Res_Icon_Add=g.ico
#AutoIt3Wrapper_Res_Icon_Add=Timer.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region converted Directives from Z:\files\Shared Documents\Programming\Cafetimer\coffeetimr.au3.ini
#AutoIt3Wrapper_Allow_Decompile=0
#EndRegion converted Directives from Z:\files\Shared Documents\Programming\Cafetimer\coffeetimr.au3.ini
;
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.2.4.8
	Author:         Dick Davies

	Script Function: Cafétime.r
	AutoIt script to time the use of a PC for use in a simple net cafe environment.

#ce ----------------------------------------------------------------------------

; Script Start

; Old command not supported Opt("RunErrorsFatal",0)
Opt("TrayMenuMode",1)


#include <GUIConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <date.au3>

$MainForm = GUICreate("CaféTime.r", 191, 149, -1, -1)
GUISetIcon("timer.ico")
$Button1 = GUICtrlCreateButton("Start now", 16, 88, 153, 49, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Arial")
$Label1 = GUICtrlCreateLabel("00:00", 16, 32, 157, 51, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 36, 400, 0, "Arial")
GUICtrlSetBkColor(-1, 0x000000)
$Label2 = GUICtrlCreateLabel("EarthWorks Café", 16, 8, 157, 22,$SS_CENTER)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")
GUISetState(@SW_SHOW, $MainForm)

$Passform = GuiCreate("Password:", 260, 85,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
$Button2 = GuiCtrlCreateButton("Enter password", 150, 40, 100, 40)
$Input3 = GuiCtrlCreateInput("", 10, 10, 240, 20)
$daynumber=-_NowCalc()

; Init - use ini file for variables & read them here
$browser =IniRead("coffeetimr.ini","main","browser","iexplore.exe")
$altbrowser = IniRead("coffeetimr.ini","main","altbrowser","firefox.exe")
$nastyversion = IniRead("coffeetimr.ini","main","nastyversion","0")
$ticktime = IniRead("coffeetimr.ini","main","ticktime","1000")
$sessiontime = IniRead("coffeetimr.ini","main","sessiontime","60")
$terminalnumber = IniRead("coffeetimr.ini","main","terminalnumber","")
$cafename = IniRead("coffeetimr.ini","main","cafename","")
; Read list of prohibited processes
$prohibit1 = IniRead("coffeetimr.ini","prohibit","prohibit1","")
$prohibit2 = IniRead("coffeetimr.ini","prohibit","prohibit2","")
$prohibit3 = IniRead("coffeetimr.ini","prohibit","prohibit3","")
$prohibit4 = IniRead("coffeetimr.ini","prohibit","prohibit4","")
$prohibit5 = IniRead("coffeetimr.ini","prohibit","prohibit5","")
$prohibit6 = IniRead("coffeetimr.ini","prohibit","prohibit6","")
; Read ovveride passwords
$pwnasty = IniRead("coffeetimr.ini","passwords","pwnasty","CVadminUKnasty")
$pwnice = IniRead("coffeetimr.ini","passwords","pwnice","CVadminUKnice")
$pwquit = IniRead("coffeetimr.ini","passwords","pwquit","CVadminUKquit")
$pwfree = IniRead("coffeetimr.ini","passwords","pwfree","CVadminUKfree")
$pwnormal = IniRead("coffeetimr.ini","passwords","pwnormal","CVadminUKnormal")
; Flags etc
$tmsg=0
$msg=0
$running = 0
$minsleft=0
$secsleft=0
$stopme = 0
$passcorrect = False
$userpw = ""

; Set password  in getcurrentpassword function
$currentpassword = getcurrentpassword()

; Set cafe name & terminal number
GUICtrlSetData($Label2,($cafename&$terminalnumber))

; Indicate nice or nasty version
If $nastyversion = 1 Then
	; yellow is nastyversion
	GUICtrlSetColor($Label1, 0xffff00)
Else
	; pale blue is niceversion
	GUICtrlSetColor($Label1, 0xaaaaff)
EndIf

; Set up tray menu
TraySetIcon("timer.ico")
; Left or right click will do
TraySetClick(9)
$traystartstop = TrayCreateItem("Start/Stop")
TrayCreateItem("")
$trayabout = TrayCreateItem("About")
$trayquit = TrayCreateItem("Quit")

; Enable browser kill function every second (while idling)
AdlibEnable("stopbrowsers", 1000)

; Main GUI Event loop
While 1
	If ($stopme = 1) Then
		sessiontimeout()
	EndIf
	; Tray commands
	$tmsg = TrayGetMsg()
	Switch $tmsg
		Case $traystartstop
			startstop()
		Case $trayabout
			MsgBox (0,"About CaféTime.r", "Life, the universe, and everything: try 42.  This application: cool isn't it!",10)
		Case $trayquit
			; Inhibit user closing down app - still possible with Task manager unless excluded in ini
			If $nastyversion = 0 Then
				Exit
			EndIf
	EndSwitch
	; GUI commands
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			; Inhibit user closing down app - still possible with Task manager unless excluded in ini
			If $nastyversion = 0 Then
				Exit
			EndIf
		Case $Button1
			startstop()
	EndSwitch
WEnd

Func countdown()
	$secsleft -= 1
	If ($secsleft < 0) Then
		$secsleft += 60
		$minsleft -= 1
		If $minsleft > 9 Then
			$tiptext = "You have "& ($minsleft+1) & " minutes left"
			TrayTip("Cafétime.r", $tiptext,10,0)
		EndIf
		If $minsleft = 9 Then
			$tiptext = "You have ten minutes left"
			TrayTip("Cafétime.r", $tiptext,10,1)
		EndIf
		If ($minsleft < 9 And $minsleft > 0) Then
			$tiptext = "You only have "& ($minsleft+1) & " minutes left"
			TrayTip("Cafétime.r", $tiptext,10,2)
		EndIf
		If $minsleft = 0 Then
			GUICtrlSetColor($Label1, 0xff0000)
			TrayTip("Cafétime.r", "You now have only ONE minute left",10,2)
		EndIf
		If $minsleft < 0 Then
			$minsleft = 0
			$secsleft = 0
			$stopme = 1
			TrayTip("Cafétime.r", "Time is up",10,2)
		EndIf
	EndIf
	If ($secsleft=50) Then
		TrayTip("None","",10)
	EndIf
	$display = StringFormat("%02i:%02i", $minsleft, $secsleft)
	ControlSetText("CaféTime.r", "", $Label1, $display)
	; Check for prohibited apps
	prohibit()
EndFunc   ;==>countdown

Func authenticate()
	$currentpassword=getcurrentpassword()
	Local $iscorrect
	$iscorrect=False
	GUISetState(@SW_HIDE, $MainForm)
	GUISetState(@SW_SHOW, $Passform)
	GUICtrlSetState($Button2,$GUI_DEFBUTTON)
	ControlSetText("Password:","",$Input3, "")
	;ControlFocus("Password:","",$Input3)
	While 1
		$msg = GuiGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				; Do nothing
				Exitloop
			Case $Button2
				$userpw = ControlGetText("Password:","", $Input3)
				Switch $userpw
					; Correct password entered?
					Case $currentpassword
						$iscorrect=True
						Exitloop
					Case $pwfree
						$iscorrect=True
						Exitloop
					; Check and act on other secret passwords
					Case $pwquit
						Exit
					Case $pwnasty
						$nastyversion=1
						; yellow is nastyversion
						GUICtrlSetColor($Label1, 0xffff00)
						ExitLoop
					Case $pwnice
						$nastyversion=0
						; pale blue is niceversion
						GUICtrlSetColor($Label1, 0xaaaaff)
						ExitLoop
					Case $pwnormal
						$nastyversion = IniRead("coffeetimr.ini","main","nastyversion","0")
						ExitLoop
				EndSwitch
		EndSwitch
	WEnd
	GUISetState(@SW_HIDE, $Passform)
	GUISetState(@SW_SHOW, $MainForm)
	Return($iscorrect)
EndFunc

Func startstop()
	If $running = 0 Then
		; Start the timer
		If authenticate()= True Then
			startsession()
		EndIf
	Else
		stopsession()
	EndIf
EndFunc


Func startsession()
	; Start a net café session
	$running = 1
	$minsleft = $sessiontime
	$secsleft = 0
	TraySetIcon("g.ico")
	GUISetIcon("g.ico")
	If $nastyversion = 1 Then
		; yellow is nastyversion
		GUICtrlSetColor($Label1, 0xffff00)
	Else
		; pale blue is niceversion
		GUICtrlSetColor($Label1, 0xaaaaff)
	EndIf
	ControlSetText("CaféTime.r", "", $Button1, "I'm finished")
	AdlibEnable("countdown", $ticktime)
	startbrowser()
EndFunc

Func stopsession()
	;stop a net café session
	AdlibEnable("stopbrowsers", 1000)
	$running = 0
	TraySetIcon("y.ico")
	GUISetIcon("y.ico")
	ControlSetText("CaféTime.r", "", $Label1, "00:00")
	ControlSetText("CaféTime.r", "", $Button1, "Start now")
EndFunc

Func sessiontimeout()
	AdlibEnable("stopbrowsers", 1000)
	$running = 0
	TraySetIcon("r.ico")
	GUISetIcon("r.ico")
	ControlSetText("CaféTime.r", "", $Button1, "Start now")
	$stopme = 0
EndFunc

Func stopbrowsers()
	; Check for running instances of browser and alternative browser
	If ProcessExists($browser) Then
		ProcessClose ($browser)
		ProcessWaitClose($browser)
	EndIf
	If ProcessExists($altbrowser) Then
		ProcessClose($altbrowser)
		ProcessWaitClose($altbrowser)
	EndIf
	; Check for prohibited running apps
	prohibit()
EndFunc

Func startbrowser()
	If not ProcessExists ($browser) Then
		ShellExecute($browser)
	Endif
EndFunc

Func prohibit()
	; Check for running instances of prohibited apps (only when nastyversion active)
	If $nastyversion = 1 Then
		If ProcessExists($prohibit1) Then
			ProcessClose ($prohibit1)
			ProcessWaitClose($prohibit1)
		EndIf
		If ProcessExists($prohibit2) Then
			ProcessClose ($prohibit2)
			ProcessWaitClose($prohibit2)
		EndIf
		If ProcessExists($prohibit3) Then
			ProcessClose ($prohibit3)
			ProcessWaitClose($prohibit3)
		EndIf
		If ProcessExists($prohibit4) Then
			ProcessClose ($prohibit4)
			ProcessWaitClose($prohibit4)
		EndIf
		If ProcessExists($prohibit5) Then
			ProcessClose ($prohibit5)
			ProcessWaitClose($prohibit5)
		EndIf
		If ProcessExists($prohibit6) Then
			ProcessClose ($prohibit6)
			ProcessWaitClose($prohibit6)
		EndIf
	EndIf
EndFunc

Func getcurrentpassword()
	$thisdaynumber = _DateToDayValue (@YEAR, @MON, @MDAY)
	$thishour= StringLeft(_NowTime(4),2)
	$thismin= StringRight(_NowTime(4),2)
	$thishournum = StringRight((100*int($thisdaynumber)) + $thishour,6)
	; New system - incl Terminal & session info plus EAN check digit
	; Work out which session we are in
	$this_session=$sessiontime*(int($thismin/$sessiontime))
	; zero pad sessiontime & terminal num to 2 digits
	If $this_session < 10 Then $this_session = "0" & Int($this_session)
	If $terminalnumber < 10 Then $terminalnumber = "0" & Int($terminalnumber)
	; get check digit based on data so far
	$eandigit = get_ean(StringStripWS( $this_session & $terminalnumber & $thishournum ,8))
	; now join terminal number, this session and EAN check digit.
	$correct_code = StringStripWS( $this_session & $terminalnumber & $eandigit & $thishournum ,8)
	Return $correct_code
EndFunc

Func get_ean($sourcenum)
	; Gets an EAN check digit from a number
	; Only works for numbers
	If Not(StringIsDigit($sourcenum)) Then return 0
	$num_len = StringLen($sourcenum)
	$sum=0
	; sum of even position numbers then multiply by 3
	For $n=1 To StringLen($sourcenum) Step 2
		$sum +=  StringMid($sourcenum,$n,1)
	Next
	$sum=$sum * 3
	; add the sum of odd position numbers (if there are any)
	If $num_len > 1 Then
		For $n=2 To StringLen($sourcenum) Step 2
			$sum +=  StringMid($sourcenum,$n,1)
		Next
	EndIf
	;The final digit of the result is subtracted from 10 to calculate the check digit (or left as is if already zero)
	$result = 10 - StringRight($sum,1)
	If $result = 10 Then $result= 0
	Return ($result)
EndFunc
