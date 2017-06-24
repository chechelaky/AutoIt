#include <Array.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <MouseOnEvent.au3>

; A5		= 1697 x 2400
; cartão	= 1142 x 2057

Opt('GUICloseOnESC', 1)
Opt('GUIOnEventMode', 1)
Opt('GUIEventOptions', 1)
Opt('ExpandVarStrings', 1)
Opt('MustDeclareVars', 1)
Opt('WinWaitDelay', 1)

Global $sGuiTitle = 'Título', $hGui, $hMsg, $active = True
Global $hZoomLabel, $hMouseLabel, $hMapPos, $hMapSize
Global $hGuiSize[2] = [800, 600]
Global $hGraphic, $hPen, $hBitmap, $hBackbuffer
Global $hGraphicSize[4] = [0, 0, 480, 360]
Global $aMousePos, $aOldMouse[2], $mosPos, $iSubtractX, $iSubtractY, $aPos[6]
Global $aZoomFactor[100] = [0.02, 0.04, 0.06, 0.08, 0.1, 0.12, 0.14, 0.16, 0.18, 0.2, 0.22, 0.24, 0.26, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38, 0.4, 0.42, 0.44, 0.46, 0.48, 0.5, 0.52, 0.54, 0.56, 0.58, 0.6, 0.62, 0.64, 0.66, 0.68, 0.7, 0.72, 0.74, 0.76, 0.78, 0.8, 0.82, 0.84, 0.86, 0.88, 0.9, 0.92, 0.94, 0.96, 0.98, 1, 1.02, 1.04, 1.06, 1.08, 1.1, 1.12, 1.14, 1.16, 1.18, 1.2, 1.22, 1.24, 1.26, 1.28, 1.3, 1.32, 1.34, 1.36, 1.38, 1.4, 1.42, 1.44, 1.46, 1.48, 1.5, 1.52, 1.54, 1.56, 1.58, 1.6, 1.62, 1.64, 1.66, 1.68, 1.7, 1.72, 1.74, 1.76, 1.78, 1.8, 1.82, 1.84, 1.86, 1.88, 1.9, 1.92, 1.94, 1.96, 1.98, 2]
Global $iFactor = 49, $iFactorDefault = $iFactor

$hGui = GUICreate($sGuiTitle, $hGuiSize[0], $hGuiSize[1])
GUISetState(@SW_SHOWNORMAL)
$hZoomLabel = GUICtrlCreateLabel('zoom[' & $aZoomFactor[$iFactor] & ']', 600, 40, 80, 20)
$hMouseLabel = GUICtrlCreateLabel('mouse[*]', 600, 70, 120, 20)
$hMapPos = GUICtrlCreateLabel('map[*]', 600, 100, 120, 20)
$hMapSize = GUICtrlCreateLabel('size[*]', 600, 130, 180, 20)
Global $hWer = GUICtrlCreateLabel('', 600, 160, 120, 20)
Global $angulo = 0
Global $hDireita = GUICtrlCreateButton('direita', 200, 370, 80, 20)
GUICtrlSetOnEvent($hDireita, '_direita')
Global $hEsquerda = GUICtrlCreateButton('esquerda', 100, 370, 80, 20)
GUICtrlSetOnEvent($hEsquerda, '_esquerda')
_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($hGraphicSize[2], $hGraphicSize[3], $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

$hPen = _GDIPlus_PenCreate()
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

GUISetOnEvent($GUI_EVENT_CLOSE, '_specialEvents')
GUISetOnEvent($GUI_EVENT_MAXIMIZE, '_specialEvents')
GUISetOnEvent($GUI_EVENT_MINIMIZE, '_specialEvents')
;~ GUICtrlSetOnEvent($hSave, '_save')

Global $hMap = _GDIPlus_ImageLoadFromFile('mapa.png')
$aPos[0] = _GDIPlus_ImageGetWidth($hMap)
$aPos[1] = _GDIPlus_ImageGetHeight($hMap)
$aPos[2] = 0
$aPos[3] = 0
GUICtrlSetData($hWer, 'aPos[' & $aPos[2] & ',' & $aPos[3] & ']')
;~ GUICtrlSetData($hMapSize, '@[' & $aPos[0] & ',' & $aPos[1] & ']')

_MouseSetOnEvent($MOUSE_WHEELDOWN_EVENT, 'whell', 0, 1)
_MouseSetOnEvent($MOUSE_WHEELSCROLLUP_EVENT, 'wheelUp', 0, 1)
_MouseSetOnEvent($MOUSE_WHEELSCROLLDOWN_EVENT, 'whellDown', 0, 1)

Func _direita()
	$angulo += 1
	DrawInsert($hGraphic, $hBitmap, $angulo, $aPos)
	ConsoleWrite('angulo[' & $angulo & ']' & @LF)
EndFunc   ;==>_direita

Func _esquerda()
	$angulo -= 1
	ConsoleWrite('angulo[' & $angulo & ']' & @LF)
	DrawInsert($hGraphic, $hBitmap, $angulo, $aPos)
EndFunc   ;==>_esquerda



Func DrawInsert($hGraphic, $hImage2, $nAngle, $aPos)
	Local $hMatrix = _GDIPlus_MatrixCreate()
;~ 	_GDIPlus_MatrixTranslate($hMatrix, 200, 150)
	_GDIPlus_MatrixRotate($hMatrix, $nAngle)
	_GDIPlus_GraphicsSetTransform($hBackbuffer, $hMatrix)
;~ 	_GDIPlus_GraphicsDrawImage($hBackbuffer, $hImage2, $aPos[0] + $aPos[2] / 2, $aPos[1])
	_GDIPlus_MatrixDispose($hMatrix)
	_update()
EndFunc   ;==>DrawInsert

_update()
While 1
	$aMousePos = GUIGetCursorInfo()
	If IsArray($aMousePos) Then
		If $aMousePos[0] <> $aOldMouse[0] Or $aMousePos[1] <> $aOldMouse[1] Then
			GUICtrlSetData($hMapPos, 'aMousePos[' & $aMousePos[0] & ',' & $aMousePos[1] & ']' & @LF)
			If $aMousePos[2] And $hMap Then
				$mosPos = GUIGetCursorInfo($hGui);GUIGetCursorInfo($hGui)
				$iSubtractX = $mosPos[0] + $aPos[2]
				$iSubtractY = $mosPos[1] + $aPos[3]
				Do
					$aMousePos = GUIGetCursorInfo($hGui)
;~ 						GUICtrlSetData($mousePos, '[' & $mosPos[0] & ',' & $mosPos[1] & '] {' & $aMousePos[0] - $iSubtractX & ',' & $aMousePos[1] - $iSubtractY & '}')
					$aPos[2] = $iSubtractX - $aMousePos[0]
					$aPos[3] = $iSubtractY - $aMousePos[1]
					_update()
					GUICtrlSetData($hMouseLabel, 'aMousePos[' & $aMousePos[0] & ',' & $aMousePos[1] & ']')
					GUICtrlSetData($hWer, 'aPos[' & $aPos[2] & ',' & $aPos[3] & ']' & @LF)
				Until Not $aMousePos[2] Or Not valid()
			EndIf
			$aOldMouse[0] = $aMousePos[0]
			$aOldMouse[1] = $aMousePos[1]
		EndIf
	EndIf

	If WinActive($hGui) And Not $active Then
		$active = True
		_update()
	ElseIf Not WinActive($hGui) And $active Then
		$active = False
	EndIf
WEnd

Func _update()
	GUICtrlSetData($hMapSize, 'hMapSize[' & $aPos[0] * $aZoomFactor[$iFactor] & ',' & $aPos[1] * $aZoomFactor[$iFactor] & ']')
	_GDIPlus_GraphicsClear($hBackbuffer, 0xF0FFFFFF)
	_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, $hMap, $aPos[2] / $aZoomFactor[$iFactor], $aPos[3] / $aZoomFactor[$iFactor], $aPos[1] / $aZoomFactor[$iFactor], $aPos[0] / $aZoomFactor[$iFactor], 0, 0, $aPos[1], $aPos[0])
	_box($hBackbuffer, 0, 0, 10, 10)
	_GDIPlus_GraphicsDrawLine($hBackbuffer, 10, 150, 390, 150, $hPen)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, $hGraphicSize[0], $hGraphicSize[1], $hGraphicSize[2], $hGraphicSize[3])
EndFunc   ;==>_update

Func _exit()
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	GUIDelete($hGui)
	Exit
EndFunc   ;==>_exit

Func _box($hToGraphic, $xx, $yy, $ll, $aa)
	Local $aBox[5][2]
	$aBox[0][0] = 4
	$aBox[1][0] = $xx
	$aBox[1][1] = $yy
	$aBox[2][0] = $xx + $ll
	$aBox[2][1] = $yy
	$aBox[3][0] = $xx + $ll
	$aBox[3][1] = $yy + $aa
	$aBox[4][0] = $xx
	$aBox[4][1] = $yy + $aa
	_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)
EndFunc   ;==>_box

Func _specialEvents()
;~ GUIRegisterMsg
	ConsoleWrite('@GUI_CtrlId[' & @GUI_CtrlId & ']' & @LF)
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			_exit()
		Case $GUI_EVENT_MAXIMIZE
;~ 			GUISetState(@SW_RESTORE, $hGui)
			_update()
;~ 			WinSetState($hGui, "", @SW_RESTORE)
		Case $GUI_EVENT_MINIMIZE
;~ 			GUISetState(@SW_MINIMIZE, $hGui)
			WinSetState($hGui, '', @SW_MINIMIZE)
			$active = False
	EndSwitch
EndFunc   ;==>_specialEvents

Func whell()
	If Not valid() Then Return
	$iFactor = $iFactorDefault
	GUICtrlSetData($hZoomLabel, 'zoom[' & $aZoomFactor[$iFactor] & ']')
	$aPos[2] = 0
	$aPos[3] = 0
	_update()
EndFunc   ;==>whell

Func wheelUp()
	If Not valid() Then Return
	$iFactor -= 1
	If $iFactor < 0 Then
		$iFactor = 0
	Else
		Local $aOld[2] = [$aPos[0] * $aZoomFactor[$iFactor + 1], $aPos[1] * $aZoomFactor[$iFactor + 1]]
		ConsoleWrite('sizeUp[' & $aPos[0] * $aZoomFactor[$iFactor] & ']' & @LF)
		GUICtrlSetData($hZoomLabel, 'zoom[' & $aZoomFactor[$iFactor] & ']')
		ConsoleWrite('dif[' & $aPos[0] * $aZoomFactor[$iFactor] - $aOld[0] & ']' & @LF)
		$aPos[2] += ($aPos[0] * $aZoomFactor[$iFactor] - $aOld[0]) / 2
		$aPos[3] += ($aPos[1] * $aZoomFactor[$iFactor] - $aOld[1]) / 2
		_update()
	EndIf
EndFunc   ;==>wheelUp

Func whellDown()
	If Not valid() Then Return
	$iFactor += 1
	If $iFactor > UBound($aZoomFactor) - 1 Then
		$iFactor = UBound($aZoomFactor) - 1
	Else
		Local $aOld[2] = [$aPos[0] * $aZoomFactor[$iFactor - 1], $aPos[1] * $aZoomFactor[$iFactor - 1]]
		If $aMousePos[0] >= $aPos[0] Then ConsoleWrite('@')
		GUICtrlSetData($hZoomLabel, 'zoom[' & $aZoomFactor[$iFactor] & ']')
		ConsoleWrite('sizeDo[' & $aPos[0] * $aZoomFactor[$iFactor] & '] x[' & $aMousePos[0] & '] $aPos[0][' & $aPos[0] & ']' & @LF)
		ConsoleWrite('dif[' & $aPos[0] * $aZoomFactor[$iFactor] - $aOld[0] & ']' & @LF)
		$aPos[2] += ($aPos[0] * $aZoomFactor[$iFactor] - $aOld[0]) / 2
		$aPos[3] += ($aPos[1] * $aZoomFactor[$iFactor] - $aOld[1]) / 2
		_update()
		ConsoleWrite(valid())
	EndIf
EndFunc   ;==>whellDown

Func valid()
	Local $aMouse = GUIGetCursorInfo()
	If IsArray($aMouse) Then
		If $aMouse[0] >= $hGraphicSize[0] And $aMouse[0] <= $hGraphicSize[0] + $hGraphicSize[2] And $aMouse[1] >= $hGraphicSize[1] And $aMouse[1] <= $hGraphicSize[1] + $hGraphicSize[3] Then Return 1
	EndIf
	Return 0
EndFunc   ;==>valid
