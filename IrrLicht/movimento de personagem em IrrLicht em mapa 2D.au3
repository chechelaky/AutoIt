#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         Luismar Chechelaky

	Script Function:
	Movimento de mapa e personagem

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here



#include <au3Irrlicht2.au3>
#include <Array.au3>
Opt('MustDeclareVars', True)

HotKeySet('{ESC}', '_exit')

Global $screen_width = @DesktopWidth
Global $screen_height = @DesktopHeight

Global $aActor[8] = [64, 64]

$aActor[2] = $screen_width - $aActor[0]
$aActor[3] = $screen_height - $aActor[1]
$aActor[4] = $aActor[2] / 2
$aActor[5] = $aActor[3] / 2

Global $frame = 0
Global $framesync = 0
Global $nave
Global $pKeyEvent, $keyCode
Global $dir = 0
Global $map0, $map1
Global $LAST_FRAME = 4
Global $iVel = 2

; $IRR_FULLSCREEN, $IRR_WINDOWED
_IrrStartAdvanced($IRR_EDT_OPENGL, $screen_width, $screen_height, $IRR_BITS_PER_PIXEL_16, $IRR_FULLSCREEN, $IRR_NO_SHADOWS, $IRR_CAPTURE_EVENTS, $IRR_VERTICAL_SYNC_ON, 0, $IRR_OFF, 2, 0)

_IrrSetWindowCaption('IrrLicht')

;~ $nave = _IrrGetTexture('nave2.png')
Local $nave = _IrrGetTexture('soldier.png')

Local $fundo = _IrrGetTexture('cache/maps/large.png')
;~ Local $fundo = _IrrGetTexture('large.jpg')

Local $BitmapFont = _IrrGetFont('font.png')

Local $fundoInf = _IrrGetTextureInformation($fundo)
$aActor[6] = $fundoInf[0] - $screen_width
$aActor[7] = $fundoInf[1] - $screen_height
ConsoleWrite($aActor[6] & '/' & $aActor[7] & @LF)

Local $aMap[2] = [0, 0]


$framesync = TimerInit()
Global $xx = Int(($screen_width - $aActor[0]) / 2), $yy = Int(($screen_height - $aActor[1]) / 2)
Global $XStrafe = 0, $ZStrafe = 0

For $ii = 0 To UBound($aActor) - 1
	ConsoleWrite('[' & $ii & ']{' & $aActor[$ii] & '} ')
Next
ConsoleWrite(@LF)
Local $press, $time = TimerInit()

While _IrrRunning()
	_IrrBeginScene(51, 51, 51)


	While _IrrKeyEventAvailable()
		$pKeyEvent = _IrrReadKeyEvent()

		$keyCode = __getKeyEvt($pKeyEvent, $EVT_KEY_IKEY)
		Select
			Case $keyCode = $KEY_RIGHT
				If __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN Then
					$XStrafe = $iVel
				Else
					If $XStrafe = $iVel Then
						$XStrafe = 0
					EndIf
				EndIf

			Case $keyCode = $KEY_LEFT
				If __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN Then
					$XStrafe = -$iVel
				Else
					If $XStrafe = -$iVel Then
						$XStrafe = 0
					EndIf
				EndIf
			Case $keyCode = $KEY_DOWN
				If __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN Then
					$ZStrafe = $iVel
				Else
					If $ZStrafe = $iVel Then
						$ZStrafe = 0
					EndIf
				EndIf
			Case $keyCode = $KEY_UP
				If __getKeyEvt($pKeyEvent, $EVT_KEY_IDIRECTION) = $IRR_KEY_DOWN Then
					$ZStrafe = -$iVel
				Else
					If $ZStrafe = -$iVel Then
						$ZStrafe = 0
					EndIf
				EndIf
		EndSelect
	WEnd
	;	[0]{60} [1]{60} [2]{740} [3]{540} [4]{370} [5]{270} [6]{2400} [7]{1960}

	move()

	If $ZStrafe Or $XStrafe Then
		Switch String($XStrafe & $ZStrafe)
			Case '0' & $iVel
				$dir = 2
			Case $iVel & '0'
				$dir = 3
			Case '0-' & $iVel
				$dir = 0
			Case '-' &$iVel & '0'
				$dir = 1
		EndSwitch
	EndIf

	_IrrDraw2DImage($fundo, $aMap[0], $aMap[1])
	_IrrDraw2DImageElement($nave, _
			$xx, $yy, _
			$frame * $aActor[0], ($dir) * $aActor[1], ($frame + 1) * $aActor[0], ($dir + 1) * $aActor[1], _
			$IRR_USE_ALPHA)

	If TimerDiff($framesync) > 50 And ($XStrafe Or $ZStrafe) Then
		$framesync = TimerInit()
		$frame += 1
		If $frame >= $LAST_FRAME Then $frame = 0
	EndIf



;~ 	_Irr2DFontDraw($BitmapFont, 'mov[' & String($XStrafe & $ZStrafe) & '] dir[' & $dir & ']', 10, 10, 250, 96)
;~ 	_Irr2DFontDraw($BitmapFont, 'soma[' & $xx - $aMap[0] + $XStrafe & ']', 10, 30, 250, 96)
	_Irr2DFontDraw($BitmapFont, 'pos[' & $xx & ',' & $yy & ']', 10, 10, 250, 96)
	_Irr2DFontDraw($BitmapFont, 'map[' & $aMap[0] & ',' & $aMap[1] & ']', 10, 70, 250, 96)
;~ 	_Irr2DFontDraw($BitmapFont, 'dif[' & $dif & ']', 10, 90, 250, 96)

	_Irr2DFontDraw($BitmapFont, 'FPS[' & _IrrGetFPS() & '] ', 10, 1000, 250, 96)

	_IrrEndScene()
WEnd

Func move()
	If Not $XStrafe And Not $ZStrafe Then Return
	;If TimerDiff($time) < 30 Then Return
	$time = TimerInit()
	Local $trace = 0
	Local $dif = 0, $mapX, $xis
	If $aMap[0] == 0 And $xx <= $aActor[4] Then
		;If $trace Then ConsoleWrite('A')
		$xx += $XStrafe
		If $xx <= 0 Then
			;If $trace Then ConsoleWrite('1')
			$xx = 0
		ElseIf $xx > $aActor[4] Then
			;If $trace Then ConsoleWrite('2')
			$xx -= $XStrafe
			$xis = $aActor[4] - $xx
			$xx += $xis
			$mapX = $XStrafe - $xis
			$aMap[0] -= $mapX
			If $trace Then ConsoleWrite('1.mapX[' & $mapX & '] xis[' & $xis & ']' & @LF)
		EndIf
		;If $trace Then ConsoleWrite('.')
	ElseIf $aMap[0] <= 0 And $aMap[0] >= -$aActor[6] And $xx == $aActor[4] Then
		;If $trace Then ConsoleWrite('B')
		$aMap[0] -= $XStrafe
		If $aMap[0] <= -$aActor[6] Then
			;If $trace Then ConsoleWrite(@LF)
			;$aMap[0] += $XStrafe
			;If $trace Then ConsoleWrite('1')
			Local $mapX = $aActor[6] + $aMap[0]
			$aMap[0] -= $mapX
			Local $xis = $XStrafe + $mapX
			$xx += $xis
			If $trace Then ConsoleWrite('2.mapX[' & $mapX & '] xis[' & $xis & ']' & @LF)
		ElseIf $aMap[0] >= 0 Then
			;If $trace Then ConsoleWrite('2')
			Local $mapX = $aMap[0]
			Local $xis = $XStrafe + $mapX
			$aMap[0] -= $aMap[0]
			$xx += $xis
			If $trace Then ConsoleWrite('3.map[' & $mapX & '] $xis[' & $xis & ']' & @LF)
		EndIf
		;If $trace Then ConsoleWrite('.')
	ElseIf $aMap[0] >= -$aActor[6] And $xx > $aActor[4] Then
		;If $trace Then ConsoleWrite('C')
		$xx += $XStrafe
		If $xx >= $aActor[2] Then
			;If $trace Then ConsoleWrite('1')
			$xx = $aActor[2]
		ElseIf $xx < $aActor[4] Then
			;If $trace Then ConsoleWrite('2')
			$xx -= $XStrafe
			$xis = $aActor[4] - $xx
			$xx += $xis
			$mapX = $XStrafe - $xis
			$aMap[0] -= $mapX
			If $trace Then ConsoleWrite('4.map[' & $mapX & '] $xis[' & $xis & ']' & @LF)
		EndIf
		;If $trace Then ConsoleWrite('.')
	EndIf

	Local $dif = 0, $mapZ, $zis
	If $aMap[1] == 0 And $yy <= $aActor[5] Then
		;If $trace Then ConsoleWrite('D')
		$yy += $ZStrafe
		If $yy <= 0 Then
			;If $trace Then ConsoleWrite('1')
			$yy = 0
		ElseIf $yy > $aActor[5] Then
			;If $trace Then ConsoleWrite('2')
			$yy -= $ZStrafe
			$zis = $aActor[5] - $yy
			$yy += $zis
			$mapZ = $ZStrafe - $zis
			$aMap[1] -= $mapZ
			If $trace Then ConsoleWrite('5.mapY[' & $mapZ & '] zis[' & $zis & ']' & @LF)
		EndIf
		;ConsoleWrite('.')
	ElseIf $aMap[1] <= 0 And $aMap[1] >= -$aActor[7] And $yy == $aActor[5] Then
		;If $trace Then ConsoleWrite('E')
		$aMap[1] -= $ZStrafe
		If $aMap[1] <= -$aActor[7] Then
			;If $trace Then ConsoleWrite(@LF)
			;$aMap[1] += $ZStrafe
			;If $trace Then ConsoleWrite('1')
			Local $mapZ = $aActor[7] + $aMap[1]
			$aMap[1] -= $mapZ
			Local $zis = $ZStrafe + $mapZ
			$yy += $zis
			If $trace Then ConsoleWrite('6.map[' & $mapZ & '] $zis[' & $zis & ']' & @LF)
		ElseIf $aMap[1] >= 0 Then
			;If $trace Then ConsoleWrite('2')
			Local $mapZ = $aMap[1]
			Local $zis = $ZStrafe + $mapZ
			$aMap[1] -= $aMap[1]
			$yy += $zis
			If $trace Then ConsoleWrite('7.map[' & $mapZ & '] $zis[' & $zis & ']' & @LF)
		EndIf
		;If $trace Then ConsoleWrite('.')
	ElseIf $aMap[1] >= -$aActor[7] And $yy > $aActor[5] Then
		;If $trace Then ConsoleWrite('F')
		$yy += $ZStrafe
		If $yy >= $aActor[3] Then
			;If $trace Then ConsoleWrite('1')
			$yy = $aActor[3]
		ElseIf $yy < $aActor[5] Then
			;If $trace Then ConsoleWrite('2')
			$yy -= $ZStrafe
			$zis = $aActor[5] - $yy
			$yy += $zis
			$mapZ = $ZStrafe - $zis
			$aMap[1] -= $mapZ
			If $trace Then ConsoleWrite('8.map[' & $mapZ & '] $zis[' & $zis & ']' & @LF)
		EndIf
		;If $trace Then ConsoleWrite('.')
	EndIf
EndFunc   ;==>move


_IrrStop()

Func _exit()
	_IrrStop()
	Exit
EndFunc   ;==>_exit