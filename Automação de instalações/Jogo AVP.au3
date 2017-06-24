#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Luismar Chechelaky

 Script Function:
	Aliens vx Preador 2

#ce ----------------------------------------------------------------------------
$versao = "1.01"
$wer = "Aliens vs Predador 2"
$icone = "C:\Arquivos de programas\Fox\Aliens vs. Predator 2\AVP2.exe"
$fundo = int(Random(1,6))
$Size = FileGetSize("D:\ISO\AVP2\disk1\Disk1.iso")

TraySetIcon($icone,1)

#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <Process.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

$j = "VSCyber.Net Client - 2.6 - Free"
$m = "[CLASS:WindowsForms10.msctls_statusbar32.app.0.378734a; INSTANCE:1]"
$aa = ControlGetHandle($j, "", $m)
$bb = _GUICtrlStatusBar_GetText($aa, 1)
$login = (StringRight($bb,StringLen($bb) - 1))
;$nome = StringLeft(StringReplace((StringRight($bb,StringLen($bb) - 1)), " ", ""),8)
;$Player = IniRead("C:\Arquivos de programas\Fox\Aliens vs. Predator 2\Profiles\Player_0.txt", "Multiplayer", "PlayerName", "")

;Criando diretório do usuário
DriveMapAdd("y:", "\\aw-001\game.client$")
DirCreate("Y:\" & $login)
DriveMapDel("Y:")

Opt('MustDeclareVars', 1)
Global $iMemo
_Main()

Func _Main()
	Local $ConfigID, $CarregarID, $SalvarID, $ManualID, $ExitID, $JogarID, $msg, $m, $GUIMsg, $hGUI, $eca, $figura, $figuratotal, $nome, $Player, $Ask

$hGUI = GUICreate($wer, 326, 426)
GuiSetIcon($icone, 0)
;GuiCtrlCreateLabel("GameClient" & $versao, 368, 1, 79, 18, "0x1000")
;GuiCtrlCreateLabel("", 175, 38, 265, 162, "0x1000")
;GUICtrlCreateLabel("Login: " & $login, 180, 2)
;GUICtrlCreateLabel("Status", 180, 20)

;Verificando nome do usuário
DriveMapAdd("x:", "\\aw-001\game.client$\" & $login)



	;$hGUI = GUICreate("ScrollBar Example", 400, 200, -1, -1)
	$iMemo = GUICtrlCreateEdit("", 4, 245, 320, 110,$ES_AUTOVSCROLL + $WS_VSCROLL + $ES_READONLY)

	GuiCtrlCreatePic("C:\_wer\avp2\avp0"& $fundo & ".jpg",3,2, 320,240)
	;GUICtrlSetFont($iMemo, 9, 200, 0, "System")
	;GUISetBkColor(0x88AABB)

	GuiCtrlCreateLabel("Nome:", 52, 360)
	$CarregarID = GUICtrlCreateButton("&Abrir jogo", 6, 380, 100, 20)
	$SalvarID = GUICtrlCreateButton("&Salvar jogo", 113, 380, 100, 20)
	$ConfigID = GUICtrlCreateButton("&Opções", 220, 380, 100, 20)
	$ManualID = GUICtrlCreateButton("&Manual", 6, 403, 100, 20)
	$JogarID = GUICtrlCreateButton("&Jogar", 113, 403, 100, 20)
	$ExitID = GUICtrlCreateButton("Sai&r", 220, 403, 100, 20)
	$Ask = GuiCtrlCreateInput($nome, 88, 358, 150, 20)
	GUISetState()  ; display the GUI



;Verificando Diretório
If FileExists("C:\_wer\avp2") Then
	MemoWrite("Diretório existe")
Else
	MemoWrite("Diretório não existe")
	DirCreate("C:\_wer\avp2")
	MemoWrite("Diretório criado")
EndIf

;Verificando compactador
If FileExists("C:\Windows\Command\Arj.exe") Then
	MemoWrite("Compactador pronto")
Else
	DriveMapAdd("X:", "\\aw-001\game.client$")
	MemoWrite("Copiando compactador")
	FileCopy("X:\_base\arj.exe","C:\Windows\Command\",9)
	MemoWrite("Compactador pronto")
	DriveMapDel("X:")
EndIf

;Verificar figuras
$figuratotal = 9
for $a = 1 to $figuratotal
	$figura = "avp0" & $a & ".jpg"
	If FileExists("C:\_wer\avp2\" & $figura) Then
		MemoWrite("Figura " & $a & "/" & $figuratotal & " existe")
	Else
		FileCopy("\\aw-001\eee$\lan\_wer\avp2\" & $figura,"C:\_wer\avp2",9)
		MemoWrite("Figura " & $a & "/" & $figuratotal & " copiada")
	EndIf
Next

;Manual
If FileExists("C:\_wer\avp2\Manual online.pdf") Then
		MemoWrite("Manual existe")
	Else
		FileCopy("\\aw-001\eee$\lan\_wer\avp2\Manual online.pdf","C:\_wer\avp2",9)
		MemoWrite("Manual copiado")
	EndIf

;Base
If $Size = 582678528 Then
    MemoWrite("Base ok")
Else
    MemoWrite("Base comprometida, copiando...")
	FileCopy("\\aw-001\eee$\lan\iso\AVP2\disk1\Disk1.iso","D:\ISO\AVP2\disk1",9)
	MemoWrite("Base copiada")
EndIf

If FileExists("x:\usuario.ini") Then
	$nome = IniRead("x:\usuario.ini","AVP2","Nome","")
	MsgBox(0,"",$nome)
	$Player = IniWrite("C:\Arquivos de programas\Fox\Aliens vs. Predator 2\Profiles\Player_0.txt", "Multiplayer", "PlayerName", chr(34) & $nome & chr(34))
Else
	IniWrite("x:\usuario.ini","AVP2","Nome",@ComputerName)
	$nome = @ComputerName
	$Player = IniWrite("C:\Arquivos de programas\Fox\Aliens vs. Predator 2\Profiles\Player_0.txt", "Multiplayer", "PlayerName", chr(34) & $nome & chr(34))
EndIf

	;MsgBox(0,"",GUICtrlRead($Ask))
	MsgBox(0,"",$nome)

	Do
		$msg = GUIGetMsg()

		Select
			Case $msg = $CarregarID
				MemoWrite("Verificando jogo salvo.")
				DriveMapAdd("N:", "\\aw-001\game.client$\" & $nome)

			If FileExists("N:\kknd.arj") Then
				MemoWrite("Copiando jogo do servidor.")
				FileCopy("N:\kknd.arj","C:\",9)
				MemoWrite("Copiado.")
				MemoWrite("Descompactando...")
				MemoWrite("Pronto.")
			Else
				MemoWrite("Ainda não existem jogos salvos.")
				DriveMapDel("N:")
			EndIf

			Case $msg = $SalvarID
				_RunDOS("C:\Windows\Command\arj.exe a -jm -r C:\kknd.arj ""C:\Games\KKND Krossfire\SAVEGAME\*.sve""")

			Case $msg = $ConfigID
				ShellEXEcute("C:\Games\KKND Krossfire\options.EXE","","")

			Case $msg = $ManualID
				ShellEXEcute("C:\_wer\avp2\Manual online.pdf","",@SW_MAXIMIZE)

			Case $msg = $JogarID
				IniWrite("C:\Arquivos de programas\Fox\Aliens vs. Predator 2\Profiles\Player_0.txt", "Multiplayer", "PlayerName", chr(34) & $nome & chr(34))
				MemoWrite("Montando base")
				_RunDOS("C:\Arquiv~1\Alcoho~1\Alcoho~1\AxCmd.exe S: /M:D:\ISO\AVP2\disk1\Disk1.iso")
				MemoWrite("Base montada")
				MemoWrite("Chamando executável")
				Run("C:\Arquivos de programas\Fox\Aliens vs. Predator 2\lithtech.exe -cmdfile avp2cmds.txt","C:\Arquivos de programas\Fox\Aliens vs. Predator 2\",@SW_HIDE,"")

			Case $msg = $ExitID
			Case $msg = $GUI_EVENT_CLOSE
				;MsgBox(0, "Saindo...", "Close")

		EndSelect

	Until $msg = $GUI_EVENT_CLOSE Or $msg = $ExitID
EndFunc


Func MemoWrite($sMessage)
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc
Exit


;--------------------------
DriveMapAdd("y:", "\\aw-001\game.client$")
DirCreate("Y:\" & $login)
DriveMapDel("Y:")

DriveMapAdd("X:","\\aw-001\game.client$\" & $login)
FileCopy("X:\spider.sav","M:\",1)
DriveMapDel("X:")

Run("C:\Windows\System32\spider.exe")

ProcessWaitClose("spider.exe")

DriveMapAdd("X:","\\aw-001\game.client$\" & $login)
FileCopy("M:\spider.sav","X:\",1)
DriveMapDel("X:")
