#include <Misc.au3>
#include <Array.au3>
#include <String.au3>
Local $names[1]
ConsoleWrite("Nome:" & _nome() & @LF)

Local $yy = 0
While $yy < 50
	Local $temp = _nome()
	ConsoleWrite("[" & $yy & "][" & StringInStr("y", $temp) & "]" & $temp & @LF)
	_ArrayAdd($names, $temp)
	$yy += 1
WEnd
_ArrayDisplay($names)


; #FUNCTION# ====================================================================================================================
; Name...........: _nome
; Description ...: Retorna uma string contendo um nome construído com sílabas aleatórias
;                  Return a string with a name build with random syllable
; Syntax.........: _nome()
; Parameters ....:
; Return values .: string name
; Author ........: Luigi (Luismar Chechelaky)
; Modified.......:
; Remarks .......:
; Link ..........:
; Example .......: Yes
; AutoIt version.: 3.3.12.0
; ===============================================================================================================================
Func _nome()
	;	require
	;	#include <Misc.au3>
	;	#include <String.au3>
	Local $aVogais = StringSplit("aeiouy", "")
	Local $aConsoantes = StringSplit("bcdfghjklmnpqrstvwx", "")
	Local $aDigrafos = StringSplit("ch,lh,nh,ph,ç,ss,rr,wh,st,lk,nk,br,kn,bl,cl", ",")
	Local $aFinal = StringSplit("bcdfghklmprstvwx", "")
	;ConsoleWrite(">" & $aConsoantes[0] & @LF)
	Local $sNome = "", $sSobreNome = ""
	$sNome = (Random(0, 1, 1) ? $aVogais[Random(1, 6, 1)] : "")

	For $x = 0 To Random(1, 2, 1)
		If $x Then
			$sNome &= $aConsoantes[Random(1, 19, 1)] & $aVogais[Random(1, 6, 1)]
		Else
			If $sNome Then
				$sNome &= (Random(0, 1, 1) ? $aConsoantes[Random(1, $aConsoantes[0] - 1, 1)] : $aDigrafos[Random(1, $aDigrafos[0], 1)]) & $aVogais[Random(1, 6, 1)]
			Else
				$sNome &= $aConsoantes[Random(1, $aConsoantes[0] - 1, 1)] & $aVogais[Random(1, 6, 1)]
			EndIf
		EndIf
	Next
	$sNome = $sNome & (Random(0, 1, 1) ? $aFinal[Random(1, $aFinal[0], 1)] : "")
	$sSobreNome = (Random(0, 1, 1) ? $aVogais[Random(1, 5, 1)] : "")
	For $xx = 0 To Random(1, 4, 1)
		If $xx Then
			$sSobreNome &= $aConsoantes[Random(1, 19, 1)] & $aVogais[Random(1, 5, 1)]
		Else
			If $sSobreNome Then
				$sSobreNome &= (Random(0, 1, 1) ? $aConsoantes[Random(1, $aConsoantes[0] - 1, 1)] : $aDigrafos[Random(1, $aDigrafos[0], 1)]) & $aVogais[Random(1, 5, 1)]
			Else
				$sSobreNome &= $aConsoantes[Random(1, $aConsoantes[0] - 1, 1)] & $aVogais[Random(1, 5, 1)]
			EndIf
		EndIf
	Next
	$sSobreNome = $sSobreNome & (Random(0, 1, 1) ? $aFinal[Random(1, $aFinal[0], 1)] : "")
	Return _StringProper($sNome) & (Random(0, 1, 1) ? (Random(0, 1, 1) ? " de " : " do ") : " ") & _StringProper($sSobreNome)
EndFunc   ;==>_nome
