;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>

#include <ScreenCapture.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
;~ #include <SQLite.au3>
#include <APIMiscConstants.au3>
#include <WinAPIMisc.au3>

Global $hGraphic, $hPen, $hBitmap, $hBackbuffer, $width = 800, $height = 600

OnAutoItExitRegister("OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global Const $PI = 3.1415926535897932384626433832795
Global Const $radToDeg = 180 / $PI
Global $g_iMouseX, $g_iMouseY
Global $aGuiSize[2] = [820, 620]
Global $sGuiTitle = "GuiTitle"
Global $hGui, $hCursor
Global $aActor[8] = [400, 300, 32, 3]
$aActor[4] = $aActor[2] / 2
$aActor[0] = $aActor[0] - $aActor[4]
$aActor[1] = $aActor[1] - $aActor[4]

Global $aPontos[5][2] = [ _
		[4], _
		[20, 20], _
		[440, 20], _
		[440, 320], _
		[20, 320] _
		]

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")

_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

$hPen = _GDIPlus_PenCreate()
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

GUISetState(@SW_SHOW, $hGui)
GUIRegisterMsg($WM_MOUSEMOVE, "WM_MOUSEMOVE")
AdlibRegister("Update", 13)



While Sleep(25)
WEnd

Func Update()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xF0FFFFFF)
	Local $iAngulo = Angulo($g_iMouseX, $g_iMouseY, $aActor[0], $aActor[1])
;~ 	ConsoleWrite($g_iMouseX & ", " & $g_iMouseY & " / " & $iAngulo[0] & ", " & $iAngulo[1] & "#" & $aActor[4] & @LF)
	If $iAngulo[1] > 2 Then
		$aActor[0] -= $aActor[3] * Cos($iAngulo[0] / $radToDeg)
		$aActor[1] -= $aActor[3] * Sin($iAngulo[0] / $radToDeg)
	Else
	EndIf
	_box($hBackbuffer, $aActor[0] - 24, $aActor[1] - 24, $aActor[2], $aActor[2])
;~ 	_GDIPlus_GraphicsDrawLine($hBackbuffer, 10, 150, 390, 150, $hPen)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 10, 10, $width, $height)
EndFunc   ;==>Update

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
;~ 					$arr[0] = 270 - ATan(($co) / ($ca)) * $radToDeg
			EndSelect
	EndSelect
	$arr[0] = StringFormat('%.2f', $arr[0])
	$arr[1] = Sqrt($co ^ 2 + $ca ^ 2)
	Return $arr
EndFunc   ;==>Angulo

Func OnExit()
	AdlibUnRegister("Update")
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	Exit
EndFunc   ;==>Quit
