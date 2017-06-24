#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)

$hGui = GUICreate('MyGUI', 800, 600, -1, -1)
GUISetState()


_GDIPlus_Startup()
Global $hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\img1.png")

$iWidth = _GDIPlus_ImageGetWidth($hImage)
$iHeight = _GDIPlus_ImageGetHeight($hImage)

Global $diagonal = _diagonal($iWidth, $iHeight)
ConsoleWrite("$iWidth[" & $iWidth & "] $iHeight[" & $iHeight & "] $diagonal[" & $diagonal & "]" & @LF)

$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($diagonal, $diagonal, $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

$hMatrix = _GDIPlus_MatrixCreate()

_GDIPlus_MatrixTranslate($hMatrix, $diagonal / 2, $diagonal / 2)

GUISetOnEvent(-3, "_Exit")

Do
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)

	_GDIPlus_MatrixRotate($hMatrix, 2)
	_GDIPlus_GraphicsSetTransform($hBackbuffer, $hMatrix)

	_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, $hImage, 0, 0, $iWidth, $iHeight, -$iWidth / 2, -$iHeight / 2, $iWidth, $iHeight)
	_GDIPlus_GraphicsDrawImage($hGraphic, $hBitmap, 10, 10)
Until Not Sleep(13)

Func _Exit()
	_GDIPlus_MatrixDispose($hMatrix)
	_GDIPlus_ImageDispose($hImage)
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
