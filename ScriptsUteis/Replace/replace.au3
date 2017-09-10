#include <Array.au3>
#include <File.au3>
 
; path do diretório
Global $sFolder = "C:\Dropbox\"
 
; monta um array com todos os arquivos '.au3' recursivamente do diretório $sFolder
Global $aFiles = _FileListToArrayRec($sFolder, "*.au3", 1, 1, 0, 2)
 
For $ii = 1 To $aFiles[0]
	; imprime o diretÃ³rio no console
	ConsoleWrite($aFiles[$ii] & @LF)
	; abre o arquivo $aFile[$ii], verifica se existe "$ghGDIPDll" e troca por "$__g_hGDIPDll"
	_ReplaceStringInFile($aFiles[$ii], "$ghGDIPDll", "$__g_hGDIPDll")
Next
