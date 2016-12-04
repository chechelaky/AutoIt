; http://www.brasilescola.com/matematica/secante-cosecante-cotangente.htm
; http://eduardo-vasconcelos.blogspot.com.br/2012/01/trigonometria-05-funcao-secante.html
#include <Array.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiComboBoxEx.au3>

; #SCRIPT# =====================================================================================================================
; Name ..........: Angulos
; Description ...: Um script que demonstra visualmente onde como é representado os componentes de um ângulo (sen, cos, tan...)
; Author ........: Luigi (Luismar Chechelaky)
; Link ..........: https://github.com/chechelaky/AutoIt/blob/master/Diversos/Angulos/Angulos.au3
; ===============================================================================================================================

Global $hGui, $hMsg, $active = True
Global $hGraphic, $hPen, $hPen2, $hBitmap, $hBackbuffer, $width = 350, $height = 300, $hCursor, $mouse[4], $xx2, $yy2

Global $mapa[10][10]
Global $largura = 800, $altura = 600, $limites[6]

Global Const $PI = 3.1415926535897932384626433832795
Global Const $radToDeg = 180 / $PI

$hGui = GUICreate('Ângulos', $largura, $altura)
Global $hSeno = GUICtrlCreateCheckbox('Seno', 10, 5, 80, 20)
Global $hCos = GUICtrlCreateCheckbox('Cosseno', 10, 25, 80, 20)
Global $hTan = GUICtrlCreateCheckbox('Tangente', 100, 5, 80, 20)
Global $hCot = GUICtrlCreateCheckbox('Cotangente', 100, 25, 80, 20)
Global $hSec = GUICtrlCreateCheckbox('Secante', 190, 5, 80, 20)
Global $hPasso = GUICtrlCreateCombo('', 280, 5, 80, 20, $CBS_DROPDOWNLIST)
Global $hInvertido = GUICtrlCreateCheckbox('Inverso', 370, 5, 80, 20)
GUICtrlSetData($hPasso, 'Livre|1|5|10|15|30', 'Livre')

Global $iSeno = 0, $iCos = 0, $iTan = 0, $iCot = 0, $iSec = 0, $iInverso = 0
GUISetState(@SW_SHOWNORMAL)

_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($largura - 20, $altura - 60, $hGraphic)

_limites()


Func _limites()
	$limites[0] = 10
	$limites[1] = 50
	$limites[2] = $largura - 20
	$limites[3] = $altura - 50
	$limites[4] = ($largura - 20) / 2
	$limites[5] = ($altura - 50) / 2
	;_ArrayDisplay($limites)
EndFunc   ;==>_limites
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

$hPen = _GDIPlus_PenCreate()
$hPen2 = _GDIPlus_PenCreate(0xFFFF0000)
$hPen3 = _GDIPlus_PenCreate(0xFF00FF00)
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

Global $hBrush_01 = _GDIPlus_BrushCreateSolid(0xFF336699)
Global $hBrush_02 = _GDIPlus_BrushCreateSolid(0xFFFF0000)
Global $hBrush_03 = _GDIPlus_BrushCreateSolid(0xFF00FF00)
Global $hFamily = _GDIPlus_FontFamilyCreate('Courier New')
Global $hFont = _GDIPlus_FontCreate($hFamily, 10)
Global $hPosX = _GDIPlus_RectFCreate(2, 0, 120, 15)
Global $hPosY = _GDIPlus_RectFCreate(2, 20, 120, 15)
Global $hAng = _GDIPlus_RectFCreate(2, 80, 120, 15)
Global $hInv = _GDIPlus_RectFCreate(2, 100, 120, 15)

Global $hPosX1 = _GDIPlus_RectFCreate(2, 40, 120, 15)
Global $hPosY1 = _GDIPlus_RectFCreate(2, 60, 120, 15)
Global $hStringFormat = _GDIPlus_StringFormatCreate()

Global $start = TimerInit()
While 1
	$hMsg = GUIGetMsg()
	Switch $hMsg
		Case $GUI_EVENT_CLOSE
			_exit()
		Case $hSeno
			$iSeno = _Iif($iSeno == 0, 1, 0)
		Case $hCos
			$iCos = _Iif($iCos == 0, 1, 0)
		Case $hTan
			$iTan = _Iif($iTan == 0, 1, 0)
		Case $hCot
			$iCot = _Iif($iCot == 0, 1, 0)
		Case $hSec
			$iSec = _Iif($iSec == 0, 1, 0)
		Case $hInvertido
			$iInverso = _Iif($iInverso == 0, 1, 0)
	EndSwitch

	$hCursor = GUIGetCursorInfo()
	If Not $hCursor Then
		$mouse[0] = $hCursor[0] - $limites[0]
		$mouse[1] = $hCursor[1] - $limites[1]
	EndIf

	If WinActive($hGui) Then
		If Not $active Then $active = True
		If TimerDiff($start) >= 10 Then
			_update()
			$start = TimerInit()
		EndIf
	ElseIf Not WinActive($hGui) And $active Then
		$active = False
	EndIf
WEnd

Func _update()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xF0FFFFFF)
	;_GDIPlus_StringFormatSetAlign($hStringFormat, 1)
	_GDIPlus_GraphicsDrawStringEx($hBackbuffer, 'x[' & $mouse[0] & ']', $hFont, $hPosX, $hStringFormat, $hBrush_01)
	_GDIPlus_GraphicsDrawStringEx($hBackbuffer, 'y[' & $mouse[1] & ']', $hFont, $hPosY, $hStringFormat, $hBrush_01)
	_GDIPlus_GraphicsDrawStringEx($hBackbuffer, 'x[' & $mouse[0] - 389 & ']', $hFont, $hPosX1, $hStringFormat, $hBrush_02)
	_GDIPlus_GraphicsDrawStringEx($hBackbuffer, 'y[' & - ($mouse[1] - 270) & ']', $hFont, $hPosY1, $hStringFormat, $hBrush_02)
	$ang = _ang(0, 0, $mouse[0] - 389, -($mouse[1] - 270))
	_GDIPlus_GraphicsDrawStringEx($hBackbuffer, 'º[' & $ang[0] & ']', $hFont, $hAng, $hStringFormat, $hBrush_02)


	_box($hBackbuffer, 0, 0, $largura - 21, $altura - 61)
	_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 21) / 2, 0, ($largura - 21) / 2, $altura - 60, $hPen)

	_GDIPlus_GraphicsDrawLine($hBackbuffer, 0, ($altura - 60) / 2, $largura - 21, ($altura - 60) / 2, $hPen)
	_GDIPlus_GraphicsDrawEllipse($hBackbuffer, ($largura - 20) / 2 - 200 - 1, ($altura - 60) / 2 - 200, 400, 400)
;~ 	_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 21) / 2, ($altura - 60) / 2, $mouse[0], $mouse[1], $hPen2)
	$cos = Int(200 * Cos(($ang[0] / 180) * $PI))
	$sen = Int(200 * Sin(($ang[0] / 180) * $PI))
	$tan = Int(200 * ($sen / $cos))
	$cot = Int(200 * ($cos / $sen))

	_GDIPlus_GraphicsDrawPie($hBackbuffer, ($largura - 20) / 2 - 1 - 25, ($altura - 60) / 2 - 25, 50, 50, 0, -$ang[0])

	If $iSeno Then
		_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, ($altura - 60) / 2, 389, 270 - $sen, $hPen2)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, 389, 270 - $sen, $hPen2)
	EndIf

	If $iCos Then
		_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, ($altura - 60) / 2, 389 + $cos, 270, $hPen2)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, 389 + $cos, 270, $hPen2)
	EndIf

	If $iTan Then
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 189, 1, 189, 538, $hPen)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 589, 1, 589, 538, $hPen)
		If $cos > 0 Then
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 589, 270 - $tan, 589, 270, $hPen2)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, 589, 270 - $tan, $hPen2)
		Else
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 189, 270 + $tan, 189, 270, $hPen2)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, 189, 270 + $tan, $hPen2)
		EndIf
	EndIf

	If $iCot Then
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 1, 70, 778, 70, $hPen)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 1, 470, 778, 470, $hPen)
		If $sen > 0 Then
			_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, 70, ($largura - 20) / 2 - 1 + $cot, 70, $hPen2)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, ($largura - 20) / 2 - 1 + $cot, 70, $hPen2)
		Else
			_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, 470, ($largura - 20) / 2 - 1 - $cot, 470, $hPen2)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, ($largura - 20) / 2 - 1 - $cot, 470, $hPen2)
		EndIf
	EndIf

	If $iSec Then
		Local $resposta = ''
		Select
			Case $ang[0] == 0 Or $ang[0] = 360
				$resposta = '#1 secante[não existe]'
			Case $ang[0] > 0 And $ang[0] < 90
				$resposta = '#2 secante[' & $ang[0] & '] angulo[' & 90 + $ang[0] & ']'
			Case $ang[0] == 90 Or $ang[0] == 180
				$resposta = '#3 secante[não existe]'
			Case $ang[0] > 90 And $ang[0] < 180
				$resposta = '#4 secante[' & $ang[0] & '] angulo[' & $ang[0] - 90 & ']'
			Case $ang[0] > 180 And $ang[0] < 270
				$resposta = '#5 secante[' & $ang[0] & '] angulo[' & 270 - $ang[0]  & ']'
			Case $ang[0] > 270 And $ang[0] < 360
				$resposta = '#6 secante[' & $ang[0] & '] angulo[' & $ang[0] - 270 & ']'
		EndSelect

		$nn1 = 389 + 0 + 1 / Int(200 * Cos(($ang[0] / 180) * $PI))
		$nn2 = 270 + 0 - $sen

		ConsoleWrite('nn1[' & $nn1 & '] nn2[' & $nn2 & ']' & @LF)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, $nn1, $nn2, $hPen2)
;~ 		_GDIPlus_GraphicsDrawEllipse($hBackbuffer, ($largura - 20) / 2 - 250 - 1, ($altura - 60) / 2 - 250, 500, 500)
		ConsoleWrite($resposta & @LF)
	EndIf

	If $iInverso Then
		Local $invertido = _Iif($ang[0] > 180, $ang[0] - 180, 180 + $ang[0])
		$invertido = _Iif($invertido = 360, 0, $invertido)
		$invertido = StringFormat('%.2f', $invertido)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, ($altura - 60) / 2, 389 - $cos, 270 + $sen, $hPen3)
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, 'º[' & $invertido & ']', $hFont, $hInv, $hStringFormat, $hBrush_03)
	EndIf
	_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, ($altura - 60) / 2, 389 + $cos, 270 - $sen, $hPen2)

	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 10, 50, $largura - 20, $altura - 60)
EndFunc   ;==>_update

Func _exit()
	_GDIPlus_BrushDispose($hBrush_01)
	_GDIPlus_BrushDispose($hBrush_02)
	_GDIPlus_BrushDispose($hBrush_03)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_StringFormatDispose($hStringFormat)

	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_PenDispose($hPen2)
	_GDIPlus_PenDispose($hPen3)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_exit

Func _box($hToGraphic, $ix1, $iy1, $il, $ia)
	Local $aBox[5][2]
	$aBox[0][0] = 4
	$aBox[1][0] = $ix1
	$aBox[1][1] = $iy1
	$aBox[2][0] = $ix1 + $il
	$aBox[2][1] = $iy1
	$aBox[3][0] = $ix1 + $il
	$aBox[3][1] = $iy1 + $ia
	$aBox[4][0] = $ix1
	$aBox[4][1] = $iy1 + $ia
	_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)
EndFunc   ;==>_box

Func _ang($xx1, $yy1, $xx2, $yy2)
	Local $arr[2], $ca = Abs($yy2 - $yy1), $co = Abs($xx2 - $xx1)
	Select
		Case $xx1 > $xx2
			Select
				Case $yy1 < $yy2
					$arr[0] = ATan(($co) / ($ca)) * $radToDeg + 90
				Case $yy1 == $yy2
					$arr[0] = 180
				Case $yy1 > $yy2
					$arr[0] = 270 - ATan(($co) / ($ca)) * $radToDeg
			EndSelect
		Case $xx1 == $xx2
			Select
				Case $yy1 < $yy2
					$arr[0] = 90
				Case $yy1 == $yy2
					$arr[0] = 0
				Case $yy1 > $yy2
					$arr[0] = 270
			EndSelect
		Case $xx1 < $xx2
			Select
				Case $yy1 < $yy2
					$arr[0] = 90 - ATan(($co) / ($ca)) * $radToDeg
				Case $yy1 == $yy2
					$arr[0] = 0
				Case $yy1 > $yy2
					$arr[0] = ATan(($co) / ($ca)) * $radToDeg + 270
					;$arr[0] = 270 - ATan(($co) / ($ca)) * $radToDeg
			EndSelect
	EndSelect
	$arr[0] = StringFormat('%.2f', $arr[0])
	$arr[1] = Sqrt($co ^ 2 + $ca ^ 2)
	Return $arr
EndFunc   ;==>_ang

Func _Iif($aa, $bb, $cc)
	If $aa Then Return $bb
	Return $cc
EndFunc
