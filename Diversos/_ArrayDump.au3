#include-once
#include <Array.au3>
; autor: Luismar Chechelaky
Func _ArrayDump($arr, $name = "")
	Local $iCol = UBound($arr, 2)
	Local $aCol[$iCol]
	Local $iLen
	Local $line_head = "+"
	For $ii = 0 To UBound($arr, 1) - 1
		For $jj = 0 To UBound($arr, 2) - 1
			$iLen = StringLen($arr[$ii][$jj])
			If $iLen > $aCol[$jj] Then $aCol[$jj] = $iLen
		Next
	Next
	Local $line = "+"
	For $ii = 0 To $iCol - 1
		$line &= _StringRepeat("-", $aCol[$ii]) & "+"
		$line_head &= _StringRepeat("-", $aCol[$ii] - StringLen(String($ii))) & $ii & "+"
	Next
	If $name Then ConsoleWrite("arr[ " & $name & " ] " & UBound($arr, 1) & "x" & UBound($arr, 2) & @LF)
	ConsoleWrite($line_head & @LF)
	For $ii = 0 To UBound($arr, 1) - 1
		ConsoleWrite($ii = 1 ? $line & @LF & "|" : "|")
		For $jj = 0 To UBound($arr, 2) - 1
			$iLen = StringLen($arr[$ii][$jj])
			ConsoleWrite(Conv($arr[$ii][$jj]) & _StringRepeat(" ", $aCol[$jj] - $iLen) & "|")
		Next
		ConsoleWrite(@LF)
	Next
	ConsoleWrite($line & @LF)
EndFunc   ;==>_ArrayDump

Func Conv($var)
	Local $Pattern[][2] = [["[áãâ]", "a"], ["[éê]", "e"], ["[íî]", "i"], ["[óõô]", "o"], ["[úû]", "u"], ["[ÁÃÂ]", "A"], ["[ÉÊ]", "E"], ["[ÍÎ]", "I"], ["[ÓÕÔ]", "O"], ["[ÚÛ]", "U"], ["[Ç]", "C"], ["[ç]", "c"]]
	For $ii = 0 To UBound($Pattern, 1) - 1
		$var = StringRegExpReplace($var, $Pattern[$ii][0], $Pattern[$ii][1])
	Next
	Return $var
EndFunc   ;==>Conv
