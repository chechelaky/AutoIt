#include <GUIConstantsEx.au3>
#include <GuiMenu.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Global Enum $e_GuiOpen = 1000, $e_GuiSave, $e_GuiInfo, $e_TvAdd
Global $hGui, $iTreeView, $hTreeView

Example()

Func Example()
	; Create GUI
	$hGui = GUICreate("Menu", 400, 300)
	ConsoleWrite("$hGui[" & $hGui & "] IsPtr[" & IsPtr($hGui) & "]" & @LF)

	$iTreeView = GUICtrlCreateTreeView(10, 10, 120, 240)
	ConsoleWrite("$iTreeView[" & $iTreeView & "] IsPtr[" & IsPtr($iTreeView) & "]" & @LF)
	$hTreeView = GUICtrlGetHandle($iTreeView)
	ConsoleWrite("$hTreeView[" & $hTreeView & "] IsPtr[" & IsPtr($hTreeView) & "]" & @LF)
	GUISetState(@SW_SHOW)

	; Register message handlers
	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
	GUIRegisterMsg($WM_CONTEXTMENU, "WM_CONTEXTMENU")

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Handle WM_COMMAND messages
Func WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $lParam
	ConsoleWrite("WM_COMMAND( $hWnd=" & $hWnd & ", $iMsg=" & $iMsg & ", $wParam=" & $wParam & ", $lParam=" & $lParam & ")" & @LF)
	Switch $wParam
		Case $e_GuiOpen
			_WinAPI_ShowMsg("Gui Open")
		Case $e_GuiSave
			_WinAPI_ShowMsg("Gui Save")
		Case $e_GuiInfo
			_WinAPI_ShowMsg("Gui Info")
		Case $e_TvAdd
			_WinAPI_ShowMsg("TreeView Add")
	EndSwitch
EndFunc   ;==>WM_COMMAND

; Handle WM_CONTEXTMENU messages
Func WM_CONTEXTMENU($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $lParam
	Local $hMenu = _GUICtrlMenu_CreatePopup()
	Local $iNotify = 0
	Switch $wParam
		Case $hGui
			_GUICtrlMenu_InsertMenuItem($hMenu, 0, "GUI Open", $e_GuiOpen)
			_GUICtrlMenu_InsertMenuItem($hMenu, 1, "GUI Save", $e_GuiSave)
			_GUICtrlMenu_InsertMenuItem($hMenu, 3, "", 0)
			_GUICtrlMenu_InsertMenuItem($hMenu, 3, "GUI Info", $e_GuiInfo)
			_GUICtrlMenu_TrackPopupMenu($hMenu, $wParam)
		Case $hTreeView
			_GUICtrlMenu_InsertMenuItem($hMenu, 0, "TreeView Add", $e_TvAdd)
			$iNotify = _GUICtrlMenu_TrackPopupMenu($hMenu, $wParam, -1, -1, 1, 1, 2)
			_SendMessage($hGui, 273, $iNotify, 0)
	EndSwitch
	_GUICtrlMenu_DestroyMenu($hMenu)
	Return True
EndFunc   ;==>WM_CONTEXTMENU
