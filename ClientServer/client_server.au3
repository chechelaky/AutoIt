#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Client32.exe
#AutoIt3Wrapper_Outfile_x64=Client64.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; #SCRIPT# ======================================================================================================================
; Name ..........: client_server.au3
; Author ........: Luigi (Luismar Chechelaky)
; Description ...: controle de botões e slider por POST request, com client/servidor em PHP em HTTPs
;                  control button and slider over POST requst, with client/server em PHP over HTTPs
; Link ..........: https://github.com/chechelaky/AutoIt/tree/master/ClientServer
; start server first, then start client
; ===============================================================================================================================

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <GuiRichEdit.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Timers.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <Debug.au3>

#include <JSMN.au3> ; https://github.com/chechelaky/AutoIt/blob/master/JSMN.au3
#include <object_dump.au3> ; https://github.com/chechelaky/AutoIt/blob/master/object_dump.au3
#include "base64.au3" ; https://github.com/chechelaky/AutoIt/blob/master/base64-2.au3

OnAutoItExitRegister("OnExit")

Global $xx = 10
Global $WHO = @ScriptName = "client_server.au3" ? "Client" : "Server"

If @Compiled Then $WHO = "Client"
Global $oErrorHandler = ObjEvent("AutoIt.Error", "_ErrFunc")
Global $hSliderTic

If $CmdLine[0] Then
	$xx = $CmdLine[1]
ElseIf $WHO = "Client" Then
	Run('"C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "C:\Dropbox\BoriusIOT\server_2.au3" 690')
	If Not FileCopy("C:\Dropbox\BoriusIOT\client_2.au3", "C:\Dropbox\BoriusIOT\server_2.au3", 1) Then Exit
EndIf

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $hGui, $hEdit
Global $TIMER[4] = [0, 0]
Global $DUMMY
Global $WORK
Global $DEBUG = False

Global $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
Global $REMOTE_URL = "https://www.borius.com.br/api/runner.php"
;~ Global $REMOTE_URL = "http://192.168.100.2/borius/run.php"
Global $REMOTE_USER, $REMOTE_PASS, $AUTHORIZATION


Global $oHwd = ObjCreate("Scripting.Dictionary")
Global $oPin = ObjCreate("Scripting.Dictionary")
Global $oVal = ObjCreate("Scripting.Dictionary")
Global $oTag = ObjCreate("Scripting.Dictionary")
Global $oLab = ObjCreate("Scripting.Dictionary")
Global $oSend = ObjCreate("Scripting.Dictionary")
Global $aSend[1], $aNew[1]

$hGui = GUICreate($WHO, 670, 600, $xx, 10, Default, $WS_EX_COMPOSITED)
GUISetFont(9, 400, 0, "DOSLike", $hGui)
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
$DUMMY = GUICtrlCreateButton("", 0, 0, 0, 0)
$hEdit = _GUICtrlRichEdit_Create($hGui, "", 340, 10, 320, 580, BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY))

Switch $WHO
	Case "Client"
		$REMOTE_USER = "IuNQTOFeBr1H8F4eMckWbfqtoDfCXAfen3mTBhg"
		$REMOTE_PASS = "mLePz9eTJ1IYN8uuuF3l2Ny3x3fTI09kdHXPCQ"
		$AUTHORIZATION = "Basic " & B64Encode($REMOTE_USER & ":" & $REMOTE_PASS)
	Case "Server"
		$REMOTE_USER = "Pm4DAWpv5Q2wZ4JW3qfPDNPxJP760dZTU7ysnsJ"
		$REMOTE_PASS = "Grwv5agziFgsEycmHrOYjhR7oIa4bPDVSscUp3"
		$AUTHORIZATION = "Basic " & B64Encode($REMOTE_USER & ":" & $REMOTE_PASS)
		$DEBUG = True
		If $DEBUG Then _DebugSetup($WHO, True, 4, $WHO & ".log", True)
EndSwitch
;~ ConsoleWrite("$REMOTE_USER[ " & $REMOTE_USER & " ]" & @LF)
;~ ConsoleWrite("$REMOTE_PASS[ " & $REMOTE_PASS & " ]" & @LF)
;~ ConsoleWrite("$REMOTE_USER:$REMOTE_PASS[ " & $REMOTE_USER & ":" & $REMOTE_PASS & " ]" & @LF)
;~ ConsoleWrite("_Base64Encode[ " & B64Encode($REMOTE_USER & ":" & $REMOTE_PASS) & " ]" & @LF)
;~ ConsoleWrite("$AUTHORIZATION[ " & $AUTHORIZATION & " ]" & @LF)
;~ $hSliderTic = GUICtrlCreateSlider(290, 124, 40, 160, $TBS_VERT, $WS_EX_COMPOSITED)
;~ Analogic(7, 250, 110)

Func Block()
	For $each In $oHwd
		GUICtrlSetState($each, $GUI_DISABLE)
		GUICtrlSetBkColor($each, 0xF0F0F0)
		If StringLower(StringMid($oHwd.Item($each), 1, 1)) = "a" Then
			GUICtrlSetData($each, 1023)
			GUICtrlSetData($oTag.Item($each), 0)
			GUICtrlSetColor($oLab.Item($each), 0x6D6D6D)
			GUICtrlSetColor($oTag.Item($each), 0x6D6D6D)
		EndIf
	Next
	GUICtrlSetState($DUMMY, $GUI_FOCUS)
EndFunc   ;==>Block

Func UnBlock()
	For $each In $oHwd
		GUICtrlSetState($each, $GUI_ENABLE)
		If StringLower(StringMid($oHwd.Item($each), 1, 1)) = "a" Then
			GUICtrlSetColor($oLab.Item($each), 0x000000)
			GUICtrlSetColor($oTag.Item($each), 0x000000)
		EndIf
	Next
EndFunc   ;==>UnBlock

Func Digital($pin, $xx, $yy)
	Local $handle = GUICtrlCreateButton($pin, $xx, $yy, 40, 20)
	GUICtrlSetOnEvent($handle, "DigitalSet")
	$oHwd.Add($handle, $pin)
	$oPin.Add($pin, $handle)
	$oVal.Add($pin, 0)
	GUICtrlSetBkColor($handle, 0xFF0000)
EndFunc   ;==>Digital

Func Analogic($pin, $xx, $yy)
	Local $handle = GUICtrlCreateSlider($xx, $yy + 14, 40, 160, $TBS_VERT, $WS_EX_COMPOSITED)
	Local $label = GUICtrlCreateLabel($pin, $xx, $yy, 40, 15)
	Local $tag = GUICtrlCreateLabel(0, $xx, $yy + 172, 36, 15, $SS_CENTER, $WS_EX_TOPMOST)
	GUICtrlSetLimit($handle, 1023, 0)
	GUICtrlSetOnEvent($handle, "AnalogicSet")
	$oHwd.Add($handle, $pin)
	$oPin.Add($pin, $handle)
	$oVal.Add($pin, 0)
	GUICtrlSetData($handle, 1023)
	$oLab.Add($handle, $label)
	$oTag.Add($handle, $tag)
EndFunc   ;==>Analogic

Func DigitalSet($pin = 0, $val = 0)
	If IsDeclared("pin") And IsDeclared("val") Then
		Local $hwd = $oPin.Item($pin)
		$oVal.Item($pin) = Number($val) ? 1 : 0
		GUICtrlSetBkColor($hwd, $val ? 0x00FF00 : 0xFF0000)
		GUICtrlSetState($hwd, $GUI_ENABLE)
	Else
		Assign("pin", $oHwd.Item(@GUI_CtrlId))
		If Number($oVal.Item($pin)) Then
			GUICtrlSetBkColor(@GUI_CtrlId, 0xFF0000)
			$oVal.Item($pin) = 0
		Else
			GUICtrlSetBkColor(@GUI_CtrlId, 0x00FF00)
			$oVal.Item($pin) = 1
		EndIf
		If Not $oSend.Exists($pin) Then
			$oSend.Add($pin, $oVal.Item($pin))
		Else
			$oSend.Item($pin) = $oVal.Item($pin)
		EndIf
		GUICtrlSetState($DUMMY, $GUI_FOCUS)
	EndIf
EndFunc   ;==>DigitalSet

Func AnalogicSet($pin = 0, $val = 0)
	If IsDeclared("pin") And IsDeclared("val") Then
		Local $hwd = $oPin.Item($pin)
		$oVal.Item($pin) = 1023 - Limit($val)
		GUICtrlSetData($hwd, $oVal.Item($pin))
		GUICtrlSetData($hwd, $oVal.Item($pin))
		GUICtrlSetData($oTag.Item($hwd), 1023 - $oVal.Item($pin))
		GUICtrlSetState($hwd, $GUI_ENABLE)
	Else
		Assign("pin", $oHwd.Item(@GUI_CtrlId))
		$pin = $oHwd.Item(@GUI_CtrlId)
		$oVal.Item($pin) = 1023 - GUICtrlRead(@GUI_CtrlId)
		GUICtrlSetData($oTag.Item(@GUI_CtrlId), $oVal.Item($pin))
		If Not $oSend.Exists($pin) Then
			$oSend.Add($pin, $oVal.Item($pin))
		Else
			$oSend.Item($pin) = $oVal.Item($pin)
		EndIf
;~ 		GUICtrlSetState(@GUI_CtrlId, $GUI_DISABLE)
;~ 		GUICtrlSetState($DUMMY, $GUI_FOCUS)
	EndIf
EndFunc   ;==>AnalogicSet

Func VectorSet($pin, $val)
EndFunc   ;==>VectorSet

Func FloatSet($pin, $val)
EndFunc   ;==>FloatSet

Func Limit($ii, $nn = 0, $xx = 1023)
	Return $ii < $nn ? $nn : $ii > $xx ? $xx : $ii
EndFunc   ;==>Limit

#Region
Work($WORK)
Digital("d22", 10, 40)
Digital("d23", 50, 40)
Digital("d24", 90, 40)
Digital("d25", 130, 40)
Digital("d26", 170, 40)
Digital("d27", 210, 40)
Digital("d28", 250, 40)
Digital("d29", 10, 60)
;~ Digital("d9", 50, 60)
;~ Digital("d10", 90, 60)
;~ Digital("d11", 130, 60)
;~ Digital("d12", 170, 60)
;~ Digital("d13", 210, 60)
;~ Digital("d14", 250, 60)

;~ Digital("d15", 10, 80)
;~ Digital("d16", 50, 80)
;~ Digital("d17", 90, 80)
;~ Digital("d18", 130, 80)
;~ Digital("d19", 170, 80)
;~ Digital("d20", 210, 80)
;~ Digital("d21", 250, 80)

Analogic("a1", 10, 110)
Analogic("a2", 50, 110)
Analogic("a3", 90, 110)
Analogic("a4", 130, 110)
Analogic("a5", 170, 110)
Analogic("a6", 210, 110)
Analogic("a7", 250, 110)
;~ Analogic("tic", 290, 110)
#EndRegion

GUISetState(@SW_SHOW, $hGui)
Block()

While Sleep(25)
	WorkRun()
WEnd

Func OnExit()
	If $WORK[0] = 2 Or $WORK[0] = 3 Then Ajax($WHO & "Off")
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
	$oHTTP = 0
EndFunc   ;==>OnExit

Func Quit()
	Exit
EndFunc   ;==>Quit

Func Work(ByRef $WORK, $xx = 10, $yy = 10, $ww = 160, $hh = 25)
	Local $arr[4] = [0]
	$arr[1] = GUICtrlCreateButton("", $xx, $yy, $ww, $hh)
	$arr[2] = GUICtrlCreateProgress($xx + 3, $yy - 8, $ww - 6, 8)
	$arr[3] = GUICtrlCreateLabel("0", $ww + $xx + 13, $yy + 3, 80, 20, $SS_CENTER)
	GUICtrlSetOnEvent($arr[1], "WorkTry")
	$WORK = $arr
	WorkSet(0)
EndFunc   ;==>Work

Func WorkTry()
	Switch $WORK[0]
		Case 0
			Ajax($WHO & "On")
		Case 2
			Ajax($WHO & "Off")
		Case 3, 4
			WorkSet(0)
	EndSwitch
EndFunc   ;==>WorkTry

Func WorkSet($mode = 0, $iTime = 0, $err = 0)
	$WORK[0] = Number($mode)
	$TIMER[1] = $iTime
	GUICtrlSetData($WORK[3], "[ " & $TIMER[1] & " ]")
	Switch $WORK[0]
		Case 0
			GUICtrlSetBkColor($WORK[1], 0xF0F0F0)
			GUICtrlSetData($WORK[1], "OFF")
			Block()
		Case 2
			GUICtrlSetBkColor($WORK[1], 0xCCFFCC)
			GUICtrlSetData($WORK[1], "ON")
			UnBlock()
		Case 3
			GUICtrlSetBkColor($WORK[1], 0xFFCC99)
			GUICtrlSetData($WORK[1], "OFF LINE")
			$TIMER[3] = 0
			Block()
		Case 4
			GUICtrlSetBkColor($WORK[1], 0xFFCC99)
			GUICtrlSetData($WORK[1], "ERROR")
			$TIMER[3] = 0
			Block()
	EndSwitch
EndFunc   ;==>WorkSet

Func WorkRun()
	If $TIMER[1] Then
		If TimerDiff($TIMER[0]) >= ($TIMER[1] + $TIMER[3]) Then
			$TIMER[0] = _Timer_Init()
			Ajax($WHO & ($WORK[0] = 2 ? "Get" : "On"))
		EndIf
		GUICtrlSetData($WORK[3], "[ " & $TIMER[1] + $TIMER[3] & " ]")
		GUICtrlSetData($WORK[2], Int((TimerDiff($TIMER[0]) / ($TIMER[1] + $TIMER[3])) * 100))
	Else
		GUICtrlSetData($WORK[2], 0)
		$TIMER[0] = 0
		$TIMER[3] = 0
	EndIf

EndFunc   ;==>WorkRun

Func Ajax($func = "")
	$oHTTP.Open("POST", $REMOTE_URL, False)
	$oHTTP.SetRequestHeader("User-Agent", "AutoIt")
	$oHTTP.SetRequestHeader("Content-Type", "application/json; charset=utf-8")
	$oHTTP.SetRequestHeader("Connection", "Keep-Alive")
	$oHTTP.SetRequestHeader("Authorization", $AUTHORIZATION)
;~ 	$oHTTP.SetCredentials($REMOTE_USER, $REMOTE_PASS, 1)
;~ 	Local $opt = '{"Pergunta":"' & $func & '"' & ($data ? ',"d":' & $data : "") & '}'
	Local $opt = ObjCreate($SD)
	$opt.Add("Pergunta", $func)
	If $oSend.Count Then
		$opt.Add("data", $oSend)
		$oSend = ObjCreate($SD)
	EndIf
	$opt = jsmn_encode($opt)
	Console(">> " & $opt)
	$oHTTP.Send(StringToBinary($opt, 4))

	$oHTTP.WaitForResponse()
	Local $oAllHeaders = $oHTTP.GetAllResponseHeaders()
	ConsoleWrite($oAllHeaders & @LF)
	If $oHTTP.Status <> 200 Then Return WorkSet(4, 0, 1)

	Local $oo = $oHTTP.ResponseText
	If Not $oo Then Return WorkSet(4, 0, 2)
	If $DEBUG Then _DebugOut($oo)
	Console($oo)
	$oo = Jsmn_decode($oo)
	If @error Then Return WorkSet(4, 0, 3)
	WorkReturn($oo, $oHTTP.ResponseText)
EndFunc   ;==>Ajax

Func HeartBeat($hs = 0)
	If $TIMER[1] Then
		$TIMER[3] = 1000 - $hs
		If $TIMER[3] > 500 Then $TIMER[3] = 500
	Else
		$TIMER[3] = 0
	EndIf
EndFunc   ;==>HeartBeat

Func WorkReturn($oo = 0, $txt = "")
	Switch $WHO
		Case "Client"
			If Not $oo.Exists("work") Then Return WorkSet(4, 6000, 4)
			If Not $oo.Item("work") Then Return WorkSet(3, 6000, 5)
		Case "Server"
	EndSwitch

	If $oo.Exists("Resposta") Then
		Console('<< {"Resposta":"' & $oo.Item("Resposta") & '"}')
		Switch $oo.Item("Resposta")
			Case "ServerOn"
				WorkSet(2, 2000)
				If $oo.Exists("news") Then
					Set($oo.Item("news"))
					UnBlock()
				EndIf
			Case "ServerOff"
				WorkSet(0, 0)
				Block()
			Case "ServerGet"
				If $oo.Exists("news") Then Set($oo.Item("news"))
				WorkSet(2, 2000)
			Case "ClientOn"
				WorkSet(2, 2000)
				If $oo.Exists("news") Then
					Set($oo.Item("news"))
					UnBlock()
				EndIf
			Case "ClientOff"
				WorkSet(0, 0)
				Block()
			Case "ClientGet"
				If $oo.Exists("news") Then Set($oo.Item("news"))
				If $oo.Exists("b") Then HeartBeat($oo.Item("b"))
				WorkSet(2, 2000)
		EndSwitch
	Else

	EndIf
EndFunc   ;==>WorkReturn

Func Set($pin = 0, $val = 0)
	If IsObj($pin) Then
		For $each In $pin
			Set($each, $pin.Item($each))
		Next
	Else
;~ 		Console("pin[" & $pin & "] val[" & $val & "] <" & StringMid($pin, 1, 1) & ">")
		Switch StringLower(StringMid($pin, 1, 1))
			Case "d"
				DigitalSet($pin, $val)
			Case "a"
				AnalogicSet($pin, $val)
			Case "v"
				VectorSet($pin, $val)
			Case "f"
				FloatSet($pin, $val)
		EndSwitch
	EndIf
EndFunc   ;==>Set

Func Console($sInput, $hour = 0, $sAttrib = "", $iColor = "")
	;	http://www.autoitscript.com/forum/topic/121728-richedit-not-working/
	Local $Comprimento = StringLen($sInput), $PASSO = 59, $Temp = ""
	;	Count the @CRLFs
	StringReplace(_GUICtrlRichEdit_GetText($hEdit, True), @CRLF, "")
	Local $iLines = @extended
	;	Adjust the text char count to account for the @CRLFs
	Local $iEndPoint = _GUICtrlRichEdit_GetTextLength($hEdit, True, True) - $iLines
	;	Add new text
	;_GUICtrlRichEdit_AppendText($hEdit, $sInput & @CRLF)
	If $Comprimento > $PASSO Then
		For $ii = 1 To $Comprimento Step $PASSO
			If $hour Then
				$Temp &= $ii = 1 ? (@HOUR & ":" & @MIN & ":" & @SEC & " ") : "         "
				$Temp &= StringMid($sInput, $ii, $PASSO) & @CRLF
			Else
				$Temp &= StringMid($sInput, $ii, $PASSO) & @CRLF
			EndIf

		Next
		_GUICtrlRichEdit_AppendText($hEdit, $Temp & StringMid($sInput, $ii, $PASSO))
	Else
		_GUICtrlRichEdit_AppendText($hEdit, $hour ? (@HOUR & ":" & @MIN & ":" & @SEC & " ") : "" & $sInput & @CRLF)
	EndIf
	;	Select text between old and new end points
	_GUICtrlRichEdit_SetSel($hEdit, $iEndPoint, -1)
	;	Convert colour from RGB to BGR
	If $iColor Then
		$iColor = Hex($iColor, 6)
		$iColor = "0x" & StringMid($iColor, 5, 2) & StringMid($iColor, 3, 2) & StringMid($iColor, 1, 2)
		_GUICtrlRichEdit_SetCharColor($hEdit, $iColor ? $iColor : 0x000000)
	Else
		_GUICtrlRichEdit_SetCharColor($hEdit, 0x000000)
	EndIf
	;	Set size
	If $sAttrib Then _GUICtrlRichEdit_SetCharAttributes($hEdit, $sAttrib)
	_GUICtrlRichEdit_SetFont($hEdit, 6, "DOSLike")
	;	Clear selection
	_GUICtrlRichEdit_Deselect($hEdit)
EndFunc   ;==>Console

Func _ErrFunc($oError)
	Local $HexNumber
	Local $strMsg

	$HexNumber = String(Hex($oError.Number, 8))
	$strMsg = "Error Number: " & $HexNumber & @CRLF
	$strMsg &= "WinDescription: " & $oError.WinDescription & @CRLF
	$strMsg &= "Script Line: " & $oError.ScriptLine & @CRLF
;~ 	MsgBox(0, "ERROR", $strMsg)
	SetError(1, $oError.ScriptLine, $HexNumber)

;~ 	; Do anything here.
;~ 	ConsoleWrite("err.number is: " & @TAB & $oError.number & @CRLF & _
;~ 			"err.windescription:" & @TAB & $oError.windescription & @CRLF & _
;~ 			"err.description is: " & @TAB & $oError.description & @CRLF & _
;~ 			"err.source is: " & @TAB & $oError.source & @CRLF & _
;~ 			"err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
;~ 			"err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
;~ 			"err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
;~ 			"err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
;~ 			"err.retcode is: " & @TAB & $oError.retcode & @CRLF & @CRLF)
EndFunc   ;==>_ErrFunc

