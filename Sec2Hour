; #FUNCTION# ====================================================================================================================
; Name...........: Sec2Hour
; Description ...: Convert a seconds number in string time
; Syntax.........: Sec2Hour( $iInput [, $iMode ] )
; Parameters ....: $iInput	integer, number of seconds
;                  $iMode	0	show amount big than 24 as day
;							1	show every all hours
; Return values .: string	$iMode = 0	"0d 00:00:00"
;							$iMode = 1	"00:00:00"
; Author ........: Luismar Chechelaky
; Modified.......: 2015/06/10
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func Sec2Hour($iInput = 0, $iMode = 0)
	$iMode = $iMode ? 1 : 0
	If $iInput <= 0 Then Return 0
	Local $aNum[3] = [86400, 3600, 60]
	Local $aRet[4] = [0, 0, 0, $iInput]
	For $ii = $iMode To 2
		While $aRet[3] >= $aNum[$ii]
			$aRet[$ii] += 1
			$aRet[3] -= $aNum[$ii]
		WEnd
		If $ii Then $aRet[$ii] = StringFormat("%02s", $aRet[$ii])
	Next
	$aRet[3] = StringFormat("%02s", $aRet[3])
	Return $iMode ? ($aRet[1] & ":" & $aRet[2] & ":" & $aRet[3]) : ($aRet[0] & "d " & $aRet[1] & ":" & $aRet[2] & ":" & $aRet[3])
EndFunc   ;==>Sec2Hour
