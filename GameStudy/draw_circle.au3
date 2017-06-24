Global $aPlot[30][30]

DrawCircle(14, 14, 14)
DrawCircle(14, 6, 3)
DrawCircle(14, 15, 3)

For $ii = 0 To UBound($aPlot, 1) - 1
	For $jj = 0 To UBound($aPlot, 2) - 1
		If $aPlot[$ii][$jj] Then
			ConsoleWrite("@")
		Else
			ConsoleWrite("-")
		EndIf
	Next
	ConsoleWrite(@LF)
Next


Func DrawCircle($iXX, $iYY, $iRadius)
;~ 	https://en.wikipedia.org/wiki/Midpoint_circle_algorithm
	Local $iX = $iRadius, $iY = 0, $decisionOver2 = 1 - $iX
	While $iX >= $iY
		map_set_plot($iX + $iXX, $iY + $iYY)
		map_set_plot($iY + $iXX, $iX + $iYY)
		map_set_plot(-$iX + $iXX, $iY + $iYY)
		map_set_plot(-$iY + $iXX, $iX + $iYY)
		map_set_plot(-$iX + $iXX, -$iY + $iYY)
		map_set_plot(-$iY + $iXX, -$iX + $iYY)
		map_set_plot($iX + $iXX, -$iY + $iYY)
		map_set_plot($iY + $iXX, -$iX + $iYY)
		$iY += 1
		If $decisionOver2 <= 0 Then
			$decisionOver2 += 2 * $iY + 1
		Else
			$iX -= 1
			$decisionOver2 += 2 * ($iY - $iX) + 1
		EndIf
	WEnd
EndFunc   ;==>DrawCircle

Func map_set_plot($iXX, $iYY)
	$aPlot[$iXX][$iYY] = 1
EndFunc   ;==>map_set_plot
