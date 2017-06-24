Global $aPlot[30][30]

DrawEllipse(4, 4, 3, 4)

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

Func DrawEllipse($x, $y, $iWidth, $iHeight)
	Local $iSqrRoot, $iPrevSR
	Local $h_2, $w_2
	Local $ii
	$iPrevSR = $iSqrRoot = 0
	$h_2 = $iHeight * $iHeight
	$w_2 = $iWidth * $iWidth
	For $ii = 1 To 2 * $iWidth
		$iSqrRoot = Sqrt($h_2 - ((($h_2 * ($iWidth - $ii)) * ($iWidth - $ii)) / $w_2))

		MoveTo($ii - 1, $iHeight + $iPrevSR)
		LineTo($ii, $iHeight + $iSqrRoot)

		MoveTo($ii - 1, $iHeight - $iPrevSR)
		LineTo($ii, $iHeight - $iSqrRoot)

		$iPrevSR = $iSqrRoot
	Next
EndFunc   ;==>DrawEllipse

Func MoveTo($iXX, $iYY)
	$aPlot[$iXX][$iYY] = 1
EndFunc   ;==>MoveTo

Func LineTo($iXX, $iYY)
	$aPlot[$iXX][$iYY] = 1
EndFunc   ;==>LineTo

Func map_set_plot($iXX, $iYY)
	$aPlot[$iXX][$iYY] = 1
EndFunc   ;==>map_set_plot