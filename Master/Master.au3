; #INDEX# =======================================================================================================================
; Title .........: Master
; AutoIt Version : 3.3.14.5
; Description ...: coletânea de funções
; Source.........: https://github.com/chechelaky/AutoIt/blob/master/Master/Master.au3
; Author.........: Luismar Chechelaky (Luigi)
; Obs............: 10/10/2018, 11 horas, intervalo, fim 09:17
; ===============================================================================================================================

#include-once
#include <Array.au3>
#include <String.au3>
#include <FileConstants.au3>
#include <Crypt.au3>

;~ https://github.com/chechelaky/AutoIt/blob/master/_TimeUnix/_TimeUnix.au3
#include <_TimeUnix.au3>


OnAutoItExitRegister("Master_OnExit")

Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")

Global Const $COMUM = RegRead("HKEY_CURRENT_USER\Software\AutoIt v3\AutoIt", "Include")

Global Const $PSFTP = $COMUM & "\psftp.exe"
Global Const $PLINK = $COMUM & "\plink.exe"
Global Const $PSCP = $COMUM & "\pscp.exe"

_Crypt_Startup()

Func Master_OnExit()
	_Crypt_Shutdown()
EndFunc   ;==>Master_OnExit

Func _ErrFunc($oErr)
	ConsoleWrite("COM Error, ScriptLine(" & $oErr.scriptline & ") : Number 0x" & Hex($oErr.number, 8) & " - " & $oErr.windescription & @CRLF)
EndFunc   ;==>_ErrFunc



; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayAdd2D
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........: Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func _ArrayAdd2D(ByRef $array, $m1 = Default, $m2 = Default, $m3 = Default, $m4 = Default, $m5 = Default, $m6 = Default, $m7 = Default, $m8 = Default, $m9 = Default, $m10 = Default, $m11 = Default, $m12 = Default, $m13 = Default, $m14 = Default, $m15 = Default, $m16 = Default, $m17 = Default, $m18 = Default, $m19 = Default, $m20 = Default, $m21 = Default, $m22 = Default, $m23 = Default, $m24 = Default, $m25 = Default)
	$array[0][0] = UBound($array, 1)
	ReDim $array[$array[0][0] + 1][UBound($array, 2)]
	Local $iCol = @NumParams - 1 < UBound($array, 2) ? @NumParams - 1 : UBound($array, 2)
	For $ii = 1 To $iCol
		$array[$array[0][0]][$ii - 1] = Execute("$m" & $ii)
	Next
	Return $array[0][0]
EndFunc   ;==>_ArrayAdd2D

; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayDump
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func _ArrayDump($array, $name = "")
;~ Author: Luigi (Luismar Chechelaky)
	Local $iCol = UBound($array, 2)
	Local $aCol[$iCol]
	Local $iLen, $iLenB
	Local $line_head = "+"
	For $ii = 0 To UBound($array, 1) - 1
		For $jj = 0 To UBound($array, 2) - 1
			$iLen = StringLen($array[$ii][$jj])
			If $iLen > $aCol[$jj] Then $aCol[$jj] = $iLen
			$iLenB = StringLen(String($jj))
			If $iLenB > $aCol[$jj] Then $aCol[$jj] = $iLenB
		Next
	Next

	Local $line = "+"
	For $ii = 0 To $iCol - 1
		$line &= _StringRepeat("-", $aCol[$ii]) & "+"
		$line_head &= _StringRepeat("-", $aCol[$ii] - StringLen(String($ii))) & $ii & "+"
	Next
	If $name Then ConsoleWrite("arr[ " & $name & " ] " & UBound($array, 1) & "x" & UBound($array, 2) & @LF)
	ConsoleWrite($line_head & @LF)
	For $ii = 0 To UBound($array, 1) - 1
		ConsoleWrite($ii = 1 ? $line & @LF & "|" : "|")
		For $jj = 0 To UBound($array, 2) - 1
			$iLen = StringLen($array[$ii][$jj])
			ConsoleWrite(Conv($array[$ii][$jj]) & _StringRepeat(" ", $aCol[$jj] - $iLen) & "|")
		Next
		ConsoleWrite(@LF)
	Next
	ConsoleWrite($line & @LF)
EndFunc   ;==>_ArrayDump

; #FUNCTION# ====================================================================================================================
; Name ..........: Conv
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func Conv($var)
	Local $Pattern[][2] = [["[áãâ]", "a"], ["[éê]", "e"], ["[íî]", "i"], ["[óõô]", "o"], ["[úû]", "u"], ["[ÁÃÂ]", "A"], ["[ÉÊ]", "E"], ["[ÍÎ]", "I"], ["[ÓÕÔ]", "O"], ["[ÚÛ]", "U"], ["[Ç]", "C"], ["[ç]", "c"]]
	For $ii = 0 To UBound($Pattern, 1) - 1
		$var = StringRegExpReplace($var, $Pattern[$ii][0], $Pattern[$ii][1])
	Next
	Return $var
EndFunc   ;==>Conv

; #FUNCTION# ====================================================================================================================
; Name ..........: StringtoArray
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func StringtoArray($in = "")
	If Not $in Then Return $in
	Local $ret[1] = [0]
	$in = StringReplace($in, @CRLF, @LF)
	$in = StringReplace($in, @CR, @LF)
	StringRemoveDouble($in, @LF)
	$in = StringSplit($in, @LF)
	For $ii = 1 To $in[0]
		$in[$ii] = __StringTrim($in[$ii])
		If $in[$ii] Then _ArrayAdd($ret, $in[$ii])
	Next
	$ret[0] = UBound($ret, 1) - 1
	Return $ret
EndFunc   ;==>StringtoArray

; #FUNCTION# ====================================================================================================================
; Name ..........: StringRemoveDouble
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func StringRemoveDouble(ByRef $input, $double)
	Local $find = $double & $double
	While StringInStr($input, $find)
		$input = StringReplace($input, $find, $double)
	WEnd
EndFunc   ;==>StringRemoveDouble

; #FUNCTION# ====================================================================================================================
; Name ..........: __StringTrim
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func __StringTrim($input)
	While StringLeft($input, 1) = " "
		$input = StringTrimLeft($input, 1)
	WEnd
	While StringRight($input, 1) = " "
		$input = StringTrimRight($input, 1)
	WEnd
	Return $input
EndFunc   ;==>__StringTrim

; #FUNCTION# ====================================================================================================================
; Name ..........: __DataConv
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func __DataConv($input, $iMode = 0)
	Switch $iMode
		Case 0
			; from 2015/06/10 20:21:22
			; to   2017-06-01 13:38:13
			Return StringReplace($input, "-", "/")
		Case Else
			Return $input
	EndSwitch
EndFunc   ;==>__DataConv

; #FUNCTION# ====================================================================================================================
; Name ..........: PassWord
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func PassWord($len = 8)
	If $len < 8 Then $len = 8
	Local $num[] = [0, 2, 3, 4, 5, 6, 7, 8, 9]
	$num[0] = UBound($num, 1) - 1
	Local $let[] = [0, "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "W", "Z"]
	$let[0] = UBound($let, 1) - 1

	Local $try, $ret = $let[Random(1, $let[0], 1)]
	Local $last = $ret
	$len -= 1

	While $len
		$try = Random(0, 1, 1) ? $num[Random(1, $num[0], 1)] : $let[Random(1, $let[0], 1)]
		If $try <> $last Then
			$ret &= $try
			$last = $try
			$len -= 1
		EndIf
	WEnd
	Return $ret
EndFunc   ;==>PassWord

; #FUNCTION# ====================================================================================================================
; Name ..........: oo()
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func oo()
	Return ObjCreate("Scripting.Dictionary")
EndFunc   ;==>oo

; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayDumpLine
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func _ArrayDumpLine($label, $val, $line)
;~ Author: Luigi (Luismar Chechelaky)
;~ Requirements
;~ #include <Array.au3>
;~ #include <String.au3>

;~ Exemplo
;~ Global $label[2] = ["nome", "valor"]
;~ Global $val[2][2] = [[100000, 2], [3, 4]]
;~ _ArrayDumpLine($label, $val, 0)
;~ _ArrayDumpLine($label, $val, 1)

;~ Resultado
;~ +------+-----+
;~ |nome  |valor|
;~ +------+-----+
;~ |100000|    2|
;~ +------+-----+
	If Not (UBound($label, 1) = UBound($val, 2)) Then Return
	Local $iCol = UBound($label, 1) - 1
	Local $col[3][$iCol + 1], $len
	For $ii = 0 To $iCol
		$col[0][$ii] = StringLen($label[$ii])
		$col[1][$ii] = $label[$ii]
	Next
	For $ii = 0 To $iCol
		$len = StringLen($val[$line][$ii])
		If $len > $col[0][$ii] Then $col[0][$ii] = $len
		$col[2][$ii] = $val[$line][$ii]
	Next
	Local $line_sep[1]
	For $ii = 0 To $iCol
		_ArrayAdd($line_sep, _StringRepeat("-", $col[0][$ii]))
	Next
	_ArrayAdd($line_sep, "")
	$line_sep = _ArrayToString($line_sep, "+")
	ConsoleWrite($line_sep & @LF)
	Local $word[1]
	For $ii = 0 To $iCol
		_ArrayAdd($word, $col[1][$ii] & _StringRepeat(" ", $col[0][$ii] - StringLen($col[1][$ii])))
	Next
	_ArrayAdd($word, "")
	$word = _ArrayToString($word, "|")
	ConsoleWrite($word & @LF)
	ConsoleWrite($line_sep & @LF)
	Local $word[1]
	For $ii = 0 To $iCol
		_ArrayAdd($word, _StringRepeat(" ", $col[0][$ii] - StringLen($col[2][$ii])) & $col[2][$ii])
	Next
	_ArrayAdd($word, "")
	$word = _ArrayToString($word, "|")
	ConsoleWrite($word & @LF)
	ConsoleWrite($line_sep & @LF)
EndFunc   ;==>_ArrayDumpLine

; #FUNCTION# ====================================================================================================================
; Name ..........: FileSave
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func FileSave($file_path, $var)
;~ 	ConsoleWrite("FileSave( $path=" & $file_path & " )" & @LF)
	Local $hFile = FileOpen($file_path, $FO_OVERWRITE + $FO_CREATEPATH + $FO_FULLFILE_DETECT)
	If IsArray($var) Then
		FileWrite($hFile, _ArrayToString($var, @LF, 1))
	Else
		FileWrite($hFile, $var)
	EndIf
	FileClose($hFile)
EndFunc   ;==>FileSave

; #FUNCTION# ====================================================================================================================
; Name ..........: FileLoad
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func FileLoad($file)
	; @TODO ter certeza da codifição do arquivo
	Local $hFile = FileOpen($file, $FO_UTF8_NOBOM)
	Local $READ = FileRead($hFile)
	FileClose($hFile)
	Return $READ
EndFunc   ;==>FileLoad


#Region  _ArrayAdd_InArray
; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayAdd_InArray
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func _ArrayAdd_InArray(ByRef $aParent, $aChild)
	Local $parent[3] = [UBound($aParent, $UBOUND_DIMENSIONS), UBound($aParent, $UBOUND_ROWS), UBound($aParent, $UBOUND_COLUMNS)]
	Local $child[3] = [UBound($aChild, $UBOUND_DIMENSIONS), UBound($aChild, $UBOUND_ROWS), UBound($aChild, $UBOUND_COLUMNS)]
	If $parent[0] = 1 And $child[0] = 1 Then
		__ArrayAdd_1x1($parent, $aParent, $child, $aChild)
	ElseIf $parent[0] = 1 And $child[0] = 2 Then
		__ArrayAdd_1x2($parent, $aParent, $child, $aChild)
	ElseIf $parent[0] = 2 And $child[0] = 2 Then
		__ArrayAdd_2x2($parent, $aParent, $child, $aChild)
	ElseIf $parent[0] = 2 And $child[0] = 1 Then
		__ArrayAdd_2x1($parent, $aParent, $child, $aChild)
	Else
		ConsoleWrite("__ArrayAdd: @error" & @LF)
	EndIf
EndFunc   ;==>_ArrayAdd_InArray

; #FUNCTION# ====================================================================================================================
; Name ..........: __ArrayAdd_1x1
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func __ArrayAdd_1x1($parent, ByRef $aParent, $child, $aChild)
	For $ii = 0 To $child[$UBOUND_ROWS] - 1
		_ArrayAdd($aParent, $aChild[$ii])
	Next
	Return UBound($aParent, 1) - 1
EndFunc   ;==>__ArrayAdd_1x1

; #FUNCTION# ====================================================================================================================
; Name ..........: __ArrayAdd_1x2
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func __ArrayAdd_1x2($parent, ByRef $aParent, $child, $aChild)
	Local $max_col = $parent[$UBOUND_COLUMNS]
;~ 	ConsoleWrite("__ArrayAdd_1x2 $max_col[" & $max_col & "]" & @LF)
	For $ii = 0 To $child[$UBOUND_ROWS] - 1
		_ArrayAdd($aParent, $aChild[$ii][0])
	Next
	Return UBound($aParent, 1) - 1
EndFunc   ;==>__ArrayAdd_1x2

; #FUNCTION# ====================================================================================================================
; Name ..........: __ArrayAdd_2x2
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func __ArrayAdd_2x2($parent, ByRef $aParent, $child, $aChild)
;~ 	ConsoleWrite("__ArrayAdd_2x2" & @LF)
	Local $max_col = $parent[$UBOUND_COLUMNS] > $child[$UBOUND_COLUMNS] ? $child[$UBOUND_COLUMNS] : $parent[$UBOUND_COLUMNS]
	ReDim $aParent[$parent[$UBOUND_ROWS] + $child[$UBOUND_ROWS]][$parent[$UBOUND_COLUMNS]]
	$parent[$UBOUND_ROWS] += $child[$UBOUND_ROWS] - 2
	For $ii = $parent[$UBOUND_ROWS] To $parent[$UBOUND_ROWS] + $child[$UBOUND_ROWS] - 1
		For $jj = 0 To $max_col - 1
			$aParent[$ii][$jj] = $aChild[$ii - $parent[$UBOUND_ROWS]][$jj]
		Next
	Next
	Return $parent[$UBOUND_ROWS]
EndFunc   ;==>__ArrayAdd_2x2

; #FUNCTION# ====================================================================================================================
; Name ..........: __ArrayAdd_2x1
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func __ArrayAdd_2x1($parent, ByRef $aParent, $child, $aChild)
;~ 	ConsoleWrite("__ArrayAdd_2x1" & @LF)
	Local $max_col = $parent[$UBOUND_COLUMNS] < $child[$UBOUND_ROWS] ? $parent[$UBOUND_COLUMNS] : $child[$UBOUND_ROWS]
	ReDim $aParent[$parent[$UBOUND_ROWS] + 1][$parent[$UBOUND_COLUMNS]]
	$parent[$UBOUND_ROWS] += 1
	For $ii = 0 To $max_col - 1
		$aParent[$parent[$UBOUND_ROWS] - 1][$ii] = $aChild[$ii]
	Next
	Return $parent[$UBOUND_ROWS]
EndFunc   ;==>__ArrayAdd_2x1
#EndRegion _ArrayAdd_InArray

; #FUNCTION# ====================================================================================================================
; Name ..........: __ArrayExtract
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func __ArrayExtract($arr, $x1, $y1 = -1, $y2 = -1)
	Local $ret[1]
	If $y1 = -1 Then $y1 = 0
	Switch UBound($arr, 0)
		Case 1
			If $y2 = -1 Then $y2 = UBound($arr, 1) - 1
			For $ii = $y1 To $y2
				ConsoleWrite($arr[$ii] & @LF)
				_ArrayAdd($ret, $arr[$ii])
			Next
		Case 2
			If $y2 = -1 Then $y2 = UBound($arr, 2) - 1
			For $ii = $y1 To $y2
				_ArrayAdd($ret, $arr[$x1][$ii])
			Next

	EndSwitch
	If UBound($ret, 1) > 1 Then _ArrayDelete($ret, 0)
	Return $ret
EndFunc   ;==>__ArrayExtract

; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayFrame
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func _ArrayFrame($arr)
	Local $ret[4]
	If IsArray($arr) Then
		$ret[0] = 1
		$ret[1] = UBound($arr, $UBOUND_DIMENSIONS)
		$ret[2] = UBound($arr, $UBOUND_ROWS)
		$ret[3] = UBound($arr, $UBOUND_COLUMNS)
	EndIf
	Return $ret
EndFunc   ;==>_ArrayFrame

; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayTypes
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func _ArrayTypes($sql)
;~ 	### Exclusive for SQLite ###
;~ 	INPUT
;~ 	$sql = 'CREATE TABLE "auth" ( `id` INTEGER PRIMARY KEY AUTOINCREMENT, `randum` TEXT, `user_id` INTEGER, `time` INTEGER )'

;~ 	OUTPUT
;~ 	+-------+-------+
;~ 	|      4|       |
;~ 	|id     |INTEGER|
;~ 	|randum |TEXT   |
;~ 	|user_id|INTEGER|
;~ 	|time   |INTEGER|
;~ 	+-------+-------+

	$sql = StringRegExpReplace($sql, "[\t]", " ")
	$sql = StringRegExpReplace($sql, "[\r\n\`\'\""]", "")
	While StringInStr($sql, "  ")
		$sql = StringReplace($sql, "  ", " ")
	WEnd
	ConsoleWrite("@line[" & @ScriptLineNumber & "] sql[ " & $sql & " ]" & @LF)

	Local $aFields[1][2], $temp1

	Local $arr = StringRegExp($sql, "(?m)\((.*?)\)", $STR_REGEXPARRAYGLOBALMATCH)

	If IsArray($arr) Then
		$arr = StringSplit($arr[0], ",", 2)
		For $ii = 0 To UBound($arr, 1) - 1
			$arr[$ii] = __StringTrim($arr[$ii])
			$temp1 = StringSplit($arr[$ii], " ", $STR_CHRSPLIT)
			_ArrayAdd2D($aFields, $temp1[1], $temp1[2])
		Next
	Else

	EndIf
	Return $aFields
EndFunc   ;==>_ArrayTypes

; #FUNCTION# ====================================================================================================================
; Name ..........: File_MD5
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func File_MD5($file = 0)
	If Not $file Then Return SetError(1, 0, 0)
	If Not FileExists($file) Then Return SetError(2, 0, 0)
	If Not FileGetSize($file) Then Return SetError(3, 0, 0)
	Local $hash = _Crypt_HashFile($file, $CALG_MD5)
	If @error Then Return SetError(4, 0, 0)
	Return StringLower(StringTrimLeft($hash, 2))
EndFunc   ;==>File_MD5

; #FUNCTION# ====================================================================================================================
; Name ..........: LS
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func LS($host, $user, $pass, $path = "/")
	Local $linux = "/usr/linux/bin/ls --full-time -lnb " & $path & " ; md5sum " & $path & "/*"
	Local $linux = "ls --full-time -lnb " & $path & " ; md5sum " & $path & "/*"
	Local $cmd = @ComSpec & " /c " & $PLINK & " -batch -ssh " & $user & "@" & $host & " -pw " & $pass & " """ & $linux & """"

	Local $iPid = Run($cmd, @ScriptDir, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
	ProcessWaitClose($iPid)
	Local $sOutput = StdoutRead($iPid, False, False)
;~ 	ConsoleWrite( $sOutput & @LF)

	Return __LS($sOutput, $path)
EndFunc   ;==>LS

; #FUNCTION# ====================================================================================================================
; Name ..........: __LS
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func __LS($txt = "", $path = "")
	Local $ret[1][25] = [[0]]
	Local $regex = "(?s)([-d])([-r])([-w])([-x])([-r])([-w])([-x])([-r])([-w])([-x])(?:\.)?\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2}):(\d{2})\.(\d{9})\s+(-\d{4})\s+(.*?)[\n\r]"
	Local $arr = StringRegExp($txt, $regex, $STR_REGEXPARRAYGLOBALMATCH)

	Local $size = UBound($arr, 1) - 1
	If Not $size Then Return $ret
	Local $line
	If $size Then
		For $ii = 0 To $size Step 23
			_ArrayAdd2D($ret, $arr[$ii], $arr[$ii + 1], $arr[$ii + 2], $arr[$ii + 3], $arr[$ii + 4], $arr[$ii + 5], $arr[$ii + 6], $arr[$ii + 7], $arr[$ii + 8], $arr[$ii + 9], $arr[$ii + 10], $arr[$ii + 11], $arr[$ii + 12], $arr[$ii + 13], $arr[$ii + 14], $arr[$ii + 15], $arr[$ii + 16], $arr[$ii + 17], $arr[$ii + 18], $arr[$ii + 19], $arr[$ii + 20], $arr[$ii + 21], $arr[$ii + 22], _TimeUnix($arr[$ii + 14] & "/" & $arr[$ii + 15] & "/" & $arr[$ii + 16] & " " & $arr[$ii + 17] & ":" & $arr[$ii + 18] & ":" & $arr[$ii + 19]))
		Next
		$ret[0][0] = UBound($ret, 1) - 1

		$regex = "(?s)([a-f0-9]{32})\s+"
		$arr = StringRegExp($txt, $regex, $STR_REGEXPARRAYGLOBALMATCH)

		For $ii = 1 To $ret[0][0]
			$ret[$ii][24] = $arr[$ii - 1]
		Next
	EndIf
	Return $ret
EndFunc   ;==>__LS

; #FUNCTION# ====================================================================================================================
; Name ..........: File_Download
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func File_Download($_host, $_user, $_pass, $_path, $_file, $_folder, $md5 = 0)

	$_folder = StringReplace($_folder, "/", "\")
	StringRemoveDouble($_folder, "\")
	If Not FileExists($_folder) Then DirCreate($_folder)

	ConsoleWrite("File_Download( $_host=" & $_host & ", $_user=" & $_user & ", $_pass=" & $_pass & ", $_path=" & $_path & ", $_file=" & $_file & ", $_folder=" & $_folder & ", $md5=" & $md5 & " )" & @LF)

	Local $remote = $_path & "/" & $_file

	Local $cmd = @ComSpec & " /c " & $PSCP & " -batch -v -pw " & $_pass & " " & $_user & "@" & $_host & ":" & $remote & " """ & $_folder & """"

	Local $pid = Run($cmd, @ScriptDir, @SW_HIDE, $STDERR_MERGED)
	ProcessWaitClose($pid)

	Local $out = StdoutRead($pid)

	If $md5 Then
		If $md5 = File_MD5($_folder & "\" & $_file) Then
			ConsoleWrite("MD5: @OK" & @LF)
		Else
			ConsoleWrite("MD5: @ERR" & @LF)
		EndIf
	EndIf

	ConsoleWrite(">>" & $out & "<<" & @LF)
EndFunc   ;==>File_Download

; #FUNCTION# ====================================================================================================================
; Name ..........: IniGet
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func IniGet($arr, $key, $default_value = "")
	Local $iSearch = _ArraySearch($arr, $key, 1, Default)
	If @error Then Return $default_value
	If Not IsDeclared("MACROS") Then Local $MACROS[1][2]
	For $ii = 1 To $MACROS[0][0]
		If StringInStr($arr[$iSearch][1], "%" & $MACROS[$ii][0] & "%") Then
			$arr[$iSearch][1] = StringReplace($arr[$iSearch][1], "%" & $MACROS[$ii][0] & "%", $MACROS[$ii][1])
			ExitLoop
		EndIf
	Next

	Return $arr[$iSearch][1]
EndFunc   ;==>IniGet

; #FUNCTION# ====================================================================================================================
; Name ..........: IniSet
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
;
; Author ........:  Luigi (Luismar Chechelaky)
; Example .......:
; ===============================================================================================================================
Func IniSet(ByRef $arr, $key, $new_value)
	Local $iSearch = _ArraySearch($arr, $key, 1, Default)
	If @error Then Return SetError(1, 0, False)
	$arr[$iSearch][1] = $new_value
	Return True
EndFunc   ;==>IniSet

#CS
	REGEX
	http://www.ultrapico.com/ExpressoDownload.htm
#CE
