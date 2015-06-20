#include-once
#include <GuiCreateEx.au3>

Global $hGui
Global $hButton_NewGui

$hGui = GUICreateEx("Título[ " & $g__aGuiCreateEx[0] & " ]", 800, 600)
$hButton_NewGui = GUICtrlCreateButton("new gui", 10, 10, 80, 20)
GUICtrlSetOnEvent($hButton_NewGui, "NewGui")
GUISetState(@SW_SHOW, $hGui)

While Sleep(25)
WEnd

Func NewGui()
	Local $aSize = WinGetPos($g__aGuiCreateEx[UBound($g__aGuiCreateEx, 1) - 1])
	Local $hGui = GUICreateEx("Título[ " & $g__aGuiCreateEx[0] & " ]", $aSize[2] - (20 + 6), $aSize[3] - (40 + 5), $aSize[0] + 10, $aSize[1] + 10, Default, Default, $g__aGuiCreateEx[UBound($g__aGuiCreateEx, 1) - 1])
	$hButton_NewGui = GUICtrlCreateButton("new gui", 10, 10, 80, 20)
	GUICtrlSetOnEvent($hButton_NewGui, "NewGui")
	GUISetState(@SW_SHOW, $hGui)
EndFunc   ;==>NewGui
