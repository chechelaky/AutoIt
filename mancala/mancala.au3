;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

; #SCRIPT# ======================================================================================================================
; Name ..........: mancala.au3
; Author ........: Luigi (Luismar Chechelaky)
; Description ...: adaptação do jogo de mancala para AutoIt
; Link ..........: https://github.com/chechelaky/AutoIt/blob/master/mancala/mancala.au3
; webgrafia......: http://www.ludomania.com.br/Tradicionais/mancala.html
; ===============================================================================================================================

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

OnAutoItExitRegister("OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $aGuiSize[2] = [1200, 400]
Global $sGuiTitle = "GuiTitle"
Global $hGui
Global $dummy
Global $hPlayerA, $hPlayerB

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
$dummy = GUICtrlCreateButton("", 0, 0, 0, 0)
Botoes()

$hPlayerA = GUICtrlCreateLabel("A[ 24 ]", 10, 320, 80, 25)
$hPlayerB = GUICtrlCreateLabel("B[ 24 ]", 10, 340, 80, 25)

Global $QuemJogou = 0 ; 0(Escolher), 1(Cima), 2(Baixo)


GUISetState(@SW_SHOW, $hGui)

While Sleep(25)
WEnd

Func Botoes()
	Local $iIntervalo = 20, $half = $iIntervalo / 2
	Local $iLargura = Int(($aGuiSize[0] - $iIntervalo * 9) / 8)

	Global $CASAS[14], $PEDRAS[14] = [4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 0]
	For $ii = 0 To 13
		Switch $ii
			Case 0, 1, 2, 3, 4, 5
				$CASAS[$ii] = GUICtrlCreateButton($PEDRAS[$ii], $iIntervalo + ($iIntervalo + $iLargura) * ($ii + 1), $iIntervalo * 2 + $iLargura, $iLargura, $iLargura, Default, $WS_EX_TOPMOST)
			Case 6
				$CASAS[$ii] = GUICtrlCreateButton($PEDRAS[$ii], $iIntervalo * 8 + $iLargura * 7, $iIntervalo, $iLargura, $iLargura * 2 + $iIntervalo, $SS_SUNKEN)
			Case 13
				$CASAS[$ii] = GUICtrlCreateButton($PEDRAS[$ii], $iIntervalo, $iIntervalo, $iLargura, $iLargura * 2 + $iIntervalo, $SS_SUNKEN)
			Case 7, 8, 9, 10, 11, 12
				$CASAS[$ii] = GUICtrlCreateButton($PEDRAS[$ii], $iIntervalo + ($iIntervalo + $iLargura) * (13 - $ii), $iIntervalo, $iLargura, $iLargura)
		EndSwitch
		GUICtrlSetTip($CASAS[$ii], $CASAS[$ii], "$ii[" & $ii & "]")
		GUICtrlSetOnEvent($CASAS[$ii], "Evento")
		GUICtrlSetFont($CASAS[$ii], 40, 400, 0, "Courier New")
	Next
EndFunc   ;==>Botoes

Func QuemJogou($in)
	Switch $in
		Case $CASAS[0] To $CASAS[0] + 6
			Return 1
		Case $CASAS[0] + 7 To $CASAS[0] + 13
			Return 2
	EndSwitch
EndFunc   ;==>QuemJogou

Func _DePara($in)
	Switch $in
		Case 4 To 9, 11 To 16
			Return $CASAS[13] - $in + $CASAS[0]
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>_DePara

Func Evento()
	Local $JOGA_MAIS_UMA_VEZ = False

	; identifica quem está jogando
	$QuemJogou = QuemJogou(@GUI_CtrlId)
	; verifica quantas pedrás existem na casa
	; caso não haje nenhuma pedra ou seja uma KALA, interrompe
	Local $QuantasPedras = GUICtrlRead(@GUI_CtrlId)
	If Not Number($QuantasPedras) Or @GUI_CtrlId = 10 Or @GUI_CtrlId = 17 Then Return

	ConsoleWrite("QuantasPedras[ " & $QuantasPedras & " ]" & @LF)
	; zera as pedras da casa
	GUICtrlSetData(@GUI_CtrlId, 0)
	Local $try

	; calcula o loop, baseado na quantidade de sementes
	; e distribui uma semente para cada uma das próximas casas
	For $ii = 1 To $QuantasPedras
		$try = @GUI_CtrlId + $ii
		If $try - $CASAS[0] > 13 Then $try -= 14
		GUICtrlSetData($try, GUICtrlRead($try) + 1)
	Next
	; define a kala do jogador
	Local $kala = $QuemJogou = 2 ? 17 : 10
	; verifica se a última casa onde foi depositada a semente é uma kala
	; se for kala, joga mais uma vez
	If $try = $kala Then
		$JOGA_MAIS_UMA_VEZ = True
		GUICtrlSetState(@GUI_CtrlId, $GUI_DISABLE)
	EndIf

	ConsoleWrite("@[ " & @GUI_CtrlId & " ] $try[ " & $try & " ]  _DePara[ " & _DePara($try) & " ] $QuantasPedras[" & $QuantasPedras & "] $ii[" & $ii & "] $QuemJogou[" & $QuemJogou & "]" & @LF)
	; verifica se a ultima casa possui uma semente, e se na casa do adversário há sementes
	; caso afirmativo, pega as sementes do adversário e movimenta para a kala
	Local $DePara = _DePara($try)
	If Number(GUICtrlRead($try)) = 1 And Number(GUICtrlRead($DePara)) Then
		ConsoleWrite("KALA" & @LF)
		GUICtrlSetData($kala, GUICtrlRead($try) + GUICtrlRead($DePara) + GUICtrlRead($kala))
		GUICtrlSetData($try, 0)
		GUICtrlSetData($DePara, 0)
		GUICtrlSetState(@GUI_CtrlId, $GUI_DISABLE)
		GUICtrlSetState($try, $GUI_DISABLE)
		GUICtrlSetState($DePara, $GUI_DISABLE)

		$JOGA_MAIS_UMA_VEZ = True
	EndIf

	; desabilita as casas sem sentes e do jogador adversário
	; habilita as casas do jogador que possuem sementes
	If $JOGA_MAIS_UMA_VEZ Then

	Else
		Switch $QuemJogou
			Case 1
				For $ii = $CASAS[0] To $CASAS[0] + 5
					GUICtrlSetState($ii, $GUI_DISABLE)
				Next

				For $ii = $CASAS[0] + 7 To $CASAS[0] + 13
					If Number(GUICtrlRead($ii)) Then GUICtrlSetState($ii, $GUI_ENABLE)
				Next
			Case 2
				For $ii = $CASAS[0] To $CASAS[0] + 6
					If Number(GUICtrlRead($ii)) Then GUICtrlSetState($ii, $GUI_ENABLE)
				Next

				For $ii = $CASAS[0] + 7 To $CASAS[0] + 12
					GUICtrlSetState($ii, $GUI_DISABLE)
				Next
		EndSwitch
	EndIf
	GUICtrlSetState($dummy, $GUI_FOCUS)
	HouveGanhador()
EndFunc   ;==>Evento

Func HouveGanhador()
	Local $iPlayerA = 0
	Local $iPlayerB = 0
	For $ii = 4 To 10
		$iPlayerA += GUICtrlRead($ii)
		$iPlayerB += GUICtrlRead($ii + 7)
	Next
	GUICtrlSetData($hPlayerA, "A[ " & $iPlayerA & " ]")
	GUICtrlSetData($hPlayerB, "B[ " & $iPlayerB & " ]")
EndFunc   ;==>HouveGanhador

Func OnExit()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	Exit
EndFunc   ;==>Quit
