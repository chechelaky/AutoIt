#include-once
#include <Array.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <Math.au3>
#include <MyMath.au3>

#include <WindowsConstants.au3>
#include <GUIConstants.au3>

;~ #include <APIMiscConstants.au3>
#include <WinAPIMisc.au3>

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

OnAutoItExitRegister("_on_exit")

Global $hGui
Global $hGraphic, $hPen, $hBitmap, $hBackbuffer
Global $g_iMouseX, $g_iMouseY, $iAngle = 0

Global $aBoard[10] = [10, 10, 800, 600]
$aBoard[4] = $aBoard[0]
$aBoard[5] = $aBoard[1]
$aBoard[6] = $aBoard[0] + $aBoard[2]
$aBoard[7] = $aBoard[1] + $aBoard[3]
$aBoard[8] = $aBoard[2] / 2
$aBoard[9] = $aBoard[3] / 2

Global $iUpdate = 15

$hGui = GUICreate("Titulo", 820, 620)
GUISetOnEvent($GUI_EVENT_CLOSE, "_quit")


_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($aBoard[2], $aBoard[3], $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

$hPen = _GDIPlus_PenCreate()
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

GUISetState(@SW_SHOW, $hGui)

GUIRegisterMsg($WM_MOUSEMOVE, "WM_MOUSEMOVE")

AdlibRegister("_update", $iUpdate)

While Sleep(10)

WEnd

Func _update()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xF0FFFFFF)
	_box($hBackbuffer, 0, 0, 10, 10)
	_GDIPlus_GraphicsDrawLine($hBackbuffer, $aBoard[8], $aBoard[9], $g_iMouseX, $g_iMouseY, $hPen)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, $aBoard[0], $aBoard[1], $aBoard[2], $aBoard[3])
EndFunc   ;==>_update

Func _on_exit()
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
EndFunc   ;==>_on_exit

Func _quit()
	Exit
EndFunc   ;==>_quit

Func _box($hToGraphic, $xx, $yy, $ll, $aa, $color = 0xFF000000)
	Local $aBox[5][2]
	$aBox[0][0] = 4
	$aBox[1][0] = $xx
	$aBox[1][1] = $yy
	$aBox[2][0] = $xx + $ll - 1
	$aBox[2][1] = $yy
	$aBox[3][0] = $xx + $ll - 1
	$aBox[3][1] = $yy + $aa - 1
	$aBox[4][0] = $xx
	$aBox[4][1] = $yy + $aa - 1
	If $color Then
		_GDIPlus_PenSetColor($hPen, $color)
		_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox, $hPen)
	Else
		_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)
	EndIf
EndFunc   ;==>_box


Func calcula()
	Local $iDistancia = __GetDistance($aBoard[8], $aBoard[9], $g_iMouseX, $g_iMouseY)
	ConsoleWrite("$iDistancia[ " & $iDistancia & " ]" & @LF)
	Local $iAngulo = __GetAngle($aBoard[8], $aBoard[9], $g_iMouseX, $g_iMouseY)
	ConsoleWrite("$iAngulo[ " & _Degree($iAngulo) & " ]" & @LF)
EndFunc   ;==>calcula

Func WM_MOUSEMOVE($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg
	Switch BitAND($wParam, 0x0000FFFF)
		Case 0
			$g_iMouseX = BitAND($lParam, 0x0000FFFF)
			$g_iMouseY = BitShift($lParam, 16)
			calcula()
		Case 1
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOUSEMOVE
