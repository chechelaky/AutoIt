#include-once
#include <Date.au3>

; #FUNCTION# ====================================================================================================================
; Name...........: _TimeUnix
; Description ...: Convert a StringTime to UnixTime and UnixTime to StringTime
;				   All StringTime must be like this "yyyy/mm/dd hh:mm:ss"
; Syntax.........:
; Parameters ....: $var
;				   $iMode
; Return values .:
; Author ........: Luismar Chechelaky
; Modified.......: 2018/010/07
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
;	exemple 1
;		Local $now = _TimeUnix()
;		$now = 1433967837
;
;	exemple 2
;		Convert a StringTime to UnixTime
;		Local $time = _TimeUnix("2015/06/10 20:21:22")
;		$time = 1433967682
;
;	exemple 3
;		Convert a UnixTime To StringTime in "yyyy/mm/dd hh:mm:ss"
;		Local $time = _TimeUnix(1433967837)
;		$time = "2015/06/10 20:23:57"
;
;	exemple 4
;		Convert a UnixTime To StringTime in "dd/mm/yyyy hh:mm:ss"
;		Local $time = _TimeUnix(1433967837, 1)
;		$time = "10/06/2015 20:23:57"
;
;	exemple 5
;~ 		Local $aFileGetTime = FileGetTime(@ScriptFullPath)
;~ 		ConsoleWrite("$aFileGetTime[ " & _ArrayToString($aFileGetTime, ",") & " ]" & @LF)
;~ 		Output: $aFileGetTime[ 2018,10,07,09,35,50 ]
;~ 		Local $iUnixTime = _TimeUnix($aFileGetTime)
;~ 		ConsoleWrite("$iUnixTime[" & $iUnixTime & "]" & @LF)
;~ 		Output: $iUnixTime[ 1538904950 ]

; ===============================================================================================================================
Func _TimeUnix($var = 0, $iMode = 0, $char = "/")
	Local $sRet = 0
	Local $sUnix = "1970/01/01 00:00:00"
	If IsArray($var) Then
		$sRet = _TimeUnix($var[0] & "/" & $var[1] & "/" & $var[2] & " " & $var[3] & ":"& $var[4] & ":"& $var[5])
	Else
		If $var = 0 Then
			$sRet = _DateDiff("s", $sUnix, _NowCalc())
		Else
			If String($var) == Number($var) Then
				$sRet = _DateAdd("s", $var, $sUnix)
				If $iMode Then $sRet = StringMid($sRet, 9, 2) & $char & StringMid($sRet, 6, 2) & $char & StringMid($sRet, 1, 4) & " " & StringMid($sRet, 12)
			Else
				$sRet = StringFormat("%014s", -_DateDiff("s", $var, $sUnix))
				$sRet = -_DateDiff("s", $var, $sUnix)
			EndIf
		EndIf
	EndIf
	Return $sRet
EndFunc   ;==>_TimeUnix
