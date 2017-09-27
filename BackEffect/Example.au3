;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf
#include-once
#include <BackEffect.au3>

; #INDEX# =======================================================================================================================
; Title .........: BackEffect Example
; AutoIt Version : 3.3.14.2
; Description ...:
; Source.........: https://github.com/chechelaky/AutoIt/edit/master/BackEffect/Example.au3
; Author(s) .....: Luismar Chechelaky (Luigi)
; ===============================================================================================================================

OnAutoItExitRegister("OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $aGui[9] = [0, "BackEfect", 520, 360, -1, -1, Default, $WS_EX_COMPOSITED, 0]

Global $aMouse, $hGui, $OVER

$aGui[0] = GUICreate($aGui[1], $aGui[2], $aGui[3], $aGui[4], $aGui[5], $aGui[6], $aGui[7], $aGui[8])
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")

Local $hControlLabel = GUICtrlCreateLabel("Label", 10, 10, 90, 30)
Local $hControlButton = GUICtrlCreateButton("Button", 110, 10, 90, 30)
Local $hControlRadio = GUICtrlCreateRadio("Radio", 210, 10, 90, 30)
Local $hControlGroup = GUICtrlCreateGroup("Group", 310, 10, 90, 30)
Local $hControlCheckBox = GUICtrlCreateCheckbox("CheckBox", 410, 10, 90, 30)
Local $hControlCheckBox = GUICtrlCreateCombo("Combo", 10, 60, 90, 30)
Local $hControlInput = GUICtrlCreateInput("Input", 110, 60, 90, 30)
Local $hControlList = GUICtrlCreateList("List", 210, 60, 90, 90)

GUISetState(@SW_SHOW, $hGui)

;__BackEffectStart($aGui[0])
__BackEffectStart($aGui[0], 0xFFFF00)

AddBack_Effect($aGui[0], $hControlLabel, 2)
AddBack_Effect($aGui[0], $hControlButton, 4)
AddBack_Effect($aGui[0], $hControlRadio, 6)
AddBack_Effect($aGui[0], $hControlGroup)
AddBack_Effect($aGui[0], $hControlCheckBox)
AddBack_Effect($aGui[0], $hControlCheckBox)
AddBack_Effect($aGui[0], $hControlInput)
AddBack_Effect($aGui[0], $hControlList)

While Sleep(10)
WEnd

Func Quit()
	Exit
EndFunc   ;==>Quit

Func OnExit($sInput = 0)
	If IsDeclared("sInput") Then ConsoleWrite("_exit[ " & $sInput & " ]" & @LF)
	GUIDelete($aGui[0])
EndFunc   ;==>OnExit
