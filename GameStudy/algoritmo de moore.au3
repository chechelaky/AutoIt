;~ https://en.wikipedia.org/wiki/Connected-component_labeling
;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf


#include-once
#include <WinAPI.au3>
#include <Array.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WinAPIGdi.au3>

#include <object_dump.au3>

OnAutoItExitRegister("_on_exit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global Const $SEP = "#"
Global $aGuiSize[2] = [800, 600]
Global $sGuiTitle = "GuiTitle"
Global $hGui
Global $ax[2], $ay[2]
Global $iSize = 32
Global $ALL[1][5] = [[0]]
Global $iChield, $aPos
Global Const $SD = "Scripting.Dictionary"
Global $oIndex = ObjCreate($SD)
Global $aMouse, $aClick[2]
Global $ON = 0xABA69E, $OFF = 0xD4D0C8
Global $hNeighbors

Global $POS, $iNext, $iSearch, $color

; grid or image
; 0 is transparency
; non-zero (value does not matter) is any color
Global $aGrid[][12] = [ _
		[0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0], _
		[0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1], _
		[0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0], _
		[0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0], _
		[1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0], _
		[0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], _
		[0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1], _
		[0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1], _
		[0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0], _
		[0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0] _
		]

; array to analise
Global $aMax[4] = [UBound($aGrid, 1), UBound($aGrid, 2)]
$aMax[2] = $aMax[0] - 1
$aMax[3] = $aMax[1] - 1

Global $hArr[$aMax[0]][$aMax[1]]

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "_quit")
GUISetState(@SW_SHOW, $hGui)
$hNeighbors = GUICtrlCreateButton("Neighbors", $iSize, 10, 80, 20)
GUICtrlSetOnEvent($hNeighbors, "Neighbors")

For $LIN = 0 To $aMax[2]
	For $COL = 0 To $aMax[3]
		$hArr[$LIN][$COL] = GUICtrlCreateLabel($aGrid[$LIN][$COL], $iSize + $COL * $iSize, $iSize + $LIN * $iSize, $iSize, $iSize, BitOR($SS_SUNKEN, $SS_CENTER))
		$color = Color()
		GUICtrlSetBkColor($hArr[$LIN][$COL], $aGrid[$LIN][$COL] ? $color : $OFF)
		GUICtrlSetTip($hArr[$LIN][$COL], $LIN & "," & $COL)
		If $aGrid[$LIN][$COL] Then Populate($ALL, $LIN, $COL, $LIN & $SEP & $COL, $color)
		__index($oIndex, $hArr[$LIN][$COL], $LIN, $COL)
	Next
Next

Func __index(ByRef $oo, $handle, $LIN = 0, $COL = 0)
	Local $arr[2] = [$LIN, $COL]
	$oo.Add($handle, $arr)
EndFunc   ;==>__index

Func Neighbors()
	Global $ALL[1][5] = [[0]]
	For $LIN = 0 To $aMax[2]
		For $COL = 0 To $aMax[3]
			$color = Color()
			GUICtrlSetBkColor($hArr[$LIN][$COL], $aGrid[$LIN][$COL] ? $color : $OFF)
			If $aGrid[$LIN][$COL] Then Populate($ALL, $LIN, $COL, $LIN & $SEP & $COL, $color)
		Next
	Next
	Colorate()
EndFunc   ;==>Neighbors

Colorate()
;~ _ArrayDisplay($ALL, "Neighbors pixels", 0, 0, Default, "$LIN|$COL|$POS|$COLOR|$parent")

Func Populate(ByRef $aInput, $LIN, $COL, $POS, $color, $parent = 0)
	$iSearch = _ArraySearch($ALL, $POS, 1, Default, 0, 0, 2, 2)
	If Not @error Then Return
	Local $viz
	$LIN = Number($LIN)
	$COL = Number($COL)
	If $parent Then
		Local $iRedim = UBound($aInput, 1)
		ReDim $aInput[$iRedim + 1][5]
		$aInput[0][0] = $iRedim
		$aInput[$iRedim][0] = $LIN
		$aInput[$iRedim][1] = $COL
		$aInput[$iRedim][2] = $POS
		$aInput[$iRedim][3] = $color
		$aInput[$iRedim][4] = $parent

		$viz = __GetNeighbor($aGrid, $LIN, $COL)
		For $ii = 1 To $viz[0]
			$aPos = StringSplit($viz[$ii], $SEP, 2)
			Populate($ALL, $aPos[0], $aPos[1], $viz[$ii], $color, $parent)
		Next
	Else
		Local $iRedim = UBound($aInput, 1)
		ReDim $aInput[$iRedim + 1][5]
		$aInput[0][0] = $iRedim
		$aInput[$iRedim][0] = $LIN
		$aInput[$iRedim][1] = $COL
		$aInput[$iRedim][2] = $POS
		$aInput[$iRedim][3] = $color
		$aInput[$iRedim][4] = $iRedim

		$viz = __GetNeighbor($aGrid, $LIN, $COL)
		If $viz[0] >= 1 Then
			For $ii = 1 To $viz[0]
				$aPos = StringSplit($viz[$ii], $SEP, 2)
				Populate($ALL, $aPos[0], $aPos[1], $viz[$ii], $color, $iRedim)
			Next
		EndIf
	EndIf
	Return $iRedim
EndFunc   ;==>Populate

Func Colorate()
	For $ii = 1 To $ALL[0][0]
		If Not ($ii = $ALL[$ii][4]) Then
;~ 			Sleep(30)
			GUICtrlSetBkColor($hArr[$ALL[$ii][0]][$ALL[$ii][1]], $ALL[$ii][3])
		EndIf
	Next
EndFunc   ;==>Colorate


While Sleep(25)
	$aMouse = GUIGetCursorInfo($hGui)
	If IsArray($aMouse) And $aMouse[3] And Not $aClick[1] Then
		$aClick[1] = $aMouse[4]
		Click_Left()
	ElseIf Not $aMouse[3] And $aClick[1] Then
		$aClick[1] = 0
	EndIf
WEnd

Func Click_Left()
	If $aClick[1] < $hArr[0][0] Or $aClick[1] > $hArr[UBound($aGrid, 1) - 1][UBound($hArr, 2) - 1] Then Return
	Local $arr = $oIndex.Item($aClick[1])
	ConsoleWrite(">" & _ArrayToString($arr, ",") & @LF)
	Switch $aGrid[$arr[0]][$arr[1]]
		Case 1
			$aGrid[$arr[0]][$arr[1]] = 0
			GUICtrlSetData($aClick[1], 0)
			GUICtrlSetBkColor($aClick[1], $OFF)
		Case Else
			$aGrid[$arr[0]][$arr[1]] = 1
			GUICtrlSetData($aClick[1], 1)
			GUICtrlSetBkColor($aClick[1], $ON)
	EndSwitch
EndFunc   ;==>Click_Left

Func _on_exit()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>_on_exit

Func _quit()
	Exit
EndFunc   ;==>_quit

Func __GetNeighbor($aInput, $LIN, $COL)
	Local $aRet[1] = [0]

	$ax[0] = $LIN - 1
	$ax[0] = $ax[0] < 0 ? 0 : $ax[0]

	$ax[1] = $LIN + 1
	$ax[1] = $ax[1] > UBound($aInput, 1) - 1 ? UBound($aInput, 1) - 1 : $ax[1]

	$ay[0] = $COL - 1
	$ay[0] = $ay[0] < 0 ? 0 : $ay[0]

	$ay[1] = $COL + 1
	$ay[1] = $ay[1] > UBound($aInput, 2) - 1 ? UBound($aInput, 2) - 1 : $ay[1]

	For $yy = $ax[0] To $ax[1]
		For $xx = $ay[0] To $ay[1]
			If $aInput[$yy][$xx] And Not ($yy = $LIN And $xx = $COL) Then _ArrayAdd($aRet, $yy & $SEP & $xx)
		Next
	Next
	If UBound($aRet, 1) - 1 > 0 Then $aRet[0] = UBound($aRet, 1) - 1
	Return $aRet
EndFunc   ;==>__GetNeighbor

Func Color()
	Local $iRet
	Do
		$iRet = "0x" & Hex(Random(0, 255, 1), 2) & Hex(Random(0, 255, 1), 2) & Hex(Random(0, 255, 1), 2)
	Until $iRet <> $ON And $iRet <> $OFF
	Return $iRet
EndFunc   ;==>Color


; #FUNCTION# ====================================================================================================================
; Name ..........: GUICtrlGetBkColor
; Description ...: Retrieves the RGB value of the control background.
; Syntax ........: GUICtrlGetBkColor($hWnd)
; Parameters ....: $hWnd                - Control ID/Handle to the control
; Return values .: Success - RGB value
;                  Failure - 0
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func GUICtrlGetBkColor($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $hDC = _WinAPI_GetDC($hWnd)
	Local $iColor = _WinAPI_GetPixel($hDC, 0, 0)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	Return $iColor
EndFunc   ;==>GUICtrlGetBkColor
