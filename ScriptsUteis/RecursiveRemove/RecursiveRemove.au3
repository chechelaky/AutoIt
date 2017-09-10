#include <Array.au3>
#include <File.au3>

; path do diretório
Global $sFolder = "E:\"

Global $sDrive, $sDir, $sFileName, $sExtension

; array de diretórios
Global $aFiles = _FileListToArrayRec($sFolder, "desktop.ini", 1, 1, 0, 2)

For $ii = 1 To $aFiles[0]
	_PathSplit($aFiles[$ii], $sDrive, $sDir, $sFileName, $sExtension)
	If StringLower($sFileName & $sExtension) == "desktop.ini" Then
		FileDelete($aFiles[$ii])
		ConsoleWrite($aFiles[$ii] & @LF)
	EndIf
Next
