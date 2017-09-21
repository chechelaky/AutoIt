#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
;~ Autor: José Henrique Dometerco
;~ Adaptação para AutoIt: Luismar Chechelaky (Luigi)

Global $aListaPodres[][3] = [ _
		["coelhada", 10, 30], _
		["peido", 2, 8], _
		["rugido de fome", 3, 6], _
		["suvacada", 8, 15], _
		["arroto", 11, 18], _
		["super bafo", 14, 19], _
		["super meleca", 1, 30], _
		["soprada congelante", 4, 9], _
		["desodorante do boticário", 12, 22], _
		["lux luxo", 1, 3], _
		["gargalhada fatal", 10, 20] _
		]

Global Enum $VILAO = -1, $PESSOA = 0, $HEROI = 1
Global Enum $NOME = 0, $TIPO, $VITORIAS, $DERROTAS, $PODERES
Global $aPessoa[1][5]
Global $aPoderes[1][4]

Global $p1 = Pessoa("Cebolinha")
Transforma($p1, Aleatorio())
ConcederPodres($p1)

Global $p2 = Pessoa("Mônica")
Transforma($p2, Aleatorio())
ConcederPodres($p2)

Global $p3 = Pessoa("Cascão")
Transforma($p3, Aleatorio())
ConcederPodres($p3)

Global $p4 = Pessoa("Magali")
Transforma($p4, Aleatorio())
ConcederPodres($p4)


Func Pessoa($NOME)
	Return _ArrayAdd2D($aPessoa, $NOME, 0, 0, 0) + 1
EndFunc   ;==>Pessoa

Func Poder($id, $NOME, $forca)
	_ArrayAdd2D($aPoderes, $id, $NOME, $forca)
EndFunc   ;==>Poder

Func ConcederPodres($id)
	If $aPessoa[$id][$TIPO] = $PESSOA Then Return
	Local $arr[1][2]
	For $ii = 0 To Random(2, 2, 1)
		Local $rnd = Random(0, UBound($aListaPodres, 1) - 1, 1)
		_ArrayAdd2D($arr, $aListaPodres[$rnd][0], Random($aListaPodres[$rnd][1], $aListaPodres[$rnd][2], 1))
	Next
	$aPessoa[$id][$PODERES] = $arr
EndFunc   ;==>ConcederPodres

Func Transforma($id, $mode)
	$aPessoa[$id][$TIPO] = $mode
	Return $mode
EndFunc   ;==>Transforma

Func _ArrayAdd2D(ByRef $aInput, $mOpt1 = Default, $mOpt2 = Default, $mOpt3 = Default, $mOpt4 = Default, $mOpt5 = Default, $mOpt6 = Default, $mOpt7 = Default, $mOpt8 = Default, $mOpt9 = Default, $mOpt10 = Default)
	Local $id = UBound($aInput, 1)
	ReDim $aInput[$id + 1][UBound($aInput, 2)]
	$aInput[0][0] = $id
	Local $iCol = @NumParams < UBound($aInput, 2) ? @NumParams : UBound($aInput, 2)
	For $ii = 1 To $iCol
		$aInput[$id][$ii - 1] = Execute("$mOpt" & $ii)
	Next
	Return $id - 1
EndFunc   ;==>_ArrayAdd2D

Func Aleatorio()
	Local $arr[3] = [$VILAO, $PESSOA, $HEROI]
	Return $arr[Random(0, 2, 1)]
EndFunc   ;==>Aleatorio

Combate()

Func Combate()
	ConsoleWrite("Combate" & @LF)
	Local $aHerois = _ArrayFindAll($aPessoa, $HEROI, 1, Default, 0, 0, $TIPO)

	Local $aVilao = _ArrayFindAll($aPessoa, $VILAO, 1, Default, 0, 0, $TIPO)
	If UBound($aHerois, 1) >= 1 And UBound($aVilao, 1) >= 1 Then
		Local $iHeroi = $aHerois[Random(0, UBound($aHerois, 1) - 1, 1)]
		Local $aHeroiPodores = $aPessoa[$iHeroi][$PODERES]
		Local $iHeroiDano, $iHeroiDanoTotal
		Local $iVilao = $aVilao[Random(0, UBound($aVilao, 1) - 1, 1)]
		Local $iVilaoDano, $iVilaoDanoTotal
		Local $aVilaoPodores = $aPessoa[$iVilao][$PODERES]
		Local $golpe
		For $ii = 0 To 2
			$golpe = Random(1, UBound($aHeroiPodores, 1) - 1, 1)
			ConsoleWrite("[" & $aPessoa[$iHeroi][$NOME] & "] usou seu poder [" & $aHeroiPodores[$golpe][0] & "] e causou [" & $aHeroiPodores[$golpe][1] & "] de dano" & @LF)
			$iHeroiDanoTotal += $aHeroiPodores[$golpe][1]

			$golpe = Random(1, UBound($aVilaoPodores, 1) - 1, 1)
			ConsoleWrite("[" & $aPessoa[$iVilao][$NOME] & "] usou seu poder [" & $aVilaoPodores[$golpe][0] & "] e causou [" & $aVilaoPodores[$golpe][1] & "] de dano" & @LF)
			$iVilaoDanoTotal += $aVilaoPodores[$golpe][1]
		Next
		ConsoleWrite(@LF)
		If $iHeroiDanoTotal = $iVilaoDanoTotal Then
			ConsoleWrite("Houve empate entre [" & $aPessoa[$iHeroi][$NOME] & "] e [" & $aPessoa[$iVilao][$NOME] & "]" & @LF)
		Else
			If $iHeroiDanoTotal > $iVilaoDanoTotal Then
				ConsoleWrite("[" & $aPessoa[$iHeroi][$NOME] & "] venceu [" & $aPessoa[$iVilao][$NOME] & "] no duelo [" & $iHeroiDanoTotal & "] contra [" & $iVilaoDanoTotal & "]" & @LF)
			Else
				ConsoleWrite("[" & $aPessoa[$iVilao][$NOME] & "] venceu [" & $aPessoa[$iHeroi][$NOME] & "] no duelo [" & $iVilaoDanoTotal & "] contra [" & $iHeroiDanoTotal & "]" & @LF)
			EndIf
		EndIf
	Else
		ConsoleWrite("Não houve duelo" & @LF)
	EndIf
EndFunc   ;==>Combate
