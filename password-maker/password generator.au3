#Region converted Directives from Z:\files\Shared Documents\Programming\Cafetimer\password generator.au3.ini
#AutoIt3Wrapper_aut2exe=E:\Program Files\AutoIt3\aut2exe\Aut2Exe.exe
#AutoIt3Wrapper_icon=Z:\files\Shared Documents\Programming\Cafetimer\code.ico
#AutoIt3Wrapper_outfile=Z:\files\Shared Documents\Programming\Cafetimer\password generator.exe
#AutoIt3Wrapper_Res_Description=AutoIt v3 Compiled Script
#AutoIt3Wrapper_Res_LegalCopyright=Richard Davies (dick.davies@gmail.com)
#EndRegion converted Directives from Z:\files\Shared Documents\Programming\Cafetimer\password generator.au3.ini
;
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.4.8
 Author:         Dick Davies

 Script Function:
	Generate apparently random numbers for each hour of each day and month.
	Print out a pretty list for operators to use.
#ce ----------------------------------------------------------------------------

; Script Start -
#include <Date.au3>
#include <GUIConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;$year = 2007
;$starthour= 8
;$finishhour=23
;$startmonth=7
;$finishmonth=7

$listfile = "codeslist.txt"

$outfile=FileOpen($listfile,2)


#Region ### START Koda GUI section ### Form=Z:\files\Shared Documents\Programming\Cafetimer\passmaker.kxf
$Form1 = GUICreate("Select the month you want", 244, 201, 192, 114)
$Combo1 = GUICtrlCreateCombo(" ", 16, 80, 113, 25)
GUICtrlSetData($Combo1, "01 January|02 February|03 March|04 April|05 May|06 June|07 July|08 August|09 September|10 October|11 November|12 December","07 July")
$Combo2 = GUICtrlCreateCombo(" ", 145, 80, 73, 25)
GUICtrlSetData($Combo2, "2009|2010|2011|2012|2013|2014|2015|2016|2017|2018|2019|2020", "2009")
$Combo3 = GUICtrlCreateCombo(" ", 97, 111, 41, 25)
GUICtrlSetData($Combo3, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23", "12")
$Combo4 = GUICtrlCreateCombo(" ", 176, 111, 41, 25)
GUICtrlSetData($Combo4, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23", "23")
$Combo5 = GUICtrlCreateCombo(" ", 168, 8, 49, 25)
GUICtrlSetData($Combo5, "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20", "03")
$Combo6 = GUICtrlCreateCombo("20", 159, 42, 57, 25)
GUICtrlSetData($Combo6, "05|10|15|20|30|60","20")
$Label1 = GUICtrlCreateLabel("Working hours:", 16, 114, 76, 17)
$Label2 = GUICtrlCreateLabel("till:", 152, 115, 16, 17)
$Label3 = GUICtrlCreateLabel("No of terminals", 72, 13, 74, 17)
$Label4 = GUICtrlCreateLabel("Session minutes", 70, 44, 80, 17)
$Button1 = GUICtrlCreateButton("Make List", 68, 155, 97, 33, 0)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
		    $year=GUICtrlRead($Combo2)
			$startmonth=StringLeft(GUICtrlRead($Combo1),2)
			$finishmonth=StringLeft(GUICtrlRead($Combo1),2)
			$starthour=GUICtrlRead($Combo3)
			$finishhour=GUICtrlRead($Combo4)
			$sessionlength =GUICtrlRead($Combo6)
			$maxterminals =GUICtrlRead($Combo5)
			ExitLoop

		Case $Button1
		    $year=GUICtrlRead($Combo2)
			$startmonth=StringLeft(GUICtrlRead($Combo1),2)
			$finishmonth=StringLeft(GUICtrlRead($Combo1),2)
			$starthour=GUICtrlRead($Combo3)
			$finishhour=GUICtrlRead($Combo4)
			$sessionlength =GUICtrlRead($Combo6)
			$maxterminals =GUICtrlRead($Combo5)
			ExitLoop
	EndSwitch
WEnd

GUISetState(@SW_HIDE)

$line = "Codes list for "& $startmonth & "/" & $year & " For the hours " & $starthour & " to " & $finishhour
FileWriteLine($listfile , $line)
$line = "============================================="
FileWriteLine($listfile , $line)
$line = " "
FileWriteLine($listfile , $line)

For $month = $startmonth to $finishmonth
; monthly
	$maxdays = _DateDaysInMonth ($year,$month)
	For $day = 1 to $maxdays
	;daily
		$Daynum = _DateToDayValue ($year, $month, $day)
		$Dayinweek = _DateToDayOfWeek ($year, $month, $day)
		$DayName = _DateDayOfWeek($Dayinweek,1)
		$dDD=""
		$dMM=""
		$dYYYY=""
		$getprettydate = _DayValueToDate($Daynum, $dYYYY,$dMM,$dDD)
		$prettydate= $DayName & " " & $dDD &"/" & $dMM & "/" & $dYYYY
		For $hour = $starthour to $finishhour
		; hourly
			$zhour = StringFormat("%02i",$hour)
			; Get hournumber
			$hournum = StringRight((100*int($Daynum)) + $hour,6)

			;; Old approach - bit rotate
			;$codehournum = BitRotate($hournum,-5)
			;; Crosscheck and note problems
			;$ushifthournum = BitRotate($codehournum,5)
			;If $ushifthournum = $hournum Then
			;	$match = ""
			;Else
			;	$match = " ERROR ************"
			;EndIf
			;$codeline = $codehournum & $match

			; new approach
			;$codeline = $hournum & ":" & get_ean($hournum)


			; loop for terminals
			For $terminal= 1 to $maxterminals
				$codeline=""
				If $terminal < 10 Then $terminal = "0" & $terminal
				; loop for session slots
				$sessmins = 0
				While $sessmins < 60
					If $sessmins < 10 Then $sessmins = "0" & $sessmins
					$eancode = get_ean(StringStripWS( $sessmins & $terminal & $hournum ,8))
					$codehournum = StringStripWS( $sessmins & $terminal & $eancode & $hournum    ,8)
					$codeline &= $zhour & ":" & $sessmins & " " & $codehournum & " "
					; for each session slot in the hour
					$sessmins += $sessionlength
				WEnd
			; Format the printout
			$line = $prettydate & " Term " & $terminal & " Codes " & $codeline
			FileWriteLine($listfile , $line)
			$prettydate = "              "
			Next
			FileWriteLine($listfile , " ")
		Next
	Next
Next

FileClose($outfile)

$msg = "Codes list has been saved in " & $listfile
MsgBox(0,"Done", $msg ,2)

ShellExecute($listfile)


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
