

;~ https://www.autoitscript.com/forum/topic/54909-detecting-when-guictrlinput-change-it-value/
;~ https://www.autoitscript.com/autoit3/scite/docs/SciTE4AutoIt3/Tidy.html
#Tidy_Parameters /gd

#include <GuiConstants.au3>
#include <GuiEdit.au3>
#include <GuiStatusBar.au3>
#include <WinAPI.au3>

Opt("MustDeclareVars", 1)

Global $iInput, $hInput
Global $nao_usada

_Example_Internal()

Func Real($number = "")
	If $number == "" Then Return ""
	If $number == "." Then Return "0."
	$number = StringRegExpReplace(StringReplace($number, ",", "."), "[^0-9.]", "")
	Local $dot = StringInStr($number, ".")
	If Not $dot Then Return $number
	Return StringReplace(StringMid($number, 1, $dot - 1), ".", "") & "." & StringReplace(StringMid($number, $dot + 1), ".", "")
EndFunc   ;==>Real

Func _Example_Internal()
	Local $hGUI
	Local $aPartRightSide[4] = [120, 248, 378, -1]

	$hGUI = GUICreate("Exemplo: uso de máscara para número real", 400, 300)
	$iInput = GUICtrlCreateInput("123.45", 2, 2, 394, 25)
	$hInput = GUICtrlGetHandle($iInput)

	GUISetState()

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	While Sleep(10) And GUIGetMsg() <> -3
	WEnd
	GUIDelete()
EndFunc   ;==>_Example_Internal

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode, $hWndEdit
	$hWndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hWndFrom
		Case $hInput
			Switch $iCode
				Case $EN_CHANGE
					GUICtrlSetData($iInput, Real(GUICtrlRead($iInput)))
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND
