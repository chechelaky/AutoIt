#include-once
#include <Date.au3>
#include <Array.au3>

; #FUNCTION# ====================================================================================================================
; Name...........: _TimeUnix
; Description ...: Convert a StringTime to UnixTime and UnixTime to StringTime
;				   All StringTime must be like this "yyyy/mm/dd hh:mm:ss"
; Syntax.........:
; Parameters ....: $mInput
;				   $iMode
; Return values .:
; Author ........: Luismar Chechelaky
; Create.........: 2015/06/10
; Modified.......: 2018/05/20
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
;	exemple 1
;		Local $now = _TimeUnix()
;		$now = 1433967837
;
;	exemple 2
;		Convert a StringTime to UnixTime
;		Local $time = _TimeUnix("2015/06/10 20:21:22")
;		$time = 1433967682
;
;	exemple 3
;		Convert a UnixTime To StringTime in "yyyy/mm/dd hh:mm:ss"
;		Local $time = _TimeUnix(1433967837)
;		$time = "2015/06/10 20:23:57"
;
;	exemple 4
;		Convert a UnixTime To StringTime in "dd/mm/yyyy hh:mm:ss"
;		Local $time = _TimeUnix(1433967837, 1)
;		$time = "10/06/2015 20:23:57"
; ===============================================================================================================================
Func _TimeUnix($mInput = 0, $iMode = 0, $date_sep = "/")
	Local $sRet = 0
	Local $sUnix = "1970/01/01 00:00:00"
	If Not $mInput Then
		; retorna a hora atual em UnixTime
		$sRet = _DateDiff("s", $sUnix, _NowCalc())
	Else
		If String($mInput) == Number($mInput) Then
			$sRet = _DateAdd("s", $mInput, $sUnix)
			If $iMode Then $sRet = StringMid($sRet, 9, 2) & $date_sep & StringMid($sRet, 6, 2) & $date_sep & StringMid($sRet, 1, 4) & " " & StringMid($sRet, 12)
		Else
			__TimeUnixAutoSense($mInput)
			$sRet = StringFormat("%014s", -_DateDiff("s", $mInput, $sUnix))
			$sRet = -_DateDiff("s", $mInput, $sUnix)
		EndIf
	EndIf
	Return $sRet
EndFunc   ;==>_TimeUnix

Func __TimeUnixAutoSense(ByRef $sTime)
	Local $aPart = StringSplit($sTime, " ", 2)

	Local $aDate = StringRegExpReplace($aPart[0], "[^0-9]", "/")
	$aDate = StringSplit($aDate, "/", 2)
	If StringLen($aDate[2]) > 2 Then _ArraySwap($aDate, 2, 0)
	$aDate = _ArrayToString($aDate, "/")

	Local $aTime = StringRegExpReplace($aPart[1], "[^0-9]", ":")
	$aTime = StringSplit($aTime, ":", 2)
	$aTime = _ArrayToString($aTime, ":", 0 , 2)
	$sTime = $aDate & " " & $aTime
EndFunc   ;==>__TimeUnixAutoSense
