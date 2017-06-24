$x = ""
$y = ""
$passo = 0
$linhas = InputBox("Criação de piramide", "Com quantas linhas você deseja a pirâmide?","", "")

While $passo +1<= $linhas
$temp = ((($linhas*2-1)-1)/2)-$passo-1
	While $temp >=0
		$x = $x & "."
		$temp = $temp -1
	WEnd
		
$temp = 0
	Do
		$temp = $temp + 1
		$y = $y & "#"
	Until $temp = (2 * ($passo))+1
ConsoleWrite($x & $y & $x & @CRLF)
$x = ""
$y = ""
$temp = ""
$passo = $passo + 1
WEnd