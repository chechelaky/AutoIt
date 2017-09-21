;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

; #SCRIPT# =====================================================================================================================
; Name ..........: Angulos
; Description ...: Um script que demonstra visualmente onde como é representado os componentes de um ângulo (sen, cos, tan...)
; Author ........: Luigi (Luismar Chechelaky)
; Link ..........: https://github.com/chechelaky/AutoIt/blob/master/Diversos/Angulos/Angulos.au3
; ===============================================================================================================================

#include <Array.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiComboBoxEx.au3>

#include <GUIConstants.au3>
#include <editconstants.au3>
#include <windowsconstants.au3>

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $RAIO = 100
Global $hGui, $hMsg, $active = True
Global $hGraphic, $hPen1, $hPen2, $hPen3, $hPen4, $hPen5, $hBitmap, $hBackbuffer, $hCursor, $mouse[4], $xx2, $yy2

Global $largura = 800, $altura = 600, $limites[6]

Global Const $PI = 3.1415926535897932384626433832795
Global Const $radToDeg = 180 / $PI

$hGui = GUICreate("Ângulos", $largura, $altura)
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit", $hGui)
Global $hSeno = GUICtrlCreateCheckbox("Seno", 10, 5, 80, 20)
GUICtrlSetOnEvent($hSeno, "Show_Seno")

Global $hCos = GUICtrlCreateCheckbox("Cosseno", 10, 25, 80, 20)
GUICtrlSetOnEvent($hCos, "Show_Cos")

Global $hTan = GUICtrlCreateCheckbox("Tangente", 100, 5, 80, 20)
GUICtrlSetOnEvent($hTan, "Show_Tan")

Global $hCot = GUICtrlCreateCheckbox("Cotangente", 100, 25, 80, 20)
GUICtrlSetOnEvent($hCot, "Show_Cot")

Global $hSec = GUICtrlCreateCheckbox("Secante", 190, 5, 80, 20)
GUICtrlSetOnEvent($hSec, "Show_Sec")

Global $hCosec = GUICtrlCreateCheckbox("Co-Sec", 190, 25, 80, 20)
GUICtrlSetOnEvent($hCosec, "Show_Cosec")

Global $hPasso = GUICtrlCreateCombo("", 270, 5, 80, 20, $CBS_DROPDOWNLIST)
GUICtrlSetData($hPasso, "Livre|1|5|10|15|30", "Livre")

Global $hInvertido = GUICtrlCreateCheckbox("Inverso", 360, 5, 80, 20)
GUICtrlSetOnEvent($hInvertido, "Show_Inverso")

Global $hDxDy = GUICtrlCreateCheckbox("DxDy", 360, 25, 80, 20)
GUICtrlSetOnEvent($hDxDy, "Show_DxDy")

Global $hPontoOrigem = GUICtrlCreateCheckbox("Origem", 450, 5, 80, 20)
GUICtrlSetOnEvent($hPontoOrigem, "Show_Origem")
Global $hPontoCartesiano = GUICtrlCreateCheckbox("Cartesiano", 450, 25, 80, 20)
GUICtrlSetOnEvent($hPontoCartesiano, "Show_Cartesiano")

GUICtrlCreateLabel("Raio", 540, 5, 80, 20)
Global $iInputRaio = GUICtrlCreateInput($RAIO, 540, 25, 80, 20, $ES_NUMBER)
Global $hInputRaio = GUICtrlGetHandle($iInputRaio)

Global $iSeno = False, $iCos = False, $iTan = False, $iCot = False, $iSec = False, $iCoSec = False, $iInverso = False, $bOrigem = False, $bCartesiano = False, $bDxDy = False
GUISetState(@SW_SHOWNORMAL)
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($largura - 20, $altura - 60, $hGraphic)

_limites()


$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

$hPen1 = _GDIPlus_PenCreate()
$hPen2 = _GDIPlus_PenCreate(0xFFFF0000, 3)
$hPen3 = _GDIPlus_PenCreate(0xFF339966)
$hPen4 = _GDIPlus_PenCreate(0xFF0000FF)
$hPen5 = _GDIPlus_PenCreate(0xFF3366FF)
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

Global $hBrush_01 = _GDIPlus_BrushCreateSolid(0xFF336699)
Global $hBrush_02 = _GDIPlus_BrushCreateSolid(0xFFFF0000)
Global $hBrush_03 = _GDIPlus_BrushCreateSolid(0xFF339966)
Global $hBrush_04 = _GDIPlus_BrushCreateSolid(0xFF3366FF)
Global $hFamily = _GDIPlus_FontFamilyCreate("Courier New")
Global $hFont = _GDIPlus_FontCreate($hFamily, 10)
Global $hFont2 = _GDIPlus_FontCreate($hFamily, 25)
Global $hPosX = _GDIPlus_RectFCreate(2, 0, 120, 15)
Global $hPosY = _GDIPlus_RectFCreate(2, 20, 120, 15)
Global $hAng = _GDIPlus_RectFCreate(600, 400, 180, 30)
Global $hInv = _GDIPlus_RectFCreate(2, 100, 120, 15)

Global $hPosX1 = _GDIPlus_RectFCreate(2, 40, 120, 15)
Global $hPosY1 = _GDIPlus_RectFCreate(2, 60, 120, 15)

Global $hPosX2 = _GDIPlus_RectFCreate(2, 120, 120, 15)
Global $hPosY2 = _GDIPlus_RectFCreate(2, 140, 120, 15)

Global $hStringFormat = _GDIPlus_StringFormatCreate()

Global $start = TimerInit()

While Sleep(10)
	$hMsg = GUIGetMsg()

	$hCursor = GUIGetCursorInfo()
	If IsArray($hCursor) Then
		$mouse[0] = $hCursor[0] - $limites[0]
		$mouse[1] = $hCursor[1] - $limites[1]
	EndIf

	If WinActive($hGui) Then
		If Not $active Then $active = True
		If TimerDiff($start) >= 10 Then
			Update()
			$start = TimerInit()
		EndIf
	ElseIf Not WinActive($hGui) And $active Then
		$active = False
	EndIf
WEnd

Func Update()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	If $bCartesiano Then
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "x[" & $mouse[0] & "]", $hFont, $hPosX, $hStringFormat, $hBrush_01)
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "y[" & $mouse[1] & "]", $hFont, $hPosY, $hStringFormat, $hBrush_01)
	EndIf
	If $bOrigem Then
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "x[" & $mouse[0] - 389 & "]", $hFont, $hPosX1, $hStringFormat, $hBrush_02)
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "y[" & - ($mouse[1] - 270) & "]", $hFont, $hPosY1, $hStringFormat, $hBrush_02)
	EndIf

	Local $ang = Angulo(0, 0, $mouse[0] - 389, -($mouse[1] - 270))
	_GDIPlus_GraphicsDrawStringEx($hBackbuffer, StringFormat("%.2f", $ang[0]) & "º", $hFont2, $hAng, $hStringFormat, $hBrush_03)

	_box($hBackbuffer, 0, 0, $largura - 21, $altura - 61)
	_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 21) / 2, 0, ($largura - 21) / 2, $altura - 60, $hPen1)

	_GDIPlus_GraphicsDrawLine($hBackbuffer, 0, ($altura - 60) / 2, $largura - 21, ($altura - 60) / 2, $hPen1)
	_GDIPlus_GraphicsDrawEllipse($hBackbuffer, ($largura - 20) / 2 - $RAIO - 1, ($altura - 60) / 2 - $RAIO, $RAIO * 2, $RAIO * 2)
;~ 	_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 21) / 2, ($altura - 60) / 2, $mouse[0], $mouse[1], $hPen2)
	Local $cos = Int($RAIO * Cos(($ang[0] / 180) * $PI))
	Local $sen = Int($RAIO * Sin(($ang[0] / 180) * $PI))
	Local $tan = Int($RAIO * ($sen / $cos))
	Local $cot = Int($RAIO * ($cos / $sen))
	Local $sec = Int($RAIO * (1 / (Cos(($ang[0] / 180) * $PI))))
	Local $cosec = Int($RAIO * (1 / (Sin(($ang[0] / 180) * $PI))))

	If $bDxDy Then
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "Dx[" & StringFormat("%.2f", Cos(($ang[0] / 180) * $PI) * $RAIO) & "]", $hFont, $hPosX2, $hStringFormat, $hBrush_02)
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "Dy[" & StringFormat("%.2f", Sin(($ang[0] / 180) * $PI) * $RAIO) & "]", $hFont, $hPosY2, $hStringFormat, $hBrush_02)
	EndIf

	_GDIPlus_GraphicsDrawPie($hBackbuffer, ($largura - 20) / 2 - 1 - 25, ($altura - 60) / 2 - 25, 50, 50, 0, -$ang[0])

	If $iSeno Then
		_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, ($altura - 60) / 2, 389, 270 - $sen, $hPen2)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, 389, 270 - $sen, $hPen1)
	EndIf

	If $iCos Then
		_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, ($altura - 60) / 2, 389 + $cos, 270, $hPen2)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, 389 + $cos, 270, $hPen1)
	EndIf

	If $iTan Then
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 - $RAIO, 1, 389 - $RAIO, 538, $hPen1)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, $RAIO + 389, 1, $RAIO + 389, 538, $hPen1)
		If $cos > 0 Then
			_GDIPlus_GraphicsDrawLine($hBackbuffer, $RAIO + 389, 270 - $tan, $RAIO + 389, 270, $hPen2)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, $RAIO + 389, 270 - $tan, $hPen1)
		Else
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 - $RAIO, 270 + $tan, 389 - $RAIO, 270, $hPen2)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, 389 - $RAIO, 270 + $tan, $hPen1)
		EndIf
	EndIf

	If $iCot Then
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 1, 270 - $RAIO, 778, 270 - $RAIO, $hPen1)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 1, 270 + $RAIO, 778, 270 + $RAIO, $hPen1)
		If $sen > 0 Then
			_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, 270 - $RAIO, ($largura - 20) / 2 - 1 + $cot, 270 - $RAIO, $hPen2)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, ($largura - 20) / 2 - 1 + $cot, 270 - $RAIO, $hPen1)
		Else
			_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, 270 + $RAIO, ($largura - 20) / 2 - 1 - $cot, 270 + $RAIO, $hPen2)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $cos, 270 - $sen, ($largura - 20) / 2 - 1 - $cot, 270 + $RAIO, $hPen1)
		EndIf
	EndIf

	If $iSec Then
		Local $resposta = ""
		Select
			Case $ang[0] == 0 Or $ang[0] = 360
				$resposta = "#1 secante[não existe]"
			Case $ang[0] > 0 And $ang[0] < 90
				$resposta = "#2 secante[" & $ang[0] & "] angulo[" & 90 + $ang[0] & "]"
			Case $ang[0] == 90 Or $ang[0] == 180
				$resposta = "#3 secante[não existe]"
			Case $ang[0] > 90 And $ang[0] < 180
				$resposta = "#4 secante[" & $ang[0] & "] angulo[" & $ang[0] - 90 & "]"
			Case $ang[0] > 180 And $ang[0] < 270
				$resposta = "#5 secante[" & $ang[0] & "]"
			Case $ang[0] > 270 And $ang[0] < 360
				$resposta = "#6 secante[" & $ang[0] & "]"
		EndSelect

		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $sec, 270, 389, 270, $hPen2)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $sec, 270, 389, 270 - $cosec, $hPen4)
	EndIf

	If $iCoSec Then
		Local $resposta = ""
		Select
			Case $ang[0] == 0 Or $ang[0] = 360
				$resposta = "#1 secante[não existe]"
			Case $ang[0] > 0 And $ang[0] < 90
				$resposta = "#2 secante[" & $ang[0] & "] angulo[" & 90 + $ang[0] & "]"
			Case $ang[0] == 90 Or $ang[0] == 180
				$resposta = "#3 secante[não existe]"
			Case $ang[0] > 90 And $ang[0] < 180
				$resposta = "#4 secante[" & $ang[0] & "] angulo[" & $ang[0] - 90 & "]"
			Case $ang[0] > 180 And $ang[0] < 270
				$resposta = "#5 secante[" & $ang[0] & "]"
			Case $ang[0] > 270 And $ang[0] < 360
				$resposta = "#6 secante[" & $ang[0] & "]"
		EndSelect

		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389 + $sec, 270, 389, 270 - $cosec, $hPen4)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, 389, 270, 389, 270 - $cosec, $hPen2)
	EndIf

	If $iInverso Then
		Local $invertido = $ang[0] > 180 ? $ang[0] - 180 : 180 + $ang[0]
		$invertido = $invertido = 360 ? 0 : $invertido
		$invertido = StringFormat("%.2f", $invertido)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, ($altura - 60) / 2, 389 - $cos, 270 + $sen, $hPen5)
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "º[" & $invertido & "]", $hFont, $hInv, $hStringFormat, $hBrush_04)
	EndIf
	_GDIPlus_GraphicsDrawLine($hBackbuffer, ($largura - 20) / 2 - 1, ($altura - 60) / 2, 389 + $cos, 270 - $sen, $hPen3)

	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 10, 50, $largura - 20, $altura - 60)
EndFunc   ;==>Update

Func Quit()

	_GDIPlus_BrushDispose($hBrush_01)
	_GDIPlus_BrushDispose($hBrush_02)
	_GDIPlus_BrushDispose($hBrush_03)
	_GDIPlus_BrushDispose($hBrush_04)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontDispose($hFont2)
	_GDIPlus_StringFormatDispose($hStringFormat)

	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_PenDispose($hPen1)
	_GDIPlus_PenDispose($hPen2)
	_GDIPlus_PenDispose($hPen3)
	_GDIPlus_PenDispose($hPen4)
	_GDIPlus_PenDispose($hPen5)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>Quit

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

Func Angulo($xx1, $yy1, $xx2, $yy2)
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
	$arr[0] = StringFormat("%.2f", $arr[0])
	$arr[1] = Sqrt($co ^ 2 + $ca ^ 2)
	Return $arr
EndFunc   ;==>Angulo

Func Show_Origem()
	$bOrigem = Not $bOrigem
EndFunc   ;==>Show_Origem

Func Show_Cartesiano()
	$bCartesiano = Not $bCartesiano
EndFunc   ;==>Show_Cartesiano

Func Show_Inverso()
	$iInverso = Not $iInverso
EndFunc   ;==>Show_Inverso

Func Show_Seno()
	$iSeno = Not $iSeno
EndFunc   ;==>Show_Seno

Func Show_Cos()
	$iCos = Not $iCos
EndFunc   ;==>Show_Cos

Func Show_Tan()
	$iTan = Not $iTan
EndFunc   ;==>Show_Tan

Func Show_Cot()
	$iCot = Not $iCot
EndFunc   ;==>Show_Cot

Func Show_Sec()
	$iSec = Not $iSec
EndFunc   ;==>Show_Sec

Func Show_Cosec()
	$iCoSec = Not $iCoSec
EndFunc   ;==>Show_Cosec

Func Show_DxDy()
	$bDxDy = Not $bDxDy
EndFunc   ;==>Show_DxDy

Func _limites()
	$limites[0] = 10
	$limites[1] = 50
	$limites[2] = $largura - 20
	$limites[3] = $altura - 50
	$limites[4] = ($largura - 20) / 2
	$limites[5] = ($altura - 50) / 2
	;_ArrayDisplay($limites)
EndFunc   ;==>_limites

Func WM_COMMAND($hWnd, $imsg, $iwParam, $ilParam)
	Local $setHK = False
	Local $nNotifyCode = BitShift($iwParam, 16)
;~     Local $nID = BitAND($iwParam, 0x0000FFFF)
;~     Local $hCtrl = $ilParam

	If $nNotifyCode = $EN_CHANGE Then
		If $ilParam = $hInputRaio Then
			$RAIO = GUICtrlRead($iInputRaio)
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND
