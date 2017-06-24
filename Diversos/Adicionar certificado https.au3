#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Local $certificado = "ITI.crt"
Local $path = @WindowsDir

Run(@ComSpec & ' /c ' & $path & '\certmgr.exe /add ' & $certificado & '\cacert.pem.cer -s Root','',@SW_HIDE)