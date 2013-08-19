;===============================================================================
;
; Description:      Mouse fix script for AutoIT
; Syntax:           mousefix.au3
; Parameter(s):     none
; Requirement(s):   AutoIT
; Return Value(s):  None
; Author(s):        AutoIT Support, this is directly from the documentation.
; Note(s):          This code ensures that the correct mouse clicks are done,
;                    even if the user has switched them.
;
;===============================================================================

; SAFER VERSION of Double click at 0,500

    Dim $primary
    Dim $secondary
    ;Determine if user has swapped right and left mouse buttons
    $k = RegRead("HKEY_CURRENT_USER\Control Panel\Mouse", "SwapMouseButtons")
   
    ; It's okay to NOT check the success of the RegRead operation
    If $k = 1 Then
        $primary = "right"
        $secondary = "left"
    Else ;normal (also case if could not read registry key)
        $primary = "left"
        $secondary = "right"
    EndIf

;===============================================================================
