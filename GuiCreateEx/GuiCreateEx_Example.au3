#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>

OnAutoItExitRegister("_GUICreateEx_OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $g__aGuiCreateEx[1] = [0]

#cs
; Example
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
#ce

; #FUNCTION# ====================================================================================================================
; Name...........:	GUICreateEx
; Description ...:	Allow create a new GUI (Graphic User Interface) above current GUI and lock previus GUI
; Syntax.........:	same way of GuiCreate
; Parameters ....:	$sTitle.......: Title's GUI
;					$iWidth.......:	width's GUI
;					$iHeight......: height's GUI
;					$iLeft........:	left position's GUI
; 					$iTop.........: top position's GUI
;					$mStyle.......:	Style's GUI
;					$mExStyle.....:	Extended Style's GUI
;					$iParent......: The handle of another previously created window
; Return values .:	a windows handle
; Author ........:	Luismar Chechelaky
; Modified.......:	2015/06/20 11:25
; Remarks .......:
; Related .......:
; Link ..........:	https://github.com/chechelaky/AutoIt/raw/master/GuiCreateEx/GuiCreateEx.au3
; Example .......:
; ===============================================================================================================================
Func GUICreateEx($sTitle = "", $iWidth = 460, $iHeight = 360, $iLeft = -1, $iTop = -1, $mStyle = Default, $mExStyle = Default, $iParent = 0)
	If Not $g__aGuiCreateEx[0] Then
		$iParent = 0
	Else
		$iParent = $g__aGuiCreateEx[UBound($g__aGuiCreateEx, 1) - 1]
		GUISetState(@SW_DISABLE, $iParent)
	EndIf
	Local $hGui = GUICreate($sTitle, $iWidth, $iHeight, $iLeft, $iTop, $mStyle, $mExStyle, $iParent)
	If @error Then Return SetError(1, 0, 0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_GUICreateEx_Quit")
	_ArrayAdd($g__aGuiCreateEx, $hGui)
	$g__aGuiCreateEx[0] = UBound($g__aGuiCreateEx, 1) - 1
	Return $g__aGuiCreateEx[$g__aGuiCreateEx[0]]
EndFunc   ;==>GUICreateEx

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	_GUICreateEx_OnExit
; Author ........:	Luismar Chechelaky
; Modified.......:	2015/06/20 11:25
; Link ..........:	https://github.com/chechelaky/AutoIt/raw/master/GuiCreateEx/GuiCreateEx.au3
; ===============================================================================================================================
Func _GUICreateEx_OnExit()
	GUISetState($g__aGuiCreateEx[1], @SW_HIDE)
	GUIDelete($g__aGuiCreateEx[1])
EndFunc   ;==>_GUICreateEx_OnExit

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	_GUICreateEx_Quit
; Author ........:	Luismar Chechelaky
; Modified.......:	2015/06/20 11:25
; Link ..........:	https://github.com/chechelaky/AutoIt/raw/master/GuiCreateEx/GuiCreateEx.au3
; ===============================================================================================================================
Func _GUICreateEx_Quit()
	Local $hGui
	Switch $g__aGuiCreateEx[0]
		Case 1
			$hGui = $g__aGuiCreateEx[$g__aGuiCreateEx[0]]
			Exit
		Case Else
			GUISetState(@SW_ENABLE, $g__aGuiCreateEx[$g__aGuiCreateEx[0] - 1])
			GUISetState($g__aGuiCreateEx[$g__aGuiCreateEx[0]], @SW_HIDE)
			GUIDelete($g__aGuiCreateEx[$g__aGuiCreateEx[0]])
			_ArrayDelete($g__aGuiCreateEx, UBound($g__aGuiCreateEx, 1) - 1)
			$g__aGuiCreateEx[0] = UBound($g__aGuiCreateEx, 1) - 1
	EndSwitch
EndFunc   ;==>_GUICreateEx_Quit
