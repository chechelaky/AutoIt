;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

; #SCRIPT# ====================================================================================================================
; Name ..........: Words's note
; Description ...: Create a text note over a word's list
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Luismar Chechelaky
; Example .......:
; ===============================================================================================================================

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GDIPlus.au3>
#include <GuiListView.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>

Global Const $RED = 0xFFB1B1, $YELLOW = 0xFFFFB1, $GREEN = 0xB1FFB1, $ORANGE = 0xFFDEB1, $WHITE = 0xFFFFFF

;~ #include <Object_dump.au3>

Global $hButton_Next, $hButton_Forward, $hButton_Bind, $hButton_UnBind, $hButton_Edit, $hButton_Save, $hButton_Delete, $hNote
Global $hLabelAssoc

Global $SQL
Global Const $SQLITE_DLL = _SQLite_Startup("sqlite3.dll", False, 0)
Global $DB = _SQLite_Open("base.db", $SQLITE_OPEN_READWRITE + $SQLITE_OPEN_CREATE, $SQLITE_ENCODING_UTF8)
Base_Start()

Global $sFont = '11|700|0|Courier New'
Global $aFont = StringSplit($sFont, '|', 3)

OnAutoItExitRegister("OnExit")
Global Const $SD = "Scripting.Dictionary"


Global $texto = "I have big eyes and oftentimes " & _
		"I let my mouth droop open to reveal " & _
		"my front teeth. It is the look of dumb. " & _
		"I see how they process my looks. My " & _
		"teachers nervously confront my face " & _
		"when they fear someone may get left behind, " & _
		"after introducing x and y."

;~ Global $texto = "um um dois três três três quatro quatro um cinco dois oito nome dez um"

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)


Global $aGuiSize[2] = [1266, 600]
Global $sGuiTitle = "GuiTitle"
Global $hGui, $hListView

Global $oo = ObjCreate("Scripting.Dictionary")
$oo.Add("keyword", oo())
$oo.Item("keyword").Add("confront", 0xFF7979)
$oo.Item("keyword").Add("process", 0xFF7979)
$oo.Item("keyword").Add("eyes", 0xFF7979)

Global $oSel = oo()
Global $oWord = oo()

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1], 100, 0)
GUISetBkColor(0xF4F399, $hGui)
GUISetFont(11, 400, 0, "Courier New", $hGui)
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
;~ $hListView = GUICtrlCreateListView("nome", 800, 10, 300, 580)
$hListView = _GUICtrlListView_Create($hGui, "Nome", 960, 10, 300, 580)
_GUICtrlListView_SetColumnWidth($hListView, 0, 299)

$hLabelAssoc = GUICtrlCreateLabel("", 10, 300, 780, 30, $SS_SUNKEN)
$hNote = GUICtrlCreateEdit("", 10, 330, 780, 210, $SS_SUNKEN)

;~ $hButton_Next, $hButton_Forward, $hButton_Bind, $hButton_UnBind
$hButton_Forward = GUICtrlCreateButton("Forward", 790, 10, 80, 20)
GUICtrlSetOnEvent($hButton_Forward, "Note_Forward")
$hButton_Next = GUICtrlCreateButton("Next", 870, 10, 80, 20)
GUICtrlSetOnEvent($hButton_Next, "Note_Next")
$hButton_UnBind = GUICtrlCreateButton("UnBind", 790, 40, 80, 20)
GUICtrlSetOnEvent($hButton_UnBind, "Note_UnBind")
$hButton_Bind = GUICtrlCreateButton("Bind", 870, 40, 80, 20)
GUICtrlSetOnEvent($hButton_Bind, "Note_Bind")

$hButton_Edit = GUICtrlCreateButton("Edit", 870, 70, 80, 20)
GUICtrlSetOnEvent($hButton_Edit, "Note_Edit")

$hButton_Save = GUICtrlCreateButton("Save", 870, 100, 80, 20)
GUICtrlSetOnEvent($hButton_Save, "Note_Save")

$hButton_Delete = GUICtrlCreateButton("Delete", 790, 100, 80, 20)
GUICtrlSetOnEvent($hButton_Delete, "Note_Delete")

Words($texto)

GUISetState(@SW_SHOW, $hGui)

Func NewArr($index)
	Local $arr[1] = [$index]
	Return $arr
EndFunc   ;==>NewArr

Func Note_Forward()
	ConsoleWrite("Note_Forward" & @LF)
EndFunc   ;==>Note_Forward

Func Note_Next()
	ConsoleWrite("Note_Next" & @LF)
EndFunc   ;==>Note_Next

Func Note_UnBind()
	ConsoleWrite("Note_UnBind" & @LF)
EndFunc   ;==>Note_UnBind

Func Note_Bind()
;~ 	ConsoleWrite("Note_Bind" & @LF)

	Local $arr[2]
	$arr[0] = _SQLite_FastEscape(GUICtrlRead($hLabelAssoc))
	$arr[1] = _SQLite_FastEscape(GUICtrlRead($hNote))
	Local $dados = _ArrayToString($arr, ",")
	$SQL = "INSERT OR REPLACE INTO mensagem(id,frase,nota)VALUES((SELECT id FROM mensagem WHERE frase=" & $arr[0] & ")," & $dados & ");"
	Local $ret = _Base_Execute($SQL)
	ConsoleWrite("$ret[ " & $ret & " ]" & @LF)

	ConsoleWrite("Note_Bind." & $SQL & @LF)
EndFunc   ;==>Note_Bind

Func Note_Delete()
	ConsoleWrite("Note_Delete" & @LF)
	Local $frase = GUICtrlRead($hLabelAssoc)
EndFunc   ;==>Note_Delete

Func Note_Save()
	ConsoleWrite("Note_Save" & @LF)
	Local $frase = GUICtrlRead($hLabelAssoc)
EndFunc   ;==>Note_Save


Func Note_Edit()
	ConsoleWrite("Note_Edit" & @LF)
	Local $frase = GUICtrlRead($hLabelAssoc)
EndFunc   ;==>Note_Edit



Func Words($input)
	Local $iHeight = 21
	Local $iYY = 10, $iXX = 10
	Local $len, $filter

	While StringInStr($input, "  ")
		$input = StringReplace($input, "  ", " ")
	WEnd
	Local $aWords = StringSplit($input, " ", 2)
	Local $handle, $arr

	For $ii = 0 To UBound($aWords, 1) - 1
		If $iYY > 700 Then
			$iYY = 10
			$iXX += $iHeight
		EndIf
		$filter = Filter($aWords[$ii])
		$len = _StringWidth($aWords[$ii])
		If $oo.Item("keyword").Exists($filter) Then
			$handle = GUICtrlCreateLabel($aWords[$ii], $iYY, $iXX, $len, 20, $SS_CENTER)
			GUICtrlSetBkColor($handle, $oo.Item("keyword").Item($aWords[$ii]))
		Else
			$handle = GUICtrlCreateLabel($aWords[$ii], $iYY, $iXX, $len, 20, $SS_CENTER)
			If $oWord.Exists($filter) Then
				$arr = $oWord.Item($filter)
				_ArrayAdd($arr, $handle)
				$oWord.Item($filter) = $arr
			Else
				$oWord.Add($filter, NewArr($handle))
			EndIf
			GUICtrlSetOnEvent(-1, "OnClick")
		EndIf
		$iYY += $len
	Next
EndFunc   ;==>Words

Func OnClick()
	Local $arr, $item
	Local $aSequence[1]
	Local $word = Filter(GUICtrlRead(@GUI_CtrlId))
	ConsoleWrite("OnClick[" & @GUI_CtrlId & "] word[" & $word & "]" & @LF)
	If $oSel.Exists($word) Then
		$item = _GUICtrlListView_FindInText($hListView, $word)
		_GUICtrlListView_DeleteItem($hListView, $item)
		$oSel.Remove($word)
		$arr = $oWord.Item($word)
		For $ii = 0 To UBound($arr, 1) - 1
			GUICtrlSetBkColor($arr[$ii], 0xF0F0F0)
		Next
	Else
		$item = _GUICtrlListView_AddItem($hListView, $word)

		$oSel.Add($word, $item)
		$arr = $oWord.Item($word)
		For $ii = 0 To UBound($arr, 1) - 1
			GUICtrlSetBkColor($arr[$ii], 0xA0A0A0)
		Next
	EndIf

	Local $BOOLEAN = False
	_GUICtrlListView_SimpleSort($hListView, $BOOLEAN, 0, True)
	For $each In $oSel
		_ArrayAdd($aSequence, $each)
	Next
	_ArraySort($aSequence, 0, 1)
	$aSequence = _ArrayToString($aSequence, "|", 1)

	GUICtrlSetData($hLabelAssoc, $aSequence)
	Note_Search($aSequence)
;~ 	dump($oSel)
EndFunc   ;==>OnClick

Func Note_Search($sString)
	ConsoleWrite("Note_Search[ " & $sString & " ]" & @LF)
	$sString = _SQLite_FastEscape($sString)
	$SQL = "SELECT nota FROM mensagem WHERE frase=" & $sString & ";"

	Local $arr = _Base_GetTable($SQL)
	If @error Then
		ConsoleWrite("@error" & @LF)
	Else
		ConsoleWrite("Ubound[" & UBound($arr, 1) & "]" & @LF)
		If UBound($arr, 1) - 1 Then
			ConsoleWrite("UBound" & @LF)
			GUICtrlSetBkColor($hNote, $WHITE)
			GUICtrlSetData($hNote, $arr[1][0])
;~ 			dump($arr)
		Else
			ConsoleWrite("Else" & @LF)
			GUICtrlSetBkColor($hNote, $ORANGE)
			GUICtrlSetData($hNote, "")
;~
		EndIf
	EndIf
EndFunc   ;==>Note_Search

While Sleep(25)
WEnd

Func OnExit()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	_SQLite_Shutdown()
	Exit
EndFunc   ;==>Quit

Func Filter($input)
	$input = StringLower($input)
	$input = StringRegExpReplace($input, "[áàãâä]", "a")
	$input = StringRegExpReplace($input, "[éèêë]", "e")
	$input = StringRegExpReplace($input, "[íìïî]", "i")
	$input = StringRegExpReplace($input, "[óòöõô]", "o")
	$input = StringRegExpReplace($input, "[óòöõô]", "u")
	$input = StringRegExpReplace($input, "[ç]", "c")
	$input = StringRegExpReplace($input, "[^a-z0-9\.\-\_\:]", "_")
	Return $input
EndFunc   ;==>Filter


; #FUNCTION# ====================================================================================================================
; Name ..........: GUICtrlGetBkColor
; Description ...: Retrieves the RGB value of the control background.
; Syntax ........: GUICtrlGetBkColor($hWnd)
; Parameters ....: $hWnd                - Control ID/Handle to the control
; Return values .: Success - RGB value
;                  Failure - 0
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func GUICtrlGetBkColor($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $hDC = _WinAPI_GetDC($hWnd)
	Local $iColor = _WinAPI_GetPixel($hDC, 0, 0)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	Return $iColor
EndFunc   ;==>GUICtrlGetBkColor

; #FUNCTION# ====================================================================================================================
; Name ..........: _StringWidth
; Description ...: Return the Width of a Label containing the given string
; Syntax ........: _StringWidth($sString)
; Parameters ....: $sString             - A string value.
; Return values .: Width in px
; Author ........: minx
; modified ......: autoBert
; ===============================================================================================================================
Func _StringWidth($sString)
	Local $hHGUI = GUICreate($sString, 0, 0)
	GUISetFont($aFont[0], $aFont[1], $aFont[2], $aFont[3], $hHGUI)
	GUISetState(@SW_HIDE, $hHGUI)
	Local $Ref = GUICtrlCreateButton($sString, 0, 0)
	Local $aPos = ControlGetPos($hHGUI, "", $Ref)
	GUIDelete($hHGUI)
	Return $aPos[2] + 2 ;+8 is for borders
EndFunc   ;==>_StringWidth


Func _Base_GetTable($sSQL)
	ConsoleWrite("_Base_GetTable[ $sSQL=" & $sSQL & " ]" & @LF)
	Local $aResult, $iRows, $iColumns, $iRval
	$iRval = _SQLite_GetTable2d($DB, $sSQL, $aResult, $iRows, $iColumns)
	If $iRval = $SQLITE_OK Then Return $aResult
	ConsoleWrite("_Base_GetTable.@error.Code[" & _SQLite_ErrCode($DB) & "] Msg[" & _SQLite_ErrMsg($DB) & "]" & @LF)
	Return SetError(1, 0, 0)
EndFunc   ;==>_Base_GetTable

Func Base_Start()
	$SQL = "PRAGMA foreign_keys=ON"
	If Not _Base_Execute($SQL) Then Return SetError(1, 0, 0)
	$SQL = "CREATE TABLE IF NOT EXISTS mensagem(id INTEGER PRIMARY KEY AUTOINCREMENT,frase TEXT NOT NULL UNIQUE,nota TEXT);"
	If Not _Base_Execute($SQL) Then Return SetError(2, 0, 0)
	Return True
EndFunc   ;==>Base_Start

Func _Base_Execute($SQL)
	If _SQLite_Exec($DB, $SQL) == $SQLITE_OK Then
		Return True
	Else
		ConsoleWrite("SQLite.Execute.Error[" & _SQLite_ErrCode($DB) & "] Msg[" & _SQLite_ErrMsg($DB) & "]" & @LF)
		Return False
	EndIf
EndFunc   ;==>_Base_Execute

Func oo()
	Return ObjCreate($SD)
EndFunc   ;==>oo
