#include-once
#include <Array.au3>
#include <String.au3>

; FRED
; #INDEX# ==========================================================================================================================================================
; Title .........: FRED 1.01
; AutoIt Version : 3.3.10.2
; Language ......: Português Br
; Description ...: codifica: array, Scripting.Dictionary, double, int32, int64, bool, string, Null, Default em uma cadeia de caracteres
; Authors .......: Luismar Chechelaky (Luigi)
; Source.........: 
; Version........: 0.0.0.2
; fixeds:
;                  30/06/2014 bug in empty code fixed
; ==================================================================================================================================================================

;~ example_01()
;~ example_02()
;~ example_03()
;~ example_04()
;~ example_05()
;~ example_06()
;~ example_07()

;~ Func example_01()
;~ 	Local $num = 1
;~ 	Local $code = code($num)
;~ 	Local $decode = decode($code)
;~ 	MsgBox(0, 'Example 01', '$num = ' & $num & @LF & '$code = ' & $code & @LF & '$decode = ' & $decode)
;~ EndFunc   ;==>example_01

;~ Func example_02()
;~ 	Local $num = 0
;~ 	Local $code = code($num)
;~ 	Local $decode = decode($code)
;~ 	MsgBox(0, 'Example 02', '$num = ' & $num & @LF & '$code = ' & $code & @LF & '$decode = ' & $decode)
;~ EndFunc   ;==>example_02

;~ Func example_03()
;~ 	Local $num = -1
;~ 	Local $code = code($num)
;~ 	Local $decode = decode($code)
;~ 	MsgBox(0, 'Example 03', '$num = ' & $num & @LF & '$code = ' & $code & @LF & '$decode = ' & $decode)
;~ EndFunc   ;==>example_03

;~ Func example_04()
;~ 	Local $string = 'É um erro ter razão cedo demais.'
;~ 	Local $code = code($string)
;~ 	Local $decode = decode($code)
;~ 	MsgBox(0, 'Example 04', '$num = ' & $string & @LF & '$code = ' & $code & @LF & '$decode = ' & $decode)
;~ EndFunc   ;==>example_04

;~ Func example_05()
;~ 	Local $aTest[2] = ['Violão', 'Argüição']
;~ 	_ArrayDisplay($aTest, 'Ex. 5')
;~ 	Local $code = code($aTest)
;~ 	MsgBox(0, 'Example 05: code array[n]', '$code = ' & $code)
;~ 	Local $decode = decode($code)
;~ 	_ArrayDisplay($decode, 'Ex. 5 decode array')
;~ EndFunc   ;==>example_05

Func example_06()
	Local $aTest1[2] = ['Violão', 'Argüição']
	Local $aTest2[2][2] = [['um', $aTest1],['três', 'quatro']]
	_ArrayDisplay($aTest2, 'Ex. 6')
	Local $code = code($aTest2)
	MsgBox(0, 'Example 06: code array[n][m]', '$code = ' & $code)
	Local $decode = decode($code)
	_ArrayDisplay($decode, 'Ex. 6 decode $aTeste2[n][m]')
	_ArrayDisplay($decode[0][1], 'Ex. 6 decode $aTest1[n]')
EndFunc   ;==>example_06

;~ Func example_07()
;~ 	Local $aTest1[2] = ["Violão", "Argüição"]
;~ 	Local $oo = ObjCreate("Scripting.Dictionary")
;~ 	$oo.Add("key1", "")
;~ 	$oo.Add("key2", "value2")
;~ 	$oo.Add("key3", $aTest1)
;~ 	Local $code = code($oo)
;~ 	MsgBox(0, "Example 07: code obj", "$code = " & $code)
;~ 	Local $decode = decode($code)
;~ 	MsgBox(0, "Example 07: decode", _
;~ 			"key1 = " & $decode.Item("key1") & _
;~ 			"key2 = " & $decode.Item("key2") & _
;~ 			"key3.0 = " & ($decode.Item("key3"))[0] & _
;~ 			"key3.1 = " & ($decode.Item("key3"))[1])
;~ EndFunc   ;==>example_07

Func decode($VAR = '')
	Local $iLenght = __lenght($VAR)
	Local $iSize = StringLeft($VAR, $iLenght)
	Local $sType = StringMid($VAR, $iLenght + 1, 1)
	Switch $sType
		Case 'a'
			Local $aMount[1]
			__mount_array($aMount, $VAR)
			__clean_var($VAR)
			Switch UBound($aMount, 0)
				Case 1
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						$aMount[$iNext_1] = __mount_next_cell($VAR)
					Next
					Return $aMount
				Case 2
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							$aMount[$iNext_1][$iNext_2] = __mount_next_cell($VAR)
						Next
					Next
					Return $aMount
				Case 3
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							For $iNext_3 = 0 To UBound($aMount, 3) - 1
								$aMount[$iNext_1][$iNext_2][$iNext_3] = __mount_next_cell($VAR)
							Next
						Next
					Next
					Return $aMount
				Case 4
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							For $iNext_3 = 0 To UBound($aMount, 3) - 1
								For $iNext_4 = 0 To UBound($aMount, 4) - 1
									$aMount[$iNext_1][$iNext_2][$iNext_3][$iNext_4] = __mount_next_cell($VAR)
								Next
							Next
						Next
					Next
					Return $aMount
				Case 4
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							For $iNext_3 = 0 To UBound($aMount, 3) - 1
								For $iNext_4 = 0 To UBound($aMount, 4) - 1
									For $iNext_5 = 0 To UBound($aMount, 5) - 1
										$aMount[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5] = __mount_next_cell($VAR)
									Next
								Next
							Next
						Next
					Next
					Return $aMount
				Case 5
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							For $iNext_3 = 0 To UBound($aMount, 3) - 1
								For $iNext_4 = 0 To UBound($aMount, 4) - 1
									For $iNext_5 = 0 To UBound($aMount, 5) - 1
										For $iNext_6 = 0 To UBound($aMount, 6) - 1
											$aMount[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6] = __mount_next_cell($VAR)
										Next
									Next
								Next
							Next
						Next
					Next
					Return $aMount
				Case 6
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							For $iNext_3 = 0 To UBound($aMount, 3) - 1
								For $iNext_4 = 0 To UBound($aMount, 4) - 1
									For $iNext_5 = 0 To UBound($aMount, 5) - 1
										For $iNext_6 = 0 To UBound($aMount, 6) - 1
											For $iNext_7 = 0 To UBound($aMount, 7) - 1
												$aMount[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6][$iNext_7] = __mount_next_cell($VAR)
											Next
										Next
									Next
								Next
							Next
						Next
					Next
					Return $aMount
				Case 7
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							For $iNext_3 = 0 To UBound($aMount, 3) - 1
								For $iNext_4 = 0 To UBound($aMount, 4) - 1
									For $iNext_5 = 0 To UBound($aMount, 5) - 1
										For $iNext_6 = 0 To UBound($aMount, 6) - 1
											For $iNext_7 = 0 To UBound($aMount, 7) - 1
												For $iNext_8 = 0 To UBound($aMount, 8) - 1
													$aMount[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6][$iNext_7][$iNext_8] = __mount_next_cell($VAR)
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
					Return $aMount
				Case 8
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							For $iNext_3 = 0 To UBound($aMount, 3) - 1
								For $iNext_4 = 0 To UBound($aMount, 4) - 1
									For $iNext_5 = 0 To UBound($aMount, 5) - 1
										For $iNext_6 = 0 To UBound($aMount, 6) - 1
											For $iNext_7 = 0 To UBound($aMount, 7) - 1
												For $iNext_8 = 0 To UBound($aMount, 8) - 1
													For $iNext_9 = 0 To UBound($aMount, 9) - 1
														$aMount[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6][$iNext_7][$iNext_8][$iNext_9] = __mount_next_cell($VAR)
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
					Return $aMount
				Case 9
					For $iNext_1 = 0 To UBound($aMount, 1) - 1
						For $iNext_2 = 0 To UBound($aMount, 2) - 1
							For $iNext_3 = 0 To UBound($aMount, 3) - 1
								For $iNext_4 = 0 To UBound($aMount, 4) - 1
									For $iNext_5 = 0 To UBound($aMount, 5) - 1
										For $iNext_6 = 0 To UBound($aMount, 6) - 1
											For $iNext_7 = 0 To UBound($aMount, 7) - 1
												For $iNext_8 = 0 To UBound($aMount, 8) - 1
													For $iNext_9 = 0 To UBound($aMount, 9) - 1
														For $iNext_10 = 0 To UBound($aMount, 10) - 1
															$aMount[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6][$iNext_7][$iNext_8][$iNext_9][$iNext_10] = __mount_next_cell($VAR)
														Next
													Next
												Next
											Next
										Next
									Next
								Next
							Next
						Next
					Next
					Return $aMount
				Case Else
					Return SetError(1, 0, 0)
			EndSwitch
		Case 'o'
			__clean_var($VAR, 1)
			Local $oo = ObjCreate('Scripting.Dictionary')
			While Not $VAR = ''
				Local $key, $value
				$key = __mount_next_cell($VAR)
				$value = __mount_next_cell($VAR)
				$oo.Add($key, $value)
			WEnd
			$VAR = $oo
		Case 'f', 'F'
			If $iSize == 0 Then
				$VAR = 0.0
			Else
				$VAR = StringReplace($VAR, '_', '.')
				$VAR = Number(StringMid($VAR, __lenght($VAR) + 2))
				$VAR *= ($sType == 'F' ? 1 : -1)
			EndIf
		Case 'i', 'I'
			If $iSize == 0 Then
				$VAR = 0
			Else
				$VAR = Number(StringMid($VAR, __lenght($VAR) + 2))
				$VAR *= ($sType == 'I' ? 1 : -1)
			EndIf
		Case 'y', 'Y'
			If $iSize == 0 Then
				$VAR = 0
			Else
				$VAR = Number(StringMid($VAR, __lenght($VAR) + 2))
				$VAR *= ($sType == 'I' ? 1 : -1)
			EndIf
		Case 'b', 'B'
			$VAR = ($sType == 'b' ? False : True)
		Case 'n'
			$VAR = Null
		Case 'd'
			$VAR = Default
		Case 's'
			If $iSize Then
				$VAR = String(__decode(StringMid($VAR, __lenght($VAR) + 2)))
			Else
				$VAR = ''
			EndIf
	EndSwitch
	Return $VAR
EndFunc   ;==>decode

Func code($VAR = '', $mode = 0)
	If Number($mode) == 1 Then
		$VAR = String($VAR)
		If $VAR == '' Then Return SetError(1, 0, 0)
		$VAR = StringRegExpReplace($VAR, '[^A-Za-z0-9\-]', '')
		If StringLen($VAR) == 0 Then Return SetError(1, 0, 0)
	EndIf

	If IsArray($VAR) Then
		Local $aDim[1]
		For $num_0 = 0 To UBound($VAR, 0) - 1
			_ArrayAdd($aDim, UBound($VAR, $num_0 + 1))
		Next
		$aDim = _ArrayToString($aDim, '*', 1)
		Switch UBound($VAR, 0)
			Case 1
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR) - 1
					_ArrayAdd($aTemp0, code($VAR[$iNext_1]))
				Next
				Local $string = _ArrayToString($aTemp0, ',', 1)
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 2
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						_ArrayAdd($aTemp1, code($VAR[$iNext_1][$iNext_2]))
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 3
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						Local $aTemp2[1]
						For $iNext_3 = 0 To UBound($VAR, 3) - 1
							_ArrayAdd($aTemp2, code($VAR[$iNext_1][$iNext_2][$iNext_3]))
						Next
						_ArrayAdd($aTemp1, '[' & _ArrayToString($aTemp2, ',', 1) & ']')
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 4
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						Local $aTemp2[1]
						For $iNext_3 = 0 To UBound($VAR, 3) - 1
							Local $aTemp3[1]
							For $iNext_4 = 0 To UBound($VAR, 4) - 1
								_ArrayAdd($aTemp3, code($VAR[$iNext_1][$iNext_2][$iNext_3][$iNext_4]))
							Next
							_ArrayAdd($aTemp2, '[' & _ArrayToString($aTemp3, ',', 1) & ']')
						Next
						_ArrayAdd($aTemp1, '[' & _ArrayToString($aTemp2, ',', 1) & ']')
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 5
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						Local $aTemp2[1]
						For $iNext_3 = 0 To UBound($VAR, 3) - 1
							Local $aTemp3[1]
							For $iNext_4 = 0 To UBound($VAR, 4) - 1
								Local $aTemp4[1]
								For $iNext_5 = 0 To UBound($VAR, 5) - 1
									_ArrayAdd($aTemp4, code($VAR[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5]))
								Next
								_ArrayAdd($aTemp3, '[' & _ArrayToString($aTemp4, ',', 1) & ']')
							Next
							_ArrayAdd($aTemp2, '[' & _ArrayToString($aTemp3, ',', 1) & ']')
						Next
						_ArrayAdd($aTemp1, '[' & _ArrayToString($aTemp2, ',', 1) & ']')
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 6
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						Local $aTemp2[1]
						For $iNext_3 = 0 To UBound($VAR, 3) - 1
							Local $aTemp3[1]
							For $iNext_4 = 0 To UBound($VAR, 4) - 1
								Local $aTemp4[1]
								For $iNext_5 = 0 To UBound($VAR, 5) - 1
									Local $aTemp5[1]
									For $iNext_6 = 0 To UBound($VAR, 6) - 1
										_ArrayAdd($aTemp5, code($VAR[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6]))
									Next
									_ArrayAdd($aTemp4, '[' & _ArrayToString($aTemp5, ',', 1) & ']')
								Next
								_ArrayAdd($aTemp3, '[' & _ArrayToString($aTemp4, ',', 1) & ']')
							Next
							_ArrayAdd($aTemp2, '[' & _ArrayToString($aTemp3, ',', 1) & ']')
						Next
						_ArrayAdd($aTemp1, '[' & _ArrayToString($aTemp2, ',', 1) & ']')
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 7
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						Local $aTemp2[1]
						For $iNext_3 = 0 To UBound($VAR, 3) - 1
							Local $aTemp3[1]
							For $iNext_4 = 0 To UBound($VAR, 4) - 1
								Local $aTemp4[1]
								For $iNext_5 = 0 To UBound($VAR, 5) - 1
									Local $aTemp5[1]
									For $iNext_6 = 0 To UBound($VAR, 6) - 1
										Local $aTemp6[1]
										For $iNext_7 = 0 To UBound($VAR, 7) - 1
											_ArrayAdd($aTemp6, code($VAR[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6][$iNext_7]))
										Next
										_ArrayAdd($aTemp5, '[' & _ArrayToString($aTemp6, ',', 1) & ']')
									Next
									_ArrayAdd($aTemp4, '[' & _ArrayToString($aTemp5, ',', 1) & ']')
								Next
								_ArrayAdd($aTemp3, '[' & _ArrayToString($aTemp4, ',', 1) & ']')
							Next
							_ArrayAdd($aTemp2, '[' & _ArrayToString($aTemp3, ',', 1) & ']')
						Next
						_ArrayAdd($aTemp1, '[' & _ArrayToString($aTemp2, ',', 1) & ']')
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 8
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						Local $aTemp2[1]
						For $iNext_3 = 0 To UBound($VAR, 3) - 1
							Local $aTemp3[1]
							For $iNext_4 = 0 To UBound($VAR, 4) - 1
								Local $aTemp4[1]
								For $iNext_5 = 0 To UBound($VAR, 5) - 1
									Local $aTemp5[1]
									For $iNext_6 = 0 To UBound($VAR, 6) - 1
										Local $aTemp6[1]
										For $iNext_7 = 0 To UBound($VAR, 7) - 1
											Local $aTemp7[1]
											For $iNext_8 = 0 To UBound($VAR, 8) - 1
												_ArrayAdd($aTemp7, code($VAR[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6][$iNext_7][$iNext_8]))
											Next
											_ArrayAdd($aTemp6, '[' & _ArrayToString($aTemp7, ',', 1) & ']')
										Next
										_ArrayAdd($aTemp5, '[' & _ArrayToString($aTemp6, ',', 1) & ']')
									Next
									_ArrayAdd($aTemp4, '[' & _ArrayToString($aTemp5, ',', 1) & ']')
								Next
								_ArrayAdd($aTemp3, '[' & _ArrayToString($aTemp4, ',', 1) & ']')
							Next
							_ArrayAdd($aTemp2, '[' & _ArrayToString($aTemp3, ',', 1) & ']')
						Next
						_ArrayAdd($aTemp1, '[' & _ArrayToString($aTemp2, ',', 1) & ']')
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 9
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						Local $aTemp2[1]
						For $iNext_3 = 0 To UBound($VAR, 3) - 1
							Local $aTemp3[1]
							For $iNext_4 = 0 To UBound($VAR, 4) - 1
								Local $aTemp4[1]
								For $iNext_5 = 0 To UBound($VAR, 5) - 1
									Local $aTemp5[1]
									For $iNext_6 = 0 To UBound($VAR, 6) - 1
										Local $aTemp6[1]
										For $iNext_7 = 0 To UBound($VAR, 7) - 1
											Local $aTemp7[1]
											For $iNext_8 = 0 To UBound($VAR, 8) - 1
												Local $aTemp8[1]
												For $iNext_9 = 0 To UBound($VAR, 9) - 1
													_ArrayAdd($aTemp8, code($VAR[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6][$iNext_7][$iNext_8][$iNext_9]))
												Next
												_ArrayAdd($aTemp7, '[' & _ArrayToString($aTemp8, ',', 1) & ']')
											Next
											_ArrayAdd($aTemp6, '[' & _ArrayToString($aTemp7, ',', 1) & ']')
										Next
										_ArrayAdd($aTemp5, '[' & _ArrayToString($aTemp6, ',', 1) & ']')
									Next
									_ArrayAdd($aTemp4, '[' & _ArrayToString($aTemp5, ',', 1) & ']')
								Next
								_ArrayAdd($aTemp3, '[' & _ArrayToString($aTemp4, ',', 1) & ']')
							Next
							_ArrayAdd($aTemp2, '[' & _ArrayToString($aTemp3, ',', 1) & ']')
						Next
						_ArrayAdd($aTemp1, '[' & _ArrayToString($aTemp2, ',', 1) & ']')
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case 10
				Local $aTemp0[1]
				For $iNext_1 = 0 To UBound($VAR, 1) - 1
					Local $aTemp1[1]
					For $iNext_2 = 0 To UBound($VAR, 2) - 1
						Local $aTemp2[1]
						For $iNext_3 = 0 To UBound($VAR, 3) - 1
							Local $aTemp3[1]
							For $iNext_4 = 0 To UBound($VAR, 4) - 1
								Local $aTemp4[1]
								For $iNext_5 = 0 To UBound($VAR, 5) - 1
									Local $aTemp5[1]
									For $iNext_6 = 0 To UBound($VAR, 6) - 1
										Local $aTemp6[1]
										For $iNext_7 = 0 To UBound($VAR, 7) - 1
											Local $aTemp7[1]
											For $iNext_8 = 0 To UBound($VAR, 8) - 1
												Local $aTemp8[1]
												For $iNext_9 = 0 To UBound($VAR, 9) - 1
													Local $aTemp9[1]
													For $iNext_10 = 0 To UBound($VAR, 10) - 1
														_ArrayAdd($aTemp9, code($VAR[$iNext_1][$iNext_2][$iNext_3][$iNext_4][$iNext_5][$iNext_6][$iNext_7][$iNext_8][$iNext_9][$iNext_10]))
													Next
													_ArrayAdd($aTemp8, '[' & _ArrayToString($aTemp9, ',', 1) & ']')
												Next
												_ArrayAdd($aTemp7, '[' & _ArrayToString($aTemp8, ',', 1) & ']')
											Next
											_ArrayAdd($aTemp6, '[' & _ArrayToString($aTemp7, ',', 1) & ']')
										Next
										_ArrayAdd($aTemp5, '[' & _ArrayToString($aTemp6, ',', 1) & ']')
									Next
									_ArrayAdd($aTemp4, '[' & _ArrayToString($aTemp5, ',', 1) & ']')
								Next
								_ArrayAdd($aTemp3, '[' & _ArrayToString($aTemp4, ',', 1) & ']')
							Next
							_ArrayAdd($aTemp2, '[' & _ArrayToString($aTemp3, ',', 1) & ']')
						Next
						_ArrayAdd($aTemp1, '[' & _ArrayToString($aTemp2, ',', 1) & ']')
					Next
					_ArrayAdd($aTemp0, '[' & _ArrayToString($aTemp1, ',', 1) & ']')
				Next
				Return __return__code_array($aDim, $VAR, $aTemp0)
			Case Else
				Return SetError(1, 0, 0)
		EndSwitch
	Else
		If IsObj($VAR) Then
			Local $aTemp[1]
			Local $oKeys = $VAR.Keys
			If UBound($oKeys) == 0 Then Return SetError(1, 0, 0)
			For $ii = 0 To UBound($oKeys, 1) - 1
				Local $key = code($oKeys[$ii], 1)
				If @error Then Return SetError(1, 0, 0)
				Local $value = $VAR.Item($oKeys[$ii])
				If ($value == '') Or Not $value Then
					$value = '0s'
				Else
					$value = code($value)
				EndIf
				If @error Then Return SetError(1, 0, 0)
				_ArrayAdd($aTemp, $key & ':' & $value)
			Next
			$VAR = 'o{' & _ArrayToString($aTemp, ',', 1) & '}'
			Return StringLen($VAR) & $VAR
		Else
;~ 			ConsoleWrite('code.var[' & $VAR & '] type[' & VarGetType($VAR) & ']' & @LF)
			Local $lenght
			Switch VarGetType($VAR)
				Case 'Bool'
					$VAR = '2|' & ($VAR == True ? '1B' : '1b')
				Case 'Keyword'
					Switch $VAR
						Case Null
							$VAR = '1n'
						Case Default
							$VAR = '1d'
						Case Else
							$VAR = '1k'
					EndSwitch
				Case 'Int32'
					If $VAR == 0 Then
						$VAR = '0i'
					Else
						$lenght = StringLen($VAR)
						If $VAR > 0 Then
							$VAR = $lenght & 'I' & $VAR
						Else
							$VAR = ($lenght - 1) & 'i' & (-1 * $VAR)
						EndIf
					EndIf
					$VAR = StringReplace($VAR, '.', '_')
				Case 'Int64'
					If $VAR == 0 Then
						$VAR = '0y'
					Else
						$lenght = StringLen($VAR)
						If $VAR > 0 Then
							$VAR = $lenght & 'Y' & $VAR
						Else
							$VAR = ($lenght - 1) & 'y' & (-1 * $VAR)
						EndIf
					EndIf
					$VAR = StringReplace($VAR, '.', '_')
				Case 'Double'
					If $VAR == 0 Then
						$VAR = '0f'
					Else
						$lenght = StringLen($VAR)
						If $VAR > 0 Then
							$VAR = $lenght & 'F' & $VAR
						Else
							$VAR = ($lenght - 1) & 'f' & (-1 * $VAR)
						EndIf
					EndIf
					$VAR = StringReplace($VAR, '.', '_')
				Case 'String'
;~ 					ConsoleWrite('String[ ' & $VAR & ' ] IsString[ ' & IsString($VAR) & ' ] IsNull[ ' & ($VAR == '' ? 'Null' : 'NotNull') & ' ]' & @LF)
					If StringLen($VAR) Then
						$VAR = __code($VAR)
						$VAR = StringLen($VAR) & 's' & $VAR
					Else
						$VAR = '0s'
					EndIf
				Case Else
					$VAR = 'eNoType_' & VarGetType($VAR)
					$VAR = StringLen($VAR) & $VAR
			EndSwitch
			Return $VAR
		EndIf
	EndIf
EndFunc   ;==>code

Func __code($VAR)
	; internal function
;~ 	ConsoleWrite('__code( ' & $VAR & ' )' & @LF)
	Local $temp
	$VAR = StringSplit($VAR, '', 2)
	For $ii = 0 To UBound($VAR) - 1
;~ 		ConsoleWrite(AscW($VAR[$ii]) & ' ')
		If StringRegExp($VAR[$ii], '[a-zA-Z0-9_]') Then
			$temp &= $VAR[$ii]
		Else
			$temp &= __code_num($VAR[$ii])
		EndIf
	Next
;~ 	ConsoleWrite(@LF)
	Return $temp
EndFunc   ;==>__code

Func __code_num($VAR)
	; internal function
	; PHP
	If $VAR == '' Then Return SetError(1, 0, 0)
	Local $aPos[4] = ['^', '~', '`', '´']
	Local $pos = 0
	$VAR = Hex(AscW($VAR))
	Do
		$pos += 1
	Until Not (StringMid($VAR, $pos, 1) == 0)
	$VAR = StringTrimLeft($VAR, $pos - 1)
	Return $aPos[StringLen($VAR) - 1] & $VAR
EndFunc   ;==>__code_num

Func __return__code_array($aDim, $VAR, $aTemp0)
	; internal function
	$VAR = 'a' & $aDim & '[' & _ArrayToString($aTemp0, ',', 1) & ']'
	Return StringLen($VAR) & $VAR
EndFunc   ;==>__return__code_array

Func __decode($VAR)
	; internal function
	$VAR = StringSplit($VAR, '', 2)
	Local $arr[4] = ['^', '~', '`', '´']
	Local $return, $ignore, $pos
	For $xx = 0 To UBound($VAR) - 1
		$pos = _ArraySearch($arr, $VAR[$xx])
		If $pos >= 0 Then
			Local $wer = ''
			$ignore = $pos + 1
			For $yy = $xx + 1 To $xx + $pos + 1
				$wer &= $VAR[$yy]
			Next
			$return &= ChrW(Dec($wer))
		Else
			If $ignore Then
				$ignore -= 1
			Else
				$return &= $VAR[$xx]
			EndIf
		EndIf
	Next
	Return $return
EndFunc   ;==>__decode

Func __mount_array(ByRef $aMount, $VAR)
	; internal function
	Local $arr = _StringBetween($VAR, 'a', '[')
	$arr = StringSplit($arr[0], '*', 2)
	Switch UBound($arr)
		Case 1
			ReDim $aMount[$arr[0]]
		Case 2
			ReDim $aMount[$arr[0]][$arr[1]]
		Case 3
			ReDim $aMount[$arr[0]][$arr[1]][$arr[2]]
		Case 4
			ReDim $aMount[$arr[0]][$arr[1]][$arr[2]][$arr[3]]
		Case 5
			ReDim $aMount[$arr[0]][$arr[1]][$arr[2]][$arr[3]][$arr[4]]
		Case 6
			ReDim $aMount[$arr[0]][$arr[1]][$arr[2]][$arr[3]][$arr[4]][$arr[5]]
		Case 7
			ReDim $aMount[$arr[0]][$arr[1]][$arr[2]][$arr[3]][$arr[4]][$arr[5]][$arr[6]]
		Case 8
			ReDim $aMount[$arr[0]][$arr[1]][$arr[2]][$arr[3]][$arr[4]][$arr[5]][$arr[6]][$arr[7]]
		Case 9
			ReDim $aMount[$arr[0]][$arr[1]][$arr[2]][$arr[3]][$arr[4]][$arr[5]][$arr[6]][$arr[7]][$arr[8]]
		Case 10
			ReDim $aMount[$arr[0]][$arr[1]][$arr[2]][$arr[3]][$arr[4]][$arr[5]][$arr[6]][$arr[7]][$arr[8]][$arr[9]]
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
EndFunc   ;==>__mount_array

Func __clean_var(ByRef $VAR, $type = 0)
	; internal function, VOID
	; PHP
	Local $tag = ($type == 0 ? '[' : '{')
	Local $first = StringInStr($VAR, $tag)
	$VAR = StringTrimRight($VAR, 1)
	$VAR = StringMid($VAR, $first + 1)
EndFunc   ;==>__clean_var

Func __lenght($input)
	; internal function
	; PHP
	Local $iLenght = 0
	While StringRegExp(StringMid($input, $iLenght + 1, 1), '[0-9]')
		$iLenght += 1
	WEnd
	Return $iLenght
EndFunc   ;==>__lenght

Func __mount_next_cell(ByRef $VAR)
	; internal function
	While Not StringRegExp(StringMid($VAR, 1, 1), '[0-9]')
		$VAR = StringTrimLeft($VAR, 1)
	WEnd
	Local $iLenght = __lenght($VAR)
	Local $iSize = StringLeft($VAR, $iLenght)
	Local $sType = StringMid($VAR, $iLenght + 1, 1)
	Local $cell = StringMid($VAR, 1, $iSize + $iLenght + 1)
	$VAR = StringTrimLeft($VAR, StringLen($cell))
	While StringInStr(StringMid($VAR, 1, 1), ',')
		$VAR = StringTrimLeft($VAR, 1)
	WEnd
	Return decode($cell)
EndFunc   ;==>__mount_next_cell

