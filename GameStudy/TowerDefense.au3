;~ http://soundbible.com/tags-ping.html

; #INDEX# =======================================================================================================================
; Title .........: ALL2D
; AutoIt Version : 3.3.12.0
; Description ...: Gera um mapa em GDI a partir de um arquivo JSON criado pelo 'Tile Map Editor'
;                  Generate a GDI map from a JSON file created by 'Tile Map Editor'
; Author(s) .....: Luismar Chechelaky

; https://github.com/chechelaky/AutoIt/tree/master/GameStudy

; https://youtu.be/qo8Xt80bpXk

; use Tiled Map Editor to build a map
; http://www.mapeditor.org/

; ===============================================================================================================================

#include-once
#include <Array.au3>
#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <APIMiscConstants.au3>
#include <WinAPIMisc.au3>
#include <JSMN.au3>
#include <object_dump.au3>
#include <Sound\Bass.au3>
#include <Sound\BassConstants.au3>

OnAutoItExitRegister("OnExit")

_BASS_STARTUP(@ScriptDir & "\sound\bass.dll")
_BASS_Init(0, -1, 44100, 0, "")

Global Const $tagSound = "Struct;ptr handle;EndStruct"
Global Const $tagWeapon = "Struct;int image_id;int xx;int yy;int speed;int range;int delay;int sound;EndStruct"
Global Const $tagImage = "Struct;ptr handle;int width;int height;EndStruct"

Global $iAngle = 0
Global Const $PI = 3.14159265359
Global Const $PI2 = $PI / 2
Global $fDegToRad = $PI / 180
Global Const $DegToRad = $PI / 180
Global Const $rad90 = $PI / 2
Global Const $rad270 = 3 * $PI / 2

Global $aTemp

Global $oShot = ObjCreate($SD), $aDel[1] = [0], $aDel2[1] = [0], $iShot = 0
Global $oUnity = ObjCreate($SD), $iUnit = 0
Global $oImage = ObjCreate($SD)

Global $aSound[1]
Global $aWeapon[1]



Opt("GUIOnEventMode", 1)

Global Enum $WIDT1 = 0, $HEIG1, $DIAG1, $DIAG2, $POSX1, $POSY1, $WIDT2, $HEIG2, $POSX2, $POSY2, $SCAN0, $GRCTX, $MTRIX, $POSX3, $POSY3, $SPEED, $RANG1, $RANG2, $DELAY, $MMENT, $SOUND
Global $aGui[10] = [800, 600]
Global $hGraphic, $hBitmap, $hBackbuffer, $hMatrix
Global $Z_RUN[3] = [TimerInit(), TimerInit(), 0]

Global $aActor[8] = [400, 300, 32, 0.6]
$aActor[4] = $aActor[2] / 2
$aActor[0] = $aActor[0] - $aActor[4]
$aActor[1] = $aActor[1] - $aActor[4]
$aActor[5] = GradToRad(6)
$aActor[6] = 0
$aActor[7] = GradToRad(3)

$hGui = GUICreate("Rotate", $aGui[0], $aGui[1], -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState()

Global $aPos[20] = [150, 50]
Global $a_hImage[1], $a_aiDim[1]

_GDIPlus_Startup()

$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($aGui[0], $aGui[1], $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

Global $hShot = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\shot.png")

Global $tSound1 = Add_Sound(@ScriptDir & "\sound\shot00.wav")
Global $tSound2 = Add_Sound(@ScriptDir & "\sound\shot01.wav")
Global $tSound3 = Add_Sound(@ScriptDir & "\sound\shot02.wav")
Global $tSound4 = Add_Sound(@ScriptDir & "\sound\impacto.wav")
ConsoleWrite("$tSound4[" & $tSound4 & "]" & @LF)

Global $img1 = Image_Create("vermelho.png", 100, 100, 4, 300, 800, 1)
Global $img2 = Image_Create("azul.png", 300, 100, 5.5, 300, 850, 2)
Global $img3 = Image_Create("amarelo.png", 500, 100, 6, 330, 600, 3)
Global $img4 = Image_Create("verde.png", 100, 300, 7, 250, 700, 3)
Global $img5 = Image_Create("vermelho2.png", 300, 300, 8, 300, 1000, 2)
Global $img6 = Image_Create("preto.png", 500, 300, 9, 400, 500, 1)
Global $img7 = Image_Create("azul.png", 300, 500, 30, 550, 600, 2)

Add_Unit(0, 200, 800, 200, 1, 1, 500, Image_Add("exemplo.png"))
;~ Add_Unit(200, 0, 150, 800, 4, 1, 700, Image_Add("carro_azul.png"))
;~ Add_Unit(250, 0, 100, 800, 8, 2, 900, Image_Add("carro_preto.png"))

Global $aPontos = MAPA("mapa4.json")
$oUnity.Item(1).Item("x") = $aPontos[1][0]
$oUnity.Item(1).Item("y") = $aPontos[1][1]

Func MAPA($sFile)
	Local $oMap = json_load($sFile)
	Local $OBJ = $oMap.Item("layers")[0]
	Local $xx = ($OBJ.Item("objects"))[0].Item("x")
	Local $yy = ($OBJ.Item("objects"))[0].Item("y")
	Local $aPolyline = ($OBJ.Item("objects"))[0].Item("polyline")
	Local $arr[1][2] = [[UBound($aPolyline, 1) - 1, 2]]
	For $ii = 0 To $arr[0][0]
		_ArrayAdd2D($arr, $xx + ($aPolyline[$ii]).Item("x"), $yy + ($aPolyline[$ii]).Item("y"))
	Next
	Return $arr
EndFunc   ;==>MAPA

Func Image_Add($sName)
	Local $ds = DllStructCreate($tagImage)
	$ds.handle = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\" & $sName)
	$ds.width = _GDIPlus_ImageGetWidth($ds.handle)
	$ds.height = _GDIPlus_ImageGetHeight($ds.handle)
	Local $id = _ArrayAdd($aWeapon, $ds)

	Local $hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\" & $sName)
	$oImage.Add($oImage.Count + 1, $hImage)
	Return $oImage.Count
EndFunc   ;==>Image_Add

Func Add_Unit($x1, $y1, $x2, $y2, $iSpeed, $iFOE, $iHP, $hImage)
	$iUnit += 1
	Local $oo = ObjCreate($SD)
	$oo.Add("x", $x1)
	$oo.Add("y", $y1)
	$oo.Add("s", $iSpeed)
	$oo.Add("f", $iFOE)
	$oo.Add("h", $iHP)
	$oo.Add("i", $hImage)
	$oUnity.Add($iUnit, $oo)
	Return $iUnit
EndFunc   ;==>Add_Unit

Func Add_Sound($sFile)
	Local $ds = DllStructCreate($tagSound)
	$ds.handle = _BASS_StreamCreateFile(False, $sFile, 0, 0, 0)
	Local $id = _ArrayAdd($aSound, $ds)
	$aSound[0] = UBound($aSound, 1) - 1
	Return $id
EndFunc   ;==>Add_Sound

Func Image_Create($sName, $xx = 0, $yy = 0, $iSpeed = 4, $iRange = 50, $iDelay = 100, $tSound = 0)
	Local $ds = DllStructCreate($tagWeapon)
	Local $id = _ArrayAdd($a_hImage, _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\" & $sName))
	Local $arr[22]

	$arr[$WIDT1] = _GDIPlus_ImageGetWidth($a_hImage[$id])
	$arr[$HEIG1] = _GDIPlus_ImageGetHeight($a_hImage[$id])
	$arr[$DIAG1] = _diagonal($arr[0], $arr[1])
	$arr[$DIAG2] = $arr[$DIAG1] / 2
	$arr[$POSX1] = $xx
	$arr[$POSY1] = $yy
	$arr[$WIDT2] = $arr[$WIDT1] / 2
	$arr[$HEIG2] = $arr[$HEIG1] / 2
	$arr[$POSX2] = $xx - $arr[$DIAG2]
	$arr[$POSY2] = $yy - $arr[$DIAG2]
	$arr[$SCAN0] = _GDIPlus_BitmapCreateFromScan0($arr[$DIAG1], $arr[$DIAG1])
	$arr[$GRCTX] = _GDIPlus_ImageGetGraphicsContext($arr[$SCAN0])
	$arr[$MTRIX] = _GDIPlus_MatrixCreate()
	$arr[$POSX3] = $xx - $iRange / 2
	$arr[$POSY3] = $yy - $iRange / 2

	$arr[$SPEED] = $iSpeed
	$arr[$RANG1] = $iRange
	$arr[$RANG2] = $iRange / 2
	$arr[$DELAY] = $iDelay
	$arr[$MMENT] = 0
	$arr[$SOUND] = $tSound
	_GDIPlus_MatrixTranslate($arr[$MTRIX], $arr[$DIAG2], $arr[$DIAG2])

	_ArrayAdd($a_aiDim, $arr, 0, "|", @CRLF, 1)
	$a_hImage[0] = UBound($a_hImage, 1) - 1

	Local $id = _ArrayAdd($aWeapon, $ds)
	$aWeapon[0] = UBound($aWeapon, 1) - 1

	Return $id
EndFunc   ;==>Image_Create

Func Image_Show()
	For $ii = 1 To $a_hImage[0]
		$iAngle = Radian2Degree(atan2($oUnity.Item(1).Item("x") - ($a_aiDim[$ii])[$POSX1], $oUnity.Item(1).Item("y") - ($a_aiDim[$ii])[$POSY1])) + 90
		_GDIPlus_GraphicsClear(($a_aiDim[$ii])[$GRCTX], 0xFFFFFFFF)

		_GDIPlus_MatrixRotate(($a_aiDim[$ii])[$MTRIX], $iAngle)
		_GDIPlus_GraphicsSetTransform(($a_aiDim[$ii])[$GRCTX], ($a_aiDim[$ii])[$MTRIX])
		_GDIPlus_MatrixRotate(($a_aiDim[$ii])[$MTRIX], -$iAngle)

		_GDIPlus_GraphicsDrawImageRectRect(($a_aiDim[$ii])[$GRCTX], $a_hImage[$ii], 0, 0, ($a_aiDim[$ii])[$WIDT1], ($a_aiDim[$ii])[$HEIG1], -($a_aiDim[$ii])[$WIDT2], -($a_aiDim[$ii])[$HEIG2], ($a_aiDim[$ii])[$WIDT1], ($a_aiDim[$ii])[$HEIG1])

		_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, ($a_aiDim[$ii])[$SCAN0], 0, 0, ($a_aiDim[$ii])[$DIAG1], ($a_aiDim[$ii])[$DIAG1], ($a_aiDim[$ii])[$POSX2], ($a_aiDim[$ii])[$POSY2], ($a_aiDim[$ii])[$DIAG1], ($a_aiDim[$ii])[$DIAG1])

		If Sqrt((($a_aiDim[$ii])[$POSX1] - $oUnity.Item(1).Item("x")) ^ 2 + (($a_aiDim[$ii])[$POSY1] - $oUnity.Item(1).Item("y")) ^ 2) <= ($a_aiDim[$ii])[$RANG2] Then
			_GDIPlus_GraphicsDrawArc($hBackbuffer, ($a_aiDim[$ii])[$POSX3], ($a_aiDim[$ii])[$POSY3], ($a_aiDim[$ii])[$RANG1], ($a_aiDim[$ii])[$RANG1], 0, 360)
			If TimerDiff((($a_aiDim[$ii])[$MMENT])) > ($a_aiDim[$ii])[$DELAY] Then
				$aTemp = $a_aiDim[$ii]
				$aTemp[$MMENT] = TimerInit()
				$a_aiDim[$ii] = $aTemp
				Add_Shot(($a_aiDim[$ii])[$POSX1], ($a_aiDim[$ii])[$POSY1], ($a_aiDim[$ii])[$DIAG2], ($a_aiDim[$ii])[$SPEED], $iAngle - 90, ($a_aiDim[$ii])[$SOUND])
			EndIf
		EndIf
	Next
EndFunc   ;==>Image_Show

Func Add_Shot($xx, $yy, $iRaio, $iSpeed, $iAngle, $iSound)
	$iShot += 1
	Local $oo = ObjCreate($SD)
	$oo.Add("x", $xx)
	$oo.Add("y", $yy)
	$oo.Add("vx", $iSpeed * Cos($iAngle * $fDegToRad))
	$oo.Add("vy", $iSpeed * Sin($iAngle * $fDegToRad))
	$oo.Add("r", $iRaio)
	$oo.Add("s", $iSpeed)
	$oo.Add("a", $iAngle)
	$oShot.Add($iShot, $oo)
	_BASS_ChannelPlay($aSound[$iSound].handle, 1)
EndFunc   ;==>Add_Shot

Func AcertouAlvo($xx, $yy)
	Local $limite = 33
	If $xx >= $oUnity.Item(1).Item("x") And $xx <= ($oUnity.Item(1).Item("x") + $limite) And $yy >= $oUnity.Item(1).Item("y") And $yy <= ($oUnity.Item(1).Item("y") + $limite) Then
		_box($hBackbuffer, $oUnity.Item(1).Item("x"), $oUnity.Item(1).Item("y"), $limite + 1, $limite + 1)
		_BASS_ChannelPlay($aSound[4].handle, 1)
		Return True
	EndIf
	Return False
EndFunc   ;==>AcertouAlvo

Func Image_Shot()
	For $each In $oShot
		$oShot.Item($each).Item("x") += $oShot.Item($each).Item("vx")
		If $oShot.Item($each).Item("x") < -9 Or $oShot.Item($each).Item("x") > 809 Then
			_ArrayAdd($aDel, $each)
		Else
			$oShot.Item($each).Item("y") += $oShot.Item($each).Item("vy")

			If $oShot.Item($each).Item("y") < -9 Or $oShot.Item($each).Item("y") > 609 Or AcertouAlvo($oShot.Item($each).Item("x"), $oShot.Item($each).Item("y")) Then
				_ArrayAdd($aDel, $each)
			Else
				_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, $hShot, 0, 0, 9, 9, $oShot.Item($each).Item("x") - 4, $oShot.Item($each).Item("y") - 4, 9, 9)
			EndIf
		EndIf
	Next
	$aDel[0] = UBound($aDel, 1)
	If $aDel[0] Then
		For $ii = 1 To $aDel[0] - 1
			$oShot.Remove($aDel[$ii])
		Next
		$aDel = $aDel2
	EndIf
EndFunc   ;==>Image_Shot

Func Image_Unit()
	For $each In $oUnity
		$iAngulo = Angulo($oUnity.Item($each).Item("x"), $oUnity.Item($each).Item("y"), $aPontos[$aPontos[0][1]][0], $aPontos[$aPontos[0][1]][1])
		If $iAngulo[1] < 8 Then
			$aPontos[0][1] += 1
			If $aPontos[0][1] >= $aPontos[0][0] Then $aPontos[0][1] = 1
		EndIf
		$oUnity.Item($each).Item("x") += $oUnity.Item($each).Item("s") * Cos($iAngulo[3])
		$oUnity.Item($each).Item("y") += $oUnity.Item($each).Item("s") * Sin($iAngulo[3])
		_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, $oImage.Item($oUnity.Item($each).Item("i")), 0, 0, 33, 33, $oUnity.Item($each).Item("x"), $oUnity.Item($each).Item("y"), 33, 33)
	Next
EndFunc   ;==>Image_Unit

While Z_RUN()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	Image_Show()
	Image_Shot()
	Image_Unit()
	_GDIPlus_GraphicsDrawImage($hGraphic, $hBitmap, 0, 0)
WEnd

Func Z_RUN()
	$Z_RUN[2] += 1
	If TimerDiff($Z_RUN[1]) > 999 Then
		WinSetTitle($hGui, "", "FPS[" & $Z_RUN[2] & "]" & @LF)
		$Z_RUN[1] = TimerInit()
		$Z_RUN[2] = 0
	EndIf
	Return True
EndFunc   ;==>Z_RUN

Func _Exit()
	For $ii = 1 To UBound($a_hImage, 1) - 1
		_GDIPlus_ImageDispose($a_hImage[$ii])
		_GDIPlus_BitmapDispose(($a_aiDim[$ii])[$SCAN0])
		_GDIPlus_MatrixDispose(($a_aiDim[$ii])[$MTRIX])
		_GDIPlus_GraphicsDispose(($a_aiDim[$ii])[$GRCTX])
	Next
	For $each In $oImage
		_GDIPlus_ImageDispose($oImage.Item($each))
	Next
	_GDIPlus_ImageDispose($hShot)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()
	GUIDelete()
	Exit
EndFunc   ;==>_Exit

Func _diagonal($CO, $CA)
	Return Sqrt($CO ^ 2 + $CA ^ 2)
EndFunc   ;==>_diagonal

Func Radian2Degree($iRadian)
	Return 180 * $iRadian / ACos(-1)
EndFunc   ;==>Radian2Degree

Func atan2($xx, $yy)
	Local $absx = 0, $absy = 0, $val = 0
	If Not $xx And Not $yy Then Return 0
	$absy = Abs($yy)
	$absx = Abs($xx)
	If ($absy - $absx = $absy) Then
		If $yy < 0 Then Return -$PI2
		Return $PI2
	EndIf
	If ($absx - $absy = $absx) Then
		$val = 0
	Else
		$val = ATan($yy / $xx)
	EndIf
	If ($xx > 0) Then Return $val
	If ($yy < 0) Then Return $val - $PI
	Return $val + $PI
EndFunc   ;==>atan2

Func OnExit()
	_BASS_Free()
EndFunc   ;==>OnExit

Func _box($hToGraphic, $iXX, $iYY, $iWW, $iHH, $iColor = 0)
	; _box3
	If $iWW = 1 And $iHH = 1 Then
		If $iColor Then
;~ 			_GDIPlus_BrushSetSolidColor($hBrush, $iColor)
;~ 			_GDIPlus_GraphicsFillRect($hBackbuffer, $iXX, $iYY, $iWW, $iHH, $hBrush)
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
;~ 			_GDIPlus_PenSetColor($hPen, $iColor)
			_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)
		Else
			_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)
		EndIf
	EndIf
EndFunc   ;==>_box

Func Angulo($xx1, $yy1, $xx2, $yy2, $ang = 0)
	Local $arr[6], $CA = Abs($yy1 - $yy2), $CO = Abs($xx1 - $xx2)
	Select
		Case $xx1 > $xx2
			Select
				Case $yy1 < $yy2
					$arr[2] = 6
					$arr[0] = $rad270 - ATan(($CO) / ($CA))
					$arr[3] = ATan(($CO) / ($CA)) + $rad90
				Case $yy1 == $yy2
					$arr[2] = 5
					$arr[0] = $PI
					$arr[3] = $PI
				Case $yy1 > $yy2
					$arr[2] = 4
					$arr[0] = ATan(($CO) / ($CA)) + $rad90
					$arr[3] = $rad270 - ATan(($CO) / ($CA))
			EndSelect
		Case $xx1 == $xx2
			Select
				Case $yy1 < $yy2
					$arr[2] = 7
					$arr[0] = $rad270
				Case $yy1 == $yy2
					$arr[2] = 9
					$arr[0] = 0
				Case $yy1 > $yy2
					$arr[2] = 3
					$arr[0] = $rad90
			EndSelect
		Case $xx1 < $xx2
			Select
				Case $yy1 < $yy2
					$arr[2] = 8
					$arr[0] = ATan(($CO) / ($CA)) + $rad270
					$arr[3] = $rad90 - ATan(($CO) / ($CA))
				Case $yy1 == $yy2
					$arr[2] = 1
					$arr[0] = 0
				Case $yy1 > $yy2
					$arr[2] = 2
					$arr[0] = $rad90 - ATan(($CO) / ($CA))
					$arr[3] = ATan(($CO) / ($CA)) - $rad90
			EndSelect
	EndSelect

	$arr[0] = StringFormat('%.2f', $arr[0])
	$arr[1] = Sqrt($CO ^ 2 + $CA ^ 2)
	Return $arr
EndFunc   ;==>Angulo

Func GradToRad($iGraus)
	Return $iGraus * $DegToRad
EndFunc   ;==>GradToRad

Func _ArrayAdd2D(ByRef $aInput, $mOpt1 = Default, $mOpt2 = Default, $mOpt3 = Default, $mOpt4 = Default, $mOpt5 = Default, $mOpt6 = Default, $mOpt7 = Default, $mOpt8 = Default, $mOpt9 = Default, $mOpt10 = Default)
	$aInput[0][0] = UBound($aInput, 1)
	ReDim $aInput[$aInput[0][0] + 1][UBound($aInput, 2)]
	Local $iCol = @NumParams - 1 < UBound($aInput, 2) ? @NumParams - 1 : UBound($aInput, 2)
	For $ii = 1 To $iCol
		$aInput[$aInput[0][0]][$ii - 1] = Execute("$mOpt" & $ii)
	Next
	Return $aInput[0][0]
EndFunc   ;==>_ArrayAdd2D

;~ "C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "C:\Dropbox\ALL2D\ALL2D.au3" load %mapfile
