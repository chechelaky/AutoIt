#include-once
#include <String.au3>

Func dump($oo, $key = "", $iIdent = 0)
	ConsoleWrite(dump_str($oo, $key, $iIdent) & @LF)
EndFunc   ;==>dump

; #FUNCTION# ====================================================================================================================
; Name...........: dump_str
; Description ...:
; Syntax.........:
; Parameters ....:
; Return values .:
; Author ........: Luismar Chechelaky
; Modified.......: 2015/06/10
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func dump_str($oo, $key = "", $iIdent = 0)
	Local $iTab = 4
	Local $sKeys
	Local $sString = ""
	If IsDictionary($oo) Then
		$sKeys = $oo.Keys
		For $each In $sKeys
			If IsDictionary($oo.Item($each)) Or IsArray($oo.Item($each)) Then
				$sString &= (($iIdent == 0 ? "" : (_StringRepeat(" ", $iIdent))) & $each & "{" & @LF)
				$sString &= dump_str($oo.Item($each), ($key == "" ? "" : $key & ".") & $each, $iTab + $iIdent)
				$sString &= (($iIdent == 0 ? "" : (_StringRepeat(" ", $iIdent))) & "}" & @LF)
			Else
				$sString &= (($iIdent == 0 ? "" : (_StringRepeat(" ", $iIdent))) & ($key == "" ? "" : $key & ".") & $each & " = " & $oo.Item($each) & @LF)
			EndIf
		Next
	Else
		If IsArray($oo) Then
			Switch UBound($oo, 0)
				Case 1
					For $ii = 0 To UBound($oo, 1) - 1
						If IsDictionary($oo[$ii]) Or IsArray($oo[$ii]) Then
							$sString &= dump_str($oo[$ii], $key & "[" & $ii & "]", $iTab + $iIdent)
						Else
							$sString &= (($iIdent == 0 ? "" : (_StringRepeat(" ", $iIdent))) & "[" & ($key == "" ? "" : $key & "[") & $ii & "] = " & $oo[$ii] & @LF)
						EndIf
					Next
				Case 2
					For $ii = 0 To UBound($oo, 1) - 1
						For $jj = 0 To UBound($oo, 2) - 1
							If IsDictionary($oo[$ii][$jj]) Or IsArray($oo[$ii][$jj]) Then
								$sString &= dump_str($oo[$ii][$jj], $key & "[" & $ii & "][" & $jj & "]", $iTab + $iIdent)
							Else
								$sString &= (($iIdent == 0 ? "" : (_StringRepeat(" ", $iIdent))) & ($key == "" ? "" : $key & "[") & $ii & "][" & $jj & "] = " & $oo[$ii][$jj] & @LF)
							EndIf
						Next
					Next
			EndSwitch
		Else

		EndIf
	EndIf
	Return $sString
EndFunc   ;==>dump_str

Func IsDictionary($oo = Null)
	If Not IsObj($oo) Or Not (ObjName($oo, 2) == "Scripting.Dictionary") Then Return 0
	Return 1
EndFunc   ;==>IsDictionary
