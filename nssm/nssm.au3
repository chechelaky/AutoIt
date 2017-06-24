#include <Array.au3>
;~ C:\Dropbox\Alf\nssm\nssm-2.24\win32\nssm.exe d9ec6f3a3b2ac7cd5eef07bd86e3efbc
;~ C:\Dropbox\Alf\nssm\nssm-2.24\win64\nssm.exe beceae2fdc4f7729a93e94ac2ccd78cc
Local $sServiceName = "a_user"
Local $sServicePath = @ScriptDir & "\current_user.exe"


Local $try
$try = ShellExecuteWait("nssm.exe", "stop " & $sServiceName, @ScriptDir, "", @SW_HIDE)
ConsoleWrite("@error[ " & @error & " ] try[ " & $try & " ]" & @LF)

Local $cmd = "edit " & $sServiceName & $opt & " confirm"
ConsoleWrite("$cmd[ " & $cmd & " ]" & @LF)
ShellExecuteWait("nssm.exe", $cmd, @ScriptDir, "", @SW_HIDE)
ConsoleWrite("@error[ " & @error & " ] try[ " & $try & " ]" & @LF)

;~ ShellExecuteWait("nssm.exe", "remove " & $aDir[$iInput][4] & " confirm", $aDir[$iInput][0], "", @SW_HIDE)
