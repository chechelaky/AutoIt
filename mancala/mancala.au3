;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

; #SCRIPT# ======================================================================================================================
; Name ..........: mancala.au3
; Author ........: Luigi (Luismar Chechelaky)
; Description ...: adaptação do jogo de mancala para AutoIt
; Link ..........: https://github.com/chechelaky/AutoIt/blob/master/mancala/mancala.au3
; webgrafia......: https://pt.wikipedia.org/wiki/Mancala
;                  http://www.colegioglauciacosta.com.br/moodle/file.php/1/Regras_Awele_CLMasse.pdf
;                  http://www.math.ku.dk/famos/.arkiv/22-1/kalaha.pdf
;                  http://fritzdooley.com/mancala/4_computer-aided_game_strategy_reverse_induction.html
; Todo...........: implementar a verificação do vencedor
; ===============================================================================================================================

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <String.au3>

Global $DEFAULT = 0xD4D4D4, $GREEN = 0x00FF00, $ORANGE = 0xFF9900

OnAutoItExitRegister("OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

; [ handle, id, is_kala, player ]
Global $JOGA_DE_NOVO = False
Global $ARR[14][7]
Global $aGuiSize[2] = [800, 600]
Global $sGuiTitle = "GuiTitle"
Global $hGui
Global $DUMMY
Global $RESET
Global $WHO_PLAY, $AUTOMATIC = False
Global $FIRST = 0
Global $hQuemJoga

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1], 1366 - 800, 0)
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
$DUMMY = GUICtrlCreateInput("", 0, 0, 1, 1)
$RESET = GUICtrlCreateButton("RESET", 10, 200, 80, 25)
GUICtrlSetOnEvent($RESET, "Reset")
$hQuemJoga = GUICtrlCreateButton("", 10, 240, 80, 25)
GUICtrlSetOnEvent($hQuemJoga, "QuemJoga")
Botoes()
GUISetState(@SW_SHOW, $hGui)

While Sleep(25)
WEnd

Func OnExit()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	Exit
EndFunc   ;==>Quit

Func Botoes()
	Local $iIntervalo = 20, $half = $iIntervalo / 2
	Local $iLargura = Int(($aGuiSize[0] - $iIntervalo * 9) / 8)

	For $ii = 0 To 13
		Switch $ii
			Case 0 To 5
				$ARR[$ii][0] = Input(4, $iIntervalo + ($iIntervalo + $iLargura) * ($ii + 1), $iIntervalo * 2 + $iLargura, $iLargura, $iLargura, "Evento", $SS_SUNKEN + $SS_CENTER)
				$ARR[$ii][1] = $ii
				$ARR[$ii][2] = 0
				$ARR[$ii][3] = 1
				$ARR[$ii][4] = 12 - $ii
				$ARR[$ii][5] = 6
			Case 6
				$ARR[$ii][0] = Input(0, $iIntervalo * 8 + $iLargura * 7, $iIntervalo, $iLargura, $iLargura * 2 + $iIntervalo, 0, $SS_SUNKEN + $SS_CENTER + $SS_CENTERIMAGE)
				$ARR[$ii][1] = $ii
				$ARR[$ii][2] = 1
				$ARR[$ii][3] = 1
				$ARR[$ii][4] = -1
				$ARR[$ii][5] = 6
			Case 13
				$ARR[$ii][0] = Input(0, $iIntervalo, $iIntervalo, $iLargura, $iLargura * 2 + $iIntervalo, 0, $SS_SUNKEN + $SS_CENTER + $SS_CENTERIMAGE)
				$ARR[$ii][1] = $ii
				$ARR[$ii][2] = 1
				$ARR[$ii][3] = 2
				$ARR[$ii][4] = -1
				$ARR[$ii][5] = 13
			Case 7 To 12
				$ARR[$ii][0] = Input(4, $iIntervalo + ($iIntervalo + $iLargura) * (13 - $ii), $iIntervalo, $iLargura, $iLargura, "Evento", $SS_SUNKEN + $SS_CENTER)
				$ARR[$ii][1] = $ii
				$ARR[$ii][2] = 0
				$ARR[$ii][3] = 2
				$ARR[$ii][4] = 12 - $ii
				$ARR[$ii][5] = 13
		EndSwitch
		GUICtrlSetBkColor($ARR[$ii][0], 0xD4D4D4)
		GUICtrlSetTip($ARR[$ii][0], $ARR[$ii][0], "$ii[" & $ii & "]" & @CRLF & "contra[" & $ARR[$ii][4] & "]")
		GUICtrlSetFont($ARR[$ii][0], 40, 400, 0, "Courier New")
	Next
EndFunc   ;==>Botoes

Func _Reset()
	For $ii = 0 To 13
		GUICtrlSetBkColor($ARR[$ii][0], $DEFAULT)
		$ARR[$ii][6] = 0
	Next
EndFunc   ;==>_Reset

Func QuemJoga()

EndFunc   ;==>QuemJoga

Func CorDefault()
	For $ii = 0 To 13
		GUICtrlSetBkColor($ARR[$ii][0], $DEFAULT)
	Next
EndFunc   ;==>CorDefault

Func Evento()
	_Reset()
	Local $id = @GUI_CtrlId - $ARR[0][0]
	Local $MY_KALA = $ARR[$ARR[$id][5]][0]
	$JOGA_DE_NOVO = False
	Local $iPlayer = $ARR[$id][3]
	If Not $FIRST Then $FIRST = $iPlayer

	Local $iPedras = Number(GUICtrlRead(@GUI_CtrlId))
	If Not $iPedras Then Return
	GUICtrlSetData(@GUI_CtrlId, 0)
	While $iPedras
		$id += 1
		If $id > 13 Then $id -= 14
		If Not $ARR[$id][2] Or IsMyKala($id, $iPlayer) Then
			Sleep(100)
			GUICtrlSetData($ARR[$id][0], GUICtrlRead($ARR[$id][0]) + 1)
			GUICtrlSetBkColor($ARR[$id][0], 0xFF9900)
			$iPedras -= 1
			$ARR[$id][6] = $iPlayer
			If Not $iPedras And $ARR[$id][0] = $MY_KALA Then
				$JOGA_DE_NOVO = True
;~ 				ConsoleWrite("$JOGA_DE_NOVO 1" & @LF)
			EndIf
		EndIf
	WEnd
;~ 	_ArrayDump($ARR)
;~ 	ConsoleWrite("id[" & $id & "] a[" & $ARR[$ARR[$id][2]][6] & "] b[" & $iPlayer & "]" & @LF)
	If Not $ARR[$id][2] And Number(GUICtrlRead($ARR[$id][0])) = 1 And Number(GUICtrlRead($ARR[$ARR[$id][4]][0])) And $ARR[$ARR[$id][2]][6] <> $iPlayer Then
;~ 		ConsoleWrite("MANCALA" & @LF)
		GUICtrlSetData($MY_KALA, 1 + GUICtrlRead($ARR[$ARR[$id][4]][0]) + GUICtrlRead($MY_KALA))
		GUICtrlSetData($ARR[$ARR[$id][4]][0], 0)
		GUICtrlSetData($ARR[$id][0], 0)
		$JOGA_DE_NOVO = True
;~ 		ConsoleWrite("$JOGA_DE_NOVO 2" & @LF)
	EndIf

	Local $iTotal = 0

	Local $1 = 0, $2 = 0, $num = 0

	For $ii = 0 To 13
		$num = Number(GUICtrlRead($ARR[$ii][0]))
		$1 += (Not $ARR[$ii][2] And $ARR[$ii][3] = 1) ? $num : 0
		$2 += (Not $ARR[$ii][2] And $ARR[$ii][3] = 2) ? $num : 0
		$iTotal += $num
	Next
	If $iTotal <> 48 Then MsgBox(0, "Erro", "Contagem errada!" & @CRLF & $iTotal)
	If Not $1 Or Not $2 Then
		If $1 > $2 Then
			HouveGanhador(1, $1, $2)
		Else
			HouveGanhador(2, $1, $2)
		EndIf
	EndIf
	GUICtrlSetState($DUMMY, $GUI_FOCUS)
	ConsoleWrite("$JOGA_DE_NOVO[" & ($JOGA_DE_NOVO = True ? "T" : "F")& "] $IP=$FI[" & ($iPlayer = $FIRST ? "T" : "F") & "] $iPlayer[" & $iPlayer & "]" & @LF)

	If $JOGA_DE_NOVO Then
		If $FIRST <> $iPlayer Then AdversarioJoga($iPlayer)
;~ 		AdversarioJoga($iPlayer)
	Else
;~ 		If $FIRST = $iPlayer Then
;~ 			AdversarioJoga($FIRST)
;~ 		Else
;~ 			AdversarioJoga($iPlayer)
;~ 		EndIf
		If $FIRST = $iPlayer Then AdversarioJoga($FIRST = 1 ? 2 : 1)
	EndIf
EndFunc   ;==>Evento

Func AdversarioJoga($player)
;~ 	If $player < 0 Then
;~ 		$player = Abs($player) = 1 ? 2 : 1
;~ 	EndIf
;~ 	ConsoleWrite("AdversarioJoga[" & $player & "]" & @LF)
	Local $move[1]
	For $ii = 0 To 13
		Switch $ii
			Case 6, 13
			Case Else
				If $ARR[$ii][3] = $player And GUICtrlRead($ARR[$ii][0]) Then _ArrayAdd($move, $ARR[$ii][0])
		EndSwitch
	Next
	Local $next = $move[Random(1, UBound($move, 1) - 1)]
	Local $try = ControlClick($hGui, "", $next, "left", 1)
EndFunc   ;==>AdversarioJoga

Func HouveGanhador($ganhador = 0, $1 = 0, $2 = 0)
;~ 	ConsoleWrite("1[" & $1 & "] 2[" & $2 & "]" & @LF)
	For $ii = 0 To 13
		If $ganhador = $ARR[$ii][3] Then
			GUICtrlSetBkColor($ARR[$ii][0], 0x00FF00)
		Else
			GUICtrlSetBkColor($ARR[$ii][0], 0xFF0000)
		EndIf
	Next
;~ 	GUICtrlSetData($ARR[6][0], $1)
;~ 	GUICtrlSetData($ARR[13][0], $2)
EndFunc   ;==>HouveGanhador


Func IsMyKala($id, $iPlayer)
	If $ARR[$id][2] And $ARR[$id][3] = $iPlayer Then Return True
	Return False
EndFunc   ;==>IsMyKala

Func Input($iPedras, $xx, $yy, $ww, $hh, $func = 0, $iStyle = -1)
	If $func Then
		Local $handle = GUICtrlCreateButton($iPedras, $xx, $yy, $ww, $hh, $iStyle)
		GUICtrlSetOnEvent($handle, $func)
	Else
		Local $handle = GUICtrlCreateLabel($iPedras, $xx, $yy, $ww, $hh, $iStyle)
	EndIf
	GUICtrlSetBkColor($handle, $COLOR_SKYBLUE)
	Return $handle
EndFunc   ;==>Input

Func Reset()
	For $ii = 0 To 13
		Switch $ii
			Case 6, 13
				GUICtrlSetData($ARR[$ii][0], 0)
			Case Else
				GUICtrlSetData($ARR[$ii][0], 4)
		EndSwitch
		GUICtrlSetState($ARR[$ii][0], $GUI_ENABLE)
		GUICtrlSetBkColor($ARR[$ii][0], 0xD4D4D4)
	Next
	$FIRST = 0
EndFunc   ;==>Reset



Func _ArrayDump($ARR, $name = "")
	Local $iCol = UBound($ARR, 2)
	Local $aCol[$iCol]
	Local $iLen
	Local $line_head = "+"
	For $ii = 0 To UBound($ARR, 1) - 1
		For $jj = 0 To UBound($ARR, 2) - 1
			$iLen = StringLen($ARR[$ii][$jj])
			If $iLen > $aCol[$jj] Then $aCol[$jj] = $iLen
		Next
	Next
	Local $line = "+"
	For $ii = 0 To $iCol - 1
		$line &= _StringRepeat("-", $aCol[$ii]) & "+"
		$line_head &= _StringRepeat("-", $aCol[$ii] - StringLen(String($ii))) & $ii & "+"
	Next
	If $name Then ConsoleWrite("arr[ " & $name & " ] " & UBound($ARR, 1) & "x" & UBound($ARR, 2) & @LF)
	ConsoleWrite($line_head & @LF)
	For $ii = 0 To UBound($ARR, 1) - 1
		ConsoleWrite($ii = 1 ? $line & @LF & "|" : "|")
		For $jj = 0 To UBound($ARR, 2) - 1
			$iLen = StringLen($ARR[$ii][$jj])
			ConsoleWrite(Conv($ARR[$ii][$jj]) & _StringRepeat(" ", $aCol[$jj] - $iLen) & "|")
		Next
		ConsoleWrite(@LF)
	Next
	ConsoleWrite($line & @LF)
EndFunc   ;==>_ArrayDump

Func Conv($var)
	Local $Pattern[][2] = [["[áãâ]", "a"], ["[éê]", "e"], ["[íî]", "i"], ["[óõô]", "o"], ["[úû]", "u"], ["[ÁÃÂ]", "A"], ["[ÉÊ]", "E"], ["[ÍÎ]", "I"], ["[ÓÕÔ]", "O"], ["[ÚÛ]", "U"], ["[Ç]", "C"], ["[ç]", "c"]]
	For $ii = 0 To UBound($Pattern, 1) - 1
		$var = StringRegExpReplace($var, $Pattern[$ii][0], $Pattern[$ii][1])
	Next
	Return $var
EndFunc   ;==>Conv

#cs
	If $JOGA_DE_NOVO Then
	If $FIRST = $iPlayer Then
	ConsoleWrite(1 & @LF)
	For $ii = 0 To 13
	If Not $ARR[$ii][2] Then
	If $ARR[$ii][3] = $iPlayer Then
	;~ 						GUICtrlSetState($ARR[$ii][0], $GUI_ENABLE)
	GUICtrlSetBkColor($ARR[$ii][0], $GREEN)
	Else
	;~ 						GUICtrlSetState($ARR[$ii][0], $GUI_DISABLE)
	GUICtrlSetBkColor($ARR[$ii][0], $DEFAULT)
	EndIf
	EndIf
	Next
	Else
	ConsoleWrite(2 & @LF)
	For $ii = 0 To 13
	If Not $ARR[$ii][2] Then
	If $ARR[$ii][3] = $iPlayer Then
	;~ 						GUICtrlSetState($ARR[$ii][0], $GUI_ENABLE)
	GUICtrlSetBkColor($ARR[$ii][0], $DEFAULT)
	Else
	;~ 						GUICtrlSetState($ARR[$ii][0], $GUI_DISABLE)
	GUICtrlSetBkColor($ARR[$ii][0], $GREEN)
	EndIf
	EndIf
	Next
	AdversarioJoga(-$iPlayer)
	EndIf
	Else
	If $FIRST = $iPlayer Then
	ConsoleWrite(3 & @LF)
	For $ii = 0 To 13
	If Not $ARR[$ii][2] Then
	If $ARR[$ii][3] = $iPlayer Then
	;~ 						GUICtrlSetState($ARR[$ii][0], $GUI_DISABLE)
	GUICtrlSetBkColor($ARR[$ii][0], $DEFAULT)
	Else
	;~ 						GUICtrlSetState($ARR[$ii][0], $GUI_ENABLE)
	GUICtrlSetBkColor($ARR[$ii][0], $ORANGE)
	EndIf
	EndIf
	Next
	AdversarioJoga(-$iPlayer)
	Else
	ConsoleWrite(4 & @LF)
	For $ii = 0 To 13
	If Not $ARR[$ii][2] Then
	If $ARR[$ii][3] = $iPlayer Then
	GUICtrlSetBkColor($ARR[$ii][0], 0xFF0000)
	;~ 						GUICtrlSetState($ARR[$ii][0], $GUI_DISABLE)
	Else
	GUICtrlSetBkColor($ARR[$ii][0], 0x00FF00)
	;~ 						GUICtrlSetState($ARR[$ii][0], $GUI_ENABLE)
	EndIf
	EndIf
	Next
	AdversarioJoga($iPlayer)
	EndIf
	EndIf
#ce
