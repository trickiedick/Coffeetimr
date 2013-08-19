; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

Dim $SCR_DETECTED = 0
$list = ProcessList()
For $i = 1 to $list[0][0]
  If StringInStr($list[$i][0], ".scr") Then
	;*********
	; Screen Saver is running
	;*********
	 $SCR_DETECTED = 1
  EndIf
Next

; BlockInput(1) Turns off keyboard and mouse 