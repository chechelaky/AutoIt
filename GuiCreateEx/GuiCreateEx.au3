#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

OnAutoItExitRegister("_GUICreateEx_Quit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)
Opt("WinWaitDelay", 0)

#Region FORM
Global $__FORM = 0, $g_hGuiCreateEx_RUN = False
Global Enum $FORM_FIELD = 0, $FORM_NAME, $FORM_VALUE, $FORM_DEFAULT, $FORM_TYPE, $FORM_HANDLE
Global Enum $g_hGuiCreateEx_FORM_STRING = 0, $g_hGuiCreateEx_TYPE_NUMBER
Global $g_hGuiCreateEx_FORM_HANDLE = 0, $g_hGuiCreateEx_FORM_MODE = False, $g_hGuiCreateEx_FORM_BASE = 0
Global $g_hGuiCreateEx_FORM_FONT = "DOSLike"
#EndRegion FORM

Global Enum $g_hGuiCreateEx_HANDLE = 0, $g_hGuiCreateEx_PARENT, $g_hGuiCreateEx_EXECUTE_ON_SUCCESS, $g_hGuiCreateEx_SHORTCUT
Global $g__aNODES[1][5] = [[0]]

; #FUNCTION# ====================================================================================================================
; Name...........:	GUICreateEx
; Description ...:	Allow create a new GUI (Graphic User Interface) above current GUI and lock previus GUI
; Syntax.........:	same way of GuiCreate
; Parameters ....:	$sTitle.......: Title's GUI
;					$iWidth.......:	width's GUI
;					$iHeight......: height's GUI
;					$iLeft........:	left position's GUI
; 					$iTop.........: top position's GUI
;					$mStyle.......:	Style's GUI
;					$mExStyle.....:	Extended Style's GUI
;					$iParent......: The handle of another previously created window
; Return values .:	a windows handle
; Author ........:	Luismar Chechelaky
; Modified.......:	2015/06/20 11:25
; Remarks .......:
; Related .......:
; Link ..........:	https://github.com/chechelaky/AutoIt/raw/master/GuiCreateEx/GuiCreateEx.au3
; Example .......:
; ===============================================================================================================================
Func GUICreateEx($sTitle = "", $iWidth = 460, $iHeight = 360, $iLeft = -1, $iTop = -1, $mStyle = Default, $mExStyle = Default, $iParent = 0, $sExecuteOnSuccess = False)
	Local $hGui = GUICreate($sTitle, $iWidth, $iHeight, $iLeft, $iTop, $mStyle, $mExStyle, $iParent)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_GUICreateEx_Quit", $hGui)
	If $iParent Then GUISetState(@SW_DISABLE, $iParent)
	_ArrayAdd2D($g__aNODES, $hGui, $iParent, $sExecuteOnSuccess)
	Return $hGui
EndFunc   ;==>GUICreateEx

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	_GUICreateEx_Quit
; Author ........:	Luismar Chechelaky
; Modified.......:	2019/10/20 09:03
; Link ..........:	https://github.com/chechelaky/AutoIt/raw/master/GuiCreateEx/GuiCreateEx.au3
; ===============================================================================================================================
Func _GUICreateEx_Quit()
	Local $last = UBound($g__aNODES, 1) - 1
	If $g__aNODES[$last][$g_hGuiCreateEx_SHORTCUT] Then HotKeySet($g__aNODES[$last][$g_hGuiCreateEx_SHORTCUT])
	GUISetState(@SW_HIDE, $g__aNODES[$last][$g_hGuiCreateEx_HANDLE])
	GUIDelete($g__aNODES[$last][$g_hGuiCreateEx_HANDLE])
	_ArrayDelete($g__aNODES, $last)
	$last -= 1
	If $last > 0 Then
		GUISetState(@SW_ENABLE, $g__aNODES[$last][$g_hGuiCreateEx_HANDLE])
		WinActivate($g__aNODES[$last][$g_hGuiCreateEx_HANDLE])
		GUISwitch($g__aNODES[$last][$g_hGuiCreateEx_HANDLE])
	EndIf
EndFunc   ;==>_GUICreateEx_Quit

Func _GUICreateEx_ExecuteOnSuccess()
	Local $last = UBound($g__aNODES, 1) - 1
	If $g__aNODES[$last][$g_hGuiCreateEx_EXECUTE_ON_SUCCESS] Then Call($g__aNODES[$last][$g_hGuiCreateEx_EXECUTE_ON_SUCCESS], $__FORM)
EndFunc   ;==>_GUICreateEx_ExecuteOnSuccess

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:	_GUICreateEx_SetShortCut
; Author ........:	Luismar Chechelaky
; Modified.......:	2016/08/21 07:30
; Link ..........:	https://github.com/chechelaky/AutoIt/raw/master/GuiCreateEx/GuiCreateEx.au3
; ===============================================================================================================================
Func _GUICreateEx_SetShortCut($hGui, $sKey, $sFunction)
	Local $iSearch = _ArraySearch($g__aNODES, $hGui, 1, Default, 0, 0, 0, $g_hGuiCreateEx_HANDLE)
	If @error Then Return
	$g__aNODES[$iSearch][$g_hGuiCreateEx_SHORTCUT] = $sKey
	HotKeySet($sKey, $sFunction)
EndFunc   ;==>_GUICreateEx_SetShortCut

#Region FORM
Func Form_SetFont($input = "DOSLike")
	$g_hGuiCreateEx_FORM_FONT = $input
EndFunc   ;==>Form_SetFont

Func Form($hGui, $FORM, ByRef $BASE, $ExecuteOnExit = False)
	$g_hGuiCreateEx_FORM_MODE = $FORM[0][2] = "CREATE" ? False : True
	$__FORM = $FORM
	$g_hGuiCreateEx_FORM_BASE = $BASE

	$g_hGuiCreateEx_FORM_HANDLE = GUICreateEx("Form1", 640, 140, -1, -1, Default, Default, $hGui, $ExecuteOnExit)
	GUISwitch($g_hGuiCreateEx_FORM_HANDLE)
	GUICtrlCreateGroup("", 10, 10, 620, 110)
	_GUICreateEx_SetShortCut($g_hGuiCreateEx_FORM_HANDLE, "{ENTER}", $FORM[0][1] & "_Form_Key")

	Local $hLabel1 = GUICtrlCreateLabel($__FORM[1][$FORM_NAME], 20, 26, 80, 12)
	GUICtrlSetBkColor($hLabel1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont($hLabel1, 7, 400, 0, $g_hGuiCreateEx_FORM_FONT)

	$__FORM[1][$FORM_HANDLE] = GUICtrlCreateInput($__FORM[1][($g_hGuiCreateEx_FORM_MODE ? $FORM_VALUE : $FORM_DEFAULT)], 20, 40, (UBound($__FORM, 1) = 3 ? 420 : 600), 26)
	GUICtrlSetFont($__FORM[1][$FORM_HANDLE], 14, 400, 0, $g_hGuiCreateEx_FORM_FONT)

	If UBound($__FORM, 1) = 3 Then
		Local $hLabel2 = GUICtrlCreateLabel($__FORM[2][$FORM_NAME], 460, 26, 80, 12)
		GUICtrlSetBkColor($hLabel2, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont($hLabel2, 7, 400, 0, $g_hGuiCreateEx_FORM_FONT)

		$__FORM[2][$FORM_HANDLE] = GUICtrlCreateInput($__FORM[2][($g_hGuiCreateEx_FORM_MODE ? $FORM_VALUE : $FORM_DEFAULT)], 460, 40, 160, 26, $ES_RIGHT)
		GUICtrlSetFont($__FORM[2][$FORM_HANDLE], 14, 400, 0, $g_hGuiCreateEx_FORM_FONT)
	EndIf

	Local $hButton1 = GUICtrlCreateButton("Limpar", 20, 80, 120, 25)
	GUICtrlSetOnEvent($hButton1, "_Form_Clean")
	GUICtrlSetFont($hButton1, 12, 400, 0, $g_hGuiCreateEx_FORM_FONT)

	Local $hButton2 = GUICtrlCreateButton("Cancelar", 360, 80, 120, 25)
	GUICtrlSetOnEvent($hButton2, "_Form_Close")
	GUICtrlSetFont($hButton2, 12, 400, 0, $g_hGuiCreateEx_FORM_FONT)

	Local $hButton3 = GUICtrlCreateButton("Salvar", 500, 80, 120, 25)
	GUICtrlSetOnEvent($hButton3, "_Form_Save")
	GUICtrlSetFont($hButton3, 12, 400, 0, $g_hGuiCreateEx_FORM_FONT)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW, $g_hGuiCreateEx_FORM_HANDLE)
EndFunc   ;==>Form

Func _Form_Clean()
	For $ii = 1 To $__FORM[0][0]
		GUICtrlSetData($__FORM[$ii][$FORM_HANDLE], $__FORM[$ii][$FORM_DEFAULT])
	Next
EndFunc   ;==>_Form_Clean

Func _Form_Close()
	_GUICreateEx_Quit()
	$g_hGuiCreateEx_FORM_HANDLE = 0
	$g_hGuiCreateEx_FORM_BASE = 0
	$g_hGuiCreateEx_RUN = False
EndFunc   ;==>_Form_Close

Func _Form_Read()
	For $ii = 1 To $__FORM[0][0]
		Switch $__FORM[$ii][$FORM_TYPE]
			Case $g_hGuiCreateEx_FORM_STRING
				$__FORM[$ii][$FORM_VALUE] = String(GUICtrlRead($__FORM[$ii][$FORM_HANDLE]))
			Case $g_hGuiCreateEx_TYPE_NUMBER
				$__FORM[$ii][$FORM_VALUE] = Number(GUICtrlRead($__FORM[$ii][$FORM_HANDLE]))
		EndSwitch
	Next
EndFunc   ;==>_Form_Read

Func _Form_Query()
	Local $sRet
	Local $arr1[1], $arr2[1]
	Switch $g_hGuiCreateEx_FORM_MODE
		Case False
			For $ii = 1 To $__FORM[0][0]
				_ArrayAdd($arr1, $__FORM[$ii][$FORM_FIELD])
				Switch $__FORM[$ii][$FORM_TYPE]
					Case $g_hGuiCreateEx_FORM_STRING
;~ 						$__FORM[$ii][$FORM_VALUE] = _SQLite_FastEscape($__FORM[$ii][$FORM_VALUE])
					Case $g_hGuiCreateEx_TYPE_NUMBER
				EndSwitch
				_ArrayAdd($arr2, $__FORM[$ii][$FORM_VALUE])
			Next
			If $__FORM[0][3] Then
				_ArrayAdd($arr1, $__FORM[0][3])
				_ArrayAdd($arr2, $__FORM[0][4])
			EndIf
			$sRet = "INSERT INTO " & $__FORM[0][1] & "(" & _ArrayToString($arr1, ",", 1) & ")VALUES(" & _ArrayToString($arr2, ",", 1) & ");"
		Case True
			For $ii = 1 To $__FORM[0][0]
				Switch $__FORM[$ii][$FORM_TYPE]
					Case $g_hGuiCreateEx_FORM_STRING
;~ 						$__FORM[$ii][$FORM_VALUE] = _SQLite_FastEscape($__FORM[$ii][$FORM_VALUE])
					Case $g_hGuiCreateEx_TYPE_NUMBER
				EndSwitch
				_ArrayAdd($arr1, $__FORM[$ii][$FORM_FIELD] & "=" & $__FORM[$ii][$FORM_VALUE])
			Next
			$sRet = "UPDATE " & $__FORM[0][1] & " SET " & _ArrayToString($arr1, ",", 1) & " WHERE " & $__FORM[0][5] & "=" & $__FORM[0][6] & ";"
	EndSwitch
	Return $sRet
EndFunc   ;==>_Form_Query

Func _Form_Save()
	_Form_Read()
	_GUICreateEx_ExecuteOnSuccess()
	$__FORM = 0
	_Form_Close()
EndFunc   ;==>_Form_Save
#EndRegion FORM
