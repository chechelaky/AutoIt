;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
#include <GuiComboBoxEx.au3>

OnAutoItExitRegister("OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $aGuiSize[2] = [510, 380]
Global $sGuiTitle = "GuiTitle"
Global $hGui
Global $iListView1, $iListView2
Global $hListView1, $hListView2

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")

$iListView1 = GUICtrlCreateListView("Nome", 10, 10, 240, 360)
$hListView1 = GUICtrlGetHandle($iListView1)
_GUICtrlListView_SetColumnWidth($iListView1, 0, 235)
GUICtrlCreateListViewItem("aaa", $iListView1)
GUICtrlCreateListViewItem("bbb", $iListView1)
GUICtrlCreateListViewItem("ccc", $iListView1)
GUICtrlCreateListViewItem("ddd", $iListView1)
GUICtrlCreateListViewItem("eee", $iListView1)

$iListView2 = GUICtrlCreateListView("Nome", 260, 10, 240, 360)
$hListView2 = GUICtrlGetHandle($iListView2)
_GUICtrlListView_SetColumnWidth($iListView2, 0, 235)

GUISetState(@SW_SHOW, $hGui)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

While Sleep(25)
WEnd

Func OnExit()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	Exit
EndFunc   ;==>Quit

Func ListViewMove($from, $to, $mode = False) ; true = insert / false = delete
	Local $index = _GUICtrlListView_GetHotItem($from)
	If $index = -1 Then Return
	Local $text = _GUICtrlListView_GetItemText($from, $index)
	_GUICtrlListView_DeleteItem($from, $index)
	_GUICtrlListView_AddItem($to, $text)
	Local $bSort = False
	_GUICtrlListView_SimpleSort($to, $bSort, 0)
	$bSort = False
	_GUICtrlListView_SimpleSort($from, $bSort, 0)
EndFunc   ;==>ListViewMove

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $tInfo

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hListView1
			Switch $iCode
				Case $NM_DBLCLK
					ListViewMove($hListView1, $hListView2, True)
			EndSwitch

		Case $hListView2
			Switch $iCode
				Case $NM_DBLCLK
					ListViewMove($hListView2, $hListView1, False)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
