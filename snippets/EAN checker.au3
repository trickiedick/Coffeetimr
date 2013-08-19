#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Dick Davies

 Script Function: EAN Checker snippet
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=Z:\files\Shared Documents\Programming\Cafetimer\EAN maker.kxf
$Form1 = GUICreate("EAN Checker", 231, 85, 192, 114)
$Number_in = GUICtrlCreateInput("Number_in", 8, 16, 113, 21)
$Button1 = GUICtrlCreateButton("Get EAN Digit", 136, 16, 81, 25, $WS_GROUP)
$Caption = GUICtrlCreateLabel("EAN digit is:", 16, 56, 61, 17)
$Input1 = GUICtrlCreateInput("0", 80, 51, 33, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1
			GUICtrlSetData($Input1, get_ean(GUICtrlRead($Number_in)))


	EndSwitch
WEnd

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
