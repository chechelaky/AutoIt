#include-once
#include <File.au3>
#include <AutoItConstants.au3>

; #UDF# ========================================================================================================================
; Name...........:	DirGetFiles
; Description ...:  procura todos os arquivos .au3 recursivamente em um diretório e executa um TIDY com a opção /dg em cada arquivo
; Author ........:	Luismar Chechelaky
; Creation.......:	2017/08/13
; ===============================================================================================================================

Global $sFolder = FileSelectFolder("Escolha a pasta", @ScriptDir, $FSF_CREATEBUTTON, @ScriptDir)

Global $aDirectory[1]

If $sFolder Then
	DirGetFiles($aDirectory, $sFolder, "*.au3", True, False)
	For $ii = 1 To $aDirectory[0]
		Local $cmd = @ComSpec & " /c Tidy.exe """ & $aDirectory[$ii] & """ /gd"
		Local $PID = Run($cmd, "C:\Program Files (x86)\AutoIt3\SciTE\Tidy\", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)
		ConsoleWrite("$PID[ " & $PID & " ] @error[ " & @error & " ] nome[" & $aDirectory[$ii] & " ]" & @LF)
		While ProcessExists($PID) And Sleep(50)
		WEnd
	Next
EndIf

; #FUNCTION# ====================================================================================================================
; Version........:  0.0.0.1
; Name...........:	DirGetFiles
; Description ...:
; Syntax.........:
; Parameters ....:
; Return values .:
; Author ........:	Luismar Chechelaky
; Creation.......:	2017/08/13
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
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

