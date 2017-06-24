#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=ALL2D.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=Luismar Chechelaky
#AutoIt3Wrapper_Res_Language=1046
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; #INDEX# =======================================================================================================================
; Title .........: ALL2D
; AutoIt Version : 3.3.12.0
; Description ...: Gera um mapa em GDI a partir de um arquivo JSON criado pelo 'Tile Map Editor'
;                  Generate a GDI map from a JSON file created by 'Tile Map Editor'
; Author(s) .....: Luismar Chechelaky
; ===============================================================================================================================

#cs
	Versão/Version
	0.0.0.1 - 17/12/2014

	Tile Map Editor
	http://www.mapeditor.org/

	F5/Preview
	Tile Map Editor -> Edit Commands
	"C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "C:\Dropbox\ALL2D\ALL2D.au3" load %mapfile

	Standard format
	;https://github.com/bjorn/tiled/wiki/TMX-Map-Format

	C:\Program Files (x86)\AutoIt3\Include\APIErrorsConstants.au3

	http://msdn.microsoft.com/pt-br/library/bb202810.aspx

	https://www.autoitscript.com/wiki/UDF-spec

	http://books.google.co.ve/books?id=-4ngT05gmAQC&printsec=frontcover#v=onepage&q&f=false

	http://stackoverflow.com/questions/14034628/algorithm-to-access-the-tiles-in-a-matrix-game-map-that-are-in-a-disc

	http://www.wildbunny.co.uk/blog/2011/12/11/how-to-make-a-2d-platform-game-part-1/

	http://www.wildbunny.co.uk/blog/2011/12/14/how-to-make-a-2d-platform-game-part-2-collision-detection/

	http://www.wildbunny.co.uk/blog/2011/12/20/how-to-make-a-2d-platform-game-part-3-ladders-and-ai/

	http://gamedev.stackexchange.com/questions/73759/can-i-prevent-diagonal-movement-from-exploring-more-of-the-map

	http://gamedevelopment.tutsplus.com/tutorials/creating-isometric-worlds-a-primer-for-game-developers--gamedev-6511

	http://www.learn-cocos2d.com/2013/08/physics-engine-platformer-terrible-idea/

	http://devmag.org.za/2009/04/13/basic-collision-detection-in-2d-part-1/

	https://github.com/bjorn/tiled/issues/57
#ce

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

#include-once
#include <Array.au3>
#include <APIErrorsConstants.au3>
#include <Constants.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <Misc.au3>
#include <String.au3>
#include <WindowsConstants.au3>
#include <WinAPIDiag.au3>
#include <Timers.au3>

#include <object_dump.au3> ; https://github.com/chechelaky/AutoIt/blob/master/Sec2Hour.au3
#include <JSMN.au3> ;~ https://github.com/ez2sugul/stopwatch_client/blob/master/JSMN.au3


;~ Global Const $SD = "Scripting.Dictionary"
Global Const $ROOT = Round(Sqrt(2) / 2, 3)
Global Enum $__BOX = 0, $__POLYGON, $__POLYLINE, $__ELLIPSE
Global $hGraphic_LayerDown
Global $hBitmap_LayerDown
Global $iXX, $iYY, $ii, $jj
Global $iWW, $iEE, $iNN, $iSS, $iNW, $iNE, $iSW, $iSE
Global $iEval
Global $oWall = ObjCreate($SD)
Global $oActor = ObjCreate($SD)
Global $oObj = ObjCreate($SD)
Global $oImage = ObjCreate($SD)
Global $oTiles = ObjCreate($SD)
Global $oLayers = ObjCreate($SD)
Global $aNext[2]

Global $iAngle = 0
Global Const $PI = 3.14159265359
Global Const $PI2 = $PI / 2

Global Const $radToDeg = 180 / $PI
Global Const $DegToRad = $PI / 180

Global Const $rad90 = $PI / 2
Global Const $rad270 = 3 * $PI / 2
Global $aPontos

Global $aActor[1]
Global $aImage[1]
Global $iAngulo

Global $hUser32 = DllOpen("User32.dll")
Global $aPress[6] = [False, False, False, False, False, False]
Global $aKeys[6] = [11, 20, 25, 26, 27, 28]

Global $aGrid[1][1]
Global $GRID = 4
Global $iDir
Global $iWalk
Global $JSON
Global $hImg2
Global $iMov
Global $hGDI = True
Global $hGui, $g_hGuiTitle
Global $GRID_ZOOM = 1
Global $hGuiStyle = Default ; BitOR($WS_POPUP, $WS_BORDER)
Global $hGuiExStyle = $WS_EX_TOPMOST
Global $GRID_W, $GRID_WZ, $GRID_H, $GRID_HZ
Global $GRID_LIMIT_TOP, $GRID_LIMIT_RIG, $GRID_LIMIT_BOT, $GRID_LIMIT_LEF
Global $aColor[1]
Global $PATH

Global $oErrorHandler = ObjEvent("AutoIt.Error", "_ErrFunc")

Global $hGraphic, $hPen, $hBitmap, $hBackbuffer
Global $hBrush
Global $hMatrix

Global $hActorDefault
Global $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""

Global $GAME
Global $tagACTOR = "Struct;" & _
		"CHAR name[8];" & _
		"FLOAT x;" & _
		"FLOAT y;" & _
		"FLOAT x2;" & _
		"FLOAT y2;" & _
		"INT w2;" & _
		"INT h2;" & _
		"INT width;" & _
		"INT height;" & _
		"INT diag;" & _
		"INT diag2;" & _
		"FLOAT speed;" & _
		"INT hp_max;" & _
		"INT hp_current;" & _
		"INT xp;" & _
		"INT gold;" & _
		"HWND image;" & _
		"HWND scan;" & _
		"HWND ctx;" & _
		"HWND matrix;" & _
		"INT sound_born;" & _
		"INT sound_hit;" & _
		"INT sound_death;" & _
		"INT margin_left;" & _
		"INT margin_top;" & _
		"INT margin_right;" & _
		"INT margin_botton;" & _
		"EndStruct"



;~ dump_struct($tagACTOR, 1)

Func dump_struct($tag, $str)
	Local $arr = StringSplit($tag, ";", 2)
	Local $temp
	For $ii = 1 To UBound($arr, 1) - 2
		$temp = _dump_struct_line($arr[$ii])
		Local $val = Eval("str." & $temp[1])
		ConsoleWrite(_StringRepeat(" ", 6 - StringLen($temp[0])) & StringUpper($temp[0]) & ": " & $temp[1] & ($temp[2] ? "[" & $temp[2] & "]=" : "=") & $val & @LF)
	Next
EndFunc   ;==>dump_struct

Func _dump_struct_line($str)
	Local $arr = StringSplit($str, " ", 2)

	Local $primeiro = StringInStr($arr[1], "[")

	If $primeiro Then
		_ArrayAdd($arr, Int(StringMid($arr[1], $primeiro + 1, StringInStr($arr[1], "]") - $primeiro - 1)))
		$arr[1] = StringLeft($arr[1], $primeiro - 1)
	Else
		_ArrayAdd($arr, StringMid($arr[1], "-"))
	EndIf

	Return $arr
EndFunc   ;==>_dump_struct_line

;~ "C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "C:\Dropbox\ALL2D\ALL2D.au3" load %mapfile
;~ "C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "C:\Dropbox\Borius\borius.au3" load %mapfile verbose on
;~ "C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "C:\Dropbox\Borius\borius.au3" load %mapfile
;~ MsgBox(0, "teste", "teste" & @CRLF & _ArrayToString($CmdLine) & @CRLF & $CmdLine[2])

If $CmdLine[0] > 0 Then
	Switch $CmdLine[1]
		Case "load"
			Local $aPathSplit = _PathSplit($CmdLine[2], $sDrive, $sDir, $sFileName, $sExtension)
			$PATH = $sDrive & $sDir
			$PATH = StringReplace($PATH, "/", "\")
			Game_UI($CmdLine[2], $CmdLine[2], 1, 20)
			ALL2D_AddActor(32, 32, 32, 32, 4)
			$aNext[0] = _Timer_Init()
			While Sleep(20)
				If _Timer_Diff($aNext[0]) > 200 Then
					$aNext[0] = _Timer_Init()
					$aNext[1] += 1
					If $aNext[1] > 3 Then $aNext[1] = 0
				EndIf
			WEnd
		Case Else
	EndSwitch
Else
	Local $exemplo = @ScriptDir & "\game.json"
	ConsoleWrite("$exemplo[ " & $exemplo & " ]" & @LF)
	Local $aPathSplit = _PathSplit($exemplo, $sDrive, $sDir, $sFileName, $sExtension)
	ConsoleWrite("$sDrive[" & $sDrive & "], $sDir[" & $sDir & "], $sFileName[" & $sFileName & "], $sExtension[" & $sExtension & "]" & @LF)
	$PATH = $sDrive & $sDir
	$PATH = StringReplace($PATH, "/", "\")

	$GAME = json_load($exemplo)
;~ 	dump($GAME)

	Game_UI("TowerDefense", @ScriptDir & "\" & $GAME.item("level"), 1.33, 20)
;~ 	ALL2D_AddActor(32, 32, 32, 32, 4)
	$aNext[0] = _Timer_Init()
	While Sleep(20)
		If _Timer_Diff($aNext[0]) > 200 Then
			$aNext[0] = _Timer_Init()
			$aNext[1] += 1
			If $aNext[1] > 3 Then $aNext[1] = 0
		EndIf
	WEnd
EndIf




OnAutoItExitRegister("Game_OnExit")

; #FUNCTION# ====================================================================================================================
; Name...........: Game_UI
; Description ...:
; Syntax.........:
; Parameters ....:
; Return values .:
; Author ........: Luismar Chechelaky
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func Game_UI($sTitle = "", $sFilePath = "", $iZoom = 1, $iTime = 20)

	Local $sDrive, $sDir, $sFileName, $sExtension
	If _Singleton($sTitle, 1) == 0 Then Exit
	$g_hGuiTitle = $sTitle
	$sFilePath = StringReplace($sFilePath, "/", "\")

	ConsoleWrite("Game_UI( $sTitle=" & $sTitle & ", $sFilePath=" & $sFilePath & ", $iZoom=" & $iZoom & ", $iTime=" & $iTime & ")" & @LF)

	ConsoleWrite("FileExists( $sFilePath=" & $sFilePath & " )" & @LF)
	If Not FileExists($sFilePath) Then Game_Die("", $ERROR_FILE_NOT_FOUND)
	_PathSplit($sFilePath, $sDrive, $sDir, $sFileName, $sExtension)
	If Not ($sExtension == ".json") Then Game_Die("", $ERROR_BAD_FORMAT)

	$JSON = Game_LoadFile($sFilePath)
	If $JSON.Item("properties").Exists("zoom") And $JSON.Item("properties").Item("zoom") > 0 Then $iZoom = $JSON.Item("properties").Item("zoom")
	$GRID_ZOOM = (Number($iZoom) < 0) ? 0.1 : Number($iZoom)
	ConsoleWrite("$GRID_ZOOM[ " & $GRID_ZOOM & " ]" & @LF)
	$iTime = (Number($iTime) < 10) ? 10 : Number($iTime)

	If $JSON.Item("properties").Exists("grid") Then $GRID = Number($JSON.Item("properties").Item("grid"))
	$GRID = Floor($GRID / 4) * 4
	$GRID = $GRID < 1 ? 1 : ($GRID > 32 ? 32 : $GRID)

	$GRID_W = Int($JSON.Item("width") * $JSON.Item("tilewidth"))
	$GRID_H = Int($JSON.Item("height") * $JSON.Item("tileheight"))
	$GRID_WZ = $GRID_W * $GRID_ZOOM
	$GRID_HZ = $GRID_H * $GRID_ZOOM
	ReDim $aGrid[$GRID_W][$GRID_H]

	$hGui = GUICreate("ALL2D: " & $sTitle, $GRID_WZ * $GRID_ZOOM, $GRID_HZ * $GRID_ZOOM, -1, -1, $hGuiStyle, $hGuiExStyle)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Game_Quit")

	_GDIPlus_Startup()
	If @error Then $hGDI = False
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
	$hBitmap = _GDIPlus_BitmapCreateFromGraphics($GRID_W, $GRID_H, $hGraphic)
	$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	$hBrush = _GDIPlus_BrushCreateSolid(0x00FFFFFF)

	$hActorDefault = __ALL2D_LoadImage("C:\Dropbox\ALL2D\images\actor\default.png")

	$hPen = _GDIPlus_PenCreate()
	_GDIPlus_GraphicsClear($hBackbuffer)
	_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

	Build_Actors()
	Build_MapWay()

	$aPontos = Build_MapWay()

	$aActor[1].x = $aPontos[1][0]
	$aActor[1].y = $aPontos[1][1]
	$iAngulo = Angulo($aActor[1].x, $aActor[1].y, $aPontos[1][0], $aPontos[1][1])

	Move_Orda()

	__ALL2D_BuildTilesets()
	__ALL2D_BuildLayers()
	If Not ($GRID_ZOOM == 1) Then
		$hMatrix = _GDIPlus_MatrixCreate()
		_GDIPlus_MatrixScale($hMatrix, $GRID_ZOOM, $GRID_ZOOM, True)
		_GDIPlus_GraphicsSetTransform($hGraphic, $hMatrix)
	EndIf

	$GRID_LIMIT_LEF = 0
	$GRID_LIMIT_TOP = 0
	$GRID_LIMIT_RIG = $JSON.Item("width") * $JSON.Item("tilewidth") - $JSON.Item("tilewidth")
	$GRID_LIMIT_BOT = $JSON.Item("height") * $JSON.Item("tileheight") - $JSON.Item("tileheight")

	GUISetState(@SW_SHOW, $hGui)

	AdlibRegister("Game_Update", $iTime)
EndFunc   ;==>Game_UI

Func Game_Update()
	__ALL2D_GetKeys()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	__ALL2D_DrawLayers()
	__ALL2D_DrawObjects()
;~ 	__ALL2D_MoveActors()
	Move_Orda()
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $GRID_WZ, $GRID_HZ)
EndFunc   ;==>Game_Update

Func __ALL2D_DrawLayers()
	_GDIPlus_GraphicsDrawImageRect($hBackbuffer, $hGraphic_LayerDown, 0, 0, $GRID_W, $GRID_H)
EndFunc   ;==>__ALL2D_DrawLayers

Func __ALL2D_DrawObjects()
	For $each In $oObj
		Switch $oObj.Item($each).Item("t")
			Case $__POLYGON, $__POLYLINE, $__BOX
				_GDIPlus_BrushSetSolidColor($hPen, $oObj.Item($each).Item("c"))
				_GDIPlus_GraphicsDrawPolygon($hBackbuffer, $oObj.Item($each).Item("a"), $hPen)
			Case $__ELLIPSE
				_GDIPlus_GraphicsDrawEllipse($hBackbuffer, $oObj.Item($each).Item("x"), $oObj.Item($each).Item("y"), $oObj.Item($each).Item("w"), $oObj.Item($each).Item("h"))
		EndSwitch
	Next
EndFunc   ;==>__ALL2D_DrawObjects

Func Build_MapWay()
;~ 	pathway
	Local $oPathWay = __JSON_Layer_Find_PathWay()
	If @error Then Game_Die("", "pathway not found")

	Local $xx = ($oPathWay.Item("objects"))[0].Item("x")
	Local $yy = ($oPathWay.Item("objects"))[0].Item("y")

	Local $aPolyline = ($oPathWay.Item("objects"))[0].Item("polyline")
	Local $arr[1][2] = [[UBound($aPolyline, 1) - 1, 1]]
	For $ii = 0 To $arr[0][0]
		_ArrayAdd2D($arr, $xx + ($aPolyline[$ii]).Item("x"), $yy + ($aPolyline[$ii]).Item("y"))
	Next
	Return $arr
EndFunc   ;==>Build_MapWay

Func __JSON_Layer_Find_PathWay()
	For $ii = 0 To UBound($JSON.Item("layers"), 1) - 1
		If ($JSON.Item("layers"))[$ii].Item("name") == "pathway" Then Return ($JSON.Item("layers"))[$ii]
	Next
	Return SetError(1, 0, 0)
EndFunc   ;==>__JSON_Layer_Find_PathWay


Func Move_Orda()
;~ 	For $each In $oUnity
	$iAngulo = Angulo($aActor[1].x, $aActor[1].y, $aPontos[$aPontos[0][1]][0], $aPontos[$aPontos[0][1]][1])
	If $iAngulo[1] < 8 Then
		$aPontos[0][1] += 1
		If $aPontos[0][1] > $aPontos[0][0] Then $aPontos[0][1] = 1
	EndIf

	$aActor[1].x += $aActor[1].speed * Cos($iAngulo[3])
	$aActor[1].y += $aActor[1].speed * Sin($iAngulo[3])

;~ 	_box($hBackbuffer, $aActor[1].x - $aActor[1].w2, $aActor[1].y - $aActor[1].h2, $aActor[1].width, $aActor[1].height)

	_GDIPlus_GraphicsClear($aActor[1].ctx, 0x00FFFFFF)

	$iAngulo[3] *= $radToDeg

	_GDIPlus_MatrixRotate($aActor[1].matrix, $iAngulo[3])
	_GDIPlus_GraphicsSetTransform($aActor[1].ctx, $aActor[1].matrix)
	_GDIPlus_MatrixRotate($aActor[1].matrix, -$iAngulo[3])

	_GDIPlus_GraphicsDrawImageRectRect($aActor[1].ctx, $aActor[1].image, 0, 0, $aActor[1].width, $aActor[1].height, -$aActor[1].w2, -$aActor[1].h2, $aActor[1].width, $aActor[1].height)

	_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, $aActor[1].scan, 0, 0, $aActor[1].diag, $aActor[1].diag, $aActor[1].x - $aActor[1].diag2, $aActor[1].y - $aActor[1].diag2, $aActor[1].diag, $aActor[1].diag)

;~ 	_GDIPlus_GraphicsDrawImageRect( $hBackbuffer, $aActor[1].image, $aActor[1].x - $aActor[1].w2, $aActor[1].y - $aActor[1].h2, $aActor[1].width, $aActor[1].height)
;~ 	Next

EndFunc   ;==>Move_Orda

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

Func ALL2D_AddActor($iXX, $iYY, $iWidth, $iHeight, $iSpeed, $mActor = Default)
	Local $id = $oActor.Count + 1
	Local $iSearch = 0
	$oActor.Add($id, ObjCreate($SD))
	$oActor.Item($id).Add("x", $iXX)
	$oActor.Item($id).Add("y", $iYY)
	$oActor.Item($id).Add("w", $iWidth)
	$oActor.Item($id).Add("h", $iHeight)
	$oActor.Item($id).Add("st", $iSpeed)
	$oActor.Item($id).Add("sx", $oActor.Item($id).Item("st") * $ROOT)
	$oActor.Item($id).Add("c", $mActor)
	$oActor.Item($id).Add("ll", 0)
	$oActor.Item($id).Add("lt", 0)
	$oActor.Item($id).Add("lr", $GRID_W - $iWidth)
	$oActor.Item($id).Add("lb", $GRID_H - $iHeight)
EndFunc   ;==>ALL2D_AddActor

Func Build_Actors()
	Local $dt
;~ 	ConsoleWrite("$dt[ " & IsObj($dt) & " ] @error[ " & @error & " ]" & @LF)

	Local $id
dump( $GAME.Item("actor") )
	For $each In $GAME.Item("actor")
		$dt = DllStructCreate($tagACTOR)
		$dt.name = $each.Item("name")
		$dt.hp_max = $each.Item("hp_max")
		$dt.x = 0.0
		$dt.y = 0.0
		$dt.speed = $each.Item("speed")
		Local $img = _LoadImage($each.Item("image"))
		If @error Then Game_Die("", $ERROR_FILE_NOT_FOUND)
		$dt.image = $img[0]
		$dt.width = $img[1]
		$dt.height = $img[2]
		$dt.diag = _diagonal($dt.width, $dt.height)
		$dt.diag2 = Int($dt.diag / 2)

		$dt.w2 = Int($img[1] / 2)
		$dt.h2 = Int($img[2] / 2)

		$dt.scan = _GDIPlus_BitmapCreateFromScan0($dt.diag, $dt.diag)
		$dt.ctx = _GDIPlus_ImageGetGraphicsContext($dt.scan)

		$dt.matrix = _GDIPlus_MatrixCreate()

		_GDIPlus_MatrixTranslate($dt.matrix, $dt.diag2, $dt.diag2)

		_GDIPlus_GraphicsSetSmoothingMode($dt.ctx, $GDIP_SMOOTHINGMODE_HIGHQUALITY)

		$dt.margin_left = 0
		$dt.margin_top = 0
		$dt.margin_right = $GRID_W - $dt.width
		$dt.margin_botton = $GRID_H - $dt.height

;~ 		dump($each)
		_ArrayAdd($aActor, $dt)
	Next
	$aActor[0] = UBound($aActor, 1) - 1

;~ 	ConsoleWrite("nome[ " & $aActor[1].name & " ]" & @LF)


;~ 	Local $id = $oActor.Count + 1
;~ 	Local $iSearch = 0
;~ 	$oActor.Add($id, ObjCreate($SD))
;~ 	$oActor.Item($id).Add("x", $iXX)
;~ 	$oActor.Item($id).Add("y", $iYY)
;~ 	$oActor.Item($id).Add("w", $iWidth)
;~ 	$oActor.Item($id).Add("h", $iHeight)
;~ 	$oActor.Item($id).Add("st", $iSpeed)
;~ 	$oActor.Item($id).Add("sx", $oActor.Item($id).Item("st") * $ROOT)



;~ 	$oActor.Item($id).Add("c", $mActor)
;~ 	$oActor.Item($id).Add("ll", 0)
;~ 	$oActor.Item($id).Add("lt", 0)
;~ 	$oActor.Item($id).Add("lr", $GRID_W - $iWidth)
;~ 	$oActor.Item($id).Add("lb", $GRID_H - $iHeight)
EndFunc   ;==>Build_Actors



Func _LoadImage($sFileName, $bMatrix = False)
	ConsoleWrite("_LoadImage[ " & $sFileName & " ]" & @LF)
	Local $ret[3] = [_GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\" & $sFileName)]
	If @error Then Return SetError(1, 0, @error)
	$ret[1] = _GDIPlus_ImageGetWidth($ret[0])
	$ret[2] = _GDIPlus_ImageGetHeight($ret[0])
	If $bMatrix Then

	EndIf
	_ArrayAdd($aImage, $ret[0])
	Return $ret
EndFunc   ;==>_LoadImage

Func Game_OnExit()
	AdlibUnRegister("Game_Update")
	If Not ($hUser32 == -1) Then DllClose($hUser32)
	If $hGDI Then
		For $each In $oImage
			_GDIPlus_ImageDispose($oImage.Item($each).Item("handle"))
		Next

		For $ii = 1 To UBound($aImage, 1) - 1
			_GDIPlus_ImageDispose($aImage[$ii])
		Next


		For $each In $oTiles
			_GDIPlus_ImageDispose($oTiles.Item($each))
		Next
		_GDIPlus_GraphicsDispose($hBackbuffer)
		_GDIPlus_BitmapDispose($hBitmap)
		_GDIPlus_PenDispose($hPen)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_Shutdown()
	EndIf
	GUIDelete($hGui)
EndFunc   ;==>Game_OnExit

Func __Move($each)
;~ 	nw  n   ne
;~ 	 w  0    e
;~ 	sw  s   se

;~  32  3   34
;~ 	 2  0    4
;~ 	52  5   54

	$iWW = $aPress[2] And Not $aPress[4] ? True : False
	$iEE = $aPress[4] And Not $aPress[2] ? True : False
	$iNN = $aPress[3] And Not $aPress[5] ? True : False
	$iSS = $aPress[5] And Not $aPress[3] ? True : False
	$iNE = $iNN And $iEE ? True : False
	$iSE = $iSS And $iEE ? True : False
	$iSW = $iWW And $iSS ? True : False
	$iNW = $iWW And $iNN ? True : False
	Select
		Case $iNW
			__MoveX($each, 8)
			$iDir = 8
		Case $iNE
			__MoveX($each, 2)
			$iDir = 2
		Case $iSE
			__MoveX($each, 4)
			$iDir = 4
		Case $iSW
			__MoveX($each, 6)
			$iDir = 6
		Case Else
			Select
				Case $iNN
					__MoveT($each, 1, "st")
				Case $iEE
					__MoveT($each, 3, "st")
				Case $iSS
					__MoveT($each, 5, "st")
				Case $iWW
					__MoveT($each, 7, "st")
				Case Else
					__MoveT($each, 0, "st")
			EndSelect
	EndSelect
EndFunc   ;==>__Move

Func __ALL2D_Walk()
	If $iDir Then
		$iWalk -= 1
		If $iWalk < 0 Then $iWalk = 8
		$iMov = $iDir
	EndIf
EndFunc   ;==>__ALL2D_Walk

Func __MoveT($each, $dir, $speed)
	$iDir = $dir
	Switch $dir
		Case 1 ; NN
			$iEval = $oActor.Item($each).Item("y") - $oActor.Item($each).Item($speed)
			$iEval = $iEval <= $oActor.Item($each).Item("lt") ? $oActor.Item($each).Item("lt") : $iEval
			For $jj = $oActor.Item($each).Item("y") - 1 To $iEval Step -1
				For $ii = $oActor.Item($each).Item("x") To $oActor.Item($each).Item("x") + $oActor.Item($each).Item("w") - 1
					If $aGrid[$ii][$jj] Then
						$oActor.Item($each).Item("y") = $jj + 1
						Return
					EndIf
				Next
			Next
			$oActor.Item($each).Item("y") = $iEval
		Case 3 ; EE / RIGHT
			$iEval = $oActor.Item($each).Item("x") + $oActor.Item($each).Item($speed)
			$iEval = $iEval >= $oActor.Item($each).Item("lr") ? $oActor.Item($each).Item("lr") : $iEval
			For $ii = $oActor.Item($each).Item("x") + $oActor.Item($each).Item("w") To $iEval + $oActor.Item($each).Item("w") - 1
				For $jj = $oActor.Item($each).Item("y") To $oActor.Item($each).Item("y") + $oActor.Item($each).Item("h") - 1
					If $aGrid[$ii][$jj] Then
						$oActor.Item($each).Item("x") = $ii - $oActor.Item($each).Item("w")
						Return
					EndIf
				Next
			Next
			$oActor.Item($each).Item("x") = $iEval
		Case 5 ; SS / DOWN
			$iEval = $oActor.Item($each).Item("y") + $oActor.Item($each).Item($speed)
			$iEval = $iEval >= $oActor.Item($each).Item("lb") ? $oActor.Item($each).Item("lb") : $iEval
			For $jj = $oActor.Item($each).Item("y") + $oActor.Item($each).Item("h") To $iEval + $oActor.Item($each).Item("h") - 1
				For $ii = $oActor.Item($each).Item("x") To $oActor.Item($each).Item("x") + $oActor.Item($each).Item("w") - 1
					If $aGrid[$ii][$jj] Then
						$oActor.Item($each).Item("y") = $jj - $oActor.Item($each).Item("h")
						Return
					EndIf
				Next
			Next
			$oActor.Item($each).Item("y") = $iEval
		Case 7 ; WW / LEFT
			$iEval = $oActor.Item($each).Item("x") - $oActor.Item($each).Item($speed)
			$iEval = $iEval <= $oActor.Item($each).Item("ll") ? $oActor.Item($each).Item("ll") : $iEval
			For $ii = $oActor.Item($each).Item("x") - 1 To $iEval Step -1
				For $jj = $oActor.Item($each).Item("y") To $oActor.Item($each).Item("y") + $oActor.Item($each).Item("h") - 1
					If $aGrid[$ii][$jj] Then
						$oActor.Item($each).Item("x") = $ii + 1
						Return
					EndIf
				Next
			Next
			$oActor.Item($each).Item("x") = $iEval
			;Case 0
	EndSwitch
EndFunc   ;==>__MoveT

Func __MoveX($each, $dir)
	Switch $dir
		Case 2 ; $iNE
			__MoveT($each, 1, "sx")
			__MoveT($each, 3, "sx")
		Case 4 ; $iSE
			__MoveT($each, 3, "sx")
			__MoveT($each, 5, "sx")
		Case 6 ; $iSW
			__MoveT($each, 5, "sx")
			__MoveT($each, 7, "sx")
		Case 8 ; $iNW
			__MoveT($each, 1, "sx")
			__MoveT($each, 7, "sx")
	EndSwitch
EndFunc   ;==>__MoveX

Func __ALL2D_GetKeys()
	If Not $oActor.Count Then Return
	For $ii = 0 To 5
		If _IsPressed($aKeys[$ii], $hUser32) And Not $aPress[$ii] Then $aPress[$ii] = True
		If Not _IsPressed($aKeys[$ii], $hUser32) And $aPress[$ii] Then $aPress[$ii] = False
	Next
EndFunc   ;==>__ALL2D_GetKeys

Func __ALL2D_MoveActors()
	If Not $oActor.Count Then Return

	For $each In $oActor
		__Move($each)
;~ 		ConsoleWrite($oActor.Item($each).Item("c") & @LF)
		_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, _
				$hActorDefault, _
				$aNext[1] * 32, _
				0, _
				32, _
				32, _
				Int($oActor.Item($each).Item("x")), _
				Int($oActor.Item($each).Item("y")), _
				32, _
				32 _
				)
;~ 		_box($hBackbuffer, Int($oActor.Item($each).Item("x")), Int($oActor.Item($each).Item("y")), $oActor.Item($each).Item("w"), $oActor.Item($each).Item("h"), $oActor.Item($each).Item("c"))
	Next
	Local $aa[9] = [0, 1, 2, 3, 7, 6, 5, 4, 0]
	If $iDir Then
		_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, $hImg2, $iWalk * 28, $aa[$iDir] * 32 + 1, 32, 32, $oActor.Item($each).Item("x"), $oActor.Item($each).Item("y"), 32, 32)
	Else
		_GDIPlus_GraphicsDrawImageRectRect($hBackbuffer, $hImg2, $iWalk * 28, $aa[$iMov] * 32 + 1, 32, 32, $oActor.Item($each).Item("x"), $oActor.Item($each).Item("y"), 32, 32)
	EndIf
EndFunc   ;==>__ALL2D_MoveActors

Func Game_LoadFile($sFilePath = "")
	If Not $sFilePath Then Return SetError(1, 0, 0)
	Local $hFile = FileOpen($sFilePath)
	If Not $hFile Or @error Then Return SetError(2, 0, 0)
	Local $sJson = FileRead($hFile)
	;ConsoleWrite($sJson & @LF)
	If @error Or Not $sJson Then Return SetError(3, 0, 0)
	$sJson = Jsmn_Decode($sJson)
	If @error Or Not IsDictionary($sJson) Then Return SetError(4, 0, 0)
	If Not (Number($sJson.Item("version")) == 1) Then Return SetError(5, 0, 0)
	If Not ($sJson.Item("orientation") == "orthogonal") Then Return SetError(6, 0, 0)
	Return $sJson
EndFunc   ;==>Game_LoadFile

Func __ALL2D_LoadImage($sPath = "")
	If Not FileExists($sPath) Then Return SetError(1, 0, 0)
	Local $hImage = _GDIPlus_ImageLoadFromFile($sPath)
	If @error Then Return SetError(2, 0, 0)
	$oImage.Add($sPath, ObjCreate($SD))
	$oImage.Item($sPath).Add("handle", $hImage)
	$oImage.Item($sPath).Add("w", _GDIPlus_ImageGetWidth($hImage))
	$oImage.Item($sPath).Add("h", _GDIPlus_ImageGetHeight($hImage))
	Return $hImage
EndFunc   ;==>__ALL2D_LoadImage

Func __ALL2D_BuildTiles($iFirstGid, $sPath, $iImageHeight, $iImageWidth, $iTileHeight, $iTileWidth, $iTranparency, $iMargin, $iSpacing, $sName)
;~ 	ConsoleWrite("__ALL2D_BuildTiles($iFirstGid[" & $iFirstGid & "], $sPath[" & $sPath & "], $iImageHeight, $iImageWidth, $iTileHeight, $iTileWidth, $iTranparency, $iMargin, $iSpacing, $sName)" & @LF)
	$sPath = StringReplace($sPath, "/", "\")
	$sPath = _PathFull($sPath, $PATH & "maps\")

	Local $hImage = _GDIPlus_ImageLoadFromFile($sPath)
	If @error Then
		MsgBox(0, "@error", "__ALL2D_BuildTiles" & @LF & "$sPath=" & $sPath & @LF & @error)
		Exit
	EndIf
	Local $hBitmap, $hBmpCtxt

	For $jj = 0 To ($iImageHeight / ($iTileHeight + $iSpacing)) - 1
		For $ii = 0 To ($iImageWidth / ($iTileWidth + $iMargin)) - 1
			$hBitmap = _GDIPlus_BitmapCreateFromScan0($iTileWidth, $iTileHeight)
			$hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
			_GDIPlus_GraphicsSetSmoothingMode($hBmpCtxt, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
			_GDIPlus_GraphicsClear($hBmpCtxt, 0x00FFFFFF)
			_GDIPlus_GraphicsDrawImageRectRect( _
					$hBmpCtxt, _
					$hImage, _
					$iMargin + $ii * ($iTileWidth + $iSpacing), _
					$iMargin + $jj * ($iTileHeight + $iSpacing), _
					$iTileWidth, _
					$iTileHeight, _
					0, _
					0, _
					$iTileWidth, _
					$iTileHeight _
					)
			$oTiles.Add($iFirstGid, $hBitmap)
			$iFirstGid += 1
			_GDIPlus_GraphicsDispose($hBmpCtxt)
		Next
	Next
EndFunc   ;==>__ALL2D_BuildTiles

Func __ALL2D_NewImage($iImageWidth, $iImageHeight)
	Local $hImage = _GDIPlus_BitmapCreateFromScan0($iImageWidth, $iImageHeight)
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hImage)
	_GDIPlus_GraphicsSetSmoothingMode($hBmpCtxt, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsClear($hBmpCtxt, 0x00FFFFFF)
	Return $hBmpCtxt
EndFunc   ;==>__ALL2D_NewImage

Func __ALL2D_BuildTilesets()
	Local $oo = $JSON.Item("tilesets")
	For $each In $oo
		__ALL2D_BuildTiles( _
				Number($each.Item("firstgid")), _
				String($each.Item("image")), _
				Number($each.Item("imageheight")), _
				Number($each.Item("imagewidth")), _
				Number($each.Item("tileheight")), _
				Number($each.Item("tilewidth")), _
				$each.Item("transparentcolor"), _
				Number($each.Item("margin")), _
				Number($each.Item("spacing")), _
				String($each.Item("name")) _
				)
	Next
EndFunc   ;==>__ALL2D_BuildTilesets

Func __ALL2D_RenderOrder()
	;The order In which tiles on tile layers are rendered. Valid values are right - down(the Default), right - up, left - down And left - up.
	;In all cases, the map is drawn row - by - row.
	;(since 0.10, but only supported For orthogonal maps at the moment)
	Local $iRet = 0
	Switch $JSON.Item("renderorder")
		Case "right-up"
			$iRet = 2
		Case "left-down"
			$iRet = 3
		Case "left-up"
			$iRet = 4
		Case Else ; right-down
			$iRet = 1
	EndSwitch
	Return $iRet
EndFunc   ;==>__ALL2D_RenderOrder

Func __ALL2D_BuildLayers()
	Local $aLayers = $JSON.Item("layers")
	Local $iRenderOrder = __ALL2D_RenderOrder()
	Local $aData, $sName, $iTile, $aObj
	Local $xx = 0, $yy = 0
	$hGraphic_LayerDown = _GDIPlus_BitmapCreateFromScan0($GRID_W, $GRID_H)
	$hBitmap_LayerDown = _GDIPlus_ImageGetGraphicsContext($hGraphic_LayerDown)
	_GDIPlus_GraphicsSetSmoothingMode($hBitmap_LayerDown, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsClear($hBitmap_LayerDown, 0x00FFFFFF)
	For $ii = 0 To UBound($aLayers, 1) - 1
		$sName = $JSON.Item("layers")[$ii].Item("name")
		Switch $JSON.Item("layers")[$ii].Item("type")
			Case "tilelayer"
				If $JSON.Item("layers")[$ii].Item("visible") == True Then
					$aData = $JSON.Item("layers")[$ii].Item("data")
					For $jj = 0 To UBound($aData, 1) - 1
						$iTile = $aData[$jj]
						If $iTile Then
							_GDIPlus_GraphicsDrawImageRectRect( _
									$hBitmap_LayerDown, _
									$oTiles.Item($iTile), _
									0, _
									0, _
									32, _
									32, _
									$xx * (32), _
									$yy * (32), _
									32, _
									32 _
									)
						EndIf
						$xx += 1
						If $xx >= $JSON.Item("width") Then
							$xx = 0
							$yy += 1
						EndIf
					Next
					$xx = 0
					$yy = 0
				EndIf
			Case "objectgroup"
				$aObj = $JSON.Item("layers")[$ii].Item("objects")
				For $jj = 0 To UBound($aObj, 1) - 1
					If ($aObj[$jj]).Item("visible") Then
						If ($aObj[$jj]).Exists("polygon") Then
							ADD2D_AddWall( _
									$__POLYGON, _
									($aObj[$jj]).Item("x"), _
									($aObj[$jj]).Item("y"), _
									($aObj[$jj]).Exists("rotation") ? ($aObj[$jj]).Item("rotation") : 0, _
									($aObj[$jj]).Item("polygon") _
									)
						ElseIf ($aObj[$jj]).Exists("polyline") Then
							ADD2D_AddWall( _
									$__POLYLINE, _
									($aObj[$jj]).Item("x"), _
									($aObj[$jj]).Item("y"), _
									($aObj[$jj]).Exists("rotation") ? ($aObj[$jj]).Item("rotation") : 0, _
									($aObj[$jj]).Item("polyline") _
									)
						Else
							If ($aObj[$jj]).Item("ellipse") == True Then
								ADD2D_AddWall( _
										$__ELLIPSE, _
										($aObj[$jj]).Item("x"), _
										($aObj[$jj]).Item("y"), _
										($aObj[$jj]).Exists("rotation") ? ($aObj[$jj]).Item("rotation") : 0, _
										($aObj[$jj]).Item("width"), _
										($aObj[$jj]).Item("height") _
										)
							Else
								ADD2D_AddWall( _
										$__BOX, _
										($aObj[$jj]).Item("x"), _
										($aObj[$jj]).Item("y"), _
										($aObj[$jj]).Exists("rotation") ? ($aObj[$jj]).Item("rotation") : 0, _
										($aObj[$jj]).Item("width"), _
										($aObj[$jj]).Item("height") _
										)
							EndIf
						EndIf
					EndIf
				Next
		EndSwitch
	Next
EndFunc   ;==>__ALL2D_BuildLayers

Func ADD2D_AddWall($iType = 0, $iXX = 0, $iYY = 0, $iRot = 0, $mOpt1 = 0, $mOpt2 = 0, $iColor = 0, $iColorBack = 0)
	Local $aPoints[1], $id = $oObj.Count + 1
	Switch $iType
		Case $__BOX
			ReDim $aPoints[5][2]
			$aPoints[0][0] = 4
			$aPoints[1][0] = $iXX
			$aPoints[1][1] = $iYY
			$aPoints[2][0] = $iXX + $mOpt1 - 1
			$aPoints[2][1] = $iYY
			$aPoints[3][0] = $iXX + $mOpt1 - 1
			$aPoints[3][1] = $iYY + $mOpt2 - 1
			$aPoints[4][0] = $iXX
			$aPoints[4][1] = $iYY + $mOpt2 - 1

			$oObj.Add($id, ObjCreate($SD))
			$oObj.Item($id).Add("x", $iXX)
			$oObj.Item($id).Add("y", $iYY)
			$oObj.Item($id).Add("t", $iType)
			$oObj.Item($id).Add("a", $aPoints)
			$oObj.Item($id).Add("c", 0xFF00FF00)
		Case $__POLYGON, $__POLYLINE
			$aPoints = __ADD2D_aObjToArray($iRot, $iXX, $iYY, $mOpt1)
			$oObj.Add($id, ObjCreate($SD))
			$oObj.Item($id).Add("x", $iXX)
			$oObj.Item($id).Add("y", $iYY)
			$oObj.Item($id).Add("t", $iType)
			$oObj.Item($id).Add("a", $aPoints)
			$oObj.Item($id).Add("c", 0xFF00FF00)
		Case $__ELLIPSE
			$oObj.Add($id, ObjCreate($SD))
			$oObj.Item($id).Add("x", $iXX)
			$oObj.Item($id).Add("y", $iYY)
			$oObj.Item($id).Add("t", $iType)
			$oObj.Item($id).Add("w", $mOpt1)
			$oObj.Item($id).Add("h", $mOpt2)
			$oObj.Item($id).Add("c", 0xFF00FF00)
			; http://stackoverflow.com/questions/10322341/simple-algorithm-for-drawing-filled-ellipse-in-c-c
	EndSwitch
EndFunc   ;==>ADD2D_AddWall

Func __ADD2D_aObjToArray($iRot, $iXX, $iYY, $oo)
	Local $aPoints[UBound($oo, 1) + 1][2] = [[UBound($oo, 1)]]
	Local $id
	For $ii = 1 To UBound($oo, 1)
		$aPoints[$ii - 0][0] = $iXX + ($oo[$ii - 1]).Item("x")
		$aPoints[$ii - 0][1] = $iYY + ($oo[$ii - 1]).Item("y")
	Next
	Return $aPoints
EndFunc   ;==>__ADD2D_aObjToArray

Func _ErrFunc($oError)
	; Do anything here.
	ConsoleWrite("err.number is: " & @TAB & $oError.number & @CRLF & _
			"err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			"err.description is: " & @TAB & $oError.description & @CRLF & _
			"err.source is: " & @TAB & $oError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			"err.retcode is: " & @TAB & $oError.retcode & @CRLF & @CRLF)
EndFunc   ;==>_ErrFunc

Func Game_Die($sMessage = "", $iError = -1, $iMode = 0)
	If Not ($iError == -1) Then
		If $sMessage Then
			$sMessage &= @LF & _WinAPI_GetErrorMessage($iError)
		Else
			$sMessage = _WinAPI_GetErrorMessage($iError)
		EndIf
	EndIf
	If $sMessage Then MsgBox($MB_OK + $MB_ICONHAND + 262144, "ALL2D Error", $sMessage & @LF & "@error: " & $iError, 30)
	Game_Quit()
EndFunc   ;==>Game_Die

#cs

	Func __ALL2D_DrawWall()
	For $each In $oWall
	_box($hBackbuffer, _
	$oWall.Item($each).Item("x"), _
	$oWall.Item($each).Item("y"), _
	$oWall.Item($each).Item("w"), _
	$oWall.Item($each).Item("h"), _
	$oWall.Item($each).Item("c"))
	Next
	EndFunc   ;==>__ALL2D_DrawWall

	Func ALL2D_AddWall_Box($xx, $yy, $iWW, $hh, $iColor)
	Local $oo = ObjCreate($SD)
	$oWall.Add($oWall.Count + 1, ObjCreate($SD))
	$oWall.Item($oWall.Count).Add("x", $xx)
	$oWall.Item($oWall.Count).Add("y", $yy)
	$oWall.Item($oWall.Count).Add("w", $iWW)
	$oWall.Item($oWall.Count).Add("h", $hh)
	$oWall.Item($oWall.Count).Add("c", $iColor)
	For $ii = $xx To $xx + $iWW - 1
	For $jj = $yy To $yy + $hh - 1
	$aGrid[$ii][$jj] = $oWall.Count
	Next
	Next
	EndFunc   ;==>ALL2D_AddWall_Box



#ce

Func _box($hToGraphic, $iXX, $iYY, $iWW, $iHH, $iColor = 0)
	; _box3
	If $iWW = 1 And $iHH = 1 Then
		If $iColor Then
			_GDIPlus_BrushSetSolidColor($hBrush, $iColor)
			_GDIPlus_GraphicsFillRect($hBackbuffer, $iXX, $iYY, $iWW, $iHH, $hBrush)
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
			_GDIPlus_PenSetColor($hPen, $iColor)
			_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox, $hPen)
		Else
			_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)
		EndIf
	EndIf
EndFunc   ;==>_box

Func Game_Quit()
	AdlibUnRegister("Game_Update")
	Exit
EndFunc   ;==>Game_Quit

Func _ArrayAdd2D(ByRef $aInput, $mOpt1 = Default, $mOpt2 = Default, $mOpt3 = Default, $mOpt4 = Default, $mOpt5 = Default, $mOpt6 = Default, $mOpt7 = Default, $mOpt8 = Default, $mOpt9 = Default, $mOpt10 = Default)
	$aInput[0][0] = UBound($aInput, 1)
	ReDim $aInput[$aInput[0][0] + 1][UBound($aInput, 2)]
	Local $iCol = @NumParams - 1 < UBound($aInput, 2) ? @NumParams - 1 : UBound($aInput, 2)
	For $ii = 1 To $iCol
		$aInput[$aInput[0][0]][$ii - 1] = Execute("$mOpt" & $ii)
	Next
	Return $aInput[0][0]
EndFunc   ;==>_ArrayAdd2D
