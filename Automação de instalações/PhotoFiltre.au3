#include <Process.au3>
#include <GuiTab.au3>
$titulo = "Install PhotoFiltre Studio X 10.3.0"
$arquivo01 = "pfs-setup-en.exe"
$arquivo02 = "StudioBR.exe"

$J02 = "Configuração do WinRAR"
$J03 = "C:\Documents and Settings\All Users\Menu Iniciar\Programas\WinRAR"
$base = "c:\temp"
$arquivo01 = "pfs-setup-en.exe"
$arquivo02 = "StudioBR.exe"
$programa = "photofiltre"
$origem = "\\aw-001\basebasebase$\13 Imagem\PhotoFiltre 10"
$destino = $base & "\" & $programa

;arquivo01
If FileExists("C:\") Then
Else
	MsgBox(4096, "C:\", "Unidade 'C:' não existe")
	Exit
EndIf

If FileExists($base) Then
Else
	DirCreate($base)
EndIf

If FileExists($base & "\" & $programa) Then
Else
	DirCreate($base & "\" & $programa)
EndIf

If FileExists($destino & "\" & $arquivo01) Then
Else
	FileCopy($origem & "\" & $arquivo01, $destino)
EndIf

;arquivo02
If FileExists("C:\") Then
Else
	MsgBox(4096, "C:\", "Unidade 'C:' não existe")
	Exit
EndIf

If FileExists($base) Then
Else
	DirCreate($base)
EndIf

If FileExists($base & "\" & $programa) Then
Else
	DirCreate($destino)
EndIf

If FileExists($base & "\" & $programa & "\" & $arquivo02) Then
Else
	FileCopy($origem & "\" & $arquivo02, $destino)
EndIf

;instalar arquivo01
Run($destino & "\" & $arquivo01)
WinActivate($titulo, "Welcome to the PhotoFiltre Studio X Setup Wizard")
WinWaitActive($titulo, "Welcome to the PhotoFiltre Studio X Setup Wizard")
ControlClick($titulo, "", "Button2")
WinActivate($titulo, "Press Page Down to see the rest of the agreement.")
WinWaitActive($titulo, "Press Page Down to see the rest of the agreement.")
ControlClick($titulo, "", "Button2")
WinActivate($titulo, "Destination Folder")
WinWaitActive($titulo, "Destination Folder")
ControlClick($titulo, "", "Button2")
WinActivate($titulo, "NSIS (c) - Antonio Da Cruz")
WinWaitActive($titulo, "NSIS (c) - Antonio Da Cruz")
ControlClick($titulo, "", "Button2")
WinActivate($titulo, "Run PhotoFiltre Studio X")
WinWaitActive($titulo, "Run PhotoFiltre Studio X")
ControlClick($titulo, "", "Button4")
Sleep(200)
ControlClick($titulo, "", "Button2")

;instalar arquivo02
Run($destino & "\" & $arquivo02)
Exit

;configurando base
Run("C:\Arquivos de programas\PhotoFiltre Studio X\pfstudiox.exe")


WinActivate($J03)
WinWaitActive($J03)
WinClose($J03)
_RunDos("D:\Base\03 WinRAR\wrar393br serial.exe")
Sleep(100)
Run("C:\Arquivos de programas\WinRAR\WinRAR.exe")
WinActivate("[CLASS:WinRarWindow]", "")
WinWaitActive("[CLASS:WinRarWindow]", "", "")
Send("^s")
$Janela = "Configurações"
WinWait($Janela)
$hSysConfig = WinGetHandle($Janela)
$hTab = ControlGetHandle($hSysConfig, "", "SysTabControl321")

_GUICtrlTab_ClickTab($hTab, 1)
Sleep(200)
ControlClick($Janela, "", "Button2")
WinActivate("Configurar opções padrão de compressão", "")
WinWaitActive("Configurar opções padrão de compressão", "", "")
ControlCommand("Configurar opções padrão de compressão", "", "ComboBox2", "SelectString", "Ótimo")
Sleep(200)
ControlClick("Configurar opções padrão de compressão", "", "Button14")
WinActivate("Configurações", "")
WinWaitActive("Configurações", "", "")
ControlClick("Configurações", "", "Button12")
WinActivate("[CLASS:WinRarWindow]", "")
WinWaitActive("[CLASS:WinRarWindow]", "", "")
WinClose("[CLASS:WinRarWindow]", "")

;removendo temporarios
FileDelete($destino & "\" & $arquivo01)
FileDelete($destino & "\" & $arquivo02)
DirRemove($destino)
