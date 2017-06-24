MsgBox("","Resultado",resto(9,2))

Func resto($dividendo,$divisor)
	Return (($dividendo / $divisor)-int(($dividendo / $divisor)))*2

EndFunc