#include-once
#include <Array.au3>
#include <String.au3>

; #FUNCTION# ====================================================================================================================
; Name...........: _nome
; Description ...: Imprime número, string com aspas e transforma em texto um array[n] ou array [n][m].
; Syntax.........: Print()
; Parameters ....: $input: número, texto, array 1D ou array 2D
; Return values .: 
; Author ........: Luigi (Luismar Chechelaky)
; Modified.......: 2018 10 06
; Remarks .......:
; Link ..........: https://github.com/chechelaky/AutoIt/edit/master/Print/Print.au3
; Example .......: No
; AutoIt version.: 3.3.14.5
; ===============================================================================================================================

Func Print($input = Null)
	If IsArray($input) Then
		$input = _Print_Array($input)
	Else
		If Number($input) Then
			$input = $input & @LF
		Else
			$input = '"' & $input & '"' & @LF
		EndIf
	EndIf
	ConsoleWrite($input)
EndFunc   ;==>Print

Func _Print_Array($input = Null)
	Local $ret = ""
	Switch UBound($input, $UBOUND_DIMENSIONS)
		Case 1
			Local $iROWS = UBound($input, $UBOUND_ROWS) - 1
			Local $iLenMax[$iROWS + 1]

			For $ii = 0 To $iROWS
				$iLenMax[$ii] = StringLen($input[$ii])
			Next
			$iLenMax = _ArrayMax($iLenMax)
			Local $iLenLen = StringLen($iROWS)

			Local $border = StringFormat("%" & $iLenLen & "s", " ") & " +" & _StringRepeat("-", $iLenMax) & "+" & @LF
			$ret &= $border
			For $ii = 0 To UBound($input, $UBOUND_ROWS) - 1
				$ret &= StringFormat("%" & $iLenLen & "s", $ii) & " |" & StringFormat("%" & $iLenMax & "s", $input[$ii]) & "|" & @LF
			Next
			$ret &= $border
		Case 2
			Local $iROWS = UBound($input, $UBOUND_ROWS) - 1
			Local $iCOLS = UBound($input, $UBOUND_COLUMNS) - 1

			Local $aLenMax[$iCOLS + 1]
			For $ii = 0 To $iROWS
				For $jj = 0 To $iCOLS
					$aLenMax[$jj] = StringLen($input[$ii][$jj]) > $aLenMax[$jj] ? StringLen($input[$ii][$jj]) : $aLenMax[$jj]
				Next
			Next
			Local $lenROWS = StringLen($iROWS)
			Local $border = ""
			Local $line = ""

			For $ii = 0 To $iROWS
				For $jj = 0 To $iCOLS
					Switch $ii
						Case 0
							Switch $jj
								Case 0
									$border &= _StringRepeat(" ", $lenROWS + 1) & "+"
									$border &= _StringRepeat("-", $aLenMax[$jj] - StringLen($aLenMax[$jj])) & $jj & "+"
									$line &= _StringRepeat(" ", $lenROWS - StringLen($ii)) & $ii & " |" & StringFormat("%" & $aLenMax[$jj] & "s", $input[$ii][$jj]) & "|"
								Case $iCOLS
									$border &= _StringRepeat("-", $aLenMax[$jj] - StringLen($aLenMax[$jj])) & $jj & "+"
									$line &= StringFormat("%" & $aLenMax[$jj] & "s", $input[$ii][$jj]) & "|"
								Case Else
									$border &= _StringRepeat("-", $aLenMax[$jj] - StringLen($aLenMax[$jj])) & $jj & "+"
									$line &= _StringRepeat(" ", $aLenMax[$jj] - StringLen($input[$ii][$jj])) & $input[$ii][$jj] & "|"
							EndSwitch
						Case $iROWS
							Switch $jj
								Case 0
									$border &= _StringRepeat(" ", $lenROWS + 1) & "+"
									$border &= _StringRepeat("-", $aLenMax[$jj]) & "+"
									$line &= _StringRepeat(" ", $lenROWS - StringLen($ii)) & $ii & " |" & StringFormat("%" & $aLenMax[$jj] & "s", $input[$ii][$jj]) & "|"
								Case $iCOLS
									$border &= _StringRepeat("-", $aLenMax[$jj]) & "+"
									$line &= StringFormat("%" & $aLenMax[$jj] & "s", $input[$ii][$jj]) & "|"
								Case Else
									$border &= _StringRepeat("-", $aLenMax[$jj]) & "+"
									$line &= _StringRepeat(" ", $aLenMax[$jj] - StringLen($input[$ii][$jj])) & $input[$ii][$jj] & "|"
							EndSwitch
						Case Else
							Switch $jj
								Case 0
									$line &= _StringRepeat(" ", $lenROWS - StringLen($ii)) & $ii & " |" & StringFormat("%" & $aLenMax[$jj] & "s", $input[$ii][$jj]) & "|"
								Case $iCOLS
									$line &= StringFormat("%" & $aLenMax[$jj] & "s", $input[$ii][$jj]) & "|"
								Case Else
									$line &= StringFormat("%" & $aLenMax[$jj] & "s", $input[$ii][$jj]) & "|"
							EndSwitch
					EndSwitch
				Next

				If $ii = $iROWS Then
					$ret &= $line & @LF
					If $border Then $ret &= $border & @LF
				Else
					If $border Then $ret &= $border & @LF
					$ret &= $line & @LF
				EndIf

				$border = ""
				$line = ""
			Next
			Return $ret
		Case Else
	EndSwitch
	Return $ret
EndFunc   ;==>_Print_Array
