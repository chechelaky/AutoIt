
#cs
	.................................   AAA(2) ..................   BBB(4) ...............
	....[ Anterior ]  [  Remover ]  [  Editar  ]  [  Painel  ]  [  Novo    ]  [  Próximo ]
	................................[  Salvar  ]                [  Salvar  ]
	................................[ Cancelar ]                [ Cancelar ]

	Global $ACTOR_MODE[3] = [ 0, 0, 0]
#ce


;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <FileConstants.au3>
#include <GDIPlus.au3>
#include <File.au3>

#include <library\Bass.au3>
#include <library\BassConstants.au3>

#include <jsmn.au3>
#include <object_dump.au3>

OnAutoItExitRegister("OnExit")

_BASS_STARTUP(@ScriptDir & "\library\bass.dll")
_BASS_Init(0, -1, 44100, 0, "")

Global $FILE_NAME = @ScriptDir & "\game.json"
Global $GAME = json_load($FILE_NAME)
Global $hGraphic, $hBitmap, $hBackbuffer

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)
Global Const $FONT = "DOSLike"
Global Const $tagATOR = "Struct;CHAR name[16];INT hp_max;INT hp_current;CHAR image[16];INT gold;INT xp;CHAR sound_hit[16];CHAR sound_death[16];CHAR sound_born[16];EndStruct"

;~ Global $GUI = DllStructCreate($tagGUI)

Global $GUI[2] = [800, 600]
Global $sGuiTitle = "GameEdit"
Global $hTab, $aTab[2][2] = [[0, 0], [0, "Ator"]]
Global $hGui



$hGui = GUICreate($sGuiTitle, $GUI[0], $GUI[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
GUISetFont(12, 400, 0, $FONT, $hGui)
$hTab = GUICtrlCreateTab(10, 10, $GUI[0] - 20, $GUI[1] - 20)

_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics(32, 32, $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

Tab_Actor()

GUISetState(@SW_SHOW, $hGui)
Actor_Image()
While Sleep(25)
WEnd

Func Tab_Actor()
	Global $aActor = $GAME.item("actor")

	If UBound($aActor, 1) Then
		Global $ACTOR_ID = UBound($aActor, 1)
		_ArrayInsert($aActor, 0, $ACTOR_ID)
	Else
		Global $ACTOR_ID = 0
		_ArrayAdd($aActor, 0)
	EndIf

	Global $ACTOR[2]
	Global $ACTOR_MODE[3] = [0, 0, 0]
	$ACTOR[1] = UBound($aActor, 1)
	$ACTOR[0] = $ACTOR[1] ? 1 : 0

	$aTab[1][0] = GUICtrlCreateTabItem($aTab[1][1])
	Global $hInput_Actor_Name = CreateInput(8, "", "Nome", 20, 40, 160)
	Global $hInput_Actor_HpMax = CreateInput(8, "", "HP max", 20, 90, 160)
	Global $hInput_Actor_HpCurrent = CreateInput(8, "", "HP current", 20, 140, 160)
	Global $hInput_Actor_Speed = CreateInput(8, "", "Speed", 20, 190, 160)
	Global $hInput_Actor_Image = CreateInput(1 + 8, "", "Image", 20, 240, 160)
	Global $hInput_Actor_Gold = CreateInput(8, "", "Gold", 20, 290, 160)
	Global $hInput_Actor_Xp = CreateInput(8, "", "Xp", 20, 340, 160)
	Global $hInput_Actor_Sound_Hit = CreateInput(2 + 8, "", "Sound hit", 20, 390, 160)
	Global $hInput_Actor_Sound_Death = CreateInput(2 + 8, "", "Sound death", 20, 440, 160)
	Global $hInput_Actor_Sound_Born = CreateInput(2 + 8, "", "Sound born", 20, 490, 160)

	Global $hButton_Actor_Prev = GUICtrlCreateButton("< Anterior", 25, 555, 110, 22)
	GUICtrlSetOnEvent($hButton_Actor_Prev, "Actor_Prev")
	Global $hButton_Actor_Next = GUICtrlCreateButton("> Próximo", 670, 555, 110, 22)
	GUICtrlSetOnEvent($hButton_Actor_Next, "Actor_Next")
	Global $hButton_Actor_Delete = GUICtrlCreateButton("- Remover", 150, 555, 110, 22)
	GUICtrlSetOnEvent($hButton_Actor_Delete, "Actor_Del")
	Global $hButton_Actor_BBB = GUICtrlCreateButton("+ Novo", 550, 555, 110, 22)
	GUICtrlSetOnEvent($hButton_Actor_BBB, "Actor_Action_B")

	Global $hButton_Actor_AAA = GUICtrlCreateButton("/ Editar", 270, 555, 110, 22)
	GUICtrlSetOnEvent($hButton_Actor_AAA, "Actor_Action_A")

	Global $hLabel_Actor = GUICtrlCreateLabel("", 390, 555, 150, 22, $SS_SUNKEN + $SS_CENTER)

	Actor_Set()
EndFunc   ;==>Tab_Actor

Func Actor_Prev()
	$ACTOR[0] -= 1
	If $ACTOR[0] <= 0 Then $ACTOR[0] = $ACTOR[1]
	Actor_Set()
EndFunc   ;==>Actor_Prev

Func Actor_Next()
	$ACTOR[0] += 1
	If $ACTOR[0] > $ACTOR[1] Then $ACTOR[0] = 1
	Actor_Set()
EndFunc   ;==>Actor_Next

Func Actor_Action_A()
	ConsoleWrite("Func Actor_Action_A() > " & $ACTOR_MODE[0])
	Switch $ACTOR_MODE[0]
		Case 0
			$ACTOR_MODE[0] = 1
			Actor_UnLock()
			GUICtrlSetData($hButton_Actor_AAA, "Salvar")
			GUICtrlSetData($hButton_Actor_BBB, "! Cancelar")
		Case 1
			_ArrayAdd($aActor, _Actor_Fields_Read())
			$ACTOR[1] = UBound($aActor, 1)
			$ACTOR[0] = $ACTOR[1] ? $ACTOR[1] : 0
			Actor_Set()
			$GAME.Item("actor") = $aActor
			Game_Update()
		Case 2
		Case 4
			$ACTOR_MODE[0] = 0
			$ACTOR[0] = $ACTOR_MODE[1]
			Actor_Mode_Reset()
			Actor_Set()
	EndSwitch
	ConsoleWrite("  > " & $ACTOR_MODE[0] & @CRLF)
EndFunc   ;==>Actor_Action_A

Func Actor_Action_B()
	ConsoleWrite("Func Actor_Action_B() > " & $ACTOR_MODE[0])
	Switch $ACTOR_MODE[0]
		Case 0
			Actor_UnLock()
			$ACTOR_MODE[0] = 4
			$ACTOR_MODE[1] = $ACTOR[0]
			ConsoleWrite("id[ " & $ACTOR[0] & " ]" & @LF)
			GUICtrlSetData($hButton_Actor_BBB, "! Salvar")
			GUICtrlSetData($hButton_Actor_AAA, "! Cancelar")
			Actor_Set(1)
			GUICtrlSetState($hInput_Actor_Name, $GUI_FOCUS)
			GUICtrlSetData($hLabel_Actor, $ACTOR[1] + 1 & "/" & $ACTOR[1] + 1)
		Case 1
			Actor_Mode_Reset()
		Case 2

		Case 4
			_ArrayDisplay($aActor)
			$ACTOR_MODE[0] = 0
			_ArrayAdd($aActor, _Actor_Fields_Read())
			$ACTOR[1] = UBound($aActor, 1)
			$ACTOR[0] = $ACTOR[1] ? $ACTOR[1] : 0
			Actor_Set()
			$GAME.Item("actor") = $aActor
			Game_Update()
			Actor_Lock()
			_ArrayDisplay($aActor)
	EndSwitch
	ConsoleWrite("  > " & $ACTOR_MODE[0] & @CRLF)
EndFunc   ;==>Actor_Action_B

Func Actor_Del()
	_ArrayDelete($aActor, $ACTOR_ID)
	$ACTOR[1] = UBound($aActor, 1)
	$ACTOR[0] = $ACTOR[1] ? $ACTOR[1] : 0
	Actor_Set()
	$GAME.Item("actor") = $aActor
	Game_Update()
EndFunc   ;==>Actor_Del

Func Actor_Mode_Reset()
	Actor_Lock()
	GUICtrlSetData($hButton_Actor_AAA, "/ Editar")
	GUICtrlSetData($hButton_Actor_BBB, "+ Novo")
	$ACTOR_MODE[0] = 0
EndFunc   ;==>Actor_Mode_Reset

Func Actor_UnLock()
	GUICtrlSetState($hInput_Actor_Name, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_HpMax, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_HpCurrent, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_Speed, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_Image, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_Gold, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_Xp, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_Sound_Hit, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_Sound_Death, $GUI_ENABLE)
	GUICtrlSetState($hInput_Actor_Sound_Born, $GUI_ENABLE)
EndFunc   ;==>Actor_UnLock

Func Actor_Lock()
	GUICtrlSetState($hInput_Actor_Name, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_HpMax, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_HpCurrent, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_Speed, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_Image, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_Gold, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_Xp, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_Sound_Hit, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_Sound_Death, $GUI_DISABLE)
	GUICtrlSetState($hInput_Actor_Sound_Born, $GUI_DISABLE)
EndFunc   ;==>Actor_Lock



Func _Actor_Fields_Read()
	Local $oo = ObjCreate($SD)
	$oo.Add("name", GUICtrlRead($hInput_Actor_Name))
	$oo.Add("hp_max", GUICtrlRead($hInput_Actor_HpMax))
	$oo.Add("hp_current", GUICtrlRead($hInput_Actor_HpCurrent))
	$oo.Add("speed", GUICtrlRead($hInput_Actor_Speed))
	$oo.Add("image", GUICtrlRead($hInput_Actor_Image))
	$oo.Add("gold", GUICtrlRead($hInput_Actor_Gold))
	$oo.Add("xp", GUICtrlRead($hInput_Actor_Xp))
	$oo.Add("sound_hit", GUICtrlRead($hInput_Actor_Sound_Hit))
	$oo.Add("sound_death", GUICtrlRead($hInput_Actor_Sound_Death))
	$oo.Add("sound_born", GUICtrlRead($hInput_Actor_Sound_Born))
	Return $oo
EndFunc   ;==>_Actor_Fields_Read

Func _Actor_Fields_Clear()
	GUICtrlSetData($hInput_Actor_Name, "")
	GUICtrlSetData($hInput_Actor_HpMax, "")
	GUICtrlSetData($hInput_Actor_HpCurrent, "")
	GUICtrlSetData($hInput_Actor_Speed, "")
	GUICtrlSetData($hInput_Actor_Image, "")
	GUICtrlSetData($hInput_Actor_Gold, "")
	GUICtrlSetData($hInput_Actor_Xp, "")
	GUICtrlSetData($hInput_Actor_Sound_Hit, "")
	GUICtrlSetData($hInput_Actor_Sound_Death, "")
	GUICtrlSetData($hInput_Actor_Sound_Born, "")
EndFunc   ;==>_Actor_Fields_Clear

Func Actor_Image()
	ConsoleWrite("Actor_Image( " & $ACTOR_ID & " )" & @LF)
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)

	If $ACTOR_ID And FileExists(@ScriptDir & "\images\" & ($aActor[$ACTOR_ID]).Item("image")) Then
		Local $hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\" & ($aActor[$ACTOR_ID]).Item("image"))
	Else
		Local $hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\empty.png")
	EndIf
	_GDIPlus_GraphicsDrawImageRect($hBackbuffer, $hImage, 0, 0, 32, 32)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 200, 0, 32, 32)
EndFunc   ;==>Actor_Image

Func Actor_Set($cmd = 0)
	If $ACTOR_ID Then
		GUICtrlSetData($hInput_Actor_Name, ($aActor[$ACTOR_ID]).Item("name"))
		GUICtrlSetData($hInput_Actor_HpMax, ($aActor[$ACTOR_ID]).Item("hp_max"))
		GUICtrlSetData($hInput_Actor_HpCurrent, ($aActor[$ACTOR_ID]).Item("hp_current"))
		GUICtrlSetData($hInput_Actor_Speed, ($aActor[$ACTOR_ID]).Item("speed"))
		GUICtrlSetData($hInput_Actor_Image, ($aActor[$ACTOR_ID]).Item("image"))
		GUICtrlSetData($hInput_Actor_Gold, ($aActor[$ACTOR_ID]).Item("gold"))
		GUICtrlSetData($hInput_Actor_Xp, ($aActor[$ACTOR_ID]).Item("xp"))
		GUICtrlSetData($hInput_Actor_Sound_Hit, ($aActor[$ACTOR_ID]).Item("sound_hit"))
		GUICtrlSetData($hInput_Actor_Sound_Death, ($aActor[$ACTOR_ID]).Item("sound_death"))
		GUICtrlSetData($hInput_Actor_Sound_Born, ($aActor[$ACTOR_ID]).Item("sound_born"))
	Else
		_Actor_Fields_Clear()
	EndIf
	Actor_Image()
	GUICtrlSetData($hLabel_Actor, $ACTOR[0] & "/" & $ACTOR[1])
EndFunc   ;==>Actor_Set

Func Game_Update()
	Local $str = jsmn_encode($GAME)
	Local $hFile = FileOpen($FILE_NAME, $FO_OVERWRITE + $FO_UTF8_NOBOM)
	FileWrite($hFile, $str)
	FileClose($hFile)
EndFunc   ;==>Game_Update

Func Actor_Image_GetFile()
	Local $sFileOpenDialog = FileOpenDialog("Escolha a imagen", @ScriptDir & "\images\", "Imagens (*.png)", $FD_FILEMUSTEXIST + $FD_PATHMUSTEXIST)
	Local $sDrive, $sDir, $sFileName, $sExtesion
	If @error Then
		GUICtrlSetData($hInput_Actor_Image, "")
	Else
		_PathSplit($sFileOpenDialog, $sDrive, $sDir, $sFileName, $sExtesion)
		GUICtrlSetData($hInput_Actor_Image, $sFileName & $sExtesion)
	EndIf
	Local $arr = $aActor[$ACTOR_ID]
	$arr.Item("image") = $sFileName & $sExtesion
	$aActor[$ACTOR_ID] = $arr
	Actor_Image()
EndFunc   ;==>Actor_Image_GetFile

Func Actor_Sound_GetFile()
	Local $sFileOpenDialog = FileOpenDialog("Escolha o som", @ScriptDir & "\sounds\", "Sons (*.wav;*.mp3)", $FD_FILEMUSTEXIST + $FD_PATHMUSTEXIST)
	Local $sDrive, $sDir, $sFileName, $sExtesion
	If @error Then
		GUICtrlSetData(@GUI_CtrlId, "")
	Else
		_PathSplit($sFileOpenDialog, $sDrive, $sDir, $sFileName, $sExtesion)
		GUICtrlSetData(@GUI_CtrlId, $sFileName & $sExtesion)
	EndIf

	Local $label = GUICtrlRead(@GUI_CtrlId - 1)
	$label = StringReplace($label, " ", "_")
	$label = StringLower($label)

	Local $arr = $aActor[$ACTOR_ID]
	$arr.Item($label) = $sFileName & $sExtesion
	$aActor[$ACTOR_ID] = $arr
EndFunc   ;==>Actor_Sound_GetFile

Func Actor_Sount_Play()
	ConsoleWrite("id[ " & @GUI_CtrlId & " ] id-1[ " & GUICtrlRead(@GUI_CtrlId - 1) & " ]" & @LF)
	Local $sound = _BASS_StreamCreateFile(False, @ScriptDir & "\sounds\" & GUICtrlRead(@GUI_CtrlId - 1), 0, 0, 0)
	_BASS_ChannelPlay($sound, 1)
EndFunc   ;==>Actor_Sount_Play

Func CreateInput($type = 0, $value = 0, $label = 0, $xx = 0, $yy = 0, $ww = 80, $hh = 22, $iStyle = -1, $iExStyle = -1)
	Local $hLabel = GUICtrlCreateLabel($label, $xx, $yy, $ww, 10, Default, $WS_EX_TRANSPARENT)
	GUICtrlSetFont($hLabel, 8.5, 500, 0, $FONT)
	Local Enum $IMAGEN = 1, $sound

	If BitAND($type, $IMAGEN) Then
		Local $hInput = GUICtrlCreateButton($value, $xx, $yy + 12, $ww, $hh, $iStyle, $iExStyle)
		GUICtrlSetOnEvent($hInput, "Actor_Image_GetFile")
	ElseIf BitAND($type, $sound) Then
		Local $hInput = GUICtrlCreateButton($value, $xx, $yy + 12, $ww, $hh, $iStyle, $iExStyle)
		GUICtrlSetOnEvent($hInput, "Actor_Sound_GetFile")
		Local $hPlay = GUICtrlCreateButton(">", $xx + $ww + 10, $yy + 12, $hh, $hh)
		GUICtrlSetOnEvent($hPlay, "Actor_Sount_Play")
	Else
		Local $hInput = GUICtrlCreateInput($value, $xx, $yy + 12, $ww, $hh, $iStyle, $iExStyle)
	EndIf

	If BitAND($type, 8) Then
		GUICtrlSetState($hInput, $GUI_DISABLE)
	EndIf

	Return $hInput
EndFunc   ;==>CreateInput

Func OnExit()
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
;~ 	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	_BASS_Free()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	If $ACTOR_MODE[0] Then
		Actor_Mode_Reset()
	Else
		Exit
	EndIf
EndFunc   ;==>Quit
