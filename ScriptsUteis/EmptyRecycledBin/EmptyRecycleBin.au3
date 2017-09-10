#include <Array.au3>
#include <File.au3>

Global Const $SD = "Scripting.Dictionary"
Global $oo = ObjCreate($SD)

$oo.Add("WIN_7", ObjCreate($SD))
$oo.Item("WIN_7").Add($oo.Item("WIN_7").Count + 1, @HomeDrive & "\$RECYCLE.BIN")
$oo.Item("WIN_7").Add($oo.Item("WIN_7").Count + 1, @HomeDrive & "\Windows\Temp")
$oo.Item("WIN_7").Add($oo.Item("WIN_7").Count + 1, @HomeDrive & "\Windows\SoftwareDistribution\Download")
$oo.Item("WIN_7").Add($oo.Item("WIN_7").Count + 1, @HomeDrive & "\Users\" & @UserName & "\AppData\Local\Temp")

Switch @OSVersion
	Case "WIN_7"
		For $each In $oo.Item(@OSVersion)
			remove($oo.Item(@OSVersion).Item($each))
		Next
EndSwitch


Func remove($in)
	ConsoleWrite($in & @LF)
	Local $arr = _FileListToArrayRec($in, "*|desktop.ini", 1, 1, 1, 2)
	For $ii = 1 To UBound($arr, 1) - 1
		If FileDelete($arr[$ii]) Then
			ConsoleWrite("+" & $arr[$ii] & @LF) ; conseguiu apagar o arquivo
		Else
			ConsoleWrite("-" & $arr[$ii] & @LF) ; não conseguiu apagar o arquivo
		EndIf
	Next
EndFunc   ;==>remove
