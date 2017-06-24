#region Header

#CS
	
	Title:          MouseOnEvent UDF
	Filename:       MouseOnEvent.au3
	Description:    Set an events handler (a hook) for Mouse device.
	Author:         G.Sandler a.k.a (Mr)CreatoR (CreatoR's Lab - http://creator-lab.ucoz.ru, http://autoit-script.ru)
	Version:        1.9
	Requirements:   AutoIt v3.3.6.1 +, Developed/Tested on Windows XP (rus) Service Pack 2/3, Win 7, with standard 3-buttons mouse device
	Uses:           WindowsConstants.au3, WinAPI.au3, Timers.au3
	Forum Link:     http://www.autoitscript.com/forum/index.php?showtopic=64738
	Notes:
	1) The original events-messages (such as $WM_MOUSEMOVE) can be used as well.
	2) Blocking $sFuncName function with commands such as "Msgbox()" can lead to unexpected behavior,
	the return to the system should be as fast as possible!
	3) When $MOUSE_PRIMARYDOWN_EVENT and $MOUSE_SECONDARYDOWN_EVENT are set,
	the $MOUSE_PRIMARYDBLCLK_EVENT and $MOUSE_SECONDARYDBLCLK_EVENT events are also set by force,
	to unset these events use _MouseSetOnEvent($MOUSE_PRIMARYDBLCLK_EVENT or $MOUSE_SECONDARYDBLCLK_EVENT).
	4) When using obfuscator, make sure to add event functions to ignore list (#Obfuscator_Ignore_Funcs).
	
	ChangLog:
	v1.9 [22.07.2012]
	* Script breaking version!
	* Dropped AutoIt 3.3.0.0 support.
	* Instead of $sParam1 and $sParam2, now $vParam used as last parameter.
	* Event function ($sFuncName) now called with $iEvent as first parameter, and $vParam as second (both optional).
	* Now $iBlockDefProc is set to -1 by default (event function can define whether to block event process or not, simply by returning 1 or 0).
	* Fixed not working $MOUSE_PRIMARYDBLCLK_EVENT and $MOUSE_SECONDARYDBLCLK_EVENT,
	now handled manually because windows does not always receive these events (depending on CS_DBLCLKS style).
	(not tested properly, so these events will have "experimental" label for now).
	* Fixed error related to "Subscript used with non-Array variable", caused when window with handle of $hTargetWnd parameter is not found (window closed).
	* Examples updated.
	
	v1.8 [02.06.2010]
	* Fixed an issue with wrong handling when $MOUSE_XBUTTONUP/DOWN_EVENT and few other events are set.
	* Fixed an issue when user attempts to set other function for the event that already have been set.
	Now the function and other parameters are replaced for the current event.
	* UDF file renamed (removed "Set" in the middle and "_UDF" at the end of the name).
	* Cosmetic changes in the UDF code.
	* Docs updated.
	
	v1.7 [14.10.2009]
	* Stability fixes. Thanks again to wraithdu.
	
	v1.6 [13.10.2009]
	* Fixed an issue with releasing the resources of mouse hook. Thanks to wraithdu.
	
	v1.5 [09.10.2009]
	+ Added wheel button up/down *scrolling* event recognition.
	Thanks to JRowe (http://www.autoitscript.com/forum/index.php?showtopic=103362).
	* Fixed an issue with returning value from __MouseSetOnEvent_MainHandler - should call _WinAPI_CallNextHookEx before return.
	* Constants starting with MOUSE_EXTRABUTTON* renamed to MOUSE_XBUTTON*, as it should be in the first place.
	* Few examples updated.
	
	v1.4 [30.09.2009]
	+ Added UDF header to the function.
	+ Now the original events-messages (such as $WM_MOUSEMOVE) can be used as well.
	+ Added missing events (althought i am not sure if they are still supported)
	$MOUSE_PRIMARYDBLCLK_EVENT - Primary mouse button double click.
	$MOUSE_SECONDARYDBLCLK_EVENT - Secondary mouse button double click.
	$MOUSE_WHEELDBLCLK_EVENT - Wheel mouse button double click.
	$MOUSE_EXTRABUTTONDBLCLK_EVENT - Side mouse button double click.
	
	* Changed global vars and internal functions names to be more unique.
	* Fixed variables declaration and misspelling.
	
	v1.3 [27.10.2008]
	* Added optional parameter $iBlockDefProc - Define wether the Mouse events handler will block the default processing or not (Default is 1, block).
	If this is -1, then user can Return from the event function to set processing operation (see the attached example «AutoDrag Window.au3»).
	
	v1.2 [05.04.2008]
	* Added: [Optional] parameter $hTargetWnd, if set, the OnEvent function will be called only on $hTargetWnd window, otherwise will be standard Event processing.
	Note: Can be a little(?) buggy when you mix different events.
	
	v1.1 [22.03.2008]
	* Fixed: Incorrect ReDim when remove event from the array, it was causing UDF to crash script with error.
	* Spell/Grammar corrections
	* Added: An example of _BlockMouseClicksInput().
	
	v1.0 [21.02.2008]
	* First public release.
#CE

#include-once
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Timers.au3>

OnAutoItExitRegister('__MouseSetOnEvent_OnExitFunc')

#endregion Header

#region Global Constants and Variables

Global $a__MSOE_Events[1][1]
Global $h__MSOE_MouseProc = -1
Global $h__MSOE_MouseHook = -1
Global $i__MSOE_EventReturn = 1
Global $h__MSOE_Hook_Timer = 0
Global $h__MSOE_PrmDblClk_Timer = 0
Global $h__MSOE_ScnDblClk_Timer = 0
Global $i__MSOE_PrmDblClk_Timer = 0
Global $i__MSOE_ScnDblClk_Timer = 0
Global $a__MSOE_PrmDblClk_LastMPos[2]
Global $a__MSOE_ScnDblClk_LastMPos[2]
Global $a__MSOE_DblClk_Data = __MouseSetOnEvent_GetDoubleClickData()

#endregion Global Constants and Variables

#region Public Constants

Global Const $MOUSE_MOVE_EVENT = 0x200 ;512 (WM_MOUSEMOVE) 		; ==> Mouse moving.
Global Const $MOUSE_PRIMARYDOWN_EVENT = 0x201 ;513 (WM_LBUTTONDOWN) 		; ==> Primary mouse button down.
Global Const $MOUSE_PRIMARYUP_EVENT = 0x202 ;514 (WM_LBUTTONUP) 		; ==> Primary mouse button up.
Global Const $MOUSE_PRIMARYDBLCLK_EVENT = 0x203 ;515 (WM_LBUTTONDBLCLK) 	; ==> Primary mouse button double click.
Global Const $MOUSE_SECONDARYDOWN_EVENT = 0x204 ;516 (WM_RBUTTONDOWN) 		; ==> Secondary mouse button down.
Global Const $MOUSE_SECONDARYUP_EVENT = 0x205 ;517 (WM_RBUTTONUP) 		; ==> Secondary mouse button up.
Global Const $MOUSE_SECONDARYDBLCLK_EVENT = 0x206 ;518 (WM_RBUTTONDBLCLK) 	; ==> Secondary mouse button double click.
Global Const $MOUSE_WHEELDOWN_EVENT = 0x207 ;519 (WM_MBUTTONDOWN) 		; ==> Wheel mouse button pressed down.
Global Const $MOUSE_WHEELUP_EVENT = 0x208 ;520 (WM_MBUTTONUP) 		; ==> Wheel mouse button up.
Global Const $MOUSE_WHEELDBLCLK_EVENT = 0x209 ;521 (WM_MBUTTONDBLCLK) 	; ==> Wheel mouse button double click.
Global Const $MOUSE_WHEELSCROLL_EVENT = 0x20A ;522 (WM_MOUSEWHEEL) 		; ==> Wheel mouse scroll.
Global Const $MOUSE_WHEELSCROLLDOWN_EVENT = 0x20A + 8 ;530 (WM_MOUSEWHEEL + 8) 	; ==> Wheel mouse scroll Down.
Global Const $MOUSE_WHEELSCROLLUP_EVENT = 0x20A + 16 ;538 (WM_MOUSEWHEEL + 16) 	; ==> Wheel mouse scroll Up.
Global Const $MOUSE_XBUTTONDOWN_EVENT = 0x20B ;523 (WM_XBUTTONDOWN) 		; ==> Side mouse button down (usually navigating next/back buttons).
Global Const $MOUSE_XBUTTONUP_EVENT = 0x20C ;524 (WM_XBUTTONUP) 		; ==> Side mouse button up.
Global Const $MOUSE_XBUTTONDBLCLK_EVENT = 0x20D ;525 (WM_XBUTTONDBLCLK) 	; ==> Side mouse button double click.

#endregion Public Constants

#region Public Functions

; #FUNCTION# ====================================================================================================
; Name...........:	_MouseSetOnEvent
; Description....:	Set an events handler (a hook) for Mouse device.
; Syntax.........:	_MouseSetOnEvent($iEvent, $sFuncName = "", $hTargetWnd = 0, $iBlockDefProc = -1, $vParam = "")
; Parameters.....:	$iEvent 		- The event to set, here is the list of supported events:
;										$MOUSE_MOVE_EVENT - Mouse moving.
;										$MOUSE_PRIMARYDOWN_EVENT - Primary mouse button down.
;										$MOUSE_PRIMARYUP_EVENT - Primary mouse button up.
;										$MOUSE_PRIMARYDBLCLK_EVENT - Primary mouse button double click.
;										$MOUSE_SECONDARYDOWN_EVENT - Secondary mouse button down.
;										$MOUSE_SECONDARYUP_EVENT - Secondary mouse button up.
;										$MOUSE_SECONDARYDBLCLK_EVENT - Secondary mouse button double click.
;										$MOUSE_WHEELDOWN_EVENT - Wheel mouse button pressed down.
;										$MOUSE_WHEELUP_EVENT - Wheel mouse button up.
;										$MOUSE_WHEELDBLCLK_EVENT - Wheel mouse button double click.
;										$MOUSE_WHEELSCROLL_EVENT - Wheel mouse scroll.
;										$MOUSE_WHEELSCROLLDOWN_EVENT - Wheel mouse scroll *Down*.
;										$MOUSE_WHEELSCROLLUP_EVENT - Wheel mouse scroll *Up*.
;										$MOUSE_XBUTTONDOWN_EVENT - Side mouse button down (usualy navigating next/back buttons).
;										$MOUSE_XBUTTONUP_EVENT - Side mouse button up.
;										$MOUSE_XBUTTONDBLCLK_EVENT - Side mouse button double click.
;
;					$sFuncName 		- [Optional] Function name to call when the event is triggered.
;										If this parameter is empty string ("") or omited, the function will *unset* the $iEvent.
;					$hTargetWnd 	- [Optional] Window handle to set the event for, e.g the event is set only for this window.
;					$iBlockDefProc 	- [Optional] Defines if the event should be blocked (actualy block the mouse action).
;										If this parameter = -1 (default), then event function can define whether to block event process or not, simply by returning 1 or 0.
;					$vParam 		- [Optional] Parameter to pass to the event function ($sFuncName).
;
; Return values..:	Success 		- If the event is set in the first time, or when the event is unset properly, the return is 1,
;										if it's set on existing event, the return is 2.
;					Failure 		- Returns 0 on UnSet event mode when there is no set events yet.
; Author.........:	G.Sandler ((Mr)CreatoR, CreatoR's Lab - http://creator-lab.ucoz.ru, http://autoit-script.ru)
; Modified.......:
; Remarks........:	1) The original events-messages (such as $WM_MOUSEMOVE) can be used as well.
;					2) Blocking of $sFuncName function by window messages with commands
;                     such as "Msgbox()" can lead to unexpected behavior, the return to the system should be as fast as possible!
; Related........:
; Link...........:	http://www.autoitscript.com/forum/index.php?showtopic=64738
; Example........:	Yes.
; ===============================================================================================================
Func _MouseSetOnEvent($iEvent, $sFuncName = "", $hTargetWnd = 0, $iBlockDefProc = -1, $vParam = "")
	If $sFuncName = "" Then ;Unset Event
		If $a__MSOE_Events[0][0] < 1 Then
			Return 0
		EndIf
		
		Local $aTmp_Mouse_Events[1][1] = [[0]]
		
		For $i = 1 To $a__MSOE_Events[0][0]
			If $a__MSOE_Events[$i][0] <> $iEvent Then
				$aTmp_Mouse_Events[0][0] += 1
				ReDim $aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0] + 1][5]
				
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][0] = $a__MSOE_Events[$i][0]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][1] = $a__MSOE_Events[$i][1]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][2] = $a__MSOE_Events[$i][2]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][3] = $a__MSOE_Events[$i][3]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][4] = $a__MSOE_Events[$i][4]
			EndIf
		Next
		
		$a__MSOE_Events = $aTmp_Mouse_Events
		
		If $a__MSOE_Events[0][0] < 1 Then
			If $i__MSOE_EventReturn = 1 Then
				__MouseSetOnEvent_OnExitFunc()
			ElseIf $i__MSOE_EventReturn = 0 Then
				$h__MSOE_Hook_Timer = _Timer_SetTimer(0, 10, "__MouseSetOnEvent_WaitHookReturn")
			EndIf
		EndIf
		
		Return 1
	EndIf
	
	;First event
	If $a__MSOE_Events[0][0] < 1 Then
		$h__MSOE_MouseProc = DllCallbackRegister("__MouseSetOnEvent_MainHandler", "int", "int;ptr;ptr")
		$h__MSOE_MouseHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($h__MSOE_MouseProc), _WinAPI_GetModuleHandle(0), 0)
	EndIf
	
	;Search thru events, and if the event already set, we just (re)set the new function and other parameters
	For $i = 1 To $a__MSOE_Events[0][0]
		If $a__MSOE_Events[$i][0] = $iEvent Then
			$a__MSOE_Events[$i][0] = $iEvent
			$a__MSOE_Events[$i][1] = $sFuncName
			$a__MSOE_Events[$i][2] = $hTargetWnd
			$a__MSOE_Events[$i][3] = $iBlockDefProc
			$a__MSOE_Events[$i][4] = $vParam
			
			Return 2
		EndIf
	Next
	
	$a__MSOE_Events[0][0] += 1
	ReDim $a__MSOE_Events[$a__MSOE_Events[0][0] + 1][5]
	
	$a__MSOE_Events[$a__MSOE_Events[0][0]][0] = $iEvent
	$a__MSOE_Events[$a__MSOE_Events[0][0]][1] = $sFuncName
	$a__MSOE_Events[$a__MSOE_Events[0][0]][2] = $hTargetWnd
	$a__MSOE_Events[$a__MSOE_Events[0][0]][3] = $iBlockDefProc
	$a__MSOE_Events[$a__MSOE_Events[0][0]][4] = $vParam
	
	;Add primary/secondary double click event, if needed can be disabled later
	If $iEvent = $MOUSE_PRIMARYDOWN_EVENT Then
		_MouseSetOnEvent($MOUSE_PRIMARYDBLCLK_EVENT, $sFuncName, $hTargetWnd, $iBlockDefProc, $vParam)
	EndIf
	
	If $iEvent = $MOUSE_SECONDARYDOWN_EVENT Then
		_MouseSetOnEvent($MOUSE_SECONDARYDBLCLK_EVENT, $sFuncName, $hTargetWnd, $iBlockDefProc, $vParam)
	EndIf
	
	Return 1
EndFunc   ;==>_MouseSetOnEvent

#endregion Public Functions

#region Internal Functions

Func __MouseSetOnEvent_MainHandler($nCode, $wParam, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($h__MSOE_MouseHook, $nCode, $wParam, $lParam) ;Continue processing
	EndIf
	
	Local $iEvent = _WinAPI_LoWord($wParam)
	Local $iRet
	Local $iBlockDefProc_Ret
	Local $iWScrollDirection = 0
	
	If $a__MSOE_Events[0][0] < 1 Then
		Return 0
	EndIf
	
	Switch $iEvent
		Case $MOUSE_WHEELSCROLL_EVENT
			Local Const $stMSLLHOOKSTRUCT = $tagPOINT & ";dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo"
			Local $tWheel_Struct = DllStructCreate($stMSLLHOOKSTRUCT, $lParam)
			
			$iWScrollDirection = _WinAPI_HiWord(DllStructGetData($tWheel_Struct, 3))
		Case $MOUSE_PRIMARYDOWN_EVENT
			If $i__MSOE_PrmDblClk_Timer = 0 Then
				$i__MSOE_PrmDblClk_Timer = TimerInit()
				$a__MSOE_PrmDblClk_LastMPos = MouseGetPos()
				$h__MSOE_PrmDblClk_Timer = _Timer_SetTimer(0, $a__MSOE_DblClk_Data[0] + 50, '__MouseSetOnEvent_DoubleClickExpire')
			ElseIf $i__MSOE_PrmDblClk_Timer > 0 Then
				If TimerDiff($i__MSOE_PrmDblClk_Timer) <= $a__MSOE_DblClk_Data[0] Then
					Local $aCurrentMPos = MouseGetPos()
					
					Local $iDC_Width = $aCurrentMPos[0] - $a__MSOE_PrmDblClk_LastMPos[0]
					If $a__MSOE_PrmDblClk_LastMPos[0] > $aCurrentMPos[0] Then $iDC_Width = $a__MSOE_PrmDblClk_LastMPos[0] - $aCurrentMPos[0]
					
					Local $iDC_Height = $aCurrentMPos[1] - $a__MSOE_PrmDblClk_LastMPos[1]
					If $a__MSOE_PrmDblClk_LastMPos[1] > $aCurrentMPos[1] Then $iDC_Height = $a__MSOE_PrmDblClk_LastMPos[1] - $aCurrentMPos[1]
					
					If $iDC_Width <= $a__MSOE_DblClk_Data[1] And $iDC_Height <= $a__MSOE_DblClk_Data[2] Then
						$iEvent = $MOUSE_PRIMARYDBLCLK_EVENT
					EndIf
				EndIf
				
				$i__MSOE_PrmDblClk_Timer = 0
			EndIf
		Case $MOUSE_SECONDARYDOWN_EVENT
			If $i__MSOE_ScnDblClk_Timer = 0 Then
				$i__MSOE_ScnDblClk_Timer = TimerInit()
				$a__MSOE_ScnDblClk_LastMPos = MouseGetPos()
				$h__MSOE_ScnDblClk_Timer = _Timer_SetTimer(0, $a__MSOE_DblClk_Data[0] + 50, '__MouseSetOnEvent_DoubleClickExpire')
			ElseIf $i__MSOE_ScnDblClk_Timer > 0 Then
				If TimerDiff($i__MSOE_ScnDblClk_Timer) <= $a__MSOE_DblClk_Data[0] Then
					Local $aCurrentMPos = MouseGetPos()
					
					Local $iDC_Width = $aCurrentMPos[0] - $a__MSOE_ScnDblClk_LastMPos[0]
					If $a__MSOE_ScnDblClk_LastMPos[0] > $aCurrentMPos[0] Then $iDC_Width = $a__MSOE_ScnDblClk_LastMPos[0] - $aCurrentMPos[0]
					
					Local $iDC_Height = $aCurrentMPos[1] - $a__MSOE_ScnDblClk_LastMPos[1]
					If $a__MSOE_ScnDblClk_LastMPos[1] > $aCurrentMPos[1] Then $iDC_Height = $a__MSOE_ScnDblClk_LastMPos[1] - $aCurrentMPos[1]
					
					If $iDC_Width <= $a__MSOE_DblClk_Data[1] And $iDC_Height <= $a__MSOE_DblClk_Data[2] Then
						$iEvent = $MOUSE_SECONDARYDBLCLK_EVENT
					EndIf
				EndIf
				
				$i__MSOE_ScnDblClk_Timer = 0
			EndIf
	EndSwitch
	
	For $i = 1 To $a__MSOE_Events[0][0]
		If $a__MSOE_Events[$i][0] = $iEvent Or $iWScrollDirection <> 0 Then
			;Handle wheel scroll up/down
			If $iEvent = $MOUSE_WHEELSCROLL_EVENT And ($a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLL_EVENT Or $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Or $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT) Then
				If $iWScrollDirection > 0 And $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Then
					$iEvent = $MOUSE_WHEELSCROLLUP_EVENT
				ElseIf $iWScrollDirection < 0 And $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT Then
					$iEvent = $MOUSE_WHEELSCROLLDOWN_EVENT
				ElseIf $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLUP_EVENT Or $a__MSOE_Events[$i][0] = $MOUSE_WHEELSCROLLDOWN_EVENT Then
					ContinueLoop
				EndIf
			ElseIf $iWScrollDirection <> 0 Then
				ContinueLoop
			EndIf
			
			If $a__MSOE_Events[$i][2] <> 0 And Not __MouseSetOnEvent_IsHoveredWnd($a__MSOE_Events[$i][2]) Then
				Return 0 ;Allow default processing
			EndIf
			
			$i__MSOE_EventReturn = 0
			$iBlockDefProc_Ret = $a__MSOE_Events[$i][3]
			
			$iRet = Call($a__MSOE_Events[$i][1], $iEvent, $a__MSOE_Events[$i][4])
			
			If @error Then
				$iRet = Call($a__MSOE_Events[$i][1], $iEvent)
				
				If @error Then
					$iRet = Call($a__MSOE_Events[$i][1])
				EndIf
			EndIf
			
			$i__MSOE_EventReturn = 1
			
			If $iBlockDefProc_Ret = -1 Then
				$iBlockDefProc_Ret = $iRet
			EndIf
			
			Return $iBlockDefProc_Ret ;Block default processing (or not :))
		EndIf
	Next
	
	Return _WinAPI_CallNextHookEx($h__MSOE_MouseHook, $nCode, $wParam, $lParam) ;Continue processing
EndFunc   ;==>__MouseSetOnEvent_MainHandler

Func __MouseSetOnEvent_WaitHookReturn($hWnd, $iMsg, $iIDTimer, $dwTime)
	If $i__MSOE_EventReturn = 1 Then
		_Timer_KillTimer(0, $h__MSOE_Hook_Timer)
		__MouseSetOnEvent_OnExitFunc()
	EndIf
EndFunc   ;==>__MouseSetOnEvent_WaitHookReturn

Func __MouseSetOnEvent_IsHoveredWnd($hWnd)
;~ 	Local $iRet = False
;~
;~ 	Local $aWin_Pos = WinGetPos($hWnd)
;~ 	Local $aMouse_Pos = MouseGetPos()
;~
;~ 	If Not IsArray($aWin_Pos) Then
;~ 		Return SetError(1, 0, False)
;~ 	EndIf
;~
;~ 	If $aMouse_Pos[0] >= $aWin_Pos[0] And $aMouse_Pos[0] <= ($aWin_Pos[0] + $aWin_Pos[2]) And _
;~ 		$aMouse_Pos[1] >= $aWin_Pos[1] And $aMouse_Pos[1] <= ($aWin_Pos[1] + $aWin_Pos[3]) Then
;~ 		$iRet = True
;~ 	EndIf
;~
;~ 	Local $aRet = DllCall("User32.dll", "hwnd", "WindowFromPoint", "long", $aMouse_Pos[0], "long", $aMouse_Pos[1])
;~
;~ 	If HWnd($aRet[0]) <> $hWnd And Not $iRet Then
;~ 		$iRet = False
;~ 	EndIf
	
	Local $tPoint = _WinAPI_GetMousePos()
	Return _WinAPI_GetAncestor(_WinAPI_WindowFromPoint($tPoint), $GA_ROOT) = $hWnd
EndFunc   ;==>__MouseSetOnEvent_IsHoveredWnd

Func __MouseSetOnEvent_DoubleClickExpire($hWnd, $iMsg, $iIDTimer, $dwTime)
	If TimerDiff($i__MSOE_PrmDblClk_Timer) > $a__MSOE_DblClk_Data[0] Then
		_Timer_KillTimer(0, $h__MSOE_PrmDblClk_Timer)
		$h__MSOE_PrmDblClk_Timer = 0
		$i__MSOE_PrmDblClk_Timer = 0
	EndIf
	
	If TimerDiff($i__MSOE_ScnDblClk_Timer) > $a__MSOE_DblClk_Data[0] Then
		_Timer_KillTimer(0, $h__MSOE_ScnDblClk_Timer)
		$h__MSOE_ScnDblClk_Timer = 0
		$i__MSOE_ScnDblClk_Timer = 0
	EndIf
EndFunc   ;==>__MouseSetOnEvent_DoubleClickExpire

Func __MouseSetOnEvent_GetDoubleClickData()
	Local $aRet[3] = _
			[ _
			RegRead('HKEY_CURRENT_USER\Control Panel\Mouse', 'DoubleClickSpeed'), _
			RegRead('HKEY_CURRENT_USER\Control Panel\Mouse', 'DoubleClickWidth'), _
			RegRead('HKEY_CURRENT_USER\Control Panel\Mouse', 'DoubleClickHeight') _
			]
	
	Local $aGDCT = DllCall('User32.dll', 'uint', 'GetDoubleClickTime')
	
	If Not @error And $aGDCT[0] > 0 Then
		$aRet[0] = $aGDCT[0]
	EndIf
	
	Return $aRet
EndFunc   ;==>__MouseSetOnEvent_GetDoubleClickData

Func __MouseSetOnEvent_OnExitFunc()
	If $h__MSOE_MouseHook <> -1 Then
		_WinAPI_UnhookWindowsHookEx($h__MSOE_MouseHook)
		$h__MSOE_MouseHook = -1
	EndIf
	
	If $h__MSOE_MouseProc <> -1 Then
		DllCallbackFree($h__MSOE_MouseProc)
		$h__MSOE_MouseProc = -1
	EndIf
EndFunc   ;==>__MouseSetOnEvent_OnExitFunc

#endregion Internal Functions
