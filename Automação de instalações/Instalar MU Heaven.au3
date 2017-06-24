#Include <GuiTreeView.au3>

;Instalar e configurar MuHeaven
;DriveMapAdd("X:", "\\aw-001\eee$\lan")

;DirCopy("X:\jogos.int\MUHeaven","D:\Jogos\MUHeaven",1)
$j = "Mu Heaven 1.05x Season 4"

Run("D:\Jogos\MUHeaven\MuHeavenS4.exe")

WinWait("$j")

ControlClick("$j","","Button1")

WinWait("$j","Informação")

ControlClick("$j","","Button1")

WinWait("$j","Licença")

ControlClick("$j","","Button4")

WinWait("$j","&Avançar")

ControlClick("$j","","Button1")

WinWait("$j","Onde Mu Heaven 1.05x Season 4 deve ser instalado?")

ControlClick("$j","","Button1")

WinWait("$j","Clique em ""Instalar"" para iniciar.")

ControlClick("$j","","&Instalar")

WinWait("$j","Mu Heaven 1.05x Season 4 foi instalado com sucesso!")

ControlClick("$j","","S&air")




Exit




;DriveMapDel("X:")