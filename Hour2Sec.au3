Local $iSec = "1:30"
$iSec = Hour2Sec($iSec)
ConsoleWrite("$iSec[" & $iSec & "]" & @LF)

; #FUNCTION# ====================================================================================================================
; Name...........: Hour2Sec
; Description ...: Convert a string with hour data in seconds hh[ :mm[ :ss]]
; Syntax.........: Hour2Sec(2)
;				   Hour2Sec("2:30")
;				   Hour2Sec("02:30:45")
; Parameters ....: $mInput
; Return values .: Integer, number of seconds
; Author ........: Luismar Chechelaky
; Modified.......: 2015/06/10
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func Hour2Sec($mInput = 0)
	$mInput = StringSplit($mInput, ":", 2)
	Local $aNum[5] = [0, 3600, 0, 0, 0]
	For $ii = 0 To 2
		If $ii < UBound($mInput, 1) And $mInput[$ii] >= 0 Then $aNum[$ii + 2] = $mInput[$ii] * $aNum[1]
		$aNum[0] += $aNum[$ii + 2]
		$aNum[1] /= 60
	Next
	Return $aNum[0]
EndFunc   ;==>Hour2Sec

