#include-once
;~ http://www.i-logic.com/utilities/trig.htm
#include <Array.au3>
#include <Math.au3>
#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>

Global $RADIANS
Global Const $PI = 4 * ATan(1)
;~ Global $pi = 4 * ATan(1)
Global Const $PI2 = $PI / 2
Global $fDegToRad = $PI / 180

Local $var = getAngle(27.5, 18.5, 32, 32)
ConsoleWrite("$var[ " & $var & " ]" & @LF)

Func getAngle($ix1, $iy1, $ix2, $iy2)

	Local $part1, $part2
	Local $angle

	If ($ix1 = $ix2) And ($iy1 = $iy2) Then Return 0

	$part1 = Abs($iy2 - $iy1)
	If ($part1 = 0) Then $part1 = 0.0000001
	$part2 = Abs($ix2 - $ix1)
	If ($part2 = 0) Then $part2 = 0.0000001; $ix1:=$ix1+0.0000001; end;


	$angle = _Degree( ATan($part1 / $part2) * 1 )
	If (($ix1 > $ix2) And ($iy1 < $iy2)) Then $angle = 180 - $angle
	If (($ix1 > $ix2) And ($iy1 > $iy2)) Then $angle = $angle + 180
	If (($ix1 < $ix2) And ($iy1 > $iy2)) Then $angle = 360 - $angle
	$angle = fix_angle($angle)
	Return $angle
EndFunc   ;==>getAngle

Func arctan($aa)
EndFunc   ;==>arctan

Func fix_angle($aa)
	While $aa >= 360
		$aa -= 360
	WEnd

	While $aa < 0
		$aa += 360
	WEnd
	Return $aa
EndFunc   ;==>fix_angle


;~ Exit

OnAutoItExitRegister("_on_exit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $aGuiSize[2] = [800, 600]
Global $sGuiTitle = "GuiTitle"
Global $hGui, $Pos, $mX, $mY, $NewLenght, $Pyth, $angle, $AngleWidth, $WidthLine, $HeightLine, $LineX, $LineY, $ATan, $MidX, $MidY, $Round
Global $hGraphic
Global $ControlX = 200
Global $ControlY = 200
Global $AngleWidth = 48
;~ Global $pi = 4 * ATan(1)
Global $radToDeg = 180 / $PI
Global $Previous = 0

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "_quit")

$hGraphic = GUICtrlCreateGraphic(0, 0, 400, 400)
GUICtrlSetGraphic($hGraphic, $GUI_GR_COLOR, 0x000000)

GUICtrlSetGraphic($hGraphic, $GUI_GR_ELLIPSE, $ControlX - ($AngleWidth / 2), $ControlY - ($AngleWidth / 2), $AngleWidth, $AngleWidth)

Global $Graph = GUICtrlCreateGraphic($ControlX - ($AngleWidth / 2), $ControlY - ($AngleWidth / 2), $AngleWidth, $AngleWidth)


GUICtrlSetGraphic($hGraphic, $GUI_GR_MOVE, $AngleWidth / 2, $AngleWidth / 2)
GUICtrlSetGraphic($hGraphic, $GUI_GR_LINE, $AngleWidth / 2, 0)
GUICtrlSetGraphic($hGraphic, $GUI_GR_REFRESH)

Global $Label = GUICtrlCreateLabel("", 5, 5, 100, 16)

GUISetState(@SW_SHOW, $hGui)

While Sleep(25)
	$Pos = GUIGetCursorInfo($hGui)
	$mX = $Pos[0]
	$mY = $Pos[1]

	$Pyth = Sqrt(($mX - $ControlX) ^ 2 + ($mY - $ControlY) ^ 2)

	$NewLenght = $Pyth / ($AngleWidth / 2)

	$LineX = ($AngleWidth / 2) + ($mX - $ControlX) / $NewLenght
	$LineY = ($AngleWidth / 2) + ($mY - $ControlY) / $NewLenght

	$WidthLine = $mX - $ControlX
	$HeightLine = $ControlY - $mY

	$ATan = ATan($HeightLine / $WidthLine) * $radToDeg

	$Round = Abs(Round($ATan, 0))

	$MidX = $mX - $ControlX
	$MidY = $mY - $ControlY

	If $MidX >= 0 Then; 0 - 180

		If $MidY <= 0 Then; 0 - 90
			$angle = 90 - $Round
		Else; 90 - 180
			$angle = 90 + $Round
		EndIf

	Else; 180 - 360

		If $MidY >= 0 Then; 180 - 270
			$angle = 180 + (90 - $Round)
		Else; 270 - 360
			$angle = 270 + $Round
		EndIf

	EndIf

	If $angle <> $Previous Then
		GUICtrlSetData($Label, $angle & "°")

		GUICtrlDelete($Graph)
		$Graph = GUICtrlCreateGraphic($ControlX - ($AngleWidth / 2), $ControlY - ($AngleWidth / 2), $AngleWidth, $AngleWidth)

		GUICtrlSetGraphic($Graph, $GUI_GR_MOVE, ($AngleWidth / 2), ($AngleWidth / 2))
		GUICtrlSetGraphic($Graph, $GUI_GR_LINE, $LineX, $LineY)
		GUICtrlSetGraphic($Graph, $GUI_GR_REFRESH)
		$Previous = $angle
	EndIf
WEnd

Func _on_exit()
	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>_on_exit

Func _quit()
	Exit
EndFunc   ;==>_quit


Func atan2($xx, $yy)
	Local $absx = 0, $absy = 0, $val = 0
	If Not $xx And Not $yy Then Return 0
	$absy = Abs($yy)
	$absx = Abs($xx)
	If ($absy - $absx = $absy) Then
		If $yy < 0 Then Return -$PI2
		Return $PI2
	EndIf
	If ($absx - $absy = $absx) Then
		$val = 0
	Else
		$val = ATan($yy / $xx)
	EndIf
	If ($xx > 0) Then Return $val
	If ($yy < 0) Then Return $val - $PI
	Return $val + $PI
EndFunc   ;==>atan2

Func Radian2Degree($iRadian)
	Return 180 * $iRadian / ACos(-1)
EndFunc   ;==>Radian2Degree
