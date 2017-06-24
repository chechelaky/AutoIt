#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         Luismar Chechelaky

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Func checkDir()
	; void
	Local $aDir[5] = [ _
			'\cache', _
			'\cache\layers', _
			'\cache\images', _
			'\cache\maps', _
			'\cache\main' _
			]
	For $each In $aDir
		Local $dir = @ScriptDir & $each
		If Not FileExists($dir) Then DirCreate($dir)
	Next
EndFunc   ;==>checkDir