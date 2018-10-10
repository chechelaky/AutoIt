#include-once
#include <Array.au3>

;	Criando o array
;Global $aTeste[1][3] = [[0]]

;	Adicionando elementos
;_ArrayAdd2D($aTeste, "a", "b", "c")
;_ArrayAdd2D($aTeste, 1, 2, 3)

;	Visualizando
;_ArrayDisplay($aTeste)

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayAdd2D
; Description ...: Add 'n' elements in $aInput
; Syntax.........: _ArrayAdd2D($aArray, "a", 20)
; Parameters ....: $aInput	ByRef input array
;				   $mOptNN	colums to add in array
; Return values .:
; Author ........: Luismar Chechelaky
; Modified.......: 2015/09/08
; Remarks .......:
; Related .......:
; Link ..........:
; ===============================================================================================================================

Func _ArrayAdd2D(ByRef $aInput, $mOpt1 = Default, $mOpt2 = Default, $mOpt3 = Default, $mOpt4 = Default, $mOpt5 = Default, $mOpt6 = Default, $mOpt7 = Default, $mOpt8 = Default, $mOpt9 = Default, $mOpt10 = Default)
	Local $id = UBound($aInput, 1)
	ReDim $aInput[$id + 1][UBound($aInput, 2)]
	$aInput[0][0] = $id

	#Region AutoIt 3.3.10.0 e superior
	Local $iCol = @NumParams < UBound($aInput, 2) ? @NumParams : UBound($aInput, 2)
	#EndRegion AutoIt 3.3.10.0 e superior

	#Region AutoIt 3.3.8.1 e anterior
;~ 	If @NumParams < UBound($aInput, 2) Then
;~ 		Local $iCol = @NumParams
;~ 	Else
;~ 		Local $iCol = UBound($aInput, 2)
;~ 	EndIf
	#EndRegion AutoIt 3.3.8.1 e anterior
	For $ii = 1 To $iCol
		$aInput[$id][$ii - 1] = Execute("$mOpt" & $ii)
	Next
EndFunc   ;==>_ArrayAdd2D

#CS
	REGEX
	http://www.ultrapico.com/ExpressoDownload.htm
#CE
