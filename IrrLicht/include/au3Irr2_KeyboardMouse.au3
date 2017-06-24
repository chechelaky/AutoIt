#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Keyboard and Mouse
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: These calls allow you recover keyboard events and mouse actions that the user creates.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;__getKeyEvt
;__getMouseEvt
;_IrrKeyEventAvailable
;_IrrReadKeyEvent
;_IrrMouseEventAvailable
;_IrrReadMouseEvent
;_IrrSetMousePosition
;_IrrGetAbsoluteMousePosition
;_IrrHideMouse
;_IrrShowMouse
;_IrrDisplayMouse
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

Global enum _ ; enumeration KEY_EVENT for possible Elements readable by __getKeyEvt
	$EVT_KEY_IKEY = 1,	_ 	; unsigned integer "key"
	$EVT_KEY_IDIRECTION, _ 	; unsigned integer "direction"
	$EVT_KEY_IFLAGS			; unsigned integer "flags"

; #FUNCTION# =============================================================================================================
; Name...........: __getKeyEvt
; Description ...: helper function: returns value of $i_Element inside a keyEvent-structure.
; Syntax.........: __getKeyEvt($p_KeyEvent, $i_Element = $EVT_KEY_IKEY)
; Parameters ....: $p_KeyEvent - A pointer as returned from _IrrReadKeyEvent.
;                  $i_Element - [optional] Event type to return:
;                  |$EVT_KEY_IKEY - ID of pressed key (see remarks).
;                  |$EVT_KEY_IDIRECTION - Direction value - can be either $IRR_KEY_DOWN or $IRR_KEY_UP
;                  |$EVT_KEY_IFLAGS - Bits are set in this parameter to specify whether the shift or control key was keydown at the time the key action occured.
; Return values .: Success - Value of selected event element.
; Author ........:
; Modified.......:
; Remarks .......: $p_KeyEvent is a pointer as returned from _IrrReadKeyEvent.
;+
;                  <b>Key code table for $EVT_KEY_IKEY:</b>
;                  @@StandardTable@@
;                  $KEY_LBUTTON	Left mouse button	$KEY_RBUTTON	Right mouse button
;                  $KEY_CANCEL	Control-break processing	$KEY_MBUTTON	Middle mouse button (three-button mouse)
;                  $KEY_XBUTTON1	Windows 2000/XP: X1 mouse button	$KEY_XBUTTON2	Windows 2000/XP: X2 mouse button
;                  $KEY_BACK	BACKSPACE key	$KEY_TAB	Tab key
;                  $KEY_CLEAR	Clear key	$KEY_RETURN	ENTER key
;                  $KEY_SHIFT	SHIFT key	$KEY_CONTROL	CTRL key
;                  $KEY_MENU	ALT key	$KEY_PAUSE	PAUSE key
;                  $KEY_CAPITAL	CAPS Lock key	$KEY_KANA	IME Kana mode
;                  $KEY_HANGUEL	IME Hanguel mode (maintained For compatibility use KEY_HANGUL)	$KEY_HANGUL	IME Hangul mode
;                  $KEY_JUNJA	IME Junja mode	$KEY_FINAL	IME final mode
;                  $KEY_HANJA	IME Hanja mode	$KEY_KANJI	IME Kanji mode
;                  $KEY_ESCAPE	ESC key	$KEY_CONVERT	IME convert
;                  $KEY_NONCONVERT	IME nonconvert	$KEY_ACCEPT	IME accept
;                  $KEY_MODECHANGE	IME mode change request	$KEY_SPACE	SPACEBAR
;                  $KEY_PRIOR	PAGE UP key	$KEY_NEXT	PAGE DOWN key
;                  $KEY_END	End key	$KEY_HOME	HOME key
;                  $KEY_LEFT	Left ARROW key	$KEY_UP	UP ARROW key
;                  $KEY_RIGHT	Right ARROW key	$KEY_DOWN	DOWN ARROW key
;                  $KEY_SELECT	Select key	$KEY_PRINT	Print key
;                  $KEY_EXECUT	EXECUTE key	$KEY_SNAPSHOT	Print Screen key
;                  $KEY_INSERT	INS key	$KEY_DELETE	DEL key
;                  $KEY_HELP	HELP key	$KEY_KEY_0	0 key
;                  $KEY_KEY_1	1 key	...	...
;                  $KEY_KEY_9	9 key	$KEY_KEY_A	A key
;                  $KEY_KEY_B	B key	...	...
;                  $KEY_KEY_Z	Z key	$KEY_LWIN	Left Win key (Microsoft® Natural® keyboard)
;                  $KEY_RWIN	Right Win key (Natural keyboard)	$KEY_APPS	Applications key (Natural keyboard)
;                  $KEY_SLEEP	Computer Sleep key	$KEY_NUMPAD0	Numeric keypad 0 key
;                  $KEY_NUMPAD1	Numeric keypad 1 key	...	...
;                  $KEY_NUMPAD9	Numeric keypad 9 key	$KEY_MULTIPLY	Multiply key
;                  $KEY_ADD	Add key	$KEY_SEPARATOR	Separator key
;                  $KEY_SUBTRACT	Subtract key	$KEY_DECIMAL	Decimal key
;                  $KEY_DIVIDE	Divide key	$KEY_F1	F1 key
;                  $KEY_F2	F2 key	...	...
;                  $KEY_F24	F24 key	$KEY_NUMLOCK	NUM Lock key
;                  $KEY_SCROLL	SCROLL Lock key	$KEY_LSHIFT	Left SHIFT key
;                  $KEY_RSHIFT	Right SHIFT key	$KEY_LCONTROL	Left CONTROL key
;                  $KEY_RCONTROL	Right CONTROL key	$KEY_LMENU	Left MENU key
;                  $KEY_RMENU	Right MENU key	$KEY_PLUS	Plus Key   (+)
;                  $KEY_COMMA	Comma Key  (,)	$KEY_MINUS	Minus Key  (-)
;                  $KEY_PERIOD	Period Key (.)	$KEY_ATTN	Attn key
;                  $KEY_CRSEL	CrSel key	$KEY_EXSEL	ExSel key
;                  $KEY_EREOF	Erase Eof key	$KEY_PLAY	Play key
;                  $KEY_ZOOM	Zoom key	$KEY_PA1	PA1 key
;                  $KEY_OEM_CLEAR	Clear key	$KEY_KEY_CODES_COUNT	This Is Not a key but the amount of keycodes there are.
;                  @@End@@
; Related .......: _IrrReadKeyEvent, _IrrKeyEventAvailable
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
func __getKeyEvt($p_KeyEvent, $i_Element = $EVT_KEY_IKEY)
	local $EventStruct = DllStructCreate("uint;uint;uint", $p_KeyEvent)
	$result = DllStructGetData($EventStruct, $i_Element)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return $result
	EndIf
EndFunc ;==> __getKeyEvt

Global enum _ ; enumeration MOUSE_EVENT for possible Elements readable by __getMouseEvt
	$EVT_MOUSE_IACTION = 1,	_ 	; unsigned integer "action"
	$EVT_MOUSE_FDELTA, _ 		; single "delta"
	$EVT_MOUSE_IX, _			; integer "x"
	$EVT_MOUSE_IY				; integer "y"


; #FUNCTION# =============================================================================================================
; Name...........: __getMouseEvt
; Description ...: helper function: returns value of $i_Element inside a MouseEvent-structure.
; Syntax.........: __getMouseEvt($p_MouseEvent, $i_Element = $EVT_MOUSE_IACTION)
; Parameters ....: $p_MouseEvent - A pointer as returned from _IrrReadMouseEvent.
;                  $i_Element - [optional] Event type to return:
;                  |$EVT_MOUSE_IACTION - ID of mouse action (see remarks).
;                  |$EVT_MOUSE_FDELTA - Amount of movement of the mouse wheel (> 0 means wheel up, < 0 means wheel down).
;                  |$EVT_MOUSE_IX - Horizontal screen coordinate at which the event took place.
;                  |$EVT_MOUSE_IY - Vertical screen coordinate at which the event took place.
; Return values .: Success - Value of selected event element.
; Author ........:
; Modified.......:
; Remarks .......: $p_MouseEvent is a pointer as returned from _IrrReadMouseEvent.
;+
;                  <b>Mouse actions table for $EVT_MOUSE_IACTION:</b>
;                  @@StandardTable@@
;                  $IRR_EMIE_LMOUSE_PRESSED_DOWN	Left mouse button pressed
;                  $IRR_EMIE_RMOUSE_PRESSED_DOWN	Right mouse button pressed
;                  $IRR_EMIE_MMOUSE_PRESSED_DOWN	Middle mouse button pressed
;                  $IRR_EMIE_LMOUSE_LEFT_UP	Left mouse button released
;                  $IRR_EMIE_RMOUSE_LEFT_UP	Right mouse button released
;                  $IRR_EMIE_MMOUSE_LEFT_UP	Middle mouse button released
;                  $IRR_EMIE_MOUSE_MOVED	Mouse was moved horizontal and/or vertical
;                  $IRR_EMIE_MOUSE_WHEEL	Mouse wheel was moved up or down
;                  @@End@@
; Related .......: _IrrReadMouseEvent, _IrrMouseEventAvailable
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
func __getMouseEvt($p_MouseEvent, $i_Element = $EVT_MOUSE_IACTION)
	local $EventStruct = DllStructCreate("uint;float;int;int", $p_MouseEvent)
	$result = DllStructGetData($EventStruct, $i_Element)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return $result
	EndIf
EndFunc ;==> __getMouseEvt


; #FUNCTION# =============================================================================================================
; Name...........: _IrrKeyEventAvailable
; Description ...: Determine if there are any keystrokes waiting to be read.
; Syntax.........: _IrrKeyEventAvailable()
; Parameters ....: None
; Return values .: Success - True if there are keystrokes, otherwise False.
; Author ........:
; Modified.......:
; Remarks .......: Event capturing needs to be enabled before with _IrrStart or _IrrStartAdvanced!
; Related .......: _IrrReadKeyEvent, __getKeyEvt, _IrrStart
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrKeyEventAvailable()
	$result = DllCall($_irrDll, "int:cdecl", "IrrKeyEventAvailable")
	Return $result[0]
EndFunc   ;==>_IrrKeyEventAvailable


; #FUNCTION# =============================================================================================================
; Name...........: _IrrReadKeyEvent
; Description ...: Read a key event from the Irrlicht window.
; Syntax.........: _IrrReadKeyEvent()
; Parameters ....: None
; Return values .: success - Pointer of a key event.
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......:  The properties of the returned key event are readable with the helper function __getKeyEvt.
; Related .......: _IrrKeyEventAvailable, __getKeyEvt
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrReadKeyEvent()
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrReadKeyEvent")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrReadKeyEvent


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMouseEventAvailable
; Description ...: Determine if there are any mouse events waiting to be read.
; Syntax.........: _IrrMouseEventAvailable()
; Parameters ....: None
; Return values .: Success - True if there are mouse events, otherwise False.
; Author ........:
; Modified.......:
; Remarks .......: Event capturing needs to be enabled before with _IrrStart or _IrrStartAdvanced!
; Related .......: _IrrReadMouseEvent, __getMouseEvt, _IrrStart
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrMouseEventAvailable()
	$result = DllCall($_irrDll, "int:cdecl", "IrrMouseEventAvailable")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrMouseEventAvailable


; #FUNCTION# =============================================================================================================
; Name...........: _IrrReadMouseEvent
; Description ...: Read a key event from the Irrlicht window.
; Syntax.........: _IrrReadMouseEvent()
; Parameters ....: None
; Return values .: success - Pointer of a mouse event.
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......:  The properties of the returned mouse event are readable with the helper function __getMouseEvt.
; Related .......: _IrrMouseEventAvailable, __getMouseEvt
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrReadMouseEvent()
	$result = DllCall($_irrDll, "int:cdecl", "IrrReadMouseEvent")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrReadMouseEvent


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetMousePosition
; Description ...: Sets relative position of the mouse pointer and returns relative position before this change.
; Syntax.........: _IrrSetMousePosition(ByRef $f_XPos, ByRef $f_YPos)
; Parameters ....: $f_XPos - Fractional value for new horizontal position (0-1).
;                  $f_YPos - Fractional value for new vertical position (0-1).
; Return values .: success - True and sets $f_XPos and $f_YPos to relative position where the mouse was before (both 0-1).
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: This function works independent from the resolution of current Irrlicht display. Expected and returned values are fractional values, where 0/0 is top left and 1/1 bottom right of the Irrlicht display.
; Related .......: _IrrReadMouseEvent, _IrrGetAbsoluteMousePosition
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetMousePosition(ByRef $f_XPos, ByRef $f_YPos)
	$result = DllCall($_irrDll, "none:cdecl", "IrrSetMousePosition", "float*", $f_XPos, "float*", $f_YPos)
	if @error Then
		Return Seterror(1,0,False)
	Else
		$f_XPos = $result[1]
		$f_YPos = $result[2]
		Return true
	EndIf
EndFunc   ;==>_IrrSetMousePosition

; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetAbsoluteMousePosition
; Description ...: Get the absolute mouse X and Y position
; Syntax.........: _IrrGetAbsoluteMousePosition()
; Parameters ....: None.
; Return values .: success - 1D Array containing absolute mouse position.
;                  |$Array[0] = X position of the mouse
;                  |$Array[1] = Y position of the mouse
;                  failure - Empty 1D Array and Set @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetAbsoluteMousePosition()
    Local $aResult, $aReturn[2]
    $aResult = DllCall($_irrDll, "none:cdecl", "IrrGetAbsoluteMousePosition", "int*", 0, "int*", 0)
    If @error Or Not IsArray($aResult) Then Return SetError(1, 0, $aReturn)
    $aReturn[0] = $aResult[1]
    $aReturn[1] = $aResult[2]
    Return SetError(0, 0, $aReturn)
EndFunc   ;==>_IrrGetAbsoluteMousePosition


; #FUNCTION# =============================================================================================================
; Name...........: _IrrHideMouse
; Description ...: Hides the mouse pointer
; Syntax.........: _IrrHideMouse()
; Parameters ....: None
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrShowMouse, _IrrDisplayMouse
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrHideMouse()
	return _IrrDisplayMouse(False)
EndFunc   ;==>_IrrHideMouse


; #FUNCTION# =============================================================================================================
; Name...........: _IrrShowMouse
; Description ...: Shows the mouse pointer
; Syntax.........: _IrrShowMouse()
; Parameters ....: None
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrHideMouse, _IrrDisplayMouse
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrShowMouse()
	return _IrrDisplayMouse(True)
EndFunc   ;==>_IrrShowMouse


; #FUNCTION# =============================================================================================================
; Name...........: _IrrDisplayMouse
; Description ...: Hide or show the mouse pointer while it is within the Irrlicht display.
; Syntax.........: _IrrDisplayMouse($i_HideShow)
; Parameters ....: $i_HideShow - True shows and False hides the mouse pointer.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: There are two functions available to simply hide or show the mouse: IrrHideMouse and IrrShowMouse.
; Related .......: _IrrShowMouse, _IrrHideMouse
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrDisplayMouse($i_HideShow)
	DllCall($_irrDll, "none:cdecl", "IrrDisplayMouse", "int", $i_HideShow)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrDisplayMouse
