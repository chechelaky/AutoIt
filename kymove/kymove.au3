#include-once
#include <Array.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

OnAutoItExitRegister("Quit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

; #SCRIPT# =====================================================================================================================
; Name ..........: kymove
; Description ...: Desenvolver o estudo de movimento de polígonos em qualquer direção com velocidade real.
;                  Isto é, a velocidade na horizontal e vertical é aproximadamente a mesma nas diagonais.
;                  Utiliza um sistema de redução de velocidade, quando em movimento em um direção, ao pressionar a tecla oposta,
;                  você tem a velocidade reduzida pela metada.
; Author ........: Luigi (Luismar Chechelaky)
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; ===============================================================================================================================

Global $MAIN_TITLE = "KYMOVE"

Global Const $ROOT = Round(Sqrt(2) / 2, 3)

Global $Z_RUN[3] = [TimerInit(), TimerInit(), 0]
Global $hGui, $hGraphic, $hBitmap, $hBackbuffer
Global $hBrush
Global $hPen
Global $sTitle = $MAIN_TITLE
Global $iWidth, $iHeight
Global $iMouveOverActor
Global $25, $26, $27, $28, $hor, $ver
Global $aKey[][5] = [[0, 1], [25, 0, 0, 0], [26, 0, 0, 0, 0], [27, 0, 0, 0, 0], [28, 0, 0, 0, 0], [11, 0, 0, 0, 0], [20, 0, 0, 0, 0]]
$aKey[0][0] = UBound($aKey, 1) - 1

Global $aMouse[5] = [@DesktopHeight / 2, @DesktopWidth / 2]
Global $aMouseTry = $aMouse
Global $aMouseDif[2]
Global $oActor = SD()
Global $iActor = 0, $iOver = 0, $iOverTry = 0
Global $aGraphic[10] = [0, 0]

Global $hDLL = DllOpen("user32.dll")

Func Gui($iWid, $iHei)
	$iWidth = $iWid
	$iHeight = $iHei

	$hGui = GUICreate($sTitle, $iWidth + 2, $iHeight + 2, -1, -1, Default, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	GUISetOnEvent($GUI_EVENT_CLOSE, "_quit")

;~ $GUI_EVENT_MINIMIZE
;~ $GUI_EVENT_RESTORE
;~ $GUI_EVENT_MAXIMIZE
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_Mouse_PrimaryDown", $hGui)
	GUISetOnEvent($GUI_EVENT_PRIMARYUP, "_Mouse_PrimaryUp", $hGui)
	GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "_Mouse_SecondaryDonw", $hGui)
	GUISetOnEvent($GUI_EVENT_SECONDARYUP, "_Mouse_SecondaryUp", $hGui)
	GUISetOnEvent($GUI_EVENT_MOUSEMOVE, "_Mouse_Move", $hGui)
;~ $GUI_EVENT_RESIZED
;~ $GUI_EVENT_DROPPED

	GUISetState(@SW_SHOW, $hGui)
	_GDIPlus_Startup()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
	$hBitmap = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphic)
	$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

	$hPen = _GDIPlus_PenCreate()

	_GDIPlus_GraphicsClear($hBackbuffer)
	_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)
	While Z_RUN()
		_Update()
	WEnd
EndFunc   ;==>Gui

Func AddBox($iXX, $iYY, $iWid = 32, $iHei = 32, $sName = False, $iSpeed = 2)
	Local $iID = $oActor.Count + 1
	Local $oo = SD()
	$oo.Add("x", $iXX)
	$oo.Add("y", $iYY)
	$oo.Add("w", $iWid)
	$oo.Add("h", $iHei)
	$sName = $sName ? $sName : "name" & $oActor.Count + 1
	$oo.Add("name", $sName)
	$oo.Add("ss", $iSpeed)
	$oo.Add("s", $iSpeed * $ROOT)
	Local $aPoly[5][2] = [ _
			[4], _
			[$iXX, $iYY], _
			[$iXX + $iWid - 1, $iYY], _
			[$iXX + $iWid - 1, $iYY + $iHei - 1], _
			[$iXX, $iYY + $iHei - 1] _
			]
	$oo.Add("poly", $aPoly)
	$oActor.Add($iID, $oo)
EndFunc   ;==>AddBox

Func _Quit()
	Exit
EndFunc   ;==>_Quit

Func _Update()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xF0FFFFFF)
	$iOver = 0
	For $each In $oActor
		$iOverTry = isPointInPath($aMouse[0], $aMouse[1], $each)
		If Not $iOver And $iOverTry Then
			$iOver = $iOverTry
			ExitLoop
		EndIf
	Next
	_MoveActor()
	For $each In $oActor
		_DrawActor($each, $iOver, $iActor)
	Next
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 1, 1, $iWidth, $iHeight)
EndFunc   ;==>_Update

Func _DrawActor($each, $iOver, $iActor)
	Local $iColor
	If $iOver = $each Then
		If $iActor = $each Then
			$iColor = $aMouseTry[2] ? 0xFFCCFFCC : 0xFF00FF00

		Else
			$iColor = 0xFF339966
		EndIf
	Else
		$iColor = $iActor = $each ? 0xFF00FF00 : 0xFF000000
	EndIf
	_box($hBackbuffer, _
			$oActor.Item($each).Item("x"), _
			$oActor.Item($each).Item("y"), _
			$oActor.Item($each).Item("w"), _
			$oActor.Item($each).Item("h"), _
			$iColor _
			)
;~ 	_GDIPlus_GraphicsDrawPolygon($hBackbuffer, $oActor.Item($each).Item("poly"))
EndFunc   ;==>_DrawActor

Func Quit()
	DllClose($hDLL)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	GUIDelete($hGui)
	Exit
EndFunc   ;==>Quit

Func _box($hToGraphic, $iXX, $iYY, $iWW, $iHH, $iColor = 0, $bFill = False)
	; _box3
	If $iWW = 1 And $iHH = 1 Then
		If $iColor Then
			_GDIPlus_BrushSetSolidColor($hBrush, $iColor)
			_GDIPlus_GraphicsFillRect($hBackbuffer, $iXX, $iYY, $iWW, $iHH, $hBrush)
		Else
			_GDIPlus_GraphicsFillRect($hBackbuffer, $iXX, $iYY, $iWW, $iHH)
		EndIf
	Else
		Local $aBox[5][2]
		$aBox[0][0] = 4
		$aBox[1][0] = $iXX
		$aBox[1][1] = $iYY
		$aBox[2][0] = $iXX + $iWW - 1
		$aBox[2][1] = $iYY
		$aBox[3][0] = $iXX + $iWW - 1
		$aBox[3][1] = $iYY + $iHH - 1
		$aBox[4][0] = $iXX
		$aBox[4][1] = $iYY + $iHH - 1
		If $iColor Then
			_GDIPlus_PenSetColor($hPen, $iColor)
			_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox, $hPen)
		Else
			_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)
		EndIf
		If $bFill Then
			_GDIPlus_BrushSetSolidColor($hBrush, $iColor)
			_GDIPlus_GraphicsFillRect($hBackbuffer, $iXX, $iYY, $iWW, $iHH, $hBrush)
		EndIf
	EndIf
EndFunc   ;==>_box

Func Z_RUN()
	Do
	Until TimerDiff($Z_RUN[0]) > 16
	$Z_RUN[0] = TimerInit()
	$Z_RUN[2] += 1
	If TimerDiff($Z_RUN[1]) > 999 Then
		WinSetTitle($hGui, "", $MAIN_TITLE & " FPS[" & $Z_RUN[2] & "]")
		$Z_RUN[1] = TimerInit()
		$Z_RUN[2] = 0
	EndIf
	Return True
EndFunc   ;==>Z_RUN

Func SD()
	Return ObjCreate("Scripting.Dictionary")
EndFunc   ;==>SD

Func isPointInPath($xx, $yy, $each)
	Local $aPoly = $oActor.Item($each).Item("poly")
;~ 	https://en.wikipedia.org/wiki/Even%E2%80%93odd_rule
	Local $iNum = UBound($aPoly, 1) - 1
	Local $jj = $iNum
	Local $cc = 0
	For $ii = 1 To $iNum
		If (($aPoly[$ii][1] > $yy) <> ($aPoly[$jj][1] > $yy)) And ($xx < ($aPoly[$jj][0] - $aPoly[$ii][0]) * ($yy - $aPoly[$ii][1]) / ($aPoly[$jj][1] - $aPoly[$ii][1]) + $aPoly[$ii][0]) Then
			$cc = Not $cc
		EndIf
		$jj = $ii
	Next
	Return $cc ? $each : 0
EndFunc   ;==>isPointInPath

Func _Mouse_PrimaryDown()
	$iActor = $iOver
	$aMouseTry[2] = 1
EndFunc   ;==>_Mouse_PrimaryDown

Func _Mouse_PrimaryUp()
	$aMouseTry[2] = 0
EndFunc   ;==>_Mouse_PrimaryUp

Func _Mouse_SecondaryDonw()
EndFunc   ;==>_Mouse_SecondaryDonw

Func _Mouse_SecondaryUp()
EndFunc   ;==>_Mouse_SecondaryUp

Func _Mouse_Move()
	$aMouseTry = GUIGetCursorInfo($hGui)
	If IsArray($aMouseTry) Then
		$aMouse[0] = $aMouseTry[0]
		$aMouse[1] = $aMouseTry[1]
		$aMouse[2] = $aMouseTry[2]
		$aMouse[3] = $aMouseTry[3]
	EndIf
EndFunc   ;==>_Mouse_Move

Func _MoveActor()
	; movimento com freio

	If Not $iActor Then Return

	$25 = _IsPressed($aKey[1][0], $hDLL)
	$26 = _IsPressed($aKey[2][0], $hDLL)
	$27 = _IsPressed($aKey[3][0], $hDLL)
	$28 = _IsPressed($aKey[4][0], $hDLL)

	; sentido
	Switch $hor
		Case -1, -0.5
			If $25 Then
				$hor = $27 ? -0.5 : -1
			Else
				If $27 Then
					$hor = 1
				Else
					$hor = 0
					$oActor.Item($iActor).Item("x") = Int($oActor.Item($iActor).Item("x"))
				EndIf
			EndIf
		Case 1, 0.5
			If $27 Then
				$hor = $25 ? 0.5 : 1
			Else
				If $25 Then
					$hor = -1
				Else
					$hor = 0
					$oActor.Item($iActor).Item("x") = Int($oActor.Item($iActor).Item("x"))
				EndIf
			EndIf
		Case Else
			If $25 Then
				If $27 Then
					$hor = 0
					$oActor.Item($iActor).Item("x") = Int($oActor.Item($iActor).Item("x"))
				Else
					$hor = -1
				EndIf
			Else
				If $27 Then
					$hor = -1
				Else
					$hor = 0
					$oActor.Item($iActor).Item("x") = Int($oActor.Item($iActor).Item("x"))
				EndIf
			EndIf
	EndSwitch

	Switch $ver
		Case -1, -0.5
			If $26 Then
				$ver = $28 ? -0.5 : -1
			Else
				If $28 Then
					$ver = 1
				Else
					$ver = 0
					$oActor.Item($iActor).Item("y") = Int($oActor.Item($iActor).Item("y"))
				EndIf
			EndIf
		Case 1, 0.5
			If $28 Then
				$ver = $26 ? 0.5 : 1
			Else
				If $26 Then
					$ver = -1
				Else
					$ver = 0
					$oActor.Item($iActor).Item("y") = Int($oActor.Item($iActor).Item("y"))
				EndIf
			EndIf
		Case Else
			If $26 Then
				If $28 Then
					$ver = 0
					$oActor.Item($iActor).Item("y") = Int($oActor.Item($iActor).Item("y"))
				Else
					$ver = -1
				EndIf
			Else
				If $28 Then
					$ver = -1
				Else
					$ver = 0
					$oActor.Item($iActor).Item("y") = Int($oActor.Item($iActor).Item("y"))
				EndIf
			EndIf
	EndSwitch

	; movimento combinado $hor e $ver
	If $hor Then
		If $ver Then
			$oActor.Item($iActor).Item("x") += $hor * $oActor.Item($iActor).Item("s")
			$oActor.Item($iActor).Item("y") += $ver * $oActor.Item($iActor).Item("s")
		Else
			$oActor.Item($iActor).Item("x") += $hor * $oActor.Item($iActor).Item("ss")
		EndIf
	Else
		$oActor.Item($iActor).Item("y") += $ver * $oActor.Item($iActor).Item("ss")
	EndIf
	_ActorSetPoly()
EndFunc   ;==>_MoveActor

Func _ActorSetPoly()
	Local $iXX = Int($oActor.Item($iActor).Item("x"))
	Local $iYY = $oActor.Item($iActor).Item("y")
	Local $iWid = $oActor.Item($iActor).Item("w")
	Local $iHei = $oActor.Item($iActor).Item("h")
	Local $aPoly = $oActor.Item($iActor).Item("poly")

	$aPoly[1][0] = $iXX
	$aPoly[1][1] = $iYY
	$aPoly[2][0] = $iXX + $iWid - 1
	$aPoly[2][1] = $iYY
	$aPoly[3][0] = $iXX + $iWid - 1
	$aPoly[3][1] = $iYY + $iHei - 1
	$aPoly[4][0] = $iXX
	$aPoly[4][1] = $iYY + $iHei - 1

	$oActor.Item($iActor).Item("poly") = $aPoly
EndFunc   ;==>_ActorSetPoly
