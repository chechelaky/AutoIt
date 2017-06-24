#include-once
#include <Array.au3>
#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>


Opt("GUIOnEventMode", 1)

Global $aGui[10] = [800, 600]
Global $hGraphic, $hBitmap, $hBackbuffer, $hMatrix

$hGui = GUICreate("Rotate", $aGui[0], $aGui[1], -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState()

Global $g_iMouseX, $g_iMouseY, $iAngle = 0
Global Const $PI = 3.14159265359
Global $aPos[20] = [150, 50]
Global $a_hImage[1], $a_aiDim[1]

_GDIPlus_Startup()

$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($aGui[0], $aGui[1], $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

GUIRegisterMsg($WM_MOUSEMOVE, "WM_MOUSEMOVE")

;~ Global $sFile = FileOpenDialog("choose image", @ScriptDir, "Images (*.jpg;*.png;*.bmp)", $FD_FILEMUSTEXIST)

Global $img1 = Image_Create("vermelho.png", 100, 100)
Global $img2 = Image_Create("azul.png", 300, 100)
Global $img3 = Image_Create("amarelo.png", 500, 100)
Global $img4 = Image_Create("verde.png", 100, 300)
Global $img5 = Image_Create("preto.png", 300, 300)
Global $img6 = Image_Create("vermelho2.png", 500, 300)

Func Image_Create($sName, $xx = 0, $yy = 0)
	Local $id = _ArrayAdd($a_hImage, _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\" & $sName))
	Local $a_iDim[13]
	$a_iDim[0] = _GDIPlus_ImageGetWidth($a_hImage[$id])
	$a_iDim[1] = _GDIPlus_ImageGetHeight($a_hImage[$id])
	$a_iDim[2] = _diagonal($a_iDim[0], $a_iDim[1])
	$a_iDim[3] = $a_iDim[2] / 2
	$a_iDim[4] = $xx
	$a_iDim[5] = $yy
	$a_iDim[6] = $a_iDim[0] / 2
	$a_iDim[7] = $a_iDim[1] / 2
	$a_iDim[8] = $xx - $a_iDim[3]
	$a_iDim[9] = $yy - $a_iDim[3]
	$a_iDim[10] = _GDIPlus_BitmapCreateFromScan0($a_iDim[2], $a_iDim[2])
	$a_iDim[11] = _GDIPlus_ImageGetGraphicsContext($a_iDim[10])
	$a_iDim[12] = _GDIPlus_MatrixCreate()
	_GDIPlus_MatrixTranslate($a_iDim[12], $a_iDim[3], $a_iDim[3])

	_ArrayAdd($a_aiDim, $a_iDim, 0, "|", @CRLF, 1)
	$a_hImage[0] = UBound($a_hImage, 1) - 1
	Return $id
EndFunc   ;==>Image_Create

Func Image_Show()
	For $ii = 1 To $a_hImage[0]
		$iAngle = Radian2Degree(atan2($g_iMouseX - ($a_aiDim[$ii])[4], $g_iMouseY - ($a_aiDim[$ii])[5])) + 90
		_GDIPlus_GraphicsClear(($a_aiDim[$ii])[11], 0x00FFFFFF)

		_GDIPlus_MatrixRotate(($a_aiDim[$ii])[12], $iAngle)
		_GDIPlus_GraphicsSetTransform(($a_aiDim[$ii])[11], ($a_aiDim[$ii])[12])
		_GDIPlus_MatrixRotate(($a_aiDim[$ii])[12], -$iAngle)

		_GDIPlus_GraphicsDrawImageRectRect(($a_aiDim[$ii])[11], $a_hImage[$ii], 0, 0, ($a_aiDim[$ii])[0], ($a_aiDim[$ii])[1], -($a_aiDim[$ii])[6], -($a_aiDim[$ii])[7], ($a_aiDim[$ii])[0], ($a_aiDim[$ii])[1])

		_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, ($a_aiDim[$ii])[10], 0, 0, ($a_aiDim[$ii])[2], ($a_aiDim[$ii])[2], ($a_aiDim[$ii])[8], ($a_aiDim[$ii])[9], ($a_aiDim[$ii])[2], ($a_aiDim[$ii])[2])
	Next
	For $ii = 1 To $a_hImage[0]
;~ 		_GDIPlus_GraphicsDrawArc($hBackbuffer, ($a_aiDim[$ii])[8], ($a_aiDim[$ii])[9], ($a_aiDim[$ii])[2], ($a_aiDim[$ii])[2], 180, 360)
	Next
	For $ii = 1 To $a_hImage[0]
;~ 		_GDIPlus_GraphicsDrawLine($hBackbuffer, ($a_aiDim[$ii])[4], ($a_aiDim[$ii])[5], $g_iMouseX, $g_iMouseY)
	Next
EndFunc   ;==>Image_Show

Do
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	Image_Show()
	_GDIPlus_GraphicsDrawImage($hGraphic, $hBitmap, 0, 0)
Until Not Sleep(10)

Func _Exit()
	For $ii = 1 To UBound($a_hImage, 1) - 1
		_GDIPlus_ImageDispose($a_hImage[$ii])
		_GDIPlus_BitmapDispose(($a_aiDim[$ii])[10])
		_GDIPlus_MatrixDispose(($a_aiDim[$ii])[12])
		_GDIPlus_GraphicsDispose(($a_aiDim[$ii])[11])
	Next

	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()
	GUIDelete()
	Exit
EndFunc   ;==>_Exit

Func _diagonal($aa, $bb)
	Return Sqrt($aa ^ 2 + $bb ^ 2)
EndFunc   ;==>_diagonal

Func Radian2Degree($iRadian)
	Return 180 * $iRadian / ACos(-1)
EndFunc   ;==>Radian2Degree

Func atan2($x, $y)
	Local $absx = 0, $absy = 0, $val = 0
	Local $PI_2 = $PI / 2
	If ($x = 0 And $y = 0) Then Return 0
	$absy = Abs($y)
	$absx = Abs($x)
	If ($absy - $absx = $absy) Then
		If $y < 0 Then Return -$PI_2
		Return $PI_2
	EndIf
	If ($absx - $absy = $absx) Then
		$val = 0
	Else
		$val = ATan($y / $x)
	EndIf
	If ($x > 0) Then Return $val
	If ($y < 0) Then Return $val - $PI
	Return $val + $PI
EndFunc   ;==>atan2

Func WM_MOUSEMOVE($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg
	Switch BitAND($wParam, 0x0000FFFF)
		Case 0
			$g_iMouseX = BitAND($lParam, 0x0000FFFF)
			$g_iMouseY = BitShift($lParam, 16)
		Case 1
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOUSEMOVE
