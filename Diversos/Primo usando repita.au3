$n = InputBox("Verificação de número primo", "Digite o número que você deseja verificar se é um número primo ou não","", "")
$i = 1
$x = 0
Do
    If(resto($n,$i)=0)Then
		$x = $x + 1
	EndIf
    $i = $i + 1
Until $i = $n
	If($x = 1)Then
		MsgBox("","Resultado","O número " & $n &" é primo")
	Else
		MsgBox("","Resultado","O número " & $n &" não é primo")
	EndIf

Func resto($dividendo,$divisor)
	Return (($dividendo / $divisor)-int($dividendo / $divisor))*2
EndFunc