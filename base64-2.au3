; https://www.autoitscript.com/forum/topic/145526-base64-converter-files-and-strings-can-be-modified-easily/

Global $__b64___B64_list[64]
; #FUNCTION# ====================================================================================================================
; Name ..........: B64Decode
; Description ...: Decodes the provided base64 input. It strips @CR and @LF on its own.
; Syntax ........: B64Decode([$__b64_input = ''[, $__b64_mode = 0[, $__b64_isfile = 0]]])
; Parameters ....: $__b64_input - [optional] Base64 data or path and name of file needing to be decoded. Leaving blank shows syntax messagebox.
; $__b64_mode - [optional] 1 = decoded data will be UTF-8 while 0 = decoded data will be ANSI. Default is 0. (not used for files)
; $__b64_isfile - [optional] 0 = input is a string of information. 1 = path and file name to file to be decoded. Default is 0.
; Return values .: Data decoded from base64 to the encoding given from the $__b64_mode variable. Decoded FILE data can be used or written to a file with the forced binary encoding...
; Author ........: Wesley G aka Morthawt
; Modified ......:
; Remarks .......: Decoded FILE data is in raw binary and should be written to a file with forced binary mode. No special encoding or decoding needed
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func B64Decode($__b64_input = '', $__b64_mode = 0, $__b64_isfile = 0)
	Local $__b64_openfile, $__b64_case
	If $__b64_input = '' Then MsgBox(0, 'Hint', 'B64Decode($InputData, 0 = ANSI 1 = is UTF-8, 1 = is a file (filename)')
	__init_b64_dictionary()
	If $__b64_mode = 0 Then
		$__b64_mode = 1
	Else
		$__b64_mode = 4
	EndIf
	Local $__b64_TheBitStream, $__b64_4_SixBitChunks, $__b64_FinalOutput, $__b64_tempvalue
	If $__b64_isfile Then
		$__b64_openfile = FileOpen($__b64_input, 0)
		$__b64_input = FileRead($__b64_openfile)
		FileClose($__b64_openfile)
	EndIf
	$__b64_input = StringReplace($__b64_input, '=', '')
	$__b64_input = StringReplace($__b64_input, @CR, '')
	$__b64_input = StringReplace($__b64_input, @LF, '')
	$__b64_input = StringStripWS($__b64_input, 8)
	For $__b64_a = 1 To StringLen($__b64_input)
		$__b64_case = 'N'
		If StringIsUpper(StringMid($__b64_input, $__b64_a, 1)) Then $__b64_case = 'U'
		$__b64_TheBitStream &= __init_b64_SixBitBinary(Eval($__b64_case & StringMid($__b64_input, $__b64_a, 1)))
	Next
	For $__b64_a = 1 To (Floor(StringLen($__b64_TheBitStream) / 8) * 8) Step 8
		$__b64_tempvalue &= Hex(String(__init_b64_FromEightBitBinary(StringMid($__b64_TheBitStream, $__b64_a, 8))), 2)
	Next
	If Not $__b64_isfile Then
		$__b64_FinalOutput = BinaryToString('0x' & $__b64_tempvalue, $__b64_mode)
	Else
		$__b64_FinalOutput = '0x' & $__b64_tempvalue
	EndIf
	Return $__b64_FinalOutput
EndFunc   ;==>B64Decode

; #FUNCTION# ====================================================================================================================
; Name ..........: B64Encode
; Description ...: Encodes the provided input to Base64.
; Syntax ........: B64Encode([$__b64_input = ''[, $__b64_mode = 0[, $__b64_linebreak = 0[, $__b64_isfile = 0]]]])
; Parameters ....: $__b64_input - [optional] Data or file path and name of a file needing to be encoded to base64. Leaving blank shows syntax messagebox.
; $__b64_mode [optional] 1 = decoded data will be UTF-8 while 0 = decoded data will be ANSI. Default is 0. (not used for files)
; $__b64_linebreak - [optional] Number of base64 characters per line. This should be between 0 and 76 to be standards complient.
; $__b64_isfile - [optional] 0 = input is a string of information. 1 = path and file name to file to be decoded. Default is 0.
; Return values .: Base64 encoded data from the input in the encoding dictated by $__b64_mode. Encoded file data can be used or written to a file.
; Author ........: Wesley G aka Morthawt
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func B64Encode($__b64_input = '', $__b64_mode = 0, $__b64_linebreak = 0, $__b64_isfile = 0)
	Local $__b64_openfile, $__b64_Number, $__b64_o_UTF_8
	If $__b64_input = '' Then MsgBox(0, 'Hint', 'B64Encode($InputData, 0 = ANSI 1 = is UTF-8, 0-76 Linebreak, 1 = is a file (filename)')
	__init_b64_dictionary()
	If $__b64_linebreak > 76 Then
		MsgBox(0, 'Error', 'Base64 encode linebreak cannot exceed 76 characters.')
		Exit
	EndIf
	If $__b64_mode = 0 Then
		$__b64_mode = 1
	Else
		$__b64_mode = 4
	EndIf
	Local $__b64_TheBitStream, $__b64_4_SixBitChunks, $__b64_FinalOutput, $__b64_tempvalue, $__b64_FinalOutput2
	If Not $__b64_isfile Then
		$__b64_o_UTF_8 = StringTrimLeft(StringToBinary($__b64_input, $__b64_mode), 2)
	Else
		$__b64_openfile = FileOpen($__b64_input, 16)
		$__b64_o_UTF_8 = StringTrimLeft(FileRead($__b64_openfile), 2)
		FileClose($__b64_openfile)
	EndIf
	For $__b64_a = 1 To StringLen($__b64_o_UTF_8) Step 2
		$__b64_TheBitStream &= __init_b64_EightBitBinary('0x' & StringMid($__b64_o_UTF_8, $__b64_a, 2))
	Next
	For $__b64_a = 1 To StringLen($__b64_TheBitStream) Step +6
		$__b64_Number = __init_b64_FromSixBitBinary(StringMid($__b64_TheBitStream, $__b64_a, 6))
		$__b64_FinalOutput &= $__b64___B64_list[$__b64_Number]
	Next
	While Floor(StringLen($__b64_FinalOutput) / 4) <> (StringLen($__b64_FinalOutput) / 4)
		$__b64_FinalOutput &= '='
	WEnd
	If $__b64_linebreak > 0 Then
		For $__b64_a = 1 To StringLen($__b64_FinalOutput) Step $__b64_linebreak
			$__b64_FinalOutput2 &= StringMid($__b64_FinalOutput, $__b64_a, $__b64_linebreak)
			If $__b64_linebreak > 0 Then
				If StringLen(StringMid($__b64_FinalOutput, $__b64_a, $__b64_linebreak)) = $__b64_linebreak And $__b64_a <= (StringLen($__b64_FinalOutput) - $__b64_linebreak) Then $__b64_FinalOutput2 &= @CRLF
			EndIf
		Next
	Else
		$__b64_FinalOutput2 = $__b64_FinalOutput
	EndIf
	Return $__b64_FinalOutput2
EndFunc   ;==>B64Encode

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __init_b64_dictionary
; Description ...: Used to initialize the base64 dictionary used in conversions
; Syntax ........: __init_b64_dictionary()
; Parameters ....: None
; Return values .: None
; Author ........: Wesley G aka Morthawt
; Modified ......:
; Remarks .......: Creates an array with base64 dictionary. Also creates variables with direct names for easy and quick access while decoding letters to numbers.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __init_b64_dictionary()
	Global $__b64___B64_list[64]
	For $__b64_a = 0 To 63
		Select
			Case $__b64_a < 26
				$__b64___B64_list[$__b64_a] = ChrW(65 + $__b64_a)
				Assign('U' & ChrW(65 + $__b64_a), $__b64_a, 2)
			Case $__b64_a < 52
				$__b64___B64_list[$__b64_a] = ChrW(71 + $__b64_a)
				Assign('N' & ChrW(71 + $__b64_a), $__b64_a, 2)
			Case $__b64_a < 62
				$__b64___B64_list[$__b64_a] = ChrW($__b64_a - 4)
				Assign('N' & ChrW($__b64_a - 4), $__b64_a, 2)
			Case $__b64_a = 62
				$__b64___B64_list[$__b64_a] = ChrW(43)
				Assign('N' & ChrW(43), $__b64_a, 2)
			Case $__b64_a = 63
				$__b64___B64_list[$__b64_a] = ChrW(47)
				Assign('N' & ChrW(47), $__b64_a, 2)
		EndSelect
	Next
EndFunc   ;==>__init_b64_dictionary

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __init_b64_EightBitBinary
; Description ...: Outputs an 8-bit binary string from an input integer between 0 and 255
; Syntax ........: __init_b64_EightBitBinary([$__b64_input = 0])
; Parameters ....: $__b64_input - [optional] Integer between 0 and 255 Default is 0.
; Return values .: 8-bit binary string representing the input integer
; Author ........: Wesley G aka Morthawt
; Modified ......:
; Remarks .......: An 8-bit binary string looks like 10101010
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __init_b64_EightBitBinary($__b64_input = 0)
	Local $__b64_tmpbitstream, $__b64_start
	If $__b64_input < 256 Then
		$__b64_tmpbitstream = ''
		$__b64_start = 128
		While $__b64_start >= 1
			If Floor($__b64_input / $__b64_start) Then
				$__b64_tmpbitstream &= 1
				$__b64_input -= ($__b64_start * Floor($__b64_input / $__b64_start))
			Else
				$__b64_tmpbitstream &= 0
			EndIf
			$__b64_start /= 2
		WEnd
	Else
		$__b64_tmpbitstream = 0
	EndIf
	Return $__b64_tmpbitstream
EndFunc   ;==>__init_b64_EightBitBinary

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __init_b64_SixBitBinary
; Description ...: Outputs a 6-bit binary string from an input integer between 0 and 63
; Syntax ........: __init_b64_SixBitBinary([$__b64_input = 0])
; Parameters ....: $__b64_input - [optional] An integer between 0 and 63. Default is 0.
; Return values .: A 6-bit binary string representing the input integer
; Author ........: Wesley G aka Morthawt
; Modified ......:
; Remarks .......: A 6-bit binary string looke like 101010
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __init_b64_SixBitBinary($__b64_input = 0)
	Local $__b64_tmpbitstream, $__b64_start
	If $__b64_input < 64 Then
		$__b64_tmpbitstream = ''
		$__b64_start = 32
		While $__b64_start >= 1
			If Floor($__b64_input / $__b64_start) Then
				$__b64_tmpbitstream &= 1
				$__b64_input -= ($__b64_start * Floor($__b64_input / $__b64_start))
			Else
				$__b64_tmpbitstream &= 0
			EndIf
			$__b64_start /= 2
		WEnd
	Else
		$__b64_tmpbitstream = 0
	EndIf
	Return $__b64_tmpbitstream
EndFunc   ;==>__init_b64_SixBitBinary

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __init_b64_FromSixBitBinary
; Description ...: Outputs an integer between 0 and 63 based on a 6-bit binary input.
; Syntax ........: __init_b64_FromSixBitBinary([$__b64_input = 0])
; Parameters ....: $__b64_input - [optional] 6-bit binary input. Default is 0.
; Return values .: Integer between 0 and 63
; Author ........: Wesley G aka Morthawt
; Modified ......:
; Remarks .......: A 6-bit binary string looke like 101010
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __init_b64_FromSixBitBinary($__b64_input = 0)
	Local $__b64_base = 32, $__b64_tempvalue = 0
	For $__b64_a = 1 To 6
		If StringMid($__b64_input, $__b64_a, 1) = 1 Then
			$__b64_tempvalue += $__b64_base
		EndIf
		$__b64_base /= 2
	Next
	Return $__b64_tempvalue
EndFunc   ;==>__init_b64_FromSixBitBinary

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __init_b64_FromEightBitBinary
; Description ...: Outputs an integer between 0 and 255 from an 8-bit binary input.
; Syntax ........: __init_b64_FromEightBitBinary([$__b64_input = 0])
; Parameters ....: $__b64_input - [optional] An 8-bit binary string. Default is 0
; Return values .: Integer between 0 and 255
; Author ........: Wesley G aka Morthawt
; Modified ......:
; Remarks .......: An 8-bit binary string looks like 10101010
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __init_b64_FromEightBitBinary($__b64_input = 0)
	Local $__b64_base = 128, $__b64_tempvalue = 0
	For $__b64_a = 1 To 8
		If StringMid($__b64_input, $__b64_a, 1) = 1 Then
			$__b64_tempvalue += $__b64_base
		EndIf
		$__b64_base /= 2
	Next
	Return $__b64_tempvalue
EndFunc   ;==>__init_b64_FromEightBitBinary

