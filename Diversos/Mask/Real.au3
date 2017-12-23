; #FUNCTION# ====================================================================================================================
; Version........: 0.0.0.1
; Name...........: Mask/Real
; Description ...: Aplica uma máscara de número real 0.00 em uma entrada numérica
; Syntax.........:
; Parameters ....:
; Return values .:
; Author ........: Luismar Chechelaky
; Creation.......: 2017/12/23
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: https://github.com/chechelaky/AutoIt/blob/master/Diversos/Mask/Real.au3
; Example .......:
; ===============================================================================================================================

Func Real($num = "")
	If $number == "" Then Return ""
	If $number == "." Then Return "0."
	$number = StringRegExpReplace(StringReplace($number, ",", "."), "[^0-9.]", "")
	Local $dot = StringInStr($number, ".")
	If Not $dot Then Return $number
	Return StringReplace(StringMid($number, 1, $dot - 1), ".", "") & "." & StringReplace(StringMid($number, $dot + 1), ".", "")
EndFunc   ;==>Real
