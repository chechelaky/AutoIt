$n = InputBox("Conversão de número", "Digite o número que você deseja converter para binário","", "")
$temp = $n
$a = 1
$bin = ""

While $temp >0.5
	$a = mod($temp,2)
	$temp = int($temp/2)
	$bin = $a & $bin
WEnd
ConsoleWrite("O número decimal: " & $n & " é " & $bin & " em binário." & @CRLF)

Func resto($dividendo,$divisor)
	Return (($dividendo / $divisor)-int(($dividendo / $divisor)))*2
EndFunc