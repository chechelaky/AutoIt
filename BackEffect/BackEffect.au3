;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf
#include-once
#include <Array.au3>
#include <Color.au3>
#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WinAPIGdi.au3>


; #INDEX# =======================================================================================================================
; Title .........: BackEffect
; AutoIt Version : 3.3.14.2
; Description ...:
; Author(s) .....: Luismar Chechelaky (Luigi)
; ===============================================================================================================================

Func AddBack_Effect($hGui, $hControl = 0, $iBorder = 4)
	#forcedef $g_oBackeffect_Control
	If Not $hControl Or $g_oBackeffect_Control.Exists($hControl) Then Return SetError(1, 0, 0)
	Local $aPos = ControlGetPos($hGui, "", $hControl)
	Local $temp = GUICtrlCreateLabel("", $aPos[0] - $iBorder, $aPos[1] - $iBorder, $aPos[2] + $iBorder * 2, $aPos[3] + $iBorder * 2)
	$g_oBackeffect_Control.Add($hControl, $temp)
	$g_oBackeffect_Control.Add($temp, $temp)
EndFunc   ;==>AddBack_Effect

Func __BackEffectStart($hGui = 0, $iColorOver = 0x00FF00, $iDelay = 10, $iIncrement = 5)
	__BackEffect_EvalNumber($iDelay, 10)
	__BackEffect_EvalNumber($iIncrement, 2)

	If Not IsDeclared("g_aBackEffect_Over") Then Global $g_aBackEffect_Over = __BackEffect_SplitColor(Hex($iColorOver, 6))
	If Not IsDeclared("g_aBackEffect_Back") Then Global $g_aBackEffect_Back = __BackEffect_SplitColor(Hex(GUIGetBkColor($hGui), 6))
;~ 	ConsoleWrite("$g_aBackEffect_Back[" & $g_aBackEffect_Back & "]" & @LF)
;~ 	ConsoleWrite("$g_aBackEffect_Back[ " &  $g_aBackEffect_Back & " ]" & @LF)
	If Not IsDeclared("g_iBackeffect_Delay") Then Global $g_iBackeffect_Delay = $iDelay
	If Not IsDeclared("g_iBackeffect_Increment") Then Global $g_iBackeffect_Increment = $iIncrement
	If Not IsDeclared("g_oBackeffect_Control") Then Global $g_oBackeffect_Control = ObjCreate("Scripting.Dictionary")
	If Not IsDeclared("g_oBackeffect_Label") Then Global $g_oBackeffect_Label = ObjCreate("Scripting.Dictionary")
	If Not IsDeclared("g_aBackeffect_Split") Then Global $g_aBackeffect_Channel
	If Not IsDeclared("g_aBackeffect_RGB") Then Global $g_aBackeffect_Channel
	If Not IsDeclared("g_aMouse") Then Global $g_aMouse
	If Not IsDeclared("g_iOVER") Then Global $g_iOVER
	If Not IsDeclared("g_hGui") Then Global $g_hGui

	AdlibRegister("__BackEffect", $g_iBackeffect_Delay)
	OnAutoItExitRegister("__BackEffectStop")
EndFunc   ;==>__BackEffectStart

Func __BackEffect_EvalNumber(ByRef $iNumber, $iMin)
	$iNumber = Int(Abs(Number($iNumber)))
	$iNumber = ($iNumber < $iMin) ? $iMin : $iNumber
EndFunc   ;==>__BackEffect_EvalNumber

Func __BackEffectStop()
	AdlibUnRegister("__BackEffect")
EndFunc   ;==>__BackEffectStop

Func __BackEffect()
	$g_aMouse = GUIGetCursorInfo($g_hGui)
	If @error Or Not $g_aMouse[4] Then
		$g_iOVER = 0
	Else
		$g_iOVER = $g_oBackeffect_Control.Item($g_aMouse[4])
	EndIf

	If $g_iOVER And Not $g_oBackeffect_Label.Exists($g_iOVER) Then $g_oBackeffect_Label.Add($g_iOVER, Hex($g_aBackEffect_Back[3]))
	For $each In $g_oBackeffect_Label
		If $each == $g_iOVER Then
			If Not ("0x" & $g_oBackeffect_Label.Item($each) == $g_aBackEffect_Over[3]) Then
				$g_aBackeffect_Channel = __BackEffect_SplitColor($g_oBackeffect_Label.Item($each))
				For $ii = 0 To 2
					$g_aBackeffect_Channel[$ii] = __BackEffect_Compare($g_aBackEffect_Over[$ii], $g_aBackeffect_Channel[$ii], $g_aBackeffect_Channel[$ii])
				Next
				$g_oBackeffect_Label.Item($each) = Hex($g_aBackeffect_Channel[0], 2) & Hex($g_aBackeffect_Channel[1], 2) & Hex($g_aBackeffect_Channel[2], 2)
				GUICtrlSetBkColor($each, "0x" & $g_oBackeffect_Label.Item($each))
			EndIf
		Else
			If Not ("0x" & $g_oBackeffect_Label.Item($each) == $g_aBackEffect_Back[3]) Then
				$g_aBackeffect_Channel = __BackEffect_SplitColor($g_oBackeffect_Label.Item($each))
				For $ii = 0 To 2
					$g_aBackeffect_Channel[$ii] = __BackEffect_Compare($g_aBackEffect_Back[$ii], $g_aBackeffect_Channel[$ii], $g_aBackeffect_Channel[$ii])
				Next
				$g_oBackeffect_Label.Item($each) = Hex($g_aBackeffect_Channel[0], 2) & Hex($g_aBackeffect_Channel[1], 2) & Hex($g_aBackeffect_Channel[2], 2)
				GUICtrlSetBkColor($each, "0x" & $g_oBackeffect_Label.Item($each))
			EndIf
		EndIf
	Next
EndFunc   ;==>__BackEffect

Func __BackEffect_Compare($FROM, $TO, $iChannel)
;~ 	ConsoleWrite("__BackEffect_Compare( $FROM=" & $FROM & ", $TO=" & $TO & ", $iChannel=" & $iChannel & " )" & @LF)
	Switch $FROM
		Case $TO
			Return $FROM
		Case Else
			If $FROM > $TO Then
				$iChannel = $TO + $g_iBackeffect_Increment
				If $iChannel > $FROM Then Return $FROM
			Else
				$iChannel = $TO - $g_iBackeffect_Increment
				If $iChannel < $FROM Then Return $FROM
			EndIf
	EndSwitch
	Return $iChannel
EndFunc   ;==>__BackEffect_Compare

Func __BackEffect_SplitColor($input)
;~ 	ConsoleWrite("__BackEffect_SplitColor[ " & $input & " ] $Red[ " & $Red & " ] $Green[ " & $Green & " ] $Blue[ " & $Blue & " ]" & @LF)
	Local $arr[4] = [BitAND(BitShift("0x" & $input, 16), 0xFF), BitAND(BitShift("0x" & $input, 8), 0xFF), BitAND("0x" & $input, 0xFF), "0x" & $input]
	Return $arr
EndFunc   ;==>__BackEffect_SplitColor

; #FUNCTION# ====================================================================================================================
; Name ..........: GUIGetBkColor
; Description ...: Retrieves the RGB value of the GUI background.
; Syntax ........: GUIGetBkColor($hWnd)
; Parameters ....: $hWnd                - A handle of the GUI.
; Return values .: Success - RGB value
;                  Failure - 0
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func GUIGetBkColor($hWnd)
	Local $iColor = 0
	If IsHWnd($hWnd) Then
		Local $hDC = _WinAPI_GetDC($hWnd)
		$iColor = _WinAPI_GetBkColor($hDC)
		_WinAPI_ReleaseDC($hWnd, $hDC)
	EndIf
	Return $iColor
EndFunc   ;==>GUIGetBkColor
