; #SCRIPT# ======================================================================================================================
; Name ..........: MyTreeView
; Description ...: TreeView com persistência em SQLite
; Author ........: Luigi (Luismar Chechelaky)
; Link ..........: 
; ===============================================================================================================================

;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#Include <GUIConstants.au3>
#include <GuiTreeView.au3>
#include <WindowsConstants.au3>
#include <GuiMenu.au3>
#include <StaticConstants.au3>
#include <TreeViewConstants.au3>
#include <WinAPI.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <File.au3>
#include <FontConstants.au3>
#include <GuiListView.au3>
#include <EditConstants.au3>
#include <ListViewConstants.au3>
#include <GuiImageList.au3>
#include <GuiComboBox.au3>
#include <WinAPIvkeysConstants.au3>

OnAutoItExitRegister("OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)
Opt("WinWaitDelay", 1)
Global $DEBUG = True
Global $PID = 1
Global Const $INI = @ScriptDir & "\config.ini"
Global $CONFIG[2][2] = [[2, ""], ["icon_path", @ScriptDir & "\icon"]]

Global Enum $e_TreeAdd = 1000, $e_TreeDel, $e_Icon_A, $e_Icon_B, $e_Icon_C, $e_Icon_D

Global $ITEM, $ITEM_TEXT, $ITEM_PARAM, $ITEM_PARENT, $ITEM_PARENT_PARAM, $TREE_VIEW_HANDLE, $TREE_VIEW_GID, $ITEM_EDIT, $B_ITEM_EDIT = False, $ITEM_CLASS_DEFAULT = 3

Global Const $SQLITE_DLL = _SQLite_Startup("sqlite3.dll", False, 0)
Global $hDB = _SQLite_Open("base.db", $SQLITE_OPEN_READWRITE + $SQLITE_OPEN_CREATE, $SQLITE_ENCODING_UTF8)


Global $hContextMenu_TreeView_Item = _GUICtrlMenu_CreatePopup()
Global $hContextMenu_TreeView_Item2 = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Item, 0, "Add", $e_TreeAdd)
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Item, 1, "Delete", $e_TreeDel)
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Item, 3, "", 0)
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Item, 3, "Class", 0, $hContextMenu_TreeView_Item2)
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Item2, 0, "icon A", $e_Icon_A)
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Item2, 1, "icon B", $e_Icon_B)
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Item2, 2, "icon C", $e_Icon_C)
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Item2, 3, "icon D", $e_Icon_D)
Global $hContextMenu_TreeView_Root = _GUICtrlMenu_CreatePopup()
_GUICtrlMenu_InsertMenuItem($hContextMenu_TreeView_Root, 0, "Add", $e_TreeAdd)


Global $aGuiSize[2] = [1266, 600]
Global $hGui

Global Enum $eGID = 0, $eHANDLE, $eNAME, $eSEQ

Global $TREE1[9]
Global $TREE2[9]
Global $LIST1[9]

$LIST1[$eNAME] = "Class"

Global $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)

Global $iExStyle = Default

Global $hMenu, $hMenu_Class

Global Enum $__HANDLE = 0, $__PARENT, $__EXECUTE_ON_SUCCESS, $__SHORTCUT
Global $g__aNODES[1][5] = [[0]]

Global $hButton

$hGui = GUICreateEx("TreeView", $aGuiSize[0], $aGuiSize[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")


$hMenu = GUICtrlCreateMenu("Config")
$hMenu_Class = GUICtrlCreateMenuItem("Class", $hMenu)

$TREE1[$eGID] = GUICtrlCreateTreeView(10, 90, 300, 400, $iStyle, $iExStyle)
$TREE1[$eHANDLE] = GUICtrlGetHandle($TREE1[$eGID])
$TREE1[$eNAME] = "TreeView1"

$TREE2[$eGID] = GUICtrlCreateTreeView(320, 90, 300, 400, $iStyle, $iExStyle)
$TREE2[$eHANDLE] = GUICtrlGetHandle($TREE2[$eGID])
$TREE2[$eNAME] = "TreeView2"



Base_Start()
GuiCtrlTreeView_Populate($TREE1)
GuiCtrlTreeView_Populate($TREE2)

;~ Populate()

GUISetState()

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

While Sleep(25)
WEnd

Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
	Local $iIDFrom = BitAND($wParam, 0xFFFF)
	Local $iCode = BitShift($wParam, 16)
	ConsoleWrite("WM_COMMAND $iIDFrom[ " & $iIDFrom & " ] $iCode[ " & $iCode & " ]" & @LF)
	Switch $wParam
		Case $e_TreeAdd
			_TreeView_Item_Add()
		Case $e_TreeDel
			_TreeView_Del()
		Case $e_Icon_A
			_TreeView_Item_Update_Icon(3)
		Case $e_Icon_B
			_TreeView_Item_Update_Icon(5)
		Case $e_Icon_C
			_TreeView_Item_Update_Icon(7)
		Case $e_Icon_D
			_TreeView_Item_Update_Icon(9)
		Case 1 ; ENTER
			If $B_ITEM_EDIT Then _TreeView_Item_Edit_End()
		Case $hMenu_Class
			Gui_Class()
		Case $hButton
			ConsoleWrite("WM_COMMAND[ $hButton ]" & @LF)
		Case Else
			ConsoleWrite("WM_COMMAND[" & $wParam & "]" & @LF)
	EndSwitch
EndFunc   ;==>WM_COMMAND

Func Gui_Block()

EndFunc

Func Gui_UnBlock()
EndFunc

Func Gui_Class()
	Local $hGuiClass = GUICreateEx("Class", 800, 500, -1, -1, Default, Default, $hGui)
	$hButton = GUICtrlCreateButton("teste", 10, 10, 80, 20)


EndFunc

Func GUICreateEx($sTitle = "", $iWidth = 460, $iHeight = 360, $iLeft = -1, $iTop = -1, $mStyle = Default, $mExStyle = Default, $iParent = 0, $sExecuteOnSuccess = False)
	Local $hGuiNew = GUICreate($sTitle, $iWidth, $iHeight, $iLeft, $iTop, $mStyle, $mExStyle, $iParent)
	GUISetFont(12, 400, 0, "DOSLike", $hGuiNew)

	GUISetOnEvent($GUI_EVENT_CLOSE, "_GUICreateEx_Quit", $hGuiNew)
	If $iParent Then GUISetState(@SW_DISABLE, $iParent)
	_ArrayAdd2D($g__aNODES, $hGuiNew, $iParent, $sExecuteOnSuccess)

	GUISetState(@SW_SHOW, $hGuiNew)
	GUISwitch($hGuiNew)
	Return $hGuiNew
EndFunc   ;==>GUICreateEx

Func _GUICreateEx_Quit()
;~ 	_ArrayDisplay($g__aNODES)
	Local $last = UBound($g__aNODES, 1) - 1
;~ 	If $g__aNODES[$last][$__SHORTCUT] Then HotKeySet($g__aNODES[$last][$__SHORTCUT])
	GUISetState(@SW_HIDE, $g__aNODES[$last][$__HANDLE])
	GUIDelete($g__aNODES[$last][$__HANDLE])
	_ArrayDelete($g__aNODES, $last)

	$last -= 1
	If $last Then
		WinActivate($g__aNODES[$last][$__HANDLE])
		GUISetState(@SW_ENABLE, $g__aNODES[$last][$__HANDLE])
	EndIf
	GUISwitch($g__aNODES[$last][$__HANDLE])
EndFunc   ;==>_GUICreateEx_Quit

Func _GuiCtrlTreeView_ItemFocus($hTreeView, $hItem = 0)
	$TREE_VIEW_HANDLE = $hTreeView

	If $hItem Then
		$ITEM = $hItem
	Else
		Local $tMPos = _WinAPI_GetMousePos(True, $hTreeView)
		$ITEM = _GUICtrlTreeView_HitTestItem($hTreeView, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
	EndIf
	If $ITEM Then
		$ITEM_TEXT = _GUICtrlTreeView_GetText($hTreeView, $ITEM)
		$ITEM_PARENT = _GUICtrlTreeView_GetParentHandle($hTreeView, $ITEM)
		$ITEM_PARENT = $ITEM_PARENT ? $ITEM_PARENT : 0
		$ITEM_PARAM = _GUICtrlTreeView_GetItemParam($hTreeView, $ITEM)
		$ITEM_PARENT_PARAM = _GUICtrlTreeView_GetParentParam($hTreeView, $ITEM)
		$ITEM_PARENT_PARAM = $ITEM_PARENT_PARAM ? $ITEM_PARENT_PARAM : 0
	Else
		$ITEM = 0
		$ITEM_TEXT = ""
		$ITEM_PARAM = 0
		$ITEM_PARENT = 0
		$ITEM_PARENT_PARAM = 0
	EndIf
	ConsoleWrite("_GuiCtrlTreeView_ItemFocus . item[" & $ITEM & "] text[" & $ITEM_TEXT & "] param[" & $ITEM_PARAM & "] parent[" & $ITEM_PARENT & "] parent_param[" & $ITEM_PARENT_PARAM & "]" & @LF)
EndFunc   ;==>_GuiCtrlTreeView_ItemFocus

Func _TreeView_Item_Update_Icon($icon)
	_GUICtrlTreeView_SetIcon($TREE_VIEW_GID, $ITEM, "shell32.dll", $icon)
	$icon = Number($icon)
	Local $SQL = "UPDATE " & _TreeView_GetTableName($TREE_VIEW_GID) & " SET class=" & $icon & " WHERE id=" & $ITEM_PARAM & ";"
	_Base_Execute($SQL)
EndFunc   ;==>_TreeView_Item_Update_Icon

Func _TreeView_Item_Add()
	Local $sText = _TreeView_Name()
	Local $hItem
	If $ITEM Then
		$hItem = _GUICtrlTreeView_AddChild($TREE_VIEW_HANDLE, $ITEM, $sText)
	Else
		$hItem = _GUICtrlTreeView_Add($TREE_VIEW_HANDLE, 0, $sText)
	EndIf

	$ITEM_PARENT = $ITEM
	$ITEM_PARENT_PARAM = $ITEM_PARAM
	$ITEM = $hItem
	_SendMessage($TREE_VIEW_HANDLE, $TVM_SELECTITEM, $TVGN_CARET, $ITEM)

	$B_ITEM_EDIT = True
	$ITEM_EDIT = _GUICtrlTreeView_EditText($TREE_VIEW_GID, $ITEM)
	Local $iParam = $ITEM_PARENT_PARAM ? $ITEM_PARENT_PARAM : "Null"
	Local $sName = _SQLite_FastEscape($sText)

	Local $SQL = "INSERT INTO " & _TreeView_GetTableName($TREE_VIEW_HANDLE) & "('name','parent','class')VALUES(" & $sName & "," & $iParam & "," & $ITEM_CLASS_DEFAULT & ");"
	_Base_Execute($SQL)
	$ITEM_PARAM = _SQLite_LastInsertRowID($hDB)
	_GUICtrlTreeView_SetItemParam($TREE_VIEW_GID, $ITEM, $ITEM_PARAM)
EndFunc   ;==>_TreeView_Item_Add

Func _TreeView_GetTableName($hTreeView)
	Switch Number($hTreeView)
		Case Number($TREE1[$eHANDLE]), Number($TREE1[$eGID])
			Return $TREE1[$eNAME]
		Case Number($TREE2[$eHANDLE]), Number($TREE2[$eGID])
			Return $TREE2[$eNAME]
	EndSwitch
EndFunc   ;==>_TreeView_GetTableName

Func _TreeVIew_Rename()
	$B_ITEM_EDIT = True
	$ITEM_EDIT = _GUICtrlTreeView_EditText($TREE_VIEW_HANDLE, $ITEM)
EndFunc

Func _TreeView_Del()
	ConsoleWrite("+_TreeView_Del" & @LF)
	Local $sTableName = _TreeView_GetTableName($TREE_VIEW_HANDLE)
	ConsoleWrite("	$sTableName[" & $sTableName & "]" & @LF)
	Local $SQL = "DELETE FROM " & $sTableName & " WHERE id=" & $ITEM_PARAM & ";"
	_Base_Execute($SQL)
	_GUICtrlTreeView_Delete($TREE_VIEW_HANDLE, $ITEM)
	ConsoleWrite("-_TreeView_Del" & @LF)
EndFunc   ;==>_TreeView_Del

Func _TreeView_Name()
	Return "novo " & $PID
EndFunc   ;==>_TreeView_Name

Func _TreeView_Item_Edit_End()
	ConsoleWrite("_TreeView_Item_Edit_End . item[" & $ITEM & "] text[" & $ITEM_TEXT & "] param[" & $ITEM_PARAM & "] parent[" & $ITEM_PARENT & "] parent_param[" & $ITEM_PARENT_PARAM & "]" & @LF)
	Local $sText = ControlGetText($hGui, "", $ITEM_EDIT)
	$ITEM_EDIT = 0
	ConsoleWrite("$sText[" & $sText & "]" & @LF)
	Local $sTableName = _TreeView_GetTableName($TREE_VIEW_HANDLE)
	ConsoleWrite("$sTableName[" & $sTableName & "]" & @LF)
	Local $SQL = "UPDATE " & $sTableName & " SET name=" & _SQLite_FastEscape($sText) & " WHERE id=" & $ITEM_PARAM & ";"
	ConsoleWrite("$SQL[" & $SQL & "]" & @LF)
	_Base_Execute($SQL)

	_GUICtrlTreeView_SetText($TREE_VIEW_HANDLE, $ITEM, $sText)
	_GUICtrlTreeView_EndEdit($TREE_VIEW_HANDLE)

	$B_ITEM_EDIT = False
EndFunc   ;==>_TreeView_Item_Edit_End

Func _TreeView_Item_Edit_Cancel()
	_GUICtrlTreeView_EndEdit($TREE_VIEW_HANDLE, True)
	$ITEM_EDIT = 0
	$B_ITEM_EDIT = False
EndFunc   ;==>_TreeView_Item_Edit_Cancel


Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")

	Switch $hWndFrom
		Case $TREE1[$eHANDLE]
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
					$TREE_VIEW_GID = $TREE1[$eGID]
					_GuiCtrlTreeView_ItemFocus($hWndFrom)
					_SendMessage($hWndFrom, $TVM_SELECTITEM, $TVGN_CARET, $ITEM)
					_GUICtrlMenu_TrackPopupMenu($ITEM ? $hContextMenu_TreeView_Item : $hContextMenu_TreeView_Root, $hGui)

;~ 					Return 0 ; zero to allow the default processing
;~ 					Return 1 ; nonzero to not allow the default processing
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
					; Case $NM_SETCURSOR ; control is setting the cursor in response to a WM_SETCURSOR message
					; Local $tInfo = DllStructCreate($tagNMMOUSE, $lParam)
					; $hWndFrom = HWnd(DllStructGetData($tInfo, "hWndFrom"))
					; $iIDFrom = DllStructGetData($tInfo, "IDFrom")
					; $iCode = DllStructGetData($tInfo, "Code")
					; _DebugPrint("$NM_SETCURSOR" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					; "-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					; "-->Code:" & @TAB & $iCode & @CRLF & _
					; "-->ItemSpec:" & @TAB & DllStructGetData($tInfo, "ItemSpec") & @CRLF & _
					; "-->ItemData:" & @TAB & DllStructGetData($tInfo, "ItemData") & @CRLF & _
					; "-->X:" & @TAB & DllStructGetData($tInfo, "X") & @CRLF & _
					; "-->Y:" & @TAB & DllStructGetData($tInfo, "Y") & @CRLF & _
					; "-->HitInfo:" & @TAB & DllStructGetData($tInfo, "HitInfo"))
					; Return 0 ; to enable the control to set the cursor
					; Return 1 ; nonzero to prevent the control from setting the cursor
				Case $NM_SETFOCUS ; control has received the input focus
					_GuiCtrlTreeView_ItemFocus($hWndFrom, _GUICtrlTreeView_GetSelection($hWndFrom))
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
					_DebugPrint("$TVN_ENDLABELEDIT")
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
					ConsoleWrite("$hWnd[" & $hWnd & "] $iMsg[" & $iMsg & "] $wParam[" & $wParam & "] $lParam[" & $lParam & "]" & @LF)
					Local $iIDFrom = BitAND($wParam, 0xFFFF)
					Local $iCode = BitShift($wParam, 16)
					ConsoleWrite("$TVN_KEYDOWN $iIDFrom[ " & $iIDFrom & " ] $iCode[ " & $iCode & " ]" & @LF)
					If KeyPressed($VK_F2) And Not $B_ITEM_EDIT Then
						_TreeVIew_Rename()
					EndIf

					If KeyPressed($VK_DELETE) And Not $B_ITEM_EDIT Then
						_TreeView_Del()
					EndIf

					If KeyPressed($VK_INSERT) And Not $B_ITEM_EDIT Then
						ConsoleWrite("############# $VK_INSERT" & @LF)
						_GuiCtrlTreeView_ItemFocus($hWndFrom, _GUICtrlTreeView_GetSelection($hWndFrom))
						_SendMessage($TREE_VIEW_HANDLE, $TVM_SELECTITEM, $TVGN_CARET, $ITEM)

						_TreeView_Item_Add()
					EndIf

				Case $TVN_SELCHANGEDA, $TVN_SELCHANGEDW
					_DebugPrint("$TVN_SELCHANGED")
					_GuiCtrlTreeView_ItemFocus($hWndFrom, _GUICtrlTreeView_GetSelection($hWndFrom))
;~ 					_SendMessage($hWndFrom, $TVM_SELECTITEM, $TVGN_CARET, $ITEM)
				Case $TVN_SELCHANGINGA, $TVN_SELCHANGINGW
;~ 					_GuiCtrlTreeView_ItemFocus($hWndFrom)
					_DebugPrint("$TVN_SELCHANGING")
				Case $TVN_SETDISPINFOA, $TVN_SETDISPINFOW
					_DebugPrint("$TVN_SETDISPINFO")
				Case $TVN_SINGLEEXPAND
					_DebugPrint("$TVN_SINGLEEXPAND")
			EndSwitch


		Case $TREE2[$eHANDLE]
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
					$TREE_VIEW_GID = $TREE2[$eGID]
					_GuiCtrlTreeView_ItemFocus($hWndFrom)
					_SendMessage($hWndFrom, $TVM_SELECTITEM, $TVGN_CARET, $ITEM)
					_GUICtrlMenu_TrackPopupMenu($ITEM ? $hContextMenu_TreeView_Item : $hContextMenu_TreeView_Root, $hGui)

;~ 					Return 0 ; zero to allow the default processing
;~ 					Return 1 ; nonzero to not allow the default processing
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
					; Case $NM_SETCURSOR ; control is setting the cursor in response to a WM_SETCURSOR message
					; Local $tInfo = DllStructCreate($tagNMMOUSE, $lParam)
					; $hWndFrom = HWnd(DllStructGetData($tInfo, "hWndFrom"))
					; $iIDFrom = DllStructGetData($tInfo, "IDFrom")
					; $iCode = DllStructGetData($tInfo, "Code")
					; _DebugPrint("$NM_SETCURSOR" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
					; "-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
					; "-->Code:" & @TAB & $iCode & @CRLF & _
					; "-->ItemSpec:" & @TAB & DllStructGetData($tInfo, "ItemSpec") & @CRLF & _
					; "-->ItemData:" & @TAB & DllStructGetData($tInfo, "ItemData") & @CRLF & _
					; "-->X:" & @TAB & DllStructGetData($tInfo, "X") & @CRLF & _
					; "-->Y:" & @TAB & DllStructGetData($tInfo, "Y") & @CRLF & _
					; "-->HitInfo:" & @TAB & DllStructGetData($tInfo, "HitInfo"))
					; Return 0 ; to enable the control to set the cursor
					; Return 1 ; nonzero to prevent the control from setting the cursor
				Case $NM_SETFOCUS ; control has received the input focus
					_GuiCtrlTreeView_ItemFocus($hWndFrom, _GUICtrlTreeView_GetSelection($hWndFrom))
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
					_DebugPrint("$TVN_ENDLABELEDIT")
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
					ConsoleWrite("$hWnd[" & $hWnd & "] $iMsg[" & $iMsg & "] $wParam[" & $wParam & "] $lParam[" & $lParam & "]" & @LF)
					Local $iIDFrom = BitAND($wParam, 0xFFFF)
					Local $iCode = BitShift($wParam, 16)
					ConsoleWrite("$TVN_KEYDOWN $iIDFrom[ " & $iIDFrom & " ] $iCode[ " & $iCode & " ]" & @LF)
					If KeyPressed($VK_F2) And Not $B_ITEM_EDIT Then
						$B_ITEM_EDIT = True
						$ITEM_EDIT = _GUICtrlTreeView_EditText($hWndFrom, $ITEM)
					EndIf

					If KeyPressed($VK_DELETE) And Not $B_ITEM_EDIT Then
						_TreeView_Del()
					EndIf

					If KeyPressed($VK_INSERT) And Not $B_ITEM_EDIT Then
;~ 							_TreeView_Item_Add()
					EndIf

				Case $TVN_SELCHANGEDA, $TVN_SELCHANGEDW
					_DebugPrint("$TVN_SELCHANGED")
					_GuiCtrlTreeView_ItemFocus($hWndFrom, _GUICtrlTreeView_GetSelection($hWndFrom))
;~ 					_SendMessage($hWndFrom, $TVM_SELECTITEM, $TVGN_CARET, $ITEM)
				Case $TVN_SELCHANGINGA, $TVN_SELCHANGINGW
;~ 					_GuiCtrlTreeView_ItemFocus($hWndFrom)
					_DebugPrint("$TVN_SELCHANGING")
				Case $TVN_SETDISPINFOA, $TVN_SETDISPINFOW
					_DebugPrint("$TVN_SETDISPINFO")
				Case $TVN_SINGLEEXPAND
					_DebugPrint("$TVN_SINGLEEXPAND")
			EndSwitch


	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY


; #FUNCTION# ====================================================================================================================
; Name ..........: KeyPressed
; Description ...:
; Syntax ........: KeyPressed($iHexKey)
; Parameters ....: $iHexKey             - an integer value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func KeyPressed($iHexKey)
	Local $aRet = DllCall("user32.dll", "int", "GetAsyncKeyState", "int", $iHexKey)
;~  If BitAND($aRet[0], 0x8000) Or BitAND($aRet[0], 1) Then Return 1
	If BitAND($aRet[0], 1) Then Return 1
	Return 0
EndFunc   ;==>KeyPressed


Func _DebugPrint($s_Text, $sLine = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @CRLF & _
			"+======================================================" & @CRLF & _
			"-->Line(" & StringFormat("%04d", $sLine) & "):" & @TAB & $s_Text & @CRLF & _
			"+======================================================" & @CRLF)
EndFunc   ;==>_DebugPrint


Func OnExit()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	If $B_ITEM_EDIT Then
		_TreeView_Item_Edit_Cancel()
	Else
		Exit
	EndIf
EndFunc   ;==>Quit


; #FUNCTION# ====================================================================================================================
; Name ..........: Populate
; Description ...:
; Syntax ........: Populate()
; Parameters ....:
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Populate()
	Local $hItem, $hChild
	Local $TREE
	For $ii = 1 To 2
		$TREE = Eval("TREE" & $ii)
		_GUICtrlTreeView_BeginUpdate($TREE[$eHANDLE])
		For $x = 1 To Random(2, 10, 1)
			$hItem = _GUICtrlTreeView_Add($TREE[$eHANDLE], 0, StringFormat($ii & " Parent %02d", $x))
			_GUICtrlTreeView_SetItemParam($TREE[$eHANDLE], $hItem, $PID)
			$PID += 1
			_GUICtrlTreeView_SetIcon($TREE[$eHANDLE], $hItem, "shell32.dll", 3)

			For $y = 1 To Random(2, 10, 1)
				$hChild = _GUICtrlTreeView_AddChild($TREE[$eHANDLE], $hItem, StringFormat($ii & " Child %02d", $y))
				_GUICtrlTreeView_SetItemParam($TREE[$eHANDLE], $hChild, $PID)
				$PID += 1
			Next
		Next
		_GUICtrlTreeView_EndUpdate($TREE[$eHANDLE])
	Next
EndFunc   ;==>Populate


#Region _DB
Func _Base_GetTable($sSQL)
	Local $aRet[2]
	Local $aResult[1], $iRows, $iColumns
	If _SQLite_GetTable2d($hDB, $sSQL, $aResult, $iRows, $iColumns) = $SQLITE_OK Then
		Return $aResult
	Else
		Return SetError(1, 0, $aResult)
	EndIf
EndFunc   ;==>_Base_GetTable

Func Base_Start()
	_Base_Execute("PRAGMA FOREIGN_KEYS=ON;")
	OnAutoItExitRegister("_Base_Quit")

	Local $SQL = "CREATE TABLE IF NOT EXISTS " & $TREE1[$eNAME] & "(" & _
			"id INTEGER PRIMARY KEY AUTOINCREMENT," & _
			"name STRING," & _
			"parent INTEGER," & _
			"class INTEGER DEFAULT 1," & _
			"FOREIGN KEY(parent) REFERENCES " & $TREE1[$eNAME] & "(id) ON DELETE CASCADE" & _
			");"
	_Base_Execute($SQL)

	; $_TREE2
	$SQL = "CREATE TABLE IF NOT EXISTS " & $TREE2[$eNAME] & "(" & _
			"id INTEGER PRIMARY KEY AUTOINCREMENT," & _
			"name STRING," & _
			"parent INTEGER," & _
			"class INTEGER DEFAULT 1," & _
			"FOREIGN KEY(parent) REFERENCES " & $TREE2[$eNAME] & "(id) ON DELETE CASCADE" & _
			");"
	_Base_Execute($SQL)

	$SQL = "CREATE TABLE IF NOT EXISTS " & $LIST1[$eNAME] & "(" & _
		"id INTEGER PRIMARY KEY AUTOINCREMENT," & _
		"name INTEGER," & _
		"icon INTEGER DEFAULT 1" & _
		");"
	_Base_Execute($SQL)

EndFunc   ;==>Base_Start

Func _Base_Quit()
	_SQLite_Close($hDB)
EndFunc   ;==>_Base_Quit

Func _Base_Execute($SQL)
	If _SQLite_Exec($hDB, $SQL) == $SQLITE_OK Then
		If $DEBUG Then
			ConsoleWrite(@TAB & "$SQL..: " & $SQL & @LF)
			ConsoleWrite(@TAB & "Result: @Ok" & @LF)
		EndIf
		Return True
	EndIf ;==>_Base_Execute
	If $DEBUG Then ConsoleWrite(@TAB & "Result: @Error[" & @error & "] ErrCode[" & _SQLite_ErrCode($hDB) & "] ErrMsg[" & _SQLite_ErrMsg($hDB) & "]" & @LF)
	Return False
EndFunc   ;==>_Base_Execute

;~ Func _Base_Insert_Name($sTableName, $id, $sName)
;~ 	Local $SQL = "INSERT INTO " & $sTableName & "_name(name)VALUES(" & _SQLite_FastEscape($sName) & ");"
;~ 	If Not _Base_Execute($SQL) Then Return SetError(1, 0, 0)
;~ 	Return _SQLite_LastInsertRowID()
;~ EndFunc   ;==>_Base_Insert_Name

;~ Func _Base_Insert_Parent($sTableName, $iParam)
;~ 	Local $SQL = "INSERT INTO " & $sTableName & "_obj(parent)VALUES(" & Number($iParam) & ");"
;~ 	If Not _Base_Execute($SQL) Then Return SetError(1, 0, 0)
;~ 	Return _SQLite_LastInsertRowID()
;~ EndFunc   ;==>_Base_Insert_Parent
Func _Base_ExecuteSingle($SQL)
	Local $aRow
	If _SQLite_QuerySingleRow($hDB, $SQL, $aRow) = $SQLITE_OK Then
		Return $aRow[0]
	Else
		If $DEBUG Then ConsoleWrite(@TAB & "Result: @Error[" & @error & "] ErrCode[" & _SQLite_ErrCode($hDB) & "] ErrMsg[" & _SQLite_ErrMsg($hDB) & "]" & @LF)
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_Base_ExecuteSingle

Func _Base_UpdateName($sTableName, $sName, $id)
	; http://www.tutorialspoint.com/sqlite/sqlite_update_query.htm
	; UPDATE table_name SET column1 = value1, column2 = value2...., columnN = valueN WHERE [condition];
	Local $SQL = "UPDATE " & $sTableName & " SET name=" & _SQLite_FastEscape($sName) & " WHERE id=" & $id & ";"
	If $DEBUG Then ConsoleWrite("$SQL[" & $SQL & "]" & @LF)
	If Not _Base_Execute($SQL) Then Return SetError(1, 0, 0)
	Return True
EndFunc   ;==>_Base_UpdateName

Func _Base_Delete($sTableName, $aDel, $iParam = 0)
;~ 	http://www.tutorialspoint.com/sqlite/sqlite_delete_query.htm
	Local $SQL = "DELETE FROM " & $sTableName & "_name WHERE id IN(" & _ArrayToString($aDel, ",", 1, Default) & ");"
;~ 	ConsoleWrite("$SQL[ " & $SQL & " ]" & @LF)
	If Not _Base_Execute($SQL) Then Return SetError(1, 0, 0)



;~ 	 "DELETE FROM artist WHERE artistname = 'Frank Sinatra';"
;~ 	If $sTableName <> "Zabbix2" Then
;~ 		$SQL = "CREATE TABLE IF NOT EXISTS table_values(" & _
;~ 		"id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE," & _
;~ 		"label STRING," & _
;~ 		"value REAL," & _
;~ 		"table_id INTEGER," & _
;~ 		"FOREIGN KEY(table_id) REFERENCES zabbix2_obj(id)" & _
;~ 		");"



;~ 		$SQL = "DELETE FROM table_values WHERE table_id=" & $iParam & ";"

;~ 		ConsoleWrite("$SQL[" & $SQL & "]" & @LF)
;~ 		ConsoleWrite("@error[" & @error & "] ErrCode[" & _SQLite_ErrCode($hDB) & "] ErrMsg[" & _SQLite_ErrMsg($hDB) & "]" & @LF)

;~ 	EndIf
;~ 	$SQL = 'DELETE FROM ' & $sT*ableName & '_obj WHERE id IN(' & _ArrayToString($aDel, ",", 1, Default) & ');'
;~ 		$SQL = 'DELETE FROM ' & $sTableName & '_obj WHERE id=' & $iParam & ';'
;~ 		ConsoleWrite("$SQL[ " & $SQL & " ]" & @LF)
;~ 	If Not _Base_Execute($SQL) Then Return SetError(1, 0, 0)


;~ 	EndIf


	Return True
EndFunc   ;==>_Base_Delete

Func _Base_Close()
	If $hDB Then _SQLite_Close($hDB)
EndFunc   ;==>_Base_Close
#EndRegion _DB


Func GuiCtrlTreeView_Populate(ByRef $ARR)
	Local $hItem
	Local $SQL = "SELECT * FROM " & $ARR[$eNAME] & " ORDER BY parent ASC;"
	Local $aRet = _Base_GetTable($SQL)
	If @error Then Return

	Local $oo = oo()
	Local $hTreeView = $ARR[$eHANDLE]
	_GUICtrlTreeView_BeginUpdate($hTreeView)
	For $xx = 1 To UBound($aRet, 1) - 1
		If $aRet[$xx][2] Then
			$hItem = _GUICtrlTreeView_AddChild($hTreeView, $oo.Item($aRet[$xx][2]), $aRet[$xx][1])
			$oo.Add($aRet[$xx][0], $hItem)
		Else
			$hItem = _GUICtrlTreeView_Add($hTreeView, 0, $aRet[$xx][1])
			$oo.Add($aRet[$xx][0], $hItem)
		EndIf
		_GUICtrlTreeView_SetIcon($hTreeView, $hItem, "shell32.dll", $aRet[$xx][3])
		_GUICtrlTreeView_SetItemParam($hTreeView, $hItem, $aRet[$xx][0])
	Next
	$oo = 0
	_GUICtrlTreeView_Sort($hTreeView)
	_GUICtrlTreeView_EndUpdate($hTreeView)
	_GUICtrlTreeView_SetSelected($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView), False)

EndFunc   ;==>GuiCtrlTreeView_Populate

Func oo()
	Return ObjCreate("Scripting.Dictionary")
EndFunc   ;==>oo


Func _ArrayAdd2D(ByRef $aInput, $mOpt1 = Default, $mOpt2 = Default, $mOpt3 = Default, $mOpt4 = Default, $mOpt5 = Default, $mOpt6 = Default, $mOpt7 = Default, $mOpt8 = Default, $mOpt9 = Default, $mOpt10 = Default)
	$aInput[0][0] = UBound($aInput, 1)
	ReDim $aInput[$aInput[0][0] + 1][UBound($aInput, 2)]
	Local $iCol = @NumParams - 1 < UBound($aInput, 2) ? @NumParams - 1 : UBound($aInput, 2)
	For $ii = 1 To $iCol
		$aInput[$aInput[0][0]][$ii - 1] = Execute("$mOpt" & $ii)
	Next
	Return $aInput[0][0]
EndFunc   ;==>_ArrayAdd2D

Func config_load()
	Local $arr = IniReadSection($INI, "config")
EndFunc

Func config_save()
	IniWriteSection($INI, "config", $CONFIG)
EndFunc
