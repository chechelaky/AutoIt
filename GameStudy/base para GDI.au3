#include <Array.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

Opt('GUICloseOnESC', 1)
Opt('GUIOnEventMode', 1)
Opt('GUIEventOptions', 1)
Opt('ExpandVarStrings', 1)
Opt('MustDeclareVars', 1)
Opt('WinWaitDelay', 1)

Global $sGuiTitle = 'Título', $hGui, $hMsg, $active = True
Global $hGuiSize[2] = [800, 600]
Global $hGraphic, $hPen, $hBitmap, $hBackbuffer
Global $hGraphicSize[2] = [480, 360]

$hGui = GUICreate($sGuiTitle, $hGuiSize[0], $hGuiSize[1])
GUISetState(@SW_SHOWNORMAL)

_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($hGraphicSize[0], $hGraphicSize[1], $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

$hPen = _GDIPlus_PenCreate()
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

GUISetOnEvent($GUI_EVENT_CLOSE, '_specialEvents')
GUISetOnEvent($GUI_EVENT_MAXIMIZE, '_specialEvents')
GUISetOnEvent($GUI_EVENT_MINIMIZE, '_specialEvents')
;~ GUICtrlSetOnEvent($hSave, '_save')

_update()
While 1

	If WinActive($hGui) And Not $active Then
		$active = True
		_update()
	ElseIf Not WinActive($hGui) And $active Then
		$active = False
	EndIf
WEnd

Func _update()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xF0FFFFFF)
	_box($hBackbuffer, 0, 0, 10, 10)
	_GDIPlus_GraphicsDrawLine($hBackbuffer, 10, 150, 390, 150, $hPen)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $hGraphicSize[0], $hGraphicSize[1])
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