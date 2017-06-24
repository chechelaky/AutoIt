#include <Array.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
OnAutoItExitRegister('_exit')

Global $hGui, $hMsg, $active = True, $sTitle = 'moveIt'
Global $zoom = 4
Global $hGraphic, $hPen, $hBitmap, $hBackbuffer, $hBrush1
Global $iTimeCount = TimerInit()
Global $aPixel[2] = [32, 32]
Global $aMap[2] = [6, 3]
Global $aGrid[2] = [$aPixel[0] * $aMap[0], $aPixel[1] * $aMap[1]]
Global $aPixel[$aGrid[0]][$aGrid[1]]
ConsoleWrite('x[' & UBound($aPixel, 1) & '] y[' & UBound($aPixel, 2) & ']' & @LF)
ConsoleWrite('g0' & $aGrid[0] & '/' & $aGrid[1] & @LF)
Global Const $nPI = 3.1415;926535897932384626433832795
Global $hDll = DllOpen('user32.dll'), $aMove[4] = [0, 0, 0, 0]
Global $iVelocidade = 2
Global $aActor[1][7], $aWall[1][7]
Global $hLabel
;~ movimento colisão

$hGui = GUICreate($sTitle, $aGrid[0] * $zoom, $aGrid[1] * $zoom + 100, -1, -1, Default, Default)
$hLabel = GUICtrlCreateLabel('', 10, 10, 120, 20)
GUISetState(@SW_SHOWNORMAL)

_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($aGrid[0], $aGrid[1], $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
Global $hImage = _GDIPlus_ImageLoadFromFile('red.png')

$hPen = _GDIPlus_PenCreate()
$hBrush1 = _GDIPlus_BrushCreateSolid()
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

Global $box = _addActor(0xff0000, 20, 60, 8, 8)

_addWall(0xFFFF0000, 16, 16, 8, 8)
_addWall(0xFFFF0000, 24, 16, 8, 8)
_addWall(0xFFFF0000, 8, 8, 8, 8)
_addWall(0xFFFF0000, 32, 8, 8, 8)
_addWall(0xFFFF0000, 40, 8, 8, 8)
_addWall(0xFFFF0000, 48, 8, 8, 8)
_addWall(0xFFFF0000, 56, 8, 8, 8)
_addWall(0xFFFF0000, 64, 8, 8, 8)
_addWall(0xFFFF0000, 72, 8, 8, 8)
_addWall(0xFFFF0000, 80, 8, 8, 8)
;~ _addWall(0xFFFF0000, 48, 16, 8, 8)
;~ _addWall(0xFFFF0000, 48, 24, 8, 8)

For $xx = 0 To 40
	_addWall(0xFFFF0000, 8 * Random(0, 23, 1), 8 * Random(0, 11, 1), 8, 8)
Next

Func _addActor($color, $posX, $posY, $lar, $alt)
	ReDim $aActor[UBound($aActor, 1) + 1][UBound($aActor, 2)]
	Local $id = UBound($aActor) - 1
	$aActor[$id][0] = $color
	$aActor[$id][1] = $posX
	$aActor[$id][2] = $posY
	$aActor[$id][3] = $lar - 1
	$aActor[$id][4] = $alt - 1
	$aActor[$id][5] = $aGrid[0] - $lar - 1
	$aActor[$id][6] = $aGrid[1] - $alt - 1
	Return $id
EndFunc   ;==>_addActor

Func _addWall($color, $posX, $posY, $lar, $alt)
	ReDim $aWall[UBound($aWall, 1) + 1][UBound($aWall, 2)]
	Local $id = UBound($aWall) - 1
	$aWall[$id][0] = $color
	$aWall[$id][1] = $posX
	$aWall[$id][2] = $posY
	$aWall[$id][3] = $lar - 1
	$aWall[$id][4] = $alt - 1
	$aWall[$id][5] = $posX + $lar - 1
	$aWall[$id][6] = $posY + $alt - 1
	For $yy = $aWall[$id][2] To $aWall[$id][6]
		For $xx = $aWall[$id][1] To $aWall[$id][5]
			$aPixel[$xx][$yy] = $id
		Next
	Next
EndFunc   ;==>_addWall

While True
	$hMsg = GUIGetMsg()
	Switch $hMsg
		Case $GUI_EVENT_CLOSE
			_exit()
	EndSwitch

	If TimerDiff($iTimeCount) > 15 Then
		For $xx = 0 To 3
			If _IsPressed(25 + $xx, $hDll) And Not $aMove[$xx] Then
				$aMove[$xx] = 1
			ElseIf $aMove[$xx] And Not _IsPressed(25 + $xx, $hDll) Then
				$aMove[$xx] = 0
			EndIf
		Next
;~ 		_moveNodes()
		_moveActor($box, $aMove, $iVelocidade)
		_update()
		GUICtrlSetData($hLabel, 'pos[' & $aActor[1][1] & '/' & $aActor[1][2] & ']')
		$iTimeCount = TimerInit()
	EndIf

;~ 	If WinActive($hGui) Then
;~ 		_update()
;~ 		If Not $active Then $active = True
;~ 	ElseIf Not WinActive($hGui) And $active Then
;~ 		$active = False
;~ 	EndIf
WEnd

Func _moveActor($id, $move, $iVel)
	$move = _ArrayToString($move, '')
;~ 	ConsoleWrite('move[' & $move & ']' & @LF)
	Switch $move
		Case 1000 ; esquerda / H
			_moveH($id, $iVel)
		Case 0100 ; cima / B
			_moveB($id, $iVel)
		Case 0010 ; direita / D
			_moveD($id, $iVel)
		Case 0001 ; baixo / F
			_moveF($id, $iVel)
		Case 1100 ; esquerda-cima / A
			_moveA($id, $iVel)
		Case 0110 ; direita-cima / C
			_moveC($id, $iVel)
		Case 0011 ; direita-baixo / E
			_moveE($id, $iVel)
		Case 1001 ; esquerda-baixo / G
			_moveG($id, $iVel)
	EndSwitch
EndFunc   ;==>_moveActor

Func _moveA($id, $iVel) ; esquerda-cima
	_moveH($id, $iVel)
	_moveB($id, $iVel)
EndFunc   ;==>_moveA

Func _moveB($id, $iVel) ; cima
	If $aActor[$id][2] > 0 Then
		Local $iStep = 0, $aContact[1]
		Do
			$aActor[$id][2] -= 1
			If $aActor[$id][2] < 0 Then $aActor[$id][2] = 0
			For $yy = $aActor[$id][1] To $aActor[$id][1] + $aActor[$id][3]
				If $aPixel[$yy][$aActor[$id][2]] Then
					_ArrayAdd($aContact, $aPixel[$yy][$aActor[$id][2]])
					$aActor[$id][2] += 1
					ExitLoop (2)
				EndIf
			Next
			$iStep += 1
		Until $iStep = $iVel
	EndIf
EndFunc   ;==>_moveB

Func _moveC($id, $iVel) ; direita-cima
	_moveB($id, $iVel)
	_moveD($id, $iVel)
EndFunc   ;==>_moveC

Func _moveD($id, $iVel) ; direita
	If $aActor[$id][1] < $aActor[$id][5] Then
		Local $iStep = 0, $aContact[1], $iSplash = 0
		Do
			$aActor[$id][1] += 1
			If $aActor[$id][1] >= $aActor[$id][5] + 1 Then $aActor[$id][1] = $aActor[$id][5] + 1
			For $yy = $aActor[$id][2] To $aActor[$id][2] + $aActor[$id][4]
				$iSplash = $aPixel[$aActor[$id][1] + $aActor[$id][3]][$yy]
				If $iSplash Then
					_ArrayAdd($aContact, $iSplash)
					$aActor[$id][1] -= 1
					ExitLoop (2)
				EndIf
			Next
			$iStep += 1
		Until $iStep = $iVel
	EndIf
EndFunc   ;==>_moveD

Func _moveE($id, $iVel) ; direita-baixo
	_moveF($id, $iVel)
	_moveD($id, $iVel)
EndFunc   ;==>_moveE

Func _moveF($id, $iVel) ; baixo
	If $aActor[$id][2] < $aActor[$id][6] Then
		Local $iStep = 0, $aContact[1], $iSplash = 0
		Do
			$aActor[$id][2] += 1
			If $aActor[$id][2] > $aActor[$id][6] + 1 Then $aActor[$id][2] = $aActor[$id][6] + 1
			For $yy = $aActor[$id][1] To $aActor[$id][1] + $aActor[$id][3]
				$iSplash = $aPixel[$yy][$aActor[$id][2] + $aActor[$id][4]]
				If $iSplash Then
					_ArrayAdd($aContact, $iSplash)
					$aActor[$id][2] -= 1
					ExitLoop (2)
				EndIf
			Next
			$iStep += 1
		Until $iStep = $iVel
	EndIf
EndFunc   ;==>_moveF

Func _moveG($id, $iVel) ; esquerda-baixo
	_moveH($id, $iVel)
	_moveF($id, $iVel)
EndFunc   ;==>_moveG

Func _moveH($id, $iVel) ;  esquerda
	If $aActor[$id][1] > 0 Then
		Local $iStep = 0, $aContact[1], $iSplash = 0
		Do
			$aActor[$id][1] -= 1
			If $aActor[$id][1] < 0 Then $aActor[$id][1] = 0
			For $xx = $aActor[$id][2] To $aActor[$id][2] + $aActor[$id][4]
				$iSplash = $aPixel[$aActor[$id][1]][$xx]
				If $iSplash Then
					_ArrayAdd($aContact, $iSplash)
					$aActor[$id][1] += 1
					ExitLoop (2)
				EndIf
			Next
			$iStep += 1
		Until $iStep = $iVel
	EndIf
EndFunc   ;==>_moveH

Func _drawActor()
	For $ii = 1 To UBound($aActor) - 1
		_box($hBackbuffer, $aActor[$ii][1], $aActor[$ii][2], $aActor[$ii][3], $aActor[$ii][4])
	Next
EndFunc   ;==>_drawActor

Func _drawWall()
	If UBound($aWall) + 1 Then
		For $ii = 1 To UBound($aWall) - 1
			_box($hBackbuffer, $aWall[$ii][1], $aWall[$ii][2], $aWall[$ii][3], $aWall[$ii][4], $aWall[$ii][0])
		Next
	EndIf
EndFunc   ;==>_drawWall

Func _update()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	_drawWall()
	_drawActor()
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 100, $aGrid[0] * $zoom, $aGrid[1] * $zoom)
EndFunc   ;==>_update

Func _exit()
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_BrushDispose($hBrush1)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	DllClose($hDll)
	Exit
EndFunc   ;==>_exit

Func _box($hToGraphic, $xx, $yy, $ll, $aa, $color = 0)
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
	If $color Then
		_GDIPlus_PenSetColor($hPen, $color)
		_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox, $hPen)
	Else
		_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)
	EndIf
EndFunc   ;==>_box
