#include <Array.au3>
#include <StaticConstants.au3>

#include <Misc.au3>
#include <ColorConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <Misc.au3>
#include <GUIConstantsEx.au3>
Global $hDll = DllOpen('user32.dll'), $aMove[4] = [0, 0, 0, 0]
Global $aActor[1][5]
Global $aPos[2]
Global $hGui, $hMsg, $sTitle = 'Título'
Global $iGrid[2] = [94, 40]
Global $hButtons[$iGrid[0]][$iGrid[1]]
Global $pix[$iGrid[0]][$iGrid[1]]
Global $aNode[1][6]
Global $cmd[8]
Global $velocidade = 2

Local $linha

$hGui = GUICreate($sTitle, 20 + 20 * $iGrid[0], 140 + 20 * $iGrid[1], -1, -1, Default, 0x02000000)
$cmd[0] = GUICtrlCreateButton(Chr(235), 900, 0, 20, 20)
GUICtrlSetFont(-1, 11, 400, 0, 'wingdings')
$cmd[1] = GUICtrlCreateButton(Chr(233), 920, 0, 20, 20)
GUICtrlSetFont(-1, 11, 400, 0, 'wingdings')
$cmd[2] = GUICtrlCreateButton(Chr(236), 940, 0, 20, 20)
GUICtrlSetFont(-1, 11, 400, 0, 'wingdings')
$cmd[3] = GUICtrlCreateButton(Chr(231), 900, 20, 20, 20)
GUICtrlSetFont(-1, 11, 400, 0, 'wingdings')
$cmd[4] = GUICtrlCreateButton(Chr(232), 940, 20, 20, 20)
GUICtrlSetFont(-1, 11, 400, 0, 'wingdings')
$cmd[5] = GUICtrlCreateButton(Chr(237), 900, 40, 20, 20)
GUICtrlSetFont(-1, 11, 400, 0, 'wingdings')
$cmd[6] = GUICtrlCreateButton(Chr(234), 920, 40, 20, 20)
GUICtrlSetFont(-1, 11, 400, 0, 'wingdings')
$cmd[7] = GUICtrlCreateButton(Chr(238), 940, 40, 20, 20)
GUICtrlSetFont(-1, 11, 400, 0, 'wingdings')

Local $label
For $yy = 0 To $iGrid[1] - 1
	For $xx = 0 To $iGrid[0] - 1
		$label = $yy & @LF & $xx
;~ 		$label = ''
		$hButtons[$xx][$yy] = GUICtrlCreateLabel($label, 10 + $xx * 20, 80 + $yy + $linha, 22, 22, BitOR($SS_CENTER, $SS_SUNKEN), $WS_EX_STATICEDGE)
		GUICtrlSetFont($hButtons[$xx][$yy], 6, 500, 0, 'Arial')
		$pix[$xx][$yy] = 0
	Next
	$linha += 20
Next

_addActor('red', 36, 5, 4, 5)
Global $limE = $iGrid[0] - $aActor[0][3]
Global $limB = $iGrid[1] - $aActor[0][4]
GUISetState(@SW_SHOWNORMAL)

addWall('a', 7, 7, 1, 7)
addWall('b', 8, 7, 4, 1)
addWall('b', 8, 13, 4, 1)
addWall('blue', 40, 10, 2, 8)
;~ addWall('blue', 0, 2, 1, 2)
;~ addWall('blue', 2, 2, 1, 3)
addWall('green', 42, 10, 8, 2)
;~ addWall('yellow', 0, 37, 2, 2)

Func addWall($color, $posX, $posY, $lar, $alt)
	ReDim $aNode[UBound($aNode, 1) + 1][UBound($aNode, 2)]
	Local $id = UBound($aNode, 1) - 1
	$aNode[$id][0] = 1
	$aNode[$id][1] = $posX
	$aNode[$id][2] = $posY
	$aNode[$id][3] = $lar
	$aNode[$id][4] = $alt
	For $xx = $posX To $posX + $aNode[$id][3] - 1
		For $yy = $posY To $posY + $aNode[$id][4] - 1
			$pix[$xx][$yy] = 'w' & $id
			GUICtrlSetBkColor($hButtons[$xx][$yy], color($color))
		Next
	Next
EndFunc   ;==>addWall

Func _addActor($color, $posX, $posY, $lar, $alt)
	For $xx = $posX To $posX + $lar - 1
		For $yy = $posY To $posY + $alt - 1
			GUICtrlSetBkColor($hButtons[$xx][$yy], color($color))
		Next
	Next
	$aPos[0] = $posX
	$aPos[1] = $posY
	$aActor[0][0] = 1
	$aActor[0][1] = $posX
	$aActor[0][2] = $posY
	$aActor[0][3] = $lar
	$aActor[0][4] = $alt
EndFunc   ;==>_addActor

Local $count = TimerInit()

While 1
	$hMsg = GUIGetMsg()
	Switch $hMsg
		Case $GUI_EVENT_CLOSE
			_exit()
		Case $cmd[0]
			leftUp($aPos, $velocidade)
		Case $cmd[2]
			rightUp($aPos, $velocidade)
		Case $cmd[5]
			leftDown($aPos, $velocidade)
		Case $cmd[7]
			rightDown($aPos, $velocidade)
	EndSwitch

	If TimerDiff($count) > 15 Then
		For $xx = 0 To 3
			If _IsPressed(25 + $xx, $hDll) And Not $aMove[$xx] Then
				$aMove[$xx] = 1
			ElseIf $aMove[$xx] And Not _IsPressed(25 + $xx, $hDll) Then
				$aMove[$xx] = 0
			EndIf
		Next
		_moveChar($aPos, $velocidade)
		$count = TimerInit()
	EndIf
WEnd

Func _moveChar(ByRef $arr, $iVel = 1)
	Local $move = _ArrayToString($aMove, ''), $iVel2 = Round($iVel * 0.7071);0.707106781186548
	Switch $move
		Case '1000' ;esquerda
			If $arr[0] > 0 Then
				Local $passo = $iVel, $temp = $arr
				Do
					Local $con[1]
					For $yy = $arr[1] To $arr[1] + $aActor[0][4] - 1
						If $pix[$arr[0] - 1][$yy] Then _ArrayAdd($con, $pix[$arr[0] - 1][$yy])
					Next
					If UBound($con) - 1 Then
						ConsoleWrite('contato[' & _ArrayToString($con, ',', 1) & ']' & @LF)
					Else
						$arr[0] -= 1
						$arr[0] = _Iif($arr[0] < 0, 0, $arr[0])
						For $yy = $arr[1] To $arr[1] + $aActor[0][4] - 1
							GUICtrlSetBkColor($hButtons[$arr[0]][$yy], 0xFF0000)
							GUICtrlSetBkColor($hButtons[$arr[0] + $aActor[0][3]][$yy], 0xD4D0C8)
						Next
					EndIf
					$passo -= 1
				Until $passo = 0 Or $arr[0] = 0 Or UBound($con) - 1
			EndIf
		Case '0100' ;cima
			If $arr[1] > 0 Then
				Local $passo = $iVel, $temp = $arr
				Do
					Local $con[1]
					For $xx = $arr[0] To $arr[0] + $aActor[0][3] - 1
						If $pix[$xx][$arr[1] - 1] Then _ArrayAdd($con, $pix[$xx][$arr[1] - 1])
					Next
					If UBound($con) - 1 Then
						ConsoleWrite('contato[' & _ArrayToString($con, ',', 1) & ']' & @LF)
					Else
						$arr[1] -= 1
						$arr[1] = _Iif($arr[1] < 0, 0, $arr[1])
						For $xx = $arr[0] To $arr[0] + $aActor[0][3] - 1
							GUICtrlSetBkColor($hButtons[$xx][$arr[1]], 0xFF0000)
							GUICtrlSetBkColor($hButtons[$xx][$arr[1] + $aActor[0][4]], 0xD4D0C8)
						Next
					EndIf
					$passo -= 1
				Until $passo = 0 Or $arr[1] = 0 Or UBound($con) - 1
			EndIf
		Case '0010' ;direita
			If $arr[0] < $limE Then
				Local $time = TimerInit()
				Local $passo = $iVel
				Do
					Local $con[1]

					For $yy = $arr[1] To $arr[1] + $aActor[0][4] - 1
						If $pix[$arr[0] + $aActor[0][3]][$yy] Then _ArrayAdd($con, $pix[$arr[0] + $aActor[0][3]][$yy])
					Next

					Local $time4 = TimerInit()
					If UBound($con) - 1 Then
;~ 						ConsoleWrite('contato[' & _ArrayToString($con, ',', 1) & ']' & @LF)
					Else
						$arr[0] += 1
						If $arr[0] > $limE Then $arr[0] = $limE
						For $yy = $arr[1] To $arr[1] + $aActor[0][4] - 1
							GUICtrlSetBkColor($hButtons[$arr[0] + $aActor[0][3] - 1][$yy], 0xFF0000)
							GUICtrlSetBkColor($hButtons[$arr[0] - 1][$yy], 0xD4D0C8)
						Next
					EndIf
					ConsoleWrite('temp4[' & TimerDiff($time4) & ']' & @LF)
					$passo -= 1
;~ 					ConsoleWrite('passo[' & $passo & '] $arr[' & $arr[0] & '] Ubound[' & UBound($con) - 1 & ']' & @LF)
				Until $passo = 0 Or $arr[0] = $limE Or UBound($con) - 1
				ConsoleWrite('tempo3[' & TimerDiff($time) & ']' & @LF)
			EndIf
		Case '0001' ;baixo
			If $arr[1] < $limB Then
				Local $time = TimerInit()
				Local $passo = $iVel
				Do
					Local $con[1]
					For $xx = $arr[0] To $arr[0] + $aActor[0][3] - 1
						If $pix[$xx][$arr[1] + $aActor[0][3]] Then _ArrayAdd($con, $pix[$xx][$arr[1] + $aActor[0][3]])
					Next

					Local $time4 = TimerInit()
					If UBound($con) - 1 Then
;~ 						ConsoleWrite('contato[' & _ArrayToString($con, ',', 1) & ']' & @LF)
					Else
						$arr[1] += 1
						If $arr[1] > $limB Then $arr[1] = $limB
						For $xx = $arr[0] To $arr[0] + $aActor[0][3] - 1
							GUICtrlSetBkColor($hButtons[$xx][$arr[1] + $aActor[0][3] - 0], 0xFF0000)
							GUICtrlSetBkColor($hButtons[$xx][$arr[1] - 1], 0xD4D0C8)
						Next
					EndIf
					ConsoleWrite('temp4[' & TimerDiff($time4) & ']' & @LF)
					$passo -= 1
;~ 					ConsoleWrite('passo[' & $passo & '] $arr[' & $arr[0] & '] Ubound[' & UBound($con) - 1 & ']' & @LF)
				Until $passo = 0 Or $arr[0] = $limE Or UBound($con) - 1
				ConsoleWrite('tempo3[' & TimerDiff($time) & ']' & @LF)
			EndIf
		Case '1100' ;esquerda-cima
			leftUp($arr, $iVel2)
		Case '0110' ;direita-cima
			rightUp($arr, $iVel2)
		Case '0011' ;direita-baixo
			rightDown($arr, $iVel2)
		Case '1001' ;esquerda-baixo
			leftDown($arr, $iVel2)
	EndSwitch
EndFunc   ;==>_moveChar

Func rightDown(ByRef $arr, $iVel = 3)
	Local $temp = $arr
	Local $try = $arr
	If $try[0] >= $iGrid[0] - $aActor[0][3] And $try[1] >= $iGrid[1] - $aActor[0][4] Then
		Return
	Else
		Local $passo = 0
		Do
			If $try[1] + $aActor[0][4] >= $iGrid[1] Then
				Local $dx = $try[0] + $aActor[0][3]
				$dx = _Iif($dx >= $iGrid[0], $iGrid[0] - $aActor[0][3], $dx)
				Local $sX = 0
				For $yy = $try[1] To $try[1] + $aActor[0][3]
					$sX += _Iif($pix[$dx][$yy] == 0, 0, 1)
				Next
				If $sX == 0 Then $try[0] += 1
			Else
				If $try[0] >= $iGrid[0] - $aActor[0][3] Then
;~ 					ConsoleWrite('aqui' & @LF)
;~ 					GUICtrlSetBkColor($hButtons[$try[0]][$try[1] + $aActor[0][4]], color('e'))
					Local $dy = $try[1] + $aActor[0][4], $sY = 0
					For $xx = $try[0] To $try[0] + $aActor[0][3] - 1
						$sY += _Iif($pix[$xx][$dy] == 0, 0, 1)
					Next
					If $sY == 0 Then $try[1] += 1
				Else
					Local $dx = $try[0] + $aActor[0][3]
					Local $dy = $try[1] + $aActor[0][4]
;~ 					GUICtrlSetBkColor($hButtons[$dx][$dy], color('e'))
					Local $aa = _Iif($pix[$dx][$dy - $aActor[0][4]] == 0, 1, 0)
;~ 					GUICtrlSetData($hButtons[$dx][$dy - $aActor[0][4]], $aa)
;~ 					GUICtrlSetBkColor($hButtons[$dx][$dy - $aActor[0][4]], color('a'))
					Local $bb = calcRightDownB($dx, $dy, $aActor, 0)
					Local $cc = _Iif($pix[$dx][$dy] == 0, 1, 0)
;~ 					GUICtrlSetBkColor($hButtons[$dx][$dy], color('c'))
					Local $dd = calcRightDownD($dx, $dy, $aActor, 0)
					Local $ee = _Iif($pix[$dx - $aActor[0][3]][$dy] == 0, 1, 0)
;~ 					GUICtrlSetBkColor($hButtons[$dx - $aActor[0][3]][$dy], color('e'))
;~ 					ConsoleWrite($aa & $bb & $cc & $dd & $ee & @LF)
					Switch $aa & $bb & $cc & $dd & $ee
						Case 11111, 11110, 01111
							$try[0] += 1
							$try[1] += 1
						Case 11011
							$try[Random(0, 1, 1)] += 1
						Case 11001, 11000, 11100, 11101
							$try[0] += 1
						Case 10011, 00011, 00111
							$try[1] += 1
					EndSwitch
				EndIf
			EndIf
			$passo += 1
			$arr[0] = _Iif($try[0] >= $iGrid[0] - $aActor[0][3], $iGrid[0] - $aActor[0][3], $try[0])
			$arr[1] = _Iif($try[1] >= $iGrid[1] - $aActor[0][4] + 1, $iGrid[1] - $aActor[0][4], $try[1])
		Until $passo = $iVel
		actorClear($temp)
		actorDraw($arr)
	EndIf
;~ 	ConsoleWrite('arr[' & _ArrayToString($arr, ',') & '] iVel=' & $iVel & @LF)
EndFunc   ;==>rightDown


Func calcRightDownB($dx, $dy, $aActor, $id)
	Local $sY = 0
	For $yy = $dy - $aActor[$id][3] To $dy - 1
		$sY += _Iif($pix[$dx][$yy] == 0, 0, 1)
;~ 		GUICtrlSetData($hButtons[$dx][$yy], _Iif($pix[$dx][$yy] == 0, 1, 0))
;~ 		GUICtrlSetBkColor($hButtons[$dx][$yy], color('b'))
	Next
	Return _Iif($sY == 0, 1, 0)
EndFunc   ;==>calcRightDownB

Func calcRightDownD($dx, $dy, $aActor, $id)
	Local $sX = 0
	For $xx = $dx - $aActor[0][3] + 1 To $dx - 1
		$sX += _Iif($pix[$xx][$dy] == 0, 0, 1)
;~ 		GUICtrlSetBkColor($hButtons[$xx][$dy], color('d'))
	Next
	Return _Iif($sX == 0, 1, 0)
EndFunc   ;==>calcRightDownD

Func actorDraw($arr)
;~ 	ConsoleWrite('$arr[' & _ArrayToString($arr, '-') & ']' & @LF)
	For $xx = $arr[0] To $arr[0] + $aActor[0][3] - 1
		For $yy = $arr[1] To $arr[1] + $aActor[0][4] - 1
			GUICtrlSetBkColor($hButtons[$xx][$yy], $COLOR_RED)
		Next
	Next
EndFunc   ;==>actorDraw

Func actorClear($arr)
	For $xx = $arr[0] To $arr[0] + $aActor[0][3] - 1
		For $yy = $arr[1] To $arr[1] + $aActor[0][4] - 1
			GUICtrlSetBkColor($hButtons[$xx][$yy], $CLR_DEFAULT)
		Next
	Next
EndFunc   ;==>actorClear

Func _exit()
	DllClose($hDll)
	Exit
EndFunc   ;==>_exit

Func color($input)
	Switch $input
		Case 'aqua'
			Return 0x00ffff
		Case 'black'
			Return 0x000000
		Case 'blue'
			Return 0x0000ff
		Case 'cream'
			Return 0xfffbf0
		Case 'fucsia'
			Return 0xff00ff
		Case 'cinza'
			Return 0x808080
		Case 'verde'
			Return 0x008000
		Case 'limao'
			Return 0x00ff00
		Case 'marron'
			Return 0x8b1c62
		Case 'azul1'
			Return 0x0002c4
		Case 'cinza1'
			Return 0xa0a0a4
		Case 'verde1'
			Return 0xc0dcc0
		Case 'navy'
			Return 0x000080
		Case 'oliva'
			Return 0x808000
		Case 'purpura'
			Return 0x800080
		Case 'red'
			Return 0xff0000
		Case 'prata'
			Return 0xc0c0c0
		Case 'azul2'
			Return 0xa6caf0
		Case 'teal'
			Return 0x008080
		Case 'white'
			Return 0xffffff
		Case 'yellow'
			Return 0xffff00
		Case 'a'
			Return 0xccffcc
		Case 'b'
			Return 0xff9900
		Case 'c'
			Return 0x00ccff
		Case 'd'
			Return 0xff00ff
		Case 'e'
			Return 0x808000
	EndSwitch
EndFunc   ;==>color

Func calcLeftUpB($dx, $dy, $aActor, $id)
	Local $sY = 0
	For $yy = $dy + 1 To $dy + $aActor[$id][3]
		$sY += _Iif($pix[$dx][$yy] == 0, 0, 1)
	Next
	Return _Iif($sY == 0, 1, 0)
EndFunc   ;==>calcLeftUpB

Func calcLeftUpC($dx, $dy, $aActor, $id)
	Local $sX = 0
	For $xx = $dx + 1 To $dx + $aActor[$id][4] - 2
		$sX += _Iif($pix[$xx][$dy] == 0, 0, 1)
	Next
	Return _Iif($sX == 0, 1, 0)
EndFunc   ;==>calcLeftUpC

Func leftUp(ByRef $arr, $iVel = 3)
	Local $temp = $arr
	Local $try = $arr
	If $try[0] <= 0 And $try[1] <= 0 Then
		Return
	Else
		Local $passo = 0
		Do
			Local $dx = _Iif($try[0] - 1 <= 0, 0, $try[0] - 1)
			Local $dy = _Iif($try[1] - 1 <= 0, 0, $try[1] - 1)

			Local $aa = _Iif($pix[$dx][$dy + $aActor[0][4]] == 0, 1, 0)
			Local $bb = calcLeftUpB($dx, $dy, $aActor, 0)
			Local $cc = _Iif($pix[$dx][$dy] == 0, 1, 0)
			Local $dd = calcLeftUpC($dx, $dy, $aActor, 0)
			Local $ee = _Iif($pix[$dx + $aActor[0][3]][$dy] == 0, 1, 0)
;~ 			ConsoleWrite('[' & $aa & $bb & $cc & $dd & $dd & ']' & @LF)
			Switch $aa & $bb & $cc & $dd & $dd
				Case 11111, 01111
					$try[0] -= 1
					$try[1] -= 1
				Case 10011, 00011, 00111, 10111
					$try[1] -= 1
				Case 11011
					$try[Random(0, 1, 1)] -= 1
				Case 11000, 11100
					$try[0] -= 1
			EndSwitch
			$passo += 1
			$arr[0] = _Iif($try[0] < 0, 0, $try[0])
			$arr[1] = _Iif($try[1] < 0, 0, $try[1])
		Until $passo = $iVel
		actorClear($temp)
		actorDraw($arr)
	EndIf
EndFunc   ;==>leftUp

Func rightUp(ByRef $arr, $iVel = 3)
	Local $temp = $arr
	Local $try = $arr
	If $try[0] >= $iGrid[0] - $aActor[0][3] And $try[1] <= 0 Then
		Return
	Else
		Local $passo = 0
		Do
			Local $dx = _Iif($try[0] + 1 >= $iGrid[0] - $aActor[0][3], $iGrid[0] - $aActor[0][3], $try[0] + 1)
			Local $dy = _Iif($try[1] - 1 <= 0, 0, $try[1] - 1)
			Local $aa = _Iif($pix[$dx + $aActor[0][3] - 1][$dy + $aActor[0][4]] == 0, 1, 0)
;~ 			GUICtrlSetBkColor($hButtons[$dx + $aActor[0][3] - 1][$dy + $aActor[0][4]], color('a'))
			Local $bb = calcRightUpB($dx, $dy, $aActor, 0)
			Local $cc = _Iif($pix[$dx + $aActor[0][3] - 1][$dy] == 0, 1, 0)
;~ 			GUICtrlSetBkColor($hButtons[$dx + $aActor[0][3] - 1][$dy], color('c'))
			Local $dd = calcRightUpC($dx, $dy, $aActor, 0)
			Local $ee = _Iif($pix[$dx - 1][$dy] == 0, 1, 0)
;~ 			GUICtrlSetBkColor($hButtons[$dx - 1][$dy], color('e'))
;~ 			ConsoleWrite('[' & $aa & $bb & $cc & $dd & $ee & ']' & @LF)
			Switch $aa & $bb & $cc & $dd & $ee
				Case 11111, 01111, 11110
					$try[0] += 1
					$try[1] -= 1
				Case 10011, 00011, 00111
					$try[1] -= 1
				Case 11011
					If Random(0, 1, 1) Then
						$try[0] += 1
					Else
						$try[1] -= 1
					EndIf
				Case 11001, 11101, 11100, 11000
					$try[0] += 1
			EndSwitch
			$passo += 1
			$arr[0] = _Iif($try[0] >= $iGrid[0] - $aActor[0][3], $iGrid[0] - $aActor[0][3], $try[0])
			$arr[1] = _Iif($try[1] < 0, 0, $try[1])
		Until $passo = $iVel
		actorClear($temp)
		actorDraw($arr)
	EndIf
EndFunc   ;==>rightUp

Func calcRightUpB($dx, $dy, $aActor, $id)
	Local $sY = 0
	For $yy = $dy + 1 To $dy + $aActor[$id][3]
		$sY += _Iif($pix[$dx + $aActor[$id][3] - 1][$yy] == 0, 0, 1)
;~ 		GUICtrlSetBkColor($hButtons[$dx + $aActor[$id][3] - 1][$yy], color('b'))
	Next
	Return _Iif($sY == 0, 1, 0)
EndFunc   ;==>calcRightUpB

Func calcRightUpC($dx, $dy, $aActor, $id)
	Local $sX = 0
	For $xx = $dx To $dx + $aActor[$id][4] - 3
		$sX += _Iif($pix[$xx][$dy] == 0, 0, 1)
;~ 		GUICtrlSetBkColor($hButtons[$xx][$dy], color('d'))
	Next
	Return _Iif($sX == 0, 1, 0)
EndFunc   ;==>calcRightUpC

Func leftDown(ByRef $arr, $iVel = 3)
;~ 	ConsoleWrite('arr[' & _ArrayToString($arr, ',') & '] iVel=' & $iVel & @LF)
	Local $temp = $arr
	Local $try = $arr
	If $try[0] <= 0 And $try[1] >= $iGrid[1] - $aActor[0][4] Then
;~ 		ConsoleWrite('nada a fazer')
		Return
	Else
		Local $passo = 0
		Do
			If $try[1] + $aActor[0][4] >= $iGrid[1] Then
				Local $dx = $try[0] - 1
				Local $sX = 0
				For $yy = $try[1] To $try[1] + $aActor[0][3]
					$sX += _Iif($pix[$dx][$yy] == 0, 0, 1)
				Next
				If $sX == 0 Then $try[0] -= 1
			Else
				If $try[0] <= 0 Then
					Local $dy = $try[1] + $aActor[0][4], $sY = 0
					For $xx = $try[0] To $try[0] + $aActor[0][3] - 1
						$sY += _Iif($pix[$xx][$dy] == 0, 0, 1)
					Next
					If $sY == 0 Then $try[1] += 1
				Else
					Local $dx = $try[0] - 1
					Local $dy = $try[1] + $aActor[0][4]
					Local $aa = _Iif($pix[$dx][$dy - $aActor[0][4]] == 0, 1, 0)
					Local $bb = calcLeftDownB($dx, $dy, $aActor, 0)
					Local $cc = _Iif($pix[$dx][$dy] == 0, 1, 0)
					Local $dd = calcLeftDownD($dx, $dy, $aActor, 0)
					Local $ee = _Iif($pix[$dx + $aActor[0][3]][$dy] == 0, 1, 0)
;~ 					ConsoleWrite($aa & $bb & $cc & $dd & $ee & @LF)
					Switch $aa & $bb & $cc & $dd & $ee
						Case 11111, 11110, 01111
							$try[0] -= 1
							$try[1] += 1
						Case 11011
							If Random(0, 1, 1) Then
								$try[0] -= 1
							Else
								$try[1] += 1
							EndIf
						Case 11001, 11101, 11100, 11000
							$try[0] -= 1
						Case 10011, 00011, 00111, 10111
							$try[1] += 1
					EndSwitch
				EndIf
			EndIf
			$passo += 1
			$arr[0] = _Iif($try[0] <= 0, 0, $try[0])
			$arr[1] = _Iif($try[1] >= $iGrid[1] - $aActor[0][4] + 1, $iGrid[1] - $aActor[0][4], $try[1])
		Until $passo = $iVel
		actorClear($temp)
		actorDraw($arr)
	EndIf
;~ 	ConsoleWrite('arr[' & _ArrayToString($arr, ',') & '] iVel=' & $iVel & @LF)
EndFunc   ;==>leftDown


Func calcLeftDownB($dx, $dy, $aActor, $id)
	Local $sY = 0
	For $yy = $dy - $aActor[$id][3] To $dy - 1
		$sY += _Iif($pix[$dx][$yy] == 0, 0, 1)
;~ 		GUICtrlSetBkColor($hButtons[$dx][$yy], color('b'))
	Next
	Return _Iif($sY == 0, 1, 0)
EndFunc   ;==>calcLeftDownB

Func calcLeftDownD($dx, $dy, $aActor, $id)
	Local $sX = 0
	For $xx = $dx + 1 To $dx + $aActor[$id][4] - 2
		$sX += _Iif($pix[$xx][$dy] == 0, 0, 1)
;~ 		GUICtrlSetBkColor($hButtons[$xx][$dy], color('d'))
	Next
	Return _Iif($sX == 0, 1, 0)
EndFunc   ;==>calcLeftDownD

Func _Iif($aa, $bb, $cc)
	If $aa Then
		Return $bb
	Else
		Return $cc
	EndIf
EndFunc   ;==>_Iif
