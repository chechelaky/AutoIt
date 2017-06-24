;#include <Prospeed30.au3>
#include <Prospeed30.au3>


Opt("MouseCoordMode", 0)
Opt("GUIOnEventMode", 1)
HotKeySet("{Esc}", "_exit")

$gui = GUICreate("Prospeed", 800, 400, -1, -1, Default)
GUISetOnEvent(-3, "_exit")
GUISetState()

$hdc = GetHDC()
CreateBuffer(800, 400)
SetBuffer($hdc)

$sp1 = loadsprite("Sprites.gif")
$sp2 = loadsprite("Sprites2.gif")
$sp3 = loadsprite("Sprites3.gif")

$Bee = sprite($sp1, 0, 0, 24, 18, 4, 1, 6, 50, 40)

SetSpriteAnimMove($Bee, 1, 0, 0)
SetSpriteAnimMove($Bee, 2, 0, 0)
SetSpriteAnimMove($Bee, 3, 0, 0)
SetSpriteAnimMove($Bee, 5, 0, 32)
SetSpriteAnimMove($Bee, 6, 0, 32)
SetSpriteAnimMove($Bee, 7, 0, 32)
SetSpriteSpeed($Bee, 1, 1)
SetSpriteMovingMode($Bee, 1)
SetmovingRectangle($Bee, 0, 0, 800 - 24, 250)

While 1
	moveSprite($Bee, Random(20, 780, 1), Random(20, 250, 1))
	ChangeSpritePara($Bee, 0, $sp1)
	Sleep(2000)
	moveSprite($Bee, Random(20, 780, 1), Random(20, 250, 1))
	ChangeSpritePara($Bee, 0, $sp2)
	Sleep(1000)
	moveSprite($Bee, Random(20, 780, 1), Random(20, 250, 1))
	ChangeSpritePara($Bee, 0, $sp3)
	Sleep(1000)
WEnd

Func _exit()
	Exit
EndFunc   ;==>_exit