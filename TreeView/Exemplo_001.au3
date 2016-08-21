#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GuiTreeView.au3>
#include <TreeViewConstants.au3>
#include <GuiMenu.au3>
#include <WinAPI.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>

#include <GUICreateEx.au3>
#include <JSMN.au3>
#include <object_dump.au3>

#cs
	Exemplo de uso com TreeView
	Implementando/refatorando código...

	Autor: Luismar Chechelaky
#ce

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

OnAutoItExitRegister("OnExit")

HotKeySet("{F2}", "Key_Edit_Start")

Global $KEY_EDIT = False

Global $ID = 0

Global Const $SQLITE_DLL = _SQLite_Startup("sqlite3.dll", False, 0)
Global $DB = _SQLite_Open("base.db", $SQLITE_OPEN_READWRITE + $SQLITE_OPEN_CREATE, $SQLITE_ENCODING_UTF8)
Global $SQL

Global $hGui, $hTreeView, $Context, $hMenu
Global Enum $ONE = 0, $TWO, $TREE
Global $aName[3] = ["A", "B", "C"]
Global $a_TreeView[3]
Global $ah_TreeView[3]
Global $hTreeView_Focus, $TreeView_ID
Global $hTreeView_Focus_Item_Handle, $hTreeView_Focus_Item_Text, $hTreeView_Focus_Item_Param
Global $hLable_TreeView_Focus_Handle, $hLabel_TreeView_Focus_Text, $hLabel_TreeView_Focus_Param

Global $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)


$hGui = GUICreateEx("TreeView", 1266, 668); , 550, 0)
_GUICreateEx_SetShortCut("KEY_EDIT", "Key_Edit_End")

$a_TreeView[$ONE] = _GUICtrlTreeView_Create($hGui, 10, 10, 300, 450, $iStyle, $WS_EX_CLIENTEDGE)
$ah_TreeView[$ONE] = ControlGetHandle($hGui, "", $a_TreeView[$ONE])

$a_TreeView[$TWO] = _GUICtrlTreeView_Create($hGui, 10 + 410, 10, 300, 450, $iStyle, $WS_EX_CLIENTEDGE)
$ah_TreeView[$TWO] = ControlGetHandle($hGui, "", $a_TreeView[$TWO])

$a_TreeView[$TREE] = _GUICtrlTreeView_Create($hGui, 10 + 820, 10, 300, 450, $iStyle, $WS_EX_CLIENTEDGE)
$ah_TreeView[$TREE] = ControlGetHandle($hGui, "", $a_TreeView[$TREE])

$hLable_TreeView_Focus_Handle = GUICtrlCreateLabel("", 10, 470, 80, 20, $SS_SUNKEN)
$hLabel_TreeView_Focus_Text = GUICtrlCreateLabel("", 10, 500, 80, 20, $SS_SUNKEN)
$hLabel_TreeView_Focus_Param = GUICtrlCreateLabel("", 10, 530, 80, 20, $SS_SUNKEN)

Global $hParent, $hItem

For $ii = 0 To 2
	$ID += 1
	_GUICtrlTreeView_BeginUpdate($a_TreeView[$ii])
	$hParent = _GUICtrlTreeView_Add($a_TreeView[$ii], 0, "root")
	_GUICtrlTreeView_SetItemParam($a_TreeView[$ii], $hParent, $ID)
	For $jj = 0 To 9
		$ID += 1
		$hItem = _GUICtrlTreeView_AddChild($a_TreeView[$ii], $hParent, $aName[$ii] & $jj)
		_GUICtrlTreeView_SetItemParam($a_TreeView[$ii], $hItem, $ID)
		_GUICtrlTreeView_Expand($a_TreeView[$ii], $hItem)
	Next
	_GUICtrlTreeView_EndUpdate($a_TreeView[$ii])
Next

Global $aButtons[4] = [3, 0, 0, 0]

Global $iDummy = GUICtrlCreateDummy()
$Context = GUICtrlCreateContextMenu($iDummy)
$hMenu = GUICtrlGetHandle($Context)
$aButtons[1] = GUICtrlCreateMenuItem("Add", $Context)
GUICtrlSetOnEvent($aButtons[1], "Add")
$aButtons[2] = GUICtrlCreateMenuItem("Rename", $Context)
GUICtrlSetOnEvent($aButtons[2], "Rename")
$aButtons[3] = GUICtrlCreateMenuItem("Del", $Context)
GUICtrlSetOnEvent($aButtons[3], "Del")

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetState(@SW_SHOW, $hGui)

While Sleep(20)

WEnd

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	OnExit
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func OnExit()
	_SQLite_Shutdown()
EndFunc   ;==>OnExit

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	Key_Edit_Start
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func Key_Edit_Start()
	ConsoleWrite("Key_Edit_Start()" & @LF)
	$hItem = _GUICtrlTreeView_GetSelection($hTreeView_Focus)
	$KEY_EDIT = True
	HotKeySet("{ENTER}", "Key_Edit_Confirm")

	_GUICtrlTreeView_EditText($hTreeView_Focus, $hItem)
EndFunc   ;==>Key_Edit_Start

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	Key_Edit_End
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func Key_Edit_End()
	ConsoleWrite("Key_Edit_End()" & @LF)
	HotKeySet("{ENTER}")
	$KEY_EDIT = False
	_GUICtrlTreeView_EndEdit($hTreeView_Focus)
EndFunc   ;==>Key_Edit_End

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	Key_Edit_Confirm
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; source.........: http://azjio.narod.ru/autoit3_docs/libfunctions/_guictrltreeview_endedit.htm
; ===============================================================================================================================
Func Key_Edit_Confirm()
	Local $hFocus = _GUICtrlTreeView_GetSelection($hTreeView_Focus)
	Local $hEdit = _GUICtrlTreeView_GetEditControl($hTreeView_Focus)
	_GUICtrlTreeView_SetText($hTreeView_Focus, $hItem, ControlGetText($hGui, "", $hEdit))
	HotKeySet("{ENTER}")
	$KEY_EDIT = False
	_GUICtrlTreeView_EndEdit($hTreeView_Focus)
EndFunc   ;==>Key_Edit_Confirm

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	Add
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func Add()
	ConsoleWrite("Add" & @LF)

	$ID += 1
	Local $h_Item
	$hItem = _GUICtrlTreeView_GetSelection($hTreeView_Focus)
	If $hItem = 0x00000000 Then
		$h_Item = _GUICtrlTreeView_AddChildFirst($hTreeView_Focus, $hItem, $aName[$TreeView_ID] & $ID)
	Else
		$h_Item = _GUICtrlTreeView_AddChild($hTreeView_Focus, $hItem, $aName[$TreeView_ID] & $ID)
	EndIf
	ConsoleWrite("$hTreeView[ " & $hTreeView_Focus & " ] $hItem[ " & $hItem & " ]" & @LF)
	Local $item = _GUICtrlTreeView_SetItemParam($hTreeView_Focus, $h_Item, $ID)
	ConsoleWrite("item[" & $item & "] $ID[ " & $ID & " ]" & @LF)

	_GUICtrlTreeView_Expand($hTreeView_Focus, $hItem)

EndFunc   ;==>Add

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	Rename
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func Rename()
	ConsoleWrite("Rename" & @LF)
EndFunc   ;==>Rename

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	Del
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func Del()
	ConsoleWrite("Del" & @LF)

	$hItem = _GUICtrlTreeView_GetSelection($hTreeView_Focus)
	ConsoleWrite("$hItem[ " & $hItem & " ] text[ " & _GUICtrlTreeView_GetText($hTreeView_Focus, $hItem) & " ]" & @LF)

;~ 	Local $sText = _GUICtrlTreeView_GetText($hTreeView_Focus, $hFocus)
;~ 	Local $iParam = _GUICtrlTreeView_GetItemParam($a_TreeView[$ID], $hFocus)

	Local $oo = oo()

	_DelRecursive($hItem, $oo)
	For $each In $oo
		_GUICtrlTreeView_Delete($hTreeView_Focus, $each)
	Next
	dump($oo)
EndFunc   ;==>Del

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	_DelRecursive
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func _DelRecursive($handle, ByRef $oo)
	Local $sText = _GUICtrlTreeView_GetText($hTreeView_Focus, $handle)
	Local $iParam = _GUICtrlTreeView_GetItemParam($hTreeView_Focus, $handle)
	Local $oItem = oo()
	$oItem.Add("name", $sText)
	$oItem.Add("param", $iParam)
	Local $hChild
	If _GUICtrlTreeView_GetChildren($hTreeView_Focus, $handle) Then
		$hChild = _GUICtrlTreeView_GetFirstChild($hTreeView_Focus, $handle)
		Do
;~ 			If _GUICtrlTreeView_GetChildren($hTreeView_Focus, $hChild) Then
			_DelRecursive($hChild, $oo)
;~ 			EndIf
			$hChild = _GUICtrlTreeView_GetNextChild($hTreeView_Focus, $hChild)
		Until $hChild = 0
	EndIf
	$oo.Add(Number($handle), $oItem)
EndFunc   ;==>_DelRecursive

;~ Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
;~ 	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $selitem

;~ 	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
;~ 	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
;~ 	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
;~ 	$iCode = DllStructGetData($tNMHDR, "Code")
;~ 	Switch $hWndFrom
;~ 		Case $a_TreeView[$ONE]
;~ 			Switch $iCode
;~ 				Case $NM_RCLICK
;~ 					$clickPos = _WinAPI_GetMousePos(True, $hGui)
;~ 					$selitem = _GUICtrlTreeView_HitTestItem($a_TreeView[$ONE], DllStructGetData($clickPos, "X"), DllStructGetData($clickPos, "Y")-10)
;~ 					If $selitem = 0 Then Return $GUI_RUNDEFMSG
;~ 					_GUICtrlTreeView_SelectItem($a_TreeView[$ONE], $selitem)

;~ 					_GUICtrlMenu_TrackPopupMenu($hMenu, $hGui)
;~ 			EndSwitch
;~ 	EndSwitch

;~ 	Return $GUI_RUNDEFMSG
;~ EndFunc   ;==>WM_NOTIFY

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	_GuiCtrlTreeView_FixFocus
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func _GuiCtrlTreeView_FixFocus($ID, $item = 0)
	ConsoleWrite("_GuiCtrlTreeView_FixFocus()" & @LF)

	Local $hFocus = $item ? $item : _GUICtrlTreeView_GetSelection($a_TreeView[$ID])
	Local $sText = _GUICtrlTreeView_GetText($a_TreeView[$ID], $hFocus)
	Local $iParam = _GUICtrlTreeView_GetItemParam($a_TreeView[$ID], $hFocus)

	GUICtrlSetData($hLable_TreeView_Focus_Handle, $aName[$ID])
	GUICtrlSetData($hLabel_TreeView_Focus_Text, $sText)
	GUICtrlSetData($hLabel_TreeView_Focus_Param, $iParam)

EndFunc   ;==>_GuiCtrlTreeView_FixFocus

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	_GuiCtrlTreeView_EvalAction
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func _GuiCtrlTreeView_EvalAction($ID, $tNMHDR, $hWndFrom, $iIDFrom, $iCode, $lParam)
	$TreeView_ID = $ID
	GUICtrlSetData($hLable_TreeView_Focus_Handle, $aName[$ID])
	$hTreeView_Focus = $ah_TreeView[$ID]
	Switch $iCode
		Case $NM_CLICK ; The user has clicked the left mouse button within the control
			_DebugPrint("$NM_CLICK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					"-->Code:" & @TAB & $iCode)
			; Return 1 ; nonzero to not allow the default processing
			Return 0 ; zero to allow the default processing
		Case $NM_DBLCLK ; The user has double-clicked the left mouse button within the control
			_DebugPrint("$NM_DBLCLK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					"-->Code:" & @TAB & $iCode)
			; Return 1 ; nonzero to not allow the default processing
			Return 0 ; zero to allow the default processing
		Case $NM_RCLICK ; The user has clicked the right mouse button within the control
			_DebugPrint("$NM_RCLICK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					"-->Code:" & @TAB & $iCode)
			; Return 1 ; nonzero to not allow the default processing
			_GUICtrlTreeView_SelectItem($hTreeView_Focus, $hTreeView_Focus_Item_Handle)
			_GuiCtrlTreeView_FixFocus($ID, $hTreeView_Focus_Item_Handle)
			_GUICtrlMenu_TrackPopupMenu($hMenu, $hGui)
			Return 0 ; zero to allow the default processing
		Case $NM_RDBLCLK ; The user has double-clicked the right mouse button within the control
			_DebugPrint("$NM_RDBLCLK" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					"-->Code:" & @TAB & $iCode)
			; Return 1 ; nonzero to not allow the default processing
			Return 0 ; zero to allow the default processing
		Case $NM_KILLFOCUS ; control has lost the input focus
			_DebugPrint("$NM_KILLFOCUS" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					"-->Code:" & @TAB & $iCode)
			; No return value
		Case $NM_RETURN ; control has the input focus and that the user has pressed the key
			_DebugPrint("$NM_RETURN" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					"-->Code:" & @TAB & $iCode)
			; Return 1 ; nonzero to not allow the default processing
			Return 0 ; zero to allow the default processing
		Case $NM_SETCURSOR ; control is setting the cursor in response to a WM_SETCURSOR message
			Local $tInfo = DllStructCreate($tagNMMOUSE, $lParam)
			$hWndFrom = HWnd(DllStructGetData($tInfo, "hWndFrom"))
			$iIDFrom = DllStructGetData($tInfo, "IDFrom")
			$iCode = DllStructGetData($tInfo, "Code")

			$hTreeView_Focus_Item_Handle = DllStructGetData($tInfo, "ItemSpec")
			$hTreeView_Focus_Item_Text = _GUICtrlTreeView_GetText($hTreeView_Focus, $hTreeView_Focus_Item_Handle)
			$hTreeView_Focus_Item_Param = _GUICtrlTreeView_GetItemParam($hTreeView_Focus, $hTreeView_Focus_Item_Handle)


			_DebugPrint("$NM_SETCURSOR" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					"-->Code:" & @TAB & $iCode & @CRLF & _
					"-->ItemSpec:" & @TAB & DllStructGetData($tInfo, "ItemSpec") & @CRLF & _
					"-->ItemData:" & @TAB & DllStructGetData($tInfo, "ItemData") & @CRLF & _
					"-->X:" & @TAB & DllStructGetData($tInfo, "X") & @CRLF & _
					"-->Y:" & @TAB & DllStructGetData($tInfo, "Y") & @CRLF & _
					"-->HitInfo:" & @TAB & DllStructGetData($tInfo, "HitInfo"))
			; Return 0 ; to enable the control to set the cursor
			Return 1 ; nonzero to prevent the control from setting the cursor
		Case $NM_SETFOCUS ; control has received the input focus
			_DebugPrint("$NM_SETFOCUS" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					"-->Code:" & @TAB & $iCode)
			; No return value
		Case $TVN_BEGINDRAGA, $TVN_BEGINDRAGW
			_DebugPrint("$TVN_BEGINDRAG")
		Case $TVN_BEGINLABELEDITA, $TVN_BEGINLABELEDITW
			_DebugPrint("$TVN_BEGINLABELEDIT")
		Case $TVN_BEGINRDRAGA, $TVN_BEGINRDRAGW
			_DebugPrint("$TVN_BEGINRDRAG")
		Case $TVN_DELETEITEMA, $TVN_DELETEITEMW
			_DebugPrint("$TVN_DELETEITEM")
		Case $TVN_ENDLABELEDITA, $TVN_ENDLABELEDITW

			ConsoleWrite("Edit Control Handle: 0x" & Hex(_GUICtrlTreeView_GetEditControl($hTreeView_Focus)) & @CRLF & _
					"IsPtr = " & IsPtr(_GUICtrlTreeView_GetEditControl($hTreeView_Focus)) & " IsHWnd = " & IsHWnd(_GUICtrlTreeView_GetEditControl($hTreeView_Focus)))

			Local $tInfo = DllStructCreate($tagNMTVDISPINFO, $lParam)
			Local $sBuffer = DllStructCreate("wchar Text[" & DllStructGetData($tInfo, "TextMax"))
			ConsoleWrite("$sBuffer[ " & $sBuffer & " ]" & @LF)
			If Not _GUICtrlTreeView_GetUnicodeFormat($hWndFrom) Then $sBuffer = StringTrimLeft($sBuffer, 1)
			ConsoleWrite("$sBuffer[ " & $sBuffer & " ]" & @LF)
			DllStructSetData($sBuffer, "Text", DllStructGetData($tInfo, "Text"))

			If StringLen(DllStructGetData($sBuffer, "Text")) Then Return 1


			_DebugPrint("$TVN_ENDLABELEDIT $sBuffer[ " & $sBuffer & " ]")
		Case $TVN_GETDISPINFOA, $TVN_GETDISPINFOW
			_DebugPrint("$TVN_GETDISPINFO")
		Case $TVN_GETINFOTIPA, $TVN_GETINFOTIPW
			_DebugPrint("$TVN_GETINFOTIP")
		Case $TVN_ITEMEXPANDEDA, $TVN_ITEMEXPANDEDW
			_DebugPrint("$TVN_ITEMEXPANDED")
		Case $TVN_ITEMEXPANDINGA, $TVN_ITEMEXPANDINGW
			_DebugPrint("$TVN_ITEMEXPANDING")
		Case $TVN_KEYDOWN
			_DebugPrint("$TVN_KEYDOWN")
		Case $TVN_SELCHANGEDA, $TVN_SELCHANGEDW
			_GuiCtrlTreeView_FixFocus($ID)
			_DebugPrint("$TVN_SELCHANGED")
		Case $TVN_SELCHANGINGA, $TVN_SELCHANGINGW
			_DebugPrint("$TVN_SELCHANGING")
		Case $TVN_SETDISPINFOA, $TVN_SETDISPINFOW
			_DebugPrint("$TVN_SETDISPINFO")
		Case $TVN_SINGLEEXPAND
			_DebugPrint("$TVN_SINGLEEXPAND")
	EndSwitch
EndFunc   ;==>_GuiCtrlTreeView_EvalAction

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:
; Author ........:
; Modified.......:
; Link ..........:
; ===============================================================================================================================
Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $lParam
	Local $tNMHDR, $hWndFrom, $iIDFrom, $iCode

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $ah_TreeView[$ONE]
			_GuiCtrlTreeView_EvalAction($ONE, $tNMHDR, $hWndFrom, $iIDFrom, $iCode, $lParam)
		Case $ah_TreeView[$TWO]
			_GuiCtrlTreeView_EvalAction($TWO, $tNMHDR, $hWndFrom, $iIDFrom, $iCode, $lParam)
		Case $ah_TreeView[$TREE]
			_GuiCtrlTreeView_EvalAction($TREE, $tNMHDR, $hWndFrom, $iIDFrom, $iCode, $lParam)
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	_DebugPrint
; Author ........:
; Modified.......:	2
; Link ..........:
; ===============================================================================================================================
Func _DebugPrint($s_Text, $sLine = @ScriptLineNumber)
	Return
	ConsoleWrite( _
			"!===========================================================" & @CRLF & _
			"+======================================================" & @CRLF & _
			"-->Line(" & StringFormat("%04d", $sLine) & "):" & @TAB & $s_Text & @CRLF & _
			"+======================================================" & @CRLF)
EndFunc   ;==>_DebugPrint

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	oo
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 17:00
; Link ..........:
; ===============================================================================================================================
Func oo()
	Return ObjCreate($SD)
EndFunc   ;==>oo
