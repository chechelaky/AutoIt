; #FUNCTION# ====================================================================================================================
; Version........: 0.0.0.1
; Name...........: DirGetFiles
; Description ...: Retorna um array contendo todos os arquivs e diretórios, inclusive recursivamente se necessário
; Syntax.........:
; Parameters ....:
; Return values .:
; Author ........: Luismar Chechelaky
; Creation.......: 2017/08/13
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: https://github.com/chechelaky/AutoIt/blob/master/Diversos/DirGetFiles.au3
; Example .......:
; ===============================================================================================================================
Func DirGetFiles(ByRef $arr, $sFolder = "", $type = "*.*", $recursive = True, $self = True)
	Local $sFileName
	Local $hSearch = FileFindFirstFile($sFolder & "\*.*")
	While True
		$sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		Switch FileGetAttrib($sFolder & "\" & $sFileName)
			Case "D"
				If $recursive Then DirGetFiles($arr, $sFolder & "\" & $sFileName, $type, $recursive, $self)
			Case "A"
				Switch $type
					Case "*" & StringRight($sFolder & "\" & $sFileName, 4)
						If (@ScriptFullPath = ($sFolder & "\" & $sFileName)) Then
							If $self Then _ArrayAdd($arr, $sFolder & "\" & $sFileName)
						Else
							_ArrayAdd($arr, $sFolder & "\" & $sFileName)
						EndIf
					Case "*.*"
						If (@ScriptFullPath = ($sFolder & "\" & $sFileName)) Then
							If $self Then _ArrayAdd($arr, $sFolder & "\" & $sFileName)
						Else
							_ArrayAdd($arr, $sFolder & "\" & $sFileName)
						EndIf
				EndSwitch
		EndSwitch
	WEnd
	FileClose($hSearch)
	$aDirectory[0] = UBound($aDirectory, 1) - 1
EndFunc   ;==>DirGetFiles

